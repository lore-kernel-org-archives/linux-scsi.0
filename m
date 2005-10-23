From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 1/2] HCIL drivers update
Date: Sun, 23 Oct 2005 15:51:28 -0400
Message-ID: <20051023195128.GA12102@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33255 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750723AbVJWTva (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 15:51:30 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id AC6BE1C095A7
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 15:51:28 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9NJpS11012145
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 15:51:28 -0400
Content-Disposition: inline
In-Reply-To: <20051023024104.GA20128@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hacking on drivers, to see where the death of sdev->{channel,id}
and sdev->lun type change leads.  DO NOT APPLY.


 drivers/scsi/53c700.c              |  111 +++++++++++++++++-------------------
 drivers/scsi/53c700.h              |    6 -
 drivers/scsi/BusLogic.c            |   12 +--
 drivers/scsi/aacraid/aachba.c      |   32 +++++-----
 drivers/scsi/aacraid/aacraid.h     |    1 
 drivers/scsi/advansys.c            |   43 +++++++-------
 drivers/scsi/aha152x.c             |    5 -
 drivers/scsi/aic7xxx/aic79xx_osm.c |   96 +++++++++++++++----------------
 drivers/scsi/aic7xxx/aic7xxx_osm.c |  113 +++++++++++++++++--------------------
 drivers/scsi/dpt_i2o.c             |   31 ++++++----
 drivers/scsi/fdomain.c             |    4 -
 11 files changed, 225 insertions(+), 229 deletions(-)

iff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a7620fc..51f9422 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -796,12 +796,6 @@ process_extended_message(struct Scsi_Hos
 			 struct scsi_cmnd *SCp, __u32 dsp, __u32 dsps)
 {
 	__u32 resume_offset = dsp, temp = dsp + 8;
-	__u8 pun = 0xff, lun = 0xff;
-
-	if(SCp != NULL) {
-		pun = SCp->device->id;
-		lun = SCp->device->lun;
-	}
 
 	switch(hostdata->msgin[2]) {
 	case A_SDTR_MSG:
@@ -843,8 +837,8 @@ process_extended_message(struct Scsi_Hos
 		break;
 	
 	case A_WDTR_MSG:
-		printk(KERN_INFO "scsi%d: (%d:%d), Unsolicited WDTR after CMD, Rejecting\n",
-		       host->host_no, pun, lun);
+		dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
+			"Unsolicited WDTR after CMD, Rejecting\n");
 		hostdata->msgout[0] = A_REJECT_MSG;
 		dma_cache_sync(hostdata->msgout, 1, DMA_TO_DEVICE);
 		script_patch_16(hostdata->script, MessageCount, 1);
@@ -853,8 +847,8 @@ process_extended_message(struct Scsi_Hos
 		break;
 
 	default:
-		printk(KERN_INFO "scsi%d (%d:%d): Unexpected message %s: ",
-		       host->host_no, pun, lun,
+		dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
+			"Unexpected message %s: ",
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
 		scsi_print_msg(hostdata->msgin);
 		printk("\n");
@@ -876,15 +870,10 @@ process_message(struct Scsi_Host *host,	
 {
 	/* work out where to return to */
 	__u32 temp = dsp + 8, resume_offset = dsp;
-	__u8 pun = 0xff, lun = 0xff;
-
-	if(SCp != NULL) {
-		pun = SCp->device->id;
-		lun = SCp->device->lun;
-	}
 
 #ifdef NCR_700_DEBUG
-	printk("scsi%d (%d:%d): message %s: ", host->host_no, pun, lun,
+	dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
+		"message %s: ",
 	       NCR_700_phase[(dsps & 0xf00) >> 8]);
 	scsi_print_msg(hostdata->msgin);
 	printk("\n");
@@ -906,34 +895,36 @@ process_message(struct Scsi_Host *host,	
 			NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 		} else if(SCp != NULL && NCR_700_get_tag_neg_state(SCp->device) == NCR_700_DURING_TAG_NEGOTIATION) {
 			/* rejected our first simple tag message */
-			printk(KERN_WARNING "scsi%d (%d:%d) Rejected first tag queue attempt, turning off tag queueing\n", host->host_no, pun, lun);
+			dev_printk(KERN_WARNING, &SCp->device->sdev_gendev,
+				"Rejected first tag queue attempt, turning off tag queueing\n");
 			/* we're done negotiating */
 			NCR_700_set_tag_neg_state(SCp->device, NCR_700_FINISHED_TAG_NEGOTIATION);
-			hostdata->tag_negotiated &= ~(1<<SCp->device->id);
+			hostdata->tag_negotiated &= ~(1<<sdev_id(SCp->device));
 			SCp->device->tagged_supported = 0;
 			scsi_deactivate_tcq(SCp->device, host->cmd_per_lun);
 		} else {
-			printk(KERN_WARNING "scsi%d (%d:%d) Unexpected REJECT Message %s\n",
-			       host->host_no, pun, lun,
+			dev_printk(KERN_WARNING, &SCp->device->sdev_gendev,
+				"Unexpected REJECT Message %s\n",
 			       NCR_700_phase[(dsps & 0xf00) >> 8]);
 			/* however, just ignore it */
 		}
 		break;
 
 	case A_PARITY_ERROR_MSG:
-		printk(KERN_ERR "scsi%d (%d:%d) Parity Error!\n", host->host_no,
-		       pun, lun);
+		dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
+			"Parity Error!\n");
 		NCR_700_internal_bus_reset(host);
 		break;
 	case A_SIMPLE_TAG_MSG:
-		printk(KERN_INFO "scsi%d (%d:%d) SIMPLE TAG %d %s\n", host->host_no,
-		       pun, lun, hostdata->msgin[1],
+		dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
+			"SIMPLE TAG %d %s\n",
+		       hostdata->msgin[1],
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
 		/* just ignore it */
 		break;
 	default:
-		printk(KERN_INFO "scsi%d (%d:%d): Unexpected message %s: ",
-		       host->host_no, pun, lun,
+		dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
+			"Unexpected message %s: ",
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
 
 		scsi_print_msg(hostdata->msgin);
@@ -960,12 +951,6 @@ process_script_interrupt(__u32 dsps, __u
 			 struct NCR_700_Host_Parameters *hostdata)
 {
 	__u32 resume_offset = 0;
-	__u8 pun = 0xff, lun=0xff;
-
-	if(SCp != NULL) {
-		pun = SCp->device->id;
-		lun = SCp->device->lun;
-	}
 
 	if(dsps == A_GOOD_STATUS_AFTER_STATUS) {
 		DEBUG(("  COMMAND COMPLETE, status=%02x\n",
@@ -983,7 +968,8 @@ process_script_interrupt(__u32 dsps, __u
 			if(SCp->cmnd[0] == REQUEST_SENSE) {
 				/* OOPS: bad device, returning another
 				 * contingent allegiance condition */
-				printk(KERN_ERR "scsi%d (%d:%d) broken device is looping in contingent allegiance: ignoring\n", host->host_no, pun, lun);
+				dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
+					"broken device is looping in contingent allegiance: ignoring\n");
 				NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
 			} else {
 #ifdef NCR_DEBUG
@@ -1001,7 +987,7 @@ process_script_interrupt(__u32 dsps, __u
 				NCR_700_unmap(hostdata, SCp, slot);
 
 				SCp->cmnd[0] = REQUEST_SENSE;
-				SCp->cmnd[1] = (SCp->device->lun & 0x7) << 5;
+				SCp->cmnd[1] = (scsilun_to_int(&SCp->device->lun) & 0x7) << 5;
 				SCp->cmnd[2] = 0;
 				SCp->cmnd[3] = 0;
 				SCp->cmnd[4] = sizeof(SCp->sense_buffer);
@@ -1047,12 +1033,13 @@ process_script_interrupt(__u32 dsps, __u
 			//			    SCp->request_bufflen,
 			//			    DMA_FROM_DEVICE);
 			//	if(((char *)SCp->request_buffer)[7] & 0x02) {
-			//		printk(KERN_INFO "scsi%d: (%d:%d) Enabling Tag Command Queuing\n", host->host_no, pun, lun);
-			//		hostdata->tag_negotiated |= (1<<SCp->device->id);
+			//		dev_printk(KERN_INFO, &SCp->device->sdev_gendev,
+			//		"Enabling Tag Command Queuing\n");
+			//		hostdata->tag_negotiated |= (1 << sdev_id(SCp->device));
 			//		NCR_700_set_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
 			//	} else {
 			//		NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
-			//		hostdata->tag_negotiated &= ~(1<<SCp->device->id);
+			//		hostdata->tag_negotiated &= ~(1 << sdev_id(SCp->device));
 			//	}
 			//}
 			NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
@@ -1060,8 +1047,8 @@ process_script_interrupt(__u32 dsps, __u
 	} else if((dsps & 0xfffff0f0) == A_UNEXPECTED_PHASE) {
 		__u8 i = (dsps & 0xf00) >> 8;
 
-		printk(KERN_ERR "scsi%d: (%d:%d), UNEXPECTED PHASE %s (%s)\n",
-		       host->host_no, pun, lun,
+		dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
+			"UNEXPECTED PHASE %s (%s)\n",
 		       NCR_700_phase[i],
 		       sbcl_to_string(NCR_700_readb(host, SBCL_REG)));
 		printk(KERN_ERR "         len = %d, cmd =", SCp->cmd_len);
@@ -1071,8 +1058,9 @@ process_script_interrupt(__u32 dsps, __u
 	} else if((dsps & 0xfffff000) == A_FATAL) {
 		int i = (dsps & 0xfff);
 
-		printk(KERN_ERR "scsi%d: (%d:%d) FATAL ERROR: %s\n",
-		       host->host_no, pun, lun, NCR_700_fatal_messages[i]);
+		dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
+			"FATAL ERROR: %s\n",
+		       NCR_700_fatal_messages[i]);
 		if(dsps == A_FATAL_ILLEGAL_MSG_LENGTH) {
 			printk(KERN_ERR "     msg begins %02x %02x\n",
 			       hostdata->msgin[0], hostdata->msgin[1]);
@@ -1082,8 +1070,8 @@ process_script_interrupt(__u32 dsps, __u
 #ifdef NCR_700_DEBUG
 		__u8 i = (dsps & 0xf00) >> 8;
 
-		printk("scsi%d: (%d:%d), DISCONNECTED (%d) %s\n",
-		       host->host_no, pun, lun,
+		dev_printk(KERN_DEBUG, &SCp->device->sdev_gendev,
+			"DISCONNECTED (%d) %s\n",
 		       i, NCR_700_phase[i]);
 #endif
 		save_for_reselection(hostdata, SCp, dsp);
@@ -1093,14 +1081,16 @@ process_script_interrupt(__u32 dsps, __u
 		struct NCR_700_command_slot *slot;
 		__u8 reselection_id = hostdata->reselection_id;
 		struct scsi_device *SDp;
+		struct scsi_lun __lun;
 
 		lun = hostdata->msgin[0] & 0x1f;
+		int_to_scsilun(lun, &__lun);
 
 		hostdata->reselection_id = 0xff;
 		DEBUG(("scsi%d: (%d:%d) RESELECTED!\n",
 		       host->host_no, reselection_id, lun));
 		/* clear the reselection indicator */
-		SDp = __scsi_device_lookup(host, 0, reselection_id, lun);
+		SDp = __scsi_device_lookup(host, 0, reselection_id, &__lun);
 		if(unlikely(SDp == NULL)) {
 			printk(KERN_ERR "scsi%d: (%d:%d) HAS NO device\n",
 			       host->host_no, reselection_id, lun);
@@ -1242,8 +1232,9 @@ process_script_interrupt(__u32 dsps, __u
 						dsp, dsps);
 	} else if((dsps &  0xfffff000) == 0) {
 		__u8 i = (dsps & 0xf0) >> 4, j = (dsps & 0xf00) >> 8;
-		printk(KERN_ERR "scsi%d: (%d:%d), unhandled script condition %s %s at %04x\n",
-		       host->host_no, pun, lun, NCR_700_condition[i],
+		dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
+			"unhandled script condition %s %s at %04x\n",
+		       NCR_700_condition[i],
 		       NCR_700_phase[j], dsp - hostdata->pScript);
 		if(SCp != NULL) {
 			scsi_print_command(SCp);
@@ -1256,12 +1247,14 @@ process_script_interrupt(__u32 dsps, __u
 		}	       
 		NCR_700_internal_bus_reset(host);
 	} else if((dsps & 0xfffff000) == A_DEBUG_INTERRUPT) {
-		printk(KERN_NOTICE "scsi%d (%d:%d) DEBUG INTERRUPT %d AT %08x[%04x], continuing\n",
-		       host->host_no, pun, lun, dsps & 0xfff, dsp, dsp - hostdata->pScript);
+		dev_printk(KERN_NOTICE, &SCp->device->sdev_gendev,
+			"DEBUG INTERRUPT %d AT %08x[%04x], continuing\n",
+		       dsps & 0xfff, dsp, dsp - hostdata->pScript);
 		resume_offset = dsp;
 	} else {
-		printk(KERN_ERR "scsi%d: (%d:%d), unidentified script interrupt 0x%x at %04x\n",
-		       host->host_no, pun, lun, dsps, dsp - hostdata->pScript);
+		dev_printk(KERN_ERR, &SCp->device->sdev_gendev,
+			"unidentified script interrupt 0x%x at %04x\n",
+		       dsps, dsp - hostdata->pScript);
 		NCR_700_internal_bus_reset(host);
 	}
 	return resume_offset;
@@ -1422,7 +1415,7 @@ NCR_700_start_command(struct scsi_cmnd *
 	 * If a contingent allegiance condition exists, the device
 	 * will refuse all tags, so send the request sense as untagged
 	 * */
-	if((hostdata->tag_negotiated & (1<<SCp->device->id))
+	if((hostdata->tag_negotiated & (1 << sdev_id(SCp->device)))
 	   && (slot->tag != SCSI_NO_TAG && SCp->cmnd[0] != REQUEST_SENSE)) {
 		count += scsi_populate_tag_msg(SCp, &hostdata->msgout[count]);
 	}
@@ -1441,7 +1434,7 @@ NCR_700_start_command(struct scsi_cmnd *
 
 
 	script_patch_ID(hostdata->script,
-			Device_ID, 1<<SCp->device->id);
+			Device_ID, 1 << sdev_id(SCp->device));
 
 	script_patch_32_abs(hostdata->script, CommandAddress, 
 			    slot->pCmd);
@@ -1764,7 +1757,7 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	 * - The blk layer sent and untagged command
 	 */
 	if(NCR_700_get_depth(SCp->device) != 0
-	   && (!(hostdata->tag_negotiated & (1<<SCp->device->id))
+	   && (!(hostdata->tag_negotiated & (1 << sdev_id(SCp->device)))
 	       || !blk_rq_tagged(SCp->request))) {
 		DEBUG((KERN_ERR "scsi%d (%d:%d) has non zero depth %d\n",
 		       SCp->device->host->host_no, SCp->device->id, SCp->device->lun,
@@ -1796,10 +1789,10 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	scsi_print_command(SCp);
 #endif
 	if(blk_rq_tagged(SCp->request)
-	   && (hostdata->tag_negotiated &(1<<SCp->device->id)) == 0
+	   && (hostdata->tag_negotiated &(1 << sdev_id(SCp->device))) == 0
 	   && NCR_700_get_tag_neg_state(SCp->device) == NCR_700_START_TAG_NEGOTIATION) {
 		printk(KERN_ERR "scsi%d: (%d:%d) Enabling Tag Command Queuing\n", SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
-		hostdata->tag_negotiated |= (1<<SCp->device->id);
+		hostdata->tag_negotiated |= (1 << sdev_id(SCp->device));
 		NCR_700_set_tag_neg_state(SCp->device, NCR_700_DURING_TAG_NEGOTIATION);
 	}
 
@@ -1810,12 +1803,12 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	 * FIXME: This will royally screw up on multiple LUN devices
 	 * */
 	if(!blk_rq_tagged(SCp->request)
-	   && (hostdata->tag_negotiated &(1<<SCp->device->id))) {
+	   && (hostdata->tag_negotiated &(1 << sdev_id(SCp->device)))) {
 		printk(KERN_INFO "scsi%d: (%d:%d) Disabling Tag Command Queuing\n", SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
-		hostdata->tag_negotiated &= ~(1<<SCp->device->id);
+		hostdata->tag_negotiated &= ~(1 << sdev_id(SCp->device));
 	}
 
-	if((hostdata->tag_negotiated &(1<<SCp->device->id))
+	if((hostdata->tag_negotiated &(1 << sdev_id(SCp->device)))
 	   && scsi_get_tag_type(SCp->device)) {
 		slot->tag = SCp->request->tag;
 		DEBUG(("53c700 %d:%d:%d, sending out tag %d, slot %p\n",
diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
index e86012c..07a1ec3 100644
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -15,15 +15,15 @@
 
 
 /* Turn on for general debugging---too verbose for normal use */
-#undef	NCR_700_DEBUG
+#define	NCR_700_DEBUG
 /* Debug the tag queues, checking hash queue allocation and deallocation
  * and search for duplicate tags */
 #undef NCR_700_TAG_DEBUG
 
 #ifdef NCR_700_DEBUG
-#define DEBUG(x)	printk x
+#define DEBUG(dev,args...)	dev_printk(KERN_DEBUG, (dev), ## args)
 #else
-#define DEBUG(x)
+#define DEBUG(dev,args...)
 #endif
 
 /* The number of available command slots */
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 9d6040b..84c05c7 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2139,7 +2139,7 @@ static void __init BusLogic_InitializeHo
 static int BusLogic_SlaveConfigure(struct scsi_device *Device)
 {
 	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Device->host->hostdata;
-	int TargetID = Device->id;
+	int TargetID = sdev_id(Device);
 	int QueueDepth = HostAdapter->QueueDepth[TargetID];
 
 	if (HostAdapter->TargetFlags[TargetID].TaggedQueuingSupported && (HostAdapter->TaggedQueuingPermitted & (1 << TargetID))) {
@@ -2744,7 +2744,7 @@ static int BusLogic_host_reset(struct sc
 {
 	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) SCpnt->device->host->hostdata;
 
-	unsigned int id = SCpnt->device->id;
+	unsigned int id = sdev_id(SCpnt->device);
 	struct BusLogic_TargetStatistics *stats = &HostAdapter->TargetStatistics[id];
 	int rc;
 
@@ -2765,12 +2765,12 @@ static int BusLogic_host_reset(struct sc
 static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRoutine) (struct scsi_cmnd *))
 {
 	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Command->device->host->hostdata;
-	struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[Command->device->id];
+	struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[sdev_id(Command->device)];
 	struct BusLogic_TargetStatistics *TargetStatistics = HostAdapter->TargetStatistics;
 	unsigned char *CDB = Command->cmnd;
 	int CDB_Length = Command->cmd_len;
-	int TargetID = Command->device->id;
-	int LogicalUnit = Command->device->lun;
+	int TargetID = sdev_id(Command->device);
+	int LogicalUnit = scsilun_to_int(&Command->device->lun);
 	void *BufferPointer = Command->request_buffer;
 	int BufferLength = Command->request_bufflen;
 	int SegmentCount = Command->use_sg;
@@ -2960,7 +2960,7 @@ static int BusLogic_AbortCommand(struct 
 {
 	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) Command->device->host->hostdata;
 
-	int TargetID = Command->device->id;
+	int TargetID = sdev_id(Command->device);
 	struct BusLogic_CCB *CCB;
 	BusLogic_IncrementErrorCounter(&HostAdapter->TargetStatistics[TargetID].CommandAbortsRequested);
 	/*
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 93416f7..8528931 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -889,7 +889,7 @@ static void io_callback(void *context, s
 	scsicmd = (struct scsi_cmnd *) context;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
-	cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
+	cid = sdev_id(scsicmd->device);
 
 	if (nblank(dprintk(x))) {
 		u64 lba;
@@ -1334,7 +1334,7 @@ static void synchronize_callback(void *c
 	else {
 		struct scsi_device *sdev = cmd->device;
 		struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
-		u32 cid = ID_LUN_TO_CONTAINER(sdev->id, sdev->lun);
+		u32 cid = sdev_id(sdev);
 		printk(KERN_WARNING 
 		     "synchronize_callback: synchronize failed, status = %d\n",
 		     le32_to_cpu(synchronizereply->status));
@@ -1446,14 +1446,14 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 	 *	Test does not apply to ID 16, the pseudo id for the controller
 	 *	itself.
 	 */
-	if (scsicmd->device->id != host->this_id) {
-		if ((scsicmd->device->channel == 0) ){
-			if( (scsicmd->device->id >= dev->maximum_num_containers) || (scsicmd->device->lun != 0)){ 
+	if (sdev_id(scsicmd->device) != host->this_id) {
+		if ((sdev_channel(scsicmd->device) == 0) ){
+			if( (sdev_id(scsicmd->device) >= dev->maximum_num_containers) || (!scsilun_zero(&scsicmd->device->lun))){ 
 				scsicmd->result = DID_NO_CONNECT << 16;
 				scsicmd->scsi_done(scsicmd);
 				return 0;
 			}
-			cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
+			cid = sdev_id(scsicmd->device);
 
 			/*
 			 *	If the target container doesn't exist, it may have
@@ -1529,7 +1529,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 	{
 		struct inquiry_data inq_data;
 
-		dprintk((KERN_DEBUG "INQUIRY command, ID: %d.\n", scsicmd->device->id));
+		dprintk((KERN_DEBUG "INQUIRY command, ID: %d.\n", sdev_id(scsicmd->device)));
 		memset(&inq_data, 0, sizeof (struct inquiry_data));
 
 		inq_data.inqd_ver = 2;	/* claim compliance to SCSI-2 */
@@ -1541,7 +1541,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 		 *	Set the Vendor, Product, and Revision Level
 		 *	see: <vendor>.c i.e. aac.c
 		 */
-		if (scsicmd->device->id == host->this_id) {
+		if (sdev_id(scsicmd->device) == host->this_id) {
 			setinqstr(cardtype, (void *) (inq_data.inqd_vid), (sizeof(container_types)/sizeof(char *)));
 			inq_data.inqd_pdt = INQD_PDT_PROC;	/* Processor device */
 			aac_internal_transfer(scsicmd, &inq_data, 0, sizeof(inq_data));
@@ -1756,7 +1756,7 @@ static int query_disk(struct aac_dev *de
 	if (copy_from_user(&qd, arg, sizeof (struct aac_query_disk)))
 		return -EFAULT;
 	if (qd.cnum == -1)
-		qd.cnum = ID_LUN_TO_CONTAINER(qd.id, qd.lun);
+		qd.cnum = qd.id;
 	else if ((qd.bus == -1) && (qd.id == -1) && (qd.lun == -1)) 
 	{
 		if (qd.cnum < 0 || qd.cnum >= dev->maximum_num_containers)
@@ -1931,7 +1931,7 @@ static void aac_srb_callback(void *conte
 			 * the channel is 2
 			 */
 			} else if ((dev->raid_scsi_mode) &&
-					(scsicmd->device->channel == 2)) {
+					(sdev_channel(scsicmd->device) == 2)) {
 				scsicmd->result = DID_OK << 16 | 
 						COMMAND_COMPLETE << 8;
 			} else {
@@ -1975,7 +1975,7 @@ static void aac_srb_callback(void *conte
 			 * the channel is 2
 			 */
 			} else if ((dev->raid_scsi_mode) &&
-					(scsicmd->device->channel == 2)) {
+					(sdev_channel(scsicmd->device) == 2)) {
 				scsicmd->result = DID_OK << 16 | 
 						COMMAND_COMPLETE << 8;
 			} else {
@@ -2093,8 +2093,8 @@ static int aac_send_srb_fib(struct scsi_
 	u32 timeout;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
-	if (scsicmd->device->id >= dev->maximum_num_physicals || 
-			scsicmd->device->lun > 7) {
+	if (sdev_id(scsicmd->device) >= dev->maximum_num_physicals || 
+			scsilun_to_int(&scsicmd->device->lun) > 7) {
 		scsicmd->result = DID_NO_CONNECT << 16;
 		scsicmd->scsi_done(scsicmd);
 		return 0;
@@ -2128,9 +2128,9 @@ static int aac_send_srb_fib(struct scsi_
 
 	srbcmd = (struct aac_srb*) fib_data(cmd_fibcontext);
 	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
-	srbcmd->channel  = cpu_to_le32(aac_logical_to_phys(scsicmd->device->channel));
-	srbcmd->id   = cpu_to_le32(scsicmd->device->id);
-	srbcmd->lun      = cpu_to_le32(scsicmd->device->lun);
+	srbcmd->channel  = cpu_to_le32(aac_logical_to_phys(sdev_channel(scsicmd->device)));
+	srbcmd->id   = cpu_to_le32(sdev_id(scsicmd->device));
+	srbcmd->lun      = cpu_to_le32(scsilun_to_int(&scsicmd->device->lun));
 	srbcmd->flags    = cpu_to_le32(flag);
 	timeout = scsicmd->timeout_per_command/HZ;
 	if(timeout == 0){
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 4a99d2f..92fd4a3 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -25,7 +25,6 @@
  * These macros convert from physical channels to virtual channels
  */
 #define CONTAINER_CHANNEL		(0)
-#define ID_LUN_TO_CONTAINER(id, lun)	(id)
 #define CONTAINER_TO_CHANNEL(cont)	(CONTAINER_CHANNEL)
 #define CONTAINER_TO_ID(cont)		(cont)
 #define CONTAINER_TO_LUN(cont)		(0)
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 37ec541..f31e293 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3523,7 +3523,7 @@ typedef struct {
 typedef struct scsi_cmnd     REQ, *REQP;
 #define REQPNEXT(reqp)       ((REQP) ((reqp)->host_scribble))
 #define REQPNEXTP(reqp)      ((REQP *) &((reqp)->host_scribble))
-#define REQPTID(reqp)        ((reqp)->device->id)
+#define REQPTID(reqp)        (sdev_id((reqp)->device))
 #define REQPTIME(reqp)       ((reqp)->SCp.this_residual)
 #define REQTIMESTAMP()       (jiffies)
 
@@ -6120,12 +6120,12 @@ advansys_slave_configure(struct scsi_dev
      * Save a pointer to the device and set its initial/maximum
      * queue depth.  Only save the pointer for a lun0 dev though.
      */
-    if(device->lun == 0)
-        boardp->device[device->id] = device;
+    if(scsilun_zero(&device->lun))
+        boardp->device[sdev_id(device)] = device;
     if(device->tagged_supported) {
         if (ASC_NARROW_BOARD(boardp)) {
 	    scsi_adjust_queue_depth(device, MSG_ORDERED_TAG,
-                boardp->dvc_var.asc_dvc_var.max_dvc_qng[device->id]);
+                boardp->dvc_var.asc_dvc_var.max_dvc_qng[sdev_id(device)]);
         } else {
 	    scsi_adjust_queue_depth(device, MSG_ORDERED_TAG,
                 boardp->dvc_var.adv_dvc_var.max_dvc_qng);
@@ -6243,7 +6243,7 @@ asc_execute_scsi_cmnd(struct scsi_cmnd *
         (ulong) scp, (ulong) scp->scsi_done);
 
     boardp = ASC_BOARDP(scp->device->host);
-    device = boardp->device[scp->device->id];
+    device = boardp->device[sdev_id(scp->device)];
 
     if (ASC_NARROW_BOARD(boardp)) {
         /*
@@ -6278,7 +6278,7 @@ asc_execute_scsi_cmnd(struct scsi_cmnd *
              * Increment monotonically increasing per device successful
              * request counter. Wrapping doesn't matter.
              */
-            boardp->reqcnt[scp->device->id]++;
+            boardp->reqcnt[sdev_id(scp->device)]++;
             asc_enqueue(&boardp->active, scp, ASC_BACK);
             ASC_DBG(1,
                 "asc_execute_scsi_cmnd: AscExeScsiQueue(), ASC_NOERROR\n");
@@ -6358,7 +6358,7 @@ asc_execute_scsi_cmnd(struct scsi_cmnd *
              * Increment monotonically increasing per device successful
              * request counter. Wrapping doesn't matter.
              */
-            boardp->reqcnt[scp->device->id]++;
+            boardp->reqcnt[sdev_id(scp->device)]++;
             asc_enqueue(&boardp->active, scp, ASC_BACK);
             ASC_DBG(1,
                 "asc_execute_scsi_cmnd: AdvExeScsiQueue(), ASC_NOERROR\n");
@@ -6434,9 +6434,9 @@ asc_build_req(asc_board_t *boardp, struc
     }
     asc_scsi_q.cdbptr = &scp->cmnd[0];
     asc_scsi_q.q2.cdb_len = scp->cmd_len;
-    asc_scsi_q.q1.target_id = ASC_TID_TO_TARGET_ID(scp->device->id);
-    asc_scsi_q.q1.target_lun = scp->device->lun;
-    asc_scsi_q.q2.target_ix = ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
+    asc_scsi_q.q1.target_id = ASC_TID_TO_TARGET_ID(sdev_id(scp->device));
+    asc_scsi_q.q1.target_lun = scsilun_to_int(&scp->device->lun);
+    asc_scsi_q.q2.target_ix = ASC_TIDLUN_TO_IX(sdev_id(scp->device), scsilun_to_int(&scp->device->lun));
     asc_scsi_q.q1.sense_addr = cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
     asc_scsi_q.q1.sense_len = sizeof(scp->sense_buffer);
 
@@ -6451,8 +6451,8 @@ asc_build_req(asc_board_t *boardp, struc
      * started request.
      *
      */
-    if ((boardp->dvc_var.asc_dvc_var.cur_dvc_qng[scp->device->id] > 0) &&
-        (boardp->reqcnt[scp->device->id] % 255) == 0) {
+    if ((boardp->dvc_var.asc_dvc_var.cur_dvc_qng[sdev_id(scp->device)] > 0) &&
+        (boardp->reqcnt[sdev_id(scp->device)] % 255) == 0) {
         asc_scsi_q.q2.tag_code = MSG_ORDERED_TAG;
     } else {
         asc_scsi_q.q2.tag_code = MSG_SIMPLE_TAG;
@@ -6610,8 +6610,8 @@ adv_build_req(asc_board_t *boardp, struc
         scsiqp->cdb16[i - 12] = scp->cmnd[i];
     }
 
-    scsiqp->target_id = scp->device->id;
-    scsiqp->target_lun = scp->device->lun;
+    scsiqp->target_id = sdev_id(scp->device);
+    scsiqp->target_lun = scsilun_to_int(&scp->device->lun);
 
     scsiqp->sense_addr = cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
     scsiqp->sense_len = sizeof(scp->sense_buffer);
@@ -6889,10 +6889,10 @@ asc_isr_callback(ASC_DVC_VAR *asc_dvc_va
          * If an INQUIRY command completed successfully, then call
          * the AscInquiryHandling() function to set-up the device.
          */
-        if (scp->cmnd[0] == INQUIRY && scp->device->lun == 0 &&
+        if (scp->cmnd[0] == INQUIRY && scsilun_zero(&scp->device->lun) &&
             (scp->request_bufflen - qdonep->remain_bytes) >= 8)
         {
-            AscInquiryHandling(asc_dvc_varp, scp->device->id & 0x7,
+            AscInquiryHandling(asc_dvc_varp, sdev_id(scp->device) & 0x7,
                 (ASC_SCSI_INQUIRY *) scp->request_buffer);
         }
 
@@ -6962,10 +6962,10 @@ asc_isr_callback(ASC_DVC_VAR *asc_dvc_va
      * current request finished normally, then set the bit for the target
      * to indicate that a device is present.
      */
-    if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(scp->device->id)) == 0 &&
+    if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(sdev_id(scp->device))) == 0 &&
         qdonep->d3.done_stat == QD_NO_ERROR &&
         qdonep->d3.host_stat == QHSTA_NO_ERROR) {
-        boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scp->device->id);
+        boardp->init_tidmask |= ADV_TID_TO_TIDMASK(sdev_id(scp->device));
     }
 
     /*
@@ -7141,10 +7141,10 @@ adv_isr_callback(ADV_DVC_VAR *adv_dvc_va
      * current request finished normally, then set the bit for the target
      * to indicate that a device is present.
      */
-    if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(scp->device->id)) == 0 &&
+    if ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(sdev_id(scp->device))) == 0 &&
         scsiqp->done_status == QD_NO_ERROR &&
         scsiqp->host_status == QHSTA_NO_ERROR) {
-        boardp->init_tidmask |= ADV_TID_TO_TIDMASK(scp->device->id);
+        boardp->init_tidmask |= ADV_TID_TO_TIDMASK(sdev_id(scp->device));
     }
 
     /*
@@ -7384,7 +7384,8 @@ asc_dequeue_list(asc_queue_t *ascq, REQP
         {
             REQP reqp;
             for (reqp = firstp; reqp; reqp = REQPNEXT(reqp)) {
-                REQTIMESTAT("asc_dequeue_list", ascq, reqp, reqp->device->id);
+                REQTIMESTAT("asc_dequeue_list", ascq, reqp,
+			    sdev_id(reqp->device));
             }
         }
 #endif /* ADVANSYS_STATS */
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 630b115..dda5706 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2921,8 +2921,9 @@ static void disp_enintr(struct Scsi_Host
  */
 static void show_command(Scsi_Cmnd *ptr)
 {
-	printk(KERN_DEBUG "0x%08x: target=%d; lun=%d; cmnd=(",
-	       (unsigned int) ptr, ptr->device->id, ptr->device->lun);
+	dev_printk(KERN_DEBUG, &ptr->device->sdev_gendev,
+		"0x%08x: cmnd=(",
+	       (unsigned int) ptr);
 
 	__scsi_print_command(ptr->cmnd);
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 95c285c..24a4040 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -52,6 +52,7 @@ static struct scsi_transport_template *a
 #include <linux/mm.h>		/* For fetching system memory size */
 #include <linux/blkdev.h>		/* For block_size() */
 #include <linux/delay.h>	/* For ssleep/msleep */
+#include <linux/device.h>
 
 /*
  * Bucket size for counting good commands in between bad ones.
@@ -397,7 +398,7 @@ ahd_linux_unmap_scb(struct ahd_softc *ah
 
 /******************************** Macros **************************************/
 #define BUILD_SCSIID(ahd, cmd)						\
-	((((cmd)->device->id << TID_SHIFT) & TID) | (ahd)->our_id)
+	(((sdev_id((cmd)->device) << TID_SHIFT) & TID) | (ahd)->our_id)
 
 /*
  * Return a string describing the driver.
@@ -526,16 +527,14 @@ ahd_linux_target_destroy(struct scsi_tar
 static int
 ahd_linux_slave_alloc(struct scsi_device *sdev)
 {
-	struct	ahd_softc *ahd =
-		*((struct ahd_softc **)sdev->host->hostdata);
 	struct scsi_target *starget = sdev->sdev_target;
 	struct ahd_linux_target *targ = scsi_transport_target_data(starget);
 	struct ahd_linux_device *dev;
 
 	if (bootverbose)
-		printf("%s: Slave Alloc %d\n", ahd_name(ahd), sdev->id);
+		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Alloc\n");
 
-	BUG_ON(targ->sdev[sdev->lun] != NULL);
+	BUG_ON(targ->sdev[scsilun_to_int(&sdev->lun)] != NULL);
 
 	dev = scsi_transport_device_data(sdev);
 	memset(dev, 0, sizeof(*dev));
@@ -553,7 +552,7 @@ ahd_linux_slave_alloc(struct scsi_device
 	 */
 	dev->maxtags = 0;
 	
-	targ->sdev[sdev->lun] = sdev;
+	targ->sdev[scsilun_to_int(&sdev->lun)] = sdev;
 
 	return (0);
 }
@@ -565,7 +564,7 @@ ahd_linux_slave_configure(struct scsi_de
 
 	ahd = *((struct ahd_softc **)sdev->host->hostdata);
 	if (bootverbose)
-		printf("%s: Slave Configure %d\n", ahd_name(ahd), sdev->id);
+		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Configure\n");
 
 	ahd_linux_device_queue_depth(sdev);
 
@@ -585,11 +584,11 @@ ahd_linux_slave_destroy(struct scsi_devi
 
 	ahd = *((struct ahd_softc **)sdev->host->hostdata);
 	if (bootverbose)
-		printf("%s: Slave Destroy %d\n", ahd_name(ahd), sdev->id);
+		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Destroy\n");
 
 	BUG_ON(dev->active);
 
-	targ->sdev[sdev->lun] = NULL;
+	targ->sdev[scsilun_to_int(&sdev->lun)] = NULL;
 
 }
 
@@ -684,7 +683,7 @@ ahd_linux_bus_reset(struct scsi_cmnd *cm
 		       ahd_name(ahd), cmd);
 #endif
 	ahd_lock(ahd, &s);
-	found = ahd_reset_channel(ahd, cmd->device->channel + 'A',
+	found = ahd_reset_channel(ahd, sdev_channel(cmd->device) + 'A',
 				  /*initiate reset*/TRUE);
 	ahd_unlock(ahd, &s);
 
@@ -1405,7 +1404,8 @@ ahd_linux_device_queue_depth(struct scsi
 
 	ahd_compile_devinfo(&devinfo,
 			    ahd->our_id,
-			    sdev->sdev_target->id, sdev->lun,
+			    sdev->sdev_target->id,
+			    scsilun_to_int(&sdev->lun),
 			    sdev->sdev_target->channel == 0 ? 'A' : 'B',
 			    ROLE_INITIATOR);
 	tags = ahd_linux_user_tagdepth(ahd, &devinfo);
@@ -1434,13 +1434,13 @@ ahd_linux_run_command(struct ahd_softc *
 	 * Get an scb to use.
 	 */
 	tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
-				    cmd->device->id, &tstate);
+				    sdev_id(cmd->device), &tstate);
 	if ((dev->flags & (AHD_DEV_Q_TAGGED|AHD_DEV_Q_BASIC)) == 0
 	 || (tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ) != 0) {
 		col_idx = AHD_NEVER_COL_IDX;
 	} else {
-		col_idx = AHD_BUILD_COL_IDX(cmd->device->id,
-					    cmd->device->lun);
+		col_idx = AHD_BUILD_COL_IDX(sdev_id(cmd->device),
+					    scsilun_to_int(&cmd->device->lun));
 	}
 	if ((scb = ahd_get_scb(ahd, col_idx)) == NULL) {
 		ahd->flags |= AHD_RESOURCE_SHORTAGE;
@@ -1457,7 +1457,7 @@ ahd_linux_run_command(struct ahd_softc *
 	 */
 	hscb->control = 0;
 	hscb->scsiid = BUILD_SCSIID(ahd, cmd);
-	hscb->lun = cmd->device->lun;
+	hscb->lun = scsilun_to_int(&cmd->device->lun);
 	scb->hscb->task_management = 0;
 	mask = SCB_GET_TARGET_MASK(ahd, scb);
 
@@ -1784,7 +1784,8 @@ ahd_linux_handle_scsi_status(struct ahd_
 
 	ahd_compile_devinfo(&devinfo,
 			    ahd->our_id,
-			    sdev->sdev_target->id, sdev->lun,
+			    sdev->sdev_target->id,
+			    scsilun_to_int(&sdev->lun),
 			    sdev->sdev_target->channel == 0 ? 'A' : 'B',
 			    ROLE_INITIATOR);
 	
@@ -2067,9 +2068,8 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	wait = FALSE;
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
-	printf("%s:%d:%d:%d: Attempting to queue a%s message:",
-	       ahd_name(ahd), cmd->device->channel,
-	       cmd->device->id, cmd->device->lun,
+	dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+	       "Attempting to queue a%s message:",
 	       flag == SCB_ABORT ? "n ABORT" : " TARGET RESET");
 
 	printf("CDB:");
@@ -2093,9 +2093,8 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		 * No target device for this command exists,
 		 * so we must not still own the command.
 		 */
-		printf("%s:%d:%d:%d: Is not an active device\n",
-		       ahd_name(ahd), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+		       "Is not an active device\n");
 		retval = SUCCESS;
 		goto no_cmd;
 	}
@@ -2112,8 +2111,9 @@ ahd_linux_queue_recovery_cmd(struct scsi
 
 		/* Any SCB for this device will do for a target reset */
 		LIST_FOREACH(pending_scb, &ahd->pending_scbs, pending_links) {
-		  	if (ahd_match_scb(ahd, pending_scb, cmd->device->id,
-					  cmd->device->channel + 'A',
+		  	if (ahd_match_scb(ahd, pending_scb,
+					  sdev_id(cmd->device),
+					  sdev_channel(cmd->device) + 'A',
 					  CAM_LUN_WILDCARD,
 					  SCB_LIST_NULL, ROLE_INITIATOR) == 0)
 				break;
@@ -2121,9 +2121,8 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	}
 
 	if (pending_scb == NULL) {
-		printf("%s:%d:%d:%d: Command not found\n",
-		       ahd_name(ahd), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			"Command not found\n");
 		goto no_cmd;
 	}
 
@@ -2146,9 +2145,8 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	paused = TRUE;
 
 	if ((pending_scb->flags & SCB_ACTIVE) == 0) {
-		printf("%s:%d:%d:%d: Command already completed\n",
-		       ahd_name(ahd), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			"Command already completed\n");
 		goto no_cmd;
 	}
 
@@ -2158,21 +2156,23 @@ ahd_linux_queue_recovery_cmd(struct scsi
 
 	disconnected = TRUE;
 	if (flag == SCB_ABORT) {
-		if (ahd_search_qinfifo(ahd, cmd->device->id, 
-				       cmd->device->channel + 'A',
-				       cmd->device->lun, 
+		if (ahd_search_qinfifo(ahd,
+				       sdev_id(cmd->device),
+				       sdev_channel(cmd->device) + 'A',
+				       scsilun_to_int(&cmd->device->lun), 
 				       pending_scb->hscb->tag,
 				       ROLE_INITIATOR, CAM_REQ_ABORTED,
 				       SEARCH_COMPLETE) > 0) {
-			printf("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
-			       ahd_name(ahd), cmd->device->channel, 
-			       cmd->device->id, cmd->device->lun);
+			dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+				"Cmd aborted from QINFIFO\n");
 			retval = SUCCESS;
 			goto done;
 		}
-	} else if (ahd_search_qinfifo(ahd, cmd->device->id,
-				      cmd->device->channel + 'A',
-				      cmd->device->lun, pending_scb->hscb->tag,
+	} else if (ahd_search_qinfifo(ahd,
+				      sdev_id(cmd->device),
+				      sdev_channel(cmd->device) + 'A',
+				      scsilun_to_int(&cmd->device->lun),
+				      pending_scb->hscb->tag,
 				      ROLE_INITIATOR, /*status*/0,
 				      SEARCH_COUNT) > 0) {
 		disconnected = FALSE;
@@ -2204,7 +2204,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	if (last_phase != P_BUSFREE
 	 && (SCB_GET_TAG(pending_scb) == active_scbptr
 	     || (flag == SCB_DEVICE_RESET
-		 && SCSIID_TARGET(ahd, saved_scsiid) == cmd->device->id))) {
+		 && SCSIID_TARGET(ahd, saved_scsiid) == sdev_id(cmd->device)))) {
 
 		/*
 		 * We're active on the bus, so assert ATN
@@ -2214,9 +2214,8 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		pending_scb->flags |= SCB_RECOVERY_SCB|flag;
 		ahd_outb(ahd, MSG_OUT, HOST_MSG);
 		ahd_outb(ahd, SCSISIGO, last_phase|ATNO);
-		printf("%s:%d:%d:%d: Device is active, asserting ATN\n",
-		       ahd_name(ahd), cmd->device->channel,
-		       cmd->device->id, cmd->device->lun);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			"Device is active, asserting ATN\n");
 		wait = TRUE;
 	} else if (disconnected) {
 
@@ -2267,8 +2266,10 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		 * so we are the next SCB for this target
 		 * to run.
 		 */
-		ahd_search_qinfifo(ahd, cmd->device->id,
-				   cmd->device->channel + 'A', cmd->device->lun,
+		ahd_search_qinfifo(ahd,
+				   sdev_id(cmd->device),
+				   sdev_channel(cmd->device) + 'A',
+				   scsilun_to_int(&cmd->device->lun),
 				   SCB_LIST_NULL, ROLE_INITIATOR,
 				   CAM_REQUEUE_REQ, SEARCH_COMPLETE);
 		ahd_qinfifo_requeue_tail(ahd, pending_scb);
@@ -2277,9 +2278,8 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		printf("Device is disconnected, re-queuing SCB\n");
 		wait = TRUE;
 	} else {
-		printf("%s:%d:%d:%d: Unable to deliver message\n",
-		       ahd_name(ahd), cmd->device->channel,
-		       cmd->device->id, cmd->device->lun);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			"Unable to deliver message\n");
 		retval = FAILED;
 		goto done;
 	}
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 6ee1435..1632db6 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -599,16 +599,14 @@ ahc_linux_target_destroy(struct scsi_tar
 static int
 ahc_linux_slave_alloc(struct scsi_device *sdev)
 {
-	struct	ahc_softc *ahc =
-		*((struct ahc_softc **)sdev->host->hostdata);
 	struct scsi_target *starget = sdev->sdev_target;
 	struct ahc_linux_target *targ = scsi_transport_target_data(starget);
 	struct ahc_linux_device *dev;
 
 	if (bootverbose)
-		printf("%s: Slave Alloc %d\n", ahc_name(ahc), sdev->id);
+		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Alloc\n");
 
-	BUG_ON(targ->sdev[sdev->lun] != NULL);
+	BUG_ON(targ->sdev[scsilun_to_int(&sdev->lun)] != NULL);
 
 	dev = scsi_transport_device_data(sdev);
 	memset(dev, 0, sizeof(*dev));
@@ -626,7 +624,7 @@ ahc_linux_slave_alloc(struct scsi_device
 	 */
 	dev->maxtags = 0;
 	
-	targ->sdev[sdev->lun] = sdev;
+	targ->sdev[scsilun_to_int(&sdev->lun)] = sdev;
 
 	spi_period(starget) = 0;
 
@@ -641,7 +639,7 @@ ahc_linux_slave_configure(struct scsi_de
 	ahc = *((struct ahc_softc **)sdev->host->hostdata);
 
 	if (bootverbose)
-		printf("%s: Slave Configure %d\n", ahc_name(ahc), sdev->id);
+		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Configure\n");
 
 	ahc_linux_device_queue_depth(sdev);
 
@@ -661,11 +659,11 @@ ahc_linux_slave_destroy(struct scsi_devi
 
 	ahc = *((struct ahc_softc **)sdev->host->hostdata);
 	if (bootverbose)
-		printf("%s: Slave Destroy %d\n", ahc_name(ahc), sdev->id);
+		dev_printk(KERN_INFO, &sdev->sdev_gendev, "Slave Destroy\n");
 
 	BUG_ON(dev->active);
 
-	targ->sdev[sdev->lun] = NULL;
+	targ->sdev[scsilun_to_int(&sdev->lun)] = NULL;
 }
 
 #if defined(__i386__)
@@ -686,7 +684,7 @@ ahc_linux_biosparam(struct scsi_device *
 	u_int	 channel;
 
 	ahc = *((struct ahc_softc **)sdev->host->hostdata);
-	channel = sdev->channel;
+	channel = sdev_channel(sdev);
 
 	bh = scsi_bios_ptable(bdev);
 	if (bh) {
@@ -759,7 +757,7 @@ ahc_linux_bus_reset(struct scsi_cmnd *cm
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
 	ahc_lock(ahc, &flags);
-	found = ahc_reset_channel(ahc, cmd->device->channel + 'A',
+	found = ahc_reset_channel(ahc, sdev_channel(cmd->device) + 'A',
 				  /*initiate reset*/TRUE);
 	ahc_unlock(ahc, &flags);
 
@@ -798,9 +796,9 @@ struct scsi_host_template aic7xxx_driver
 
 /******************************** Macros **************************************/
 #define BUILD_SCSIID(ahc, cmd)						    \
-	((((cmd)->device->id << TID_SHIFT) & TID)			    \
-	| (((cmd)->device->channel == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
-	| (((cmd)->device->channel == 0) ? 0 : TWIN_CHNLB))
+	(((sdev_id((cmd)->device) << TID_SHIFT) & TID)			    \
+	| ((sdev_channel((cmd)->device) == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
+	| ((sdev_channel((cmd)->device) == 0) ? 0 : TWIN_CHNLB))
 
 /******************************** Bus DMA *************************************/
 int
@@ -1398,7 +1396,8 @@ ahc_linux_device_queue_depth(struct scsi
 	ahc_compile_devinfo(&devinfo,
 			    sdev->sdev_target->channel == 0
 			  ? ahc->our_id : ahc->our_id_b,
-			    sdev->sdev_target->id, sdev->lun,
+			    sdev->sdev_target->id,
+			    scsilun_to_int(&sdev->lun),
 			    sdev->sdev_target->channel == 0 ? 'A' : 'B',
 			    ROLE_INITIATOR);
 	tags = ahc_linux_user_tagdepth(ahc, &devinfo);
@@ -1440,7 +1439,7 @@ ahc_linux_run_command(struct ahc_softc *
 	    && (ahc->features & AHC_SCB_BTT) == 0) {
 		int target_offset;
 
-		target_offset = cmd->device->id + cmd->device->channel * 8;
+		target_offset = sdev_id(cmd->device) + sdev_channel(cmd->device) * 8;
 		untagged_q = &(ahc->untagged_queues[target_offset]);
 		if (!TAILQ_EMPTY(untagged_q))
 			/* if we're already executing an untagged command
@@ -1465,7 +1464,7 @@ ahc_linux_run_command(struct ahc_softc *
 	 */
 	hscb->control = 0;
 	hscb->scsiid = BUILD_SCSIID(ahc, cmd);
-	hscb->lun = cmd->device->lun;
+	hscb->lun = scsilun_to_int(&cmd->device->lun);
 	mask = SCB_GET_TARGET_MASK(ahc, scb);
 	tinfo = ahc_fetch_transinfo(ahc, SCB_GET_CHANNEL(ahc, scb),
 				    SCB_GET_OUR_ID(scb),
@@ -1849,7 +1848,8 @@ ahc_linux_handle_scsi_status(struct ahc_
 
 	ahc_compile_devinfo(&devinfo,
 			    ahc->our_id,
-			    sdev->sdev_target->id, sdev->lun,
+			    sdev->sdev_target->id,
+			    scsilun_to_int(&sdev->lun),
 			    sdev->sdev_target->channel == 0 ? 'A' : 'B',
 			    ROLE_INITIATOR);
 	
@@ -2117,9 +2117,8 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	wait = FALSE;
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
-	printf("%s:%d:%d:%d: Attempting to queue a%s message\n",
-	       ahc_name(ahc), cmd->device->channel,
-	       cmd->device->id, cmd->device->lun,
+	dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+		"Attempting to queue a%s message\n",
 	       flag == SCB_ABORT ? "n ABORT" : " TARGET RESET");
 
 	printf("CDB:");
@@ -2143,21 +2142,19 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		 * No target device for this command exists,
 		 * so we must not still own the command.
 		 */
-		printf("%s:%d:%d:%d: Is not an active device\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			"Is not an active device\n");
 		retval = SUCCESS;
 		goto no_cmd;
 	}
 
 	if ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED)) == 0
-	 && ahc_search_untagged_queues(ahc, cmd, cmd->device->id,
-				       cmd->device->channel + 'A',
-				       cmd->device->lun,
+	 && ahc_search_untagged_queues(ahc, cmd, sdev_id(cmd->device),
+				       sdev_channel(cmd->device) + 'A',
+				       scsilun_to_int(&cmd->device->lun),
 				       CAM_REQ_ABORTED, SEARCH_COMPLETE) != 0) {
-		printf("%s:%d:%d:%d: Command found on untagged queue\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			"Command found on untagged queue\n");
 		retval = SUCCESS;
 		goto done;
 	}
@@ -2174,8 +2171,8 @@ ahc_linux_queue_recovery_cmd(struct scsi
 
 		/* Any SCB for this device will do for a target reset */
 		LIST_FOREACH(pending_scb, &ahc->pending_scbs, pending_links) {
-		  	if (ahc_match_scb(ahc, pending_scb, cmd->device->id,
-					  cmd->device->channel + 'A',
+		  	if (ahc_match_scb(ahc, pending_scb, sdev_id(cmd->device),
+					  sdev_channel(cmd->device) + 'A',
 					  CAM_LUN_WILDCARD,
 					  SCB_LIST_NULL, ROLE_INITIATOR) == 0)
 				break;
@@ -2183,9 +2180,8 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	}
 
 	if (pending_scb == NULL) {
-		printf("%s:%d:%d:%d: Command not found\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			"Command not found\n");
 		goto no_cmd;
 	}
 
@@ -2207,9 +2203,8 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	paused = TRUE;
 
 	if ((pending_scb->flags & SCB_ACTIVE) == 0) {
-		printf("%s:%d:%d:%d: Command already completed\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			"Command already completed\n");
 		goto no_cmd;
 	}
 
@@ -2219,21 +2214,21 @@ ahc_linux_queue_recovery_cmd(struct scsi
 
 	disconnected = TRUE;
 	if (flag == SCB_ABORT) {
-		if (ahc_search_qinfifo(ahc, cmd->device->id,
-				       cmd->device->channel + 'A',
-				       cmd->device->lun,
+		if (ahc_search_qinfifo(ahc, sdev_id(cmd->device),
+				       sdev_channel(cmd->device) + 'A',
+				       scsilun_to_int(&cmd->device->lun),
 				       pending_scb->hscb->tag,
 				       ROLE_INITIATOR, CAM_REQ_ABORTED,
 				       SEARCH_COMPLETE) > 0) {
-			printf("%s:%d:%d:%d: Cmd aborted from QINFIFO\n",
-			       ahc_name(ahc), cmd->device->channel,
-					cmd->device->id, cmd->device->lun);
+			dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+				"Cmd aborted from QINFIFO\n");
 			retval = SUCCESS;
 			goto done;
 		}
-	} else if (ahc_search_qinfifo(ahc, cmd->device->id,
-				      cmd->device->channel + 'A',
-				      cmd->device->lun, pending_scb->hscb->tag,
+	} else if (ahc_search_qinfifo(ahc, sdev_id(cmd->device),
+				      sdev_channel(cmd->device) + 'A',
+				      scsilun_to_int(&cmd->device->lun),
+				      pending_scb->hscb->tag,
 				      ROLE_INITIATOR, /*status*/0,
 				      SEARCH_COUNT) > 0) {
 		disconnected = FALSE;
@@ -2266,7 +2261,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	if (last_phase != P_BUSFREE
 	 && (pending_scb->hscb->tag == active_scb_index
 	  || (flag == SCB_DEVICE_RESET
-	   && SCSIID_TARGET(ahc, saved_scsiid) == cmd->device->id))) {
+	   && SCSIID_TARGET(ahc, saved_scsiid) == sdev_id(cmd->device)))) {
 
 		/*
 		 * We're active on the bus, so assert ATN
@@ -2276,9 +2271,8 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		pending_scb->flags |= SCB_RECOVERY_SCB|flag;
 		ahc_outb(ahc, MSG_OUT, HOST_MSG);
 		ahc_outb(ahc, SCSISIGO, last_phase|ATNO);
-		printf("%s:%d:%d:%d: Device is active, asserting ATN\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			"Device is active, asserting ATN\n");
 		wait = TRUE;
 	} else if (disconnected) {
 
@@ -2308,9 +2302,10 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		 * same element in the SCB, SCB_NEXT, for
 		 * both the qinfifo and the disconnected list.
 		 */
-		ahc_search_disc_list(ahc, cmd->device->id,
-				     cmd->device->channel + 'A',
-				     cmd->device->lun, pending_scb->hscb->tag,
+		ahc_search_disc_list(ahc, sdev_id(cmd->device),
+				     sdev_channel(cmd->device) + 'A',
+				     scsilun_to_int(&cmd->device->lun),
+				     pending_scb->hscb->tag,
 				     /*stop_on_first*/TRUE,
 				     /*remove*/TRUE,
 				     /*save_state*/FALSE);
@@ -2333,9 +2328,10 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		 * so we are the next SCB for this target
 		 * to run.
 		 */
-		ahc_search_qinfifo(ahc, cmd->device->id,
-				   cmd->device->channel + 'A',
-				   cmd->device->lun, SCB_LIST_NULL,
+		ahc_search_qinfifo(ahc, sdev_id(cmd->device),
+				   sdev_channel(cmd->device) + 'A',
+				   scsilun_to_int(&cmd->device->lun),
+				   SCB_LIST_NULL,
 				   ROLE_INITIATOR, CAM_REQUEUE_REQ,
 				   SEARCH_COMPLETE);
 		ahc_qinfifo_requeue_tail(ahc, pending_scb);
@@ -2344,9 +2340,8 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		printf("Device is disconnected, re-queuing SCB\n");
 		wait = TRUE;
 	} else {
-		printf("%s:%d:%d:%d: Unable to deliver message\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		dev_printk(KERN_INFO, &cmd->device->sdev_gendev,
+			"Unable to deliver message\n");
 		retval = FAILED;
 		goto done;
 	}
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 7235f94..c3a13e0 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -425,7 +425,10 @@ static int adpt_queue(struct scsi_cmnd *
 		 * to the device structure.  This should be a TEST_UNIT_READY
 		 * command from scan_scsis_single.
 		 */
-		if ((pDev = adpt_find_device(pHba, (u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun)) == NULL) {
+		if ((pDev = adpt_find_device(pHba,
+			sdev_channel(cmd->device),
+			sdev_id(cmd->device),
+			scsilun_to_int(&cmd->device->lun))) == NULL) {
 			// TODO: if any luns are at this bus, scsi id then fake a TEST_UNIT_READY and INQUIRY response 
 			// with type 7F (for all luns less than the max for this bus,id) so the lun scan will continue.
 			cmd->result = (DID_NO_CONNECT << 16);
@@ -724,9 +727,10 @@ static int adpt_bus_reset(struct scsi_cm
 
 	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
 	memset(msg, 0, sizeof(msg));
-	printk(KERN_WARNING"%s: Bus reset: SCSI Bus %d: tid: %d\n",pHba->name, cmd->device->channel,pHba->channel[cmd->device->channel].tid );
+	dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+		"Bus reset: tid: %d\n", pHba->channel[sdev_channel(cmd->device)].tid );
 	msg[0] = FOUR_WORD_MSG_SIZE|SGL_OFFSET_0;
-	msg[1] = (I2O_HBA_BUS_RESET<<24|HOST_TID<<12|pHba->channel[cmd->device->channel].tid);
+	msg[1] = (I2O_HBA_BUS_RESET<<24|HOST_TID<<12|pHba->channel[sdev_channel(cmd->device)].tid);
 	msg[2] = 0;
 	msg[3] = 0;
 	if(adpt_i2o_post_wait(pHba, msg,sizeof(msg), FOREVER) ){
@@ -744,7 +748,8 @@ static int __adpt_reset(struct scsi_cmnd
 	adpt_hba* pHba;
 	int rcode;
 	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
-	printk(KERN_WARNING"%s: Hba Reset: scsi id %d: tid: %d\n",pHba->name,cmd->device->channel,pHba->channel[cmd->device->channel].tid );
+	dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+		"Hba Reset: tid: %d\n", pHba->channel[sdev_channel(cmd->device)].tid );
 	rcode =  adpt_hba_reset(pHba);
 	if(rcode == 0){
 		printk(KERN_WARNING"%s: HBA reset complete\n",pHba->name);
@@ -2256,8 +2261,9 @@ static s32 adpt_i2o_to_scsi(void __iomem
 		case I2O_SCSI_DSC_COMMAND_TIMEOUT:
 		case I2O_SCSI_DSC_NO_ADAPTER:
 		case I2O_SCSI_DSC_RESOURCE_UNAVAILABLE:
-			printk(KERN_WARNING"%s: SCSI Timeout-Device (%d,%d,%d) hba status=0x%x, dev status=0x%x, cmd=0x%x\n",
-				pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun, hba_status, dev_status, cmd->cmnd[0]);
+			dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+				"SCSI Timeout-Device hba status=0x%x, dev status=0x%x, cmd=0x%x\n",
+				hba_status, dev_status, cmd->cmnd[0]);
 			cmd->result = (DID_TIME_OUT << 16);
 			break;
 		case I2O_SCSI_DSC_ADAPTER_BUSY:
@@ -2296,8 +2302,9 @@ static s32 adpt_i2o_to_scsi(void __iomem
 		case I2O_SCSI_DSC_QUEUE_FROZEN:
 		case I2O_SCSI_DSC_REQUEST_INVALID:
 		default:
-			printk(KERN_WARNING"%s: SCSI error %0x-Device(%d,%d,%d) hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
-				pHba->name, detailed_status & I2O_SCSI_DSC_MASK, (u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun,
+			dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+				"SCSI error %0x-Device hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
+				detailed_status & I2O_SCSI_DSC_MASK,
 			       hba_status, dev_status, cmd->cmnd[0]);
 			cmd->result = (DID_ERROR << 16);
 			break;
@@ -2314,8 +2321,8 @@ static s32 adpt_i2o_to_scsi(void __iomem
 			   cmd->sense_buffer[2] == DATA_PROTECT ){
 				/* This is to handle an array failed */
 				cmd->result = (DID_TIME_OUT << 16);
-				printk(KERN_WARNING"%s: SCSI Data Protect-Device (%d,%d,%d) hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
-					pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun, 
+				dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+					"SCSI Data Protect-Device hba_status=0x%x, dev_status=0x%x, cmd=0x%x\n",
 					hba_status, dev_status, cmd->cmnd[0]);
 
 			}
@@ -2326,8 +2333,8 @@ static s32 adpt_i2o_to_scsi(void __iomem
 		 * for a limitted number of retries.
 		 */
 		cmd->result = (DID_TIME_OUT << 16);
-		printk(KERN_WARNING"%s: I2O MSG_FAIL - Device (%d,%d,%d) tid=%d, cmd=0x%x\n",
-			pHba->name, (u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun,
+		dev_printk(KERN_WARNING, &cmd->device->sdev_gendev,
+			"I2O MSG_FAIL - Device tid=%d, cmd=0x%x\n",
 			((struct adpt_device*)(cmd->device->hostdata))->tid, cmd->cmnd[0]);
 	}
 
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 3b2a5bf..9353598 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1154,7 +1154,7 @@ static irqreturn_t do_fdomain_16x0_intr(
       outb(0x40 | FIFO_COUNT, port_base + Interrupt_Cntl);
 
       outb(0x82, port_base + SCSI_Cntl); /* Bus Enable + Select */
-      outb(adapter_mask | (1 << current_SC->device->id), port_base + SCSI_Data_NoACK);
+      outb(adapter_mask | (1 << sdev_id(current_SC->device)), port_base + SCSI_Data_NoACK);
       
       /* Stop arbitration and enable parity */
       outb(0x10 | PARITY_MASK, port_base + TMC_Cntl);
@@ -1166,7 +1166,7 @@ static irqreturn_t do_fdomain_16x0_intr(
       status = inb(port_base + SCSI_Status);
       if (!(status & 0x01)) {
 	 /* Try again, for slow devices */
-	 if (fdomain_select( current_SC->device->id )) {
+	 if (fdomain_select( sdev_id(current_SC->device) )) {
 #if EVERY_ACCESS
 	    printk( " SFAIL " );
 #endif
