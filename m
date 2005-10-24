From: Jeff Garzik <jgarzik@pobox.com>
Subject: [scsi hcil 8/9] use sfoo_printk() in drivers
Date: Mon, 24 Oct 2005 18:04:36 -0400
Message-ID: <20051024220436.GH10567@havoc.gtf.org>
References: <20051024220013.GA10070@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:52623 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751344AbVJXWEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:04:37 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id B2C311C0A80A
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 18:04:36 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9OM4aLT010821
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 18:04:36 -0400
Content-Disposition: inline
In-Reply-To: <20051024220013.GA10070@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


commit 2b24ff9239844b1edf7cc0b829639e46b1c1f80b
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Mon Oct 24 17:14:07 2005 -0400

    [SCSI] use sfoo_printk() in drivers

 drivers/scsi/3w-9xxx.c               |    4 +
 drivers/scsi/3w-xxxx.c               |    4 +
 drivers/scsi/53c700.c                |   83 +++++++++++++++++------------------
 drivers/scsi/53c700.h                |    8 ++-
 drivers/scsi/NCR5380.c               |    9 ++-
 drivers/scsi/aha152x.c               |    3 -
 drivers/scsi/aha1542.c               |    3 -
 drivers/scsi/aic7xxx/aic79xx_osm.c   |   28 +++--------
 drivers/scsi/aic7xxx/aic7xxx_osm.c   |   22 ++-------
 drivers/scsi/atp870u.c               |    7 +-
 drivers/scsi/ch.c                    |    4 -
 drivers/scsi/eata.c                  |   56 +++++++++--------------
 drivers/scsi/eata_pio.c              |   21 ++++++--
 drivers/scsi/ibmmca.c                |   10 ++--
 drivers/scsi/ide-scsi.c              |    2 
 drivers/scsi/in2000.c                |    2 
 drivers/scsi/ipr.h                   |    5 --
 drivers/scsi/megaraid/megaraid_sas.c |    5 --
 drivers/scsi/osst.c                  |    6 +-
 drivers/scsi/tmscsim.c               |    4 -
 drivers/scsi/u14-34f.c               |   32 ++++++-------
 21 files changed, 154 insertions(+), 164 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index a748fbf..d06ee65 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1732,7 +1732,9 @@ static int twa_scsi_eh_reset(struct scsi
 
 	tw_dev->num_resets++;
 
-	printk(KERN_WARNING "3w-9xxx: scsi%d: WARNING: (0x%02X:0x%04X): Unit #%d: Command (0x%x) timed out, resetting card.\n", tw_dev->host->host_no, TW_DRIVER, 0x2c, SCpnt->device->id, SCpnt->cmnd[0]);
+	sdev_printk(KERN_WARNING, SCpnt->device,
+		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
+		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
 
 	/* Now reset the card and some of the device extension data */
 	if (twa_reset_device_extension(tw_dev, 0)) {
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index ae9e020..283f6d2 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1432,7 +1432,9 @@ static int tw_scsi_eh_reset(struct scsi_
 
 	tw_dev->num_resets++;
 
-	printk(KERN_WARNING "3w-xxxx: scsi%d: WARNING: Unit #%d: Command (0x%x) timed out, resetting card.\n", tw_dev->host->host_no, SCpnt->device->id, SCpnt->cmnd[0]);
+	sdev_printk(KERN_WARNING, SCpnt->device,
+		"WARNING: Command (0x%x) timed out, resetting card.\n",
+		SCpnt->cmnd[0]);
 
 	/* Now reset the card and some of the device extension data */
 	if (tw_reset_device_extension(tw_dev, 0)) {
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a7620fc..523d2a9 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -128,6 +128,7 @@
 #include <linux/blkdev.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/device.h>
 #include <asm/dma.h>
 #include <asm/system.h>
 #include <asm/io.h>
@@ -831,8 +832,8 @@ process_extended_message(struct Scsi_Hos
 
 		} else {
 			/* SDTR message out of the blue, reject it */
-			printk(KERN_WARNING "scsi%d Unexpected SDTR msg\n",
-			       host->host_no);
+			shost_printk(KERN_WARNING, host,
+				"Unexpected SDTR msg\n");
 			hostdata->msgout[0] = A_REJECT_MSG;
 			dma_cache_sync(hostdata->msgout, 1, DMA_TO_DEVICE);
 			script_patch_16(hostdata->script, MessageCount, 1);
@@ -906,15 +907,17 @@ process_message(struct Scsi_Host *host,	
 			NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 		} else if(SCp != NULL && NCR_700_get_tag_neg_state(SCp->device) == NCR_700_DURING_TAG_NEGOTIATION) {
 			/* rejected our first simple tag message */
-			printk(KERN_WARNING "scsi%d (%d:%d) Rejected first tag queue attempt, turning off tag queueing\n", host->host_no, pun, lun);
+			scmd_printk(KERN_WARNING, SCp,
+				"Rejected first tag queue attempt, turning off tag queueing\n");
 			/* we're done negotiating */
 			NCR_700_set_tag_neg_state(SCp->device, NCR_700_FINISHED_TAG_NEGOTIATION);
-			hostdata->tag_negotiated &= ~(1<<SCp->device->id);
+			hostdata->tag_negotiated &= ~(1<<scmd_id(SCp));
 			SCp->device->tagged_supported = 0;
 			scsi_deactivate_tcq(SCp->device, host->cmd_per_lun);
 		} else {
-			printk(KERN_WARNING "scsi%d (%d:%d) Unexpected REJECT Message %s\n",
-			       host->host_no, pun, lun,
+			shost_printk(KERN_WARNING, host,
+				"(%d:%d) Unexpected REJECT Message %s\n",
+			       pun, lun,
 			       NCR_700_phase[(dsps & 0xf00) >> 8]);
 			/* however, just ignore it */
 		}
@@ -983,7 +986,8 @@ process_script_interrupt(__u32 dsps, __u
 			if(SCp->cmnd[0] == REQUEST_SENSE) {
 				/* OOPS: bad device, returning another
 				 * contingent allegiance condition */
-				printk(KERN_ERR "scsi%d (%d:%d) broken device is looping in contingent allegiance: ignoring\n", host->host_no, pun, lun);
+				scmd_printk(KERN_ERR, SCp,
+					"broken device is looping in contingent allegiance: ignoring\n");
 				NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
 			} else {
 #ifdef NCR_DEBUG
@@ -1047,12 +1051,13 @@ process_script_interrupt(__u32 dsps, __u
 			//			    SCp->request_bufflen,
 			//			    DMA_FROM_DEVICE);
 			//	if(((char *)SCp->request_buffer)[7] & 0x02) {
-			//		printk(KERN_INFO "scsi%d: (%d:%d) Enabling Tag Command Queuing\n", host->host_no, pun, lun);
-			//		hostdata->tag_negotiated |= (1<<SCp->device->id);
+			//		scmd_printk(KERN_INFO, SCp,
+			//		     "Enabling Tag Command Queuing\n");
+			//		hostdata->tag_negotiated |= (1<<scmd_id(SCp));
 			//		NCR_700_set_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
 			//	} else {
 			//		NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
-			//		hostdata->tag_negotiated &= ~(1<<SCp->device->id);
+			//		hostdata->tag_negotiated &= ~(1<<scmd_id(SCp));
 			//	}
 			//}
 			NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
@@ -1060,11 +1065,11 @@ process_script_interrupt(__u32 dsps, __u
 	} else if((dsps & 0xfffff0f0) == A_UNEXPECTED_PHASE) {
 		__u8 i = (dsps & 0xf00) >> 8;
 
-		printk(KERN_ERR "scsi%d: (%d:%d), UNEXPECTED PHASE %s (%s)\n",
-		       host->host_no, pun, lun,
+		scmd_printk(KERN_ERR, SCp, "UNEXPECTED PHASE %s (%s)\n",
 		       NCR_700_phase[i],
 		       sbcl_to_string(NCR_700_readb(host, SBCL_REG)));
-		printk(KERN_ERR "         len = %d, cmd =", SCp->cmd_len);
+		scmd_printk(KERN_ERR, SCp, "         len = %d, cmd =",
+			SCp->cmd_len);
 		scsi_print_command(SCp);
 
 		NCR_700_internal_bus_reset(host);
@@ -1115,14 +1120,14 @@ process_script_interrupt(__u32 dsps, __u
 			}
 
 			slot = (struct NCR_700_command_slot *)SCp->host_scribble;
-			DEBUG(("53c700: %d:%d:%d, reselection is tag %d, slot %p(%d)\n",
-			       host->host_no, SDp->id, SDp->lun,
-			       hostdata->msgin[2], slot, slot->tag));
+			DDEBUG(KERN_DEBUG, SDp,
+				"reselection is tag %d, slot %p(%d)\n",
+				hostdata->msgin[2], slot, slot->tag);
 		} else {
 			struct scsi_cmnd *SCp = scsi_find_tag(SDp, SCSI_NO_TAG);
 			if(unlikely(SCp == NULL)) {
-				printk(KERN_ERR "scsi%d: (%d:%d) no saved request for untagged cmd\n", 
-				       host->host_no, reselection_id, lun);
+				sdev_printk(KERN_ERR, SDp,
+					"no saved request for untagged cmd\n");
 				BUG();
 			}
 			slot = (struct NCR_700_command_slot *)SCp->host_scribble;
@@ -1764,17 +1769,15 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	 * - The blk layer sent and untagged command
 	 */
 	if(NCR_700_get_depth(SCp->device) != 0
-	   && (!(hostdata->tag_negotiated & (1<<SCp->device->id))
+	   && (!(hostdata->tag_negotiated & (1<<scmd_id(SCp)))
 	       || !blk_rq_tagged(SCp->request))) {
-		DEBUG((KERN_ERR "scsi%d (%d:%d) has non zero depth %d\n",
-		       SCp->device->host->host_no, SCp->device->id, SCp->device->lun,
-		       NCR_700_get_depth(SCp->device)));
+		CDEBUG(KERN_ERR, SCp, "has non zero depth %d\n",
+		       NCR_700_get_depth(SCp->device));
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 	if(NCR_700_get_depth(SCp->device) >= SCp->device->queue_depth) {
-		DEBUG((KERN_ERR "scsi%d (%d:%d) has max tag depth %d\n",
-		       SCp->device->host->host_no, SCp->device->id, SCp->device->lun,
-		       NCR_700_get_depth(SCp->device)));
+		CDEBUG(KERN_ERR, SCp, "has max tag depth %d\n",
+		       NCR_700_get_depth(SCp->device));
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 	NCR_700_set_depth(SCp->device, NCR_700_get_depth(SCp->device) + 1);
@@ -1796,10 +1799,10 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	scsi_print_command(SCp);
 #endif
 	if(blk_rq_tagged(SCp->request)
-	   && (hostdata->tag_negotiated &(1<<SCp->device->id)) == 0
+	   && (hostdata->tag_negotiated &(1<<scmd_id(SCp))) == 0
 	   && NCR_700_get_tag_neg_state(SCp->device) == NCR_700_START_TAG_NEGOTIATION) {
-		printk(KERN_ERR "scsi%d: (%d:%d) Enabling Tag Command Queuing\n", SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
-		hostdata->tag_negotiated |= (1<<SCp->device->id);
+		scmd_printk(KERN_ERR, SCp, "Enabling Tag Command Queuing\n");
+		hostdata->tag_negotiated |= (1<<scmd_id(SCp));
 		NCR_700_set_tag_neg_state(SCp->device, NCR_700_DURING_TAG_NEGOTIATION);
 	}
 
@@ -1810,17 +1813,16 @@ NCR_700_queuecommand(struct scsi_cmnd *S
 	 * FIXME: This will royally screw up on multiple LUN devices
 	 * */
 	if(!blk_rq_tagged(SCp->request)
-	   && (hostdata->tag_negotiated &(1<<SCp->device->id))) {
-		printk(KERN_INFO "scsi%d: (%d:%d) Disabling Tag Command Queuing\n", SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
-		hostdata->tag_negotiated &= ~(1<<SCp->device->id);
+	   && (hostdata->tag_negotiated &(1<<scmd_id(SCp)))) {
+		scmd_printk(KERN_INFO, SCp, "Disabling Tag Command Queuing\n");
+		hostdata->tag_negotiated &= ~(1<<scmd_id(SCp));
 	}
 
-	if((hostdata->tag_negotiated &(1<<SCp->device->id))
+	if((hostdata->tag_negotiated &(1<<scmd_id(SCp)))
 	   && scsi_get_tag_type(SCp->device)) {
 		slot->tag = SCp->request->tag;
-		DEBUG(("53c700 %d:%d:%d, sending out tag %d, slot %p\n",
-		       SCp->device->host->host_no, SCp->device->id, SCp->device->lun, slot->tag,
-		       slot));
+		CDEBUG(KERN_DEBUG, SCp, "sending out tag %d, slot %p\n",
+		       slot->tag, slot);
 	} else {
 		slot->tag = SCSI_NO_TAG;
 		/* must populate current_cmnd for scsi_find_tag to work */
@@ -1920,8 +1922,8 @@ NCR_700_abort(struct scsi_cmnd * SCp)
 {
 	struct NCR_700_command_slot *slot;
 
-	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants to abort command\n\t",
-	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
+	scmd_printk(KERN_INFO, SCp,
+		"New error handler wants to abort command\n\t");
 	scsi_print_command(SCp);
 
 	slot = (struct NCR_700_command_slot *)SCp->host_scribble;
@@ -1954,8 +1956,8 @@ NCR_700_bus_reset(struct scsi_cmnd * SCp
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
 
-	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants BUS reset, cmd %p\n\t",
-	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun, SCp);
+	scmd_printk(KERN_INFO, SCp,
+		"New error handler wants BUS reset, cmd %p\n\t", SCp);
 	scsi_print_command(SCp);
 
 	/* In theory, eh_complete should always be null because the
@@ -1987,8 +1989,7 @@ NCR_700_bus_reset(struct scsi_cmnd * SCp
 STATIC int
 NCR_700_host_reset(struct scsi_cmnd * SCp)
 {
-	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants HOST reset\n\t",
-	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
+	scmd_printk(KERN_INFO, SCp, "New error handler wants HOST reset\n\t");
 	scsi_print_command(SCp);
 
 	spin_lock_irq(SCp->device->host->host_lock);
diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
index e86012c..362d784 100644
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -22,8 +22,14 @@
 
 #ifdef NCR_700_DEBUG
 #define DEBUG(x)	printk x
+#define DDEBUG(prefix, sdev, fmt, a...) \
+	sdev_printk(prefix, sdev, fmt, ##a)
+#define CDEBUG(prefix, scmd, fmt, a...) \
+	scmd_printk(prefix, scmd, fmt, ##a)
 #else
-#define DEBUG(x)
+#define DEBUG(x)	do {} while (0)
+#define DDEBUG(prefix, scmd, fmt, a...) do {} while (0)
+#define CDEBUG(prefix, scmd, fmt, a...) do {} while (0)
 #endif
 
 /* The number of available command slots */
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 23392ae..4368767 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2190,7 +2190,8 @@ static void NCR5380_information_transfer
 						 * If the watchdog timer fires, all future accesses to this
 						 * device will use the polled-IO.
 						 */
-						printk("scsi%d : switching target %d lun %d to slow handshake\n", instance->host_no, cmd->device->id, cmd->device->lun);
+						scmd_printk(KERN_INFO, cmd,
+							    "switching to slow handshake\n");
 						cmd->device->borken = 1;
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 						sink = 1;
@@ -2429,9 +2430,11 @@ static void NCR5380_information_transfer
 						scsi_print_msg(extended_msg);
 						printk("\n");
 					} else if (tmp != EXTENDED_MESSAGE)
-						printk("scsi%d: rejecting unknown message %02x from target %d, lun %d\n", instance->host_no, tmp, cmd->device->id, cmd->device->lun);
+						scmd_printk(KERN_INFO, cmd,
+							"rejecting unknown message %02x\n",tmp);
 					else
-						printk("scsi%d: rejecting unknown extended message code %02x, length %d from target %d, lun %d\n", instance->host_no, extended_msg[1], extended_msg[0], cmd->device->id, cmd->device->lun);
+						scmd_printk(KERN_INFO, cmd,
+							"rejecting unknown extended message code %02x, length %d\n", extended_msg[1], extended_msg[0]);
 
 					msgout = MESSAGE_REJECT;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 630b115..9b7caf5 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2921,8 +2921,7 @@ static void disp_enintr(struct Scsi_Host
  */
 static void show_command(Scsi_Cmnd *ptr)
 {
-	printk(KERN_DEBUG "0x%08x: target=%d; lun=%d; cmnd=(",
-	       (unsigned int) ptr, ptr->device->id, ptr->device->lun);
+	scmd_printk(KERN_DEBUG, ptr, "%p: cmnd=(", ptr);
 
 	__scsi_print_command(ptr->cmnd);
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 9ec4641..adda750 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1405,7 +1405,8 @@ static int aha1542_dev_reset(Scsi_Cmnd *
 	 */
 	aha1542_out(SCpnt->device->host->io_port, &ahacmd, 1);
 
-	printk(KERN_WARNING "aha1542.c: Trying device reset for target %d\n", SCpnt->device->id);
+	scmd_printk(KERN_WARNING, SCpnt,
+		"Trying device reset for target\n");
 
 	return SUCCESS;
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 95c285c..5e023dc 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -52,6 +52,7 @@ static struct scsi_transport_template *a
 #include <linux/mm.h>		/* For fetching system memory size */
 #include <linux/blkdev.h>		/* For block_size() */
 #include <linux/delay.h>	/* For ssleep/msleep */
+#include <linux/device.h>
 
 /*
  * Bucket size for counting good commands in between bad ones.
@@ -565,7 +566,7 @@ ahd_linux_slave_configure(struct scsi_de
 
 	ahd = *((struct ahd_softc **)sdev->host->hostdata);
 	if (bootverbose)
-		printf("%s: Slave Configure %d\n", ahd_name(ahd), sdev->id);
+		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
 
 	ahd_linux_device_queue_depth(sdev);
 
@@ -2067,9 +2068,8 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	wait = FALSE;
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
-	printf("%s:%d:%d:%d: Attempting to queue a%s message:",
-	       ahd_name(ahd), cmd->device->channel,
-	       cmd->device->id, cmd->device->lun,
+	scmd_printk(KERN_INFO, cmd,
+	       "Attempting to queue a%s message:",
 	       flag == SCB_ABORT ? "n ABORT" : " TARGET RESET");
 
 	printf("CDB:");
@@ -2093,9 +2093,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		 * No target device for this command exists,
 		 * so we must not still own the command.
 		 */
-		printf("%s:%d:%d:%d: Is not an active device\n",
-		       ahd_name(ahd), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		scmd_printk(KERN_INFO, cmd, "Is not an active device\n");
 		retval = SUCCESS;
 		goto no_cmd;
 	}
@@ -2121,9 +2119,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	}
 
 	if (pending_scb == NULL) {
-		printf("%s:%d:%d:%d: Command not found\n",
-		       ahd_name(ahd), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		scmd_printk(KERN_INFO, cmd, "Command not found\n");
 		goto no_cmd;
 	}
 
@@ -2146,9 +2142,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 	paused = TRUE;
 
 	if ((pending_scb->flags & SCB_ACTIVE) == 0) {
-		printf("%s:%d:%d:%d: Command already completed\n",
-		       ahd_name(ahd), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		scmd_printk(KERN_INFO, cmd, "Command already completed\n");
 		goto no_cmd;
 	}
 
@@ -2214,9 +2208,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		pending_scb->flags |= SCB_RECOVERY_SCB|flag;
 		ahd_outb(ahd, MSG_OUT, HOST_MSG);
 		ahd_outb(ahd, SCSISIGO, last_phase|ATNO);
-		printf("%s:%d:%d:%d: Device is active, asserting ATN\n",
-		       ahd_name(ahd), cmd->device->channel,
-		       cmd->device->id, cmd->device->lun);
+		scmd_printk(KERN_INFO, cmd, "Device is active, asserting ATN\n");
 		wait = TRUE;
 	} else if (disconnected) {
 
@@ -2277,9 +2269,7 @@ ahd_linux_queue_recovery_cmd(struct scsi
 		printf("Device is disconnected, re-queuing SCB\n");
 		wait = TRUE;
 	} else {
-		printf("%s:%d:%d:%d: Unable to deliver message\n",
-		       ahd_name(ahd), cmd->device->channel,
-		       cmd->device->id, cmd->device->lun);
+		scmd_printk(KERN_INFO, cmd, "Unable to deliver message\n");
 		retval = FAILED;
 		goto done;
 	}
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 6ee1435..7074ab9 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -641,7 +641,7 @@ ahc_linux_slave_configure(struct scsi_de
 	ahc = *((struct ahc_softc **)sdev->host->hostdata);
 
 	if (bootverbose)
-		printf("%s: Slave Configure %d\n", ahc_name(ahc), sdev->id);
+		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
 
 	ahc_linux_device_queue_depth(sdev);
 
@@ -2117,9 +2117,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	wait = FALSE;
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
-	printf("%s:%d:%d:%d: Attempting to queue a%s message\n",
-	       ahc_name(ahc), cmd->device->channel,
-	       cmd->device->id, cmd->device->lun,
+	scmd_printk(KERN_INFO, cmd, "Attempting to queue a%s message\n",
 	       flag == SCB_ABORT ? "n ABORT" : " TARGET RESET");
 
 	printf("CDB:");
@@ -2183,9 +2181,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	}
 
 	if (pending_scb == NULL) {
-		printf("%s:%d:%d:%d: Command not found\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		scmd_printk(KERN_INFO, cmd, "Command not found\n");
 		goto no_cmd;
 	}
 
@@ -2207,9 +2203,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 	paused = TRUE;
 
 	if ((pending_scb->flags & SCB_ACTIVE) == 0) {
-		printf("%s:%d:%d:%d: Command already completed\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		scmd_printk(KERN_INFO, cmd, "Command already completed\n");
 		goto no_cmd;
 	}
 
@@ -2276,9 +2270,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		pending_scb->flags |= SCB_RECOVERY_SCB|flag;
 		ahc_outb(ahc, MSG_OUT, HOST_MSG);
 		ahc_outb(ahc, SCSISIGO, last_phase|ATNO);
-		printf("%s:%d:%d:%d: Device is active, asserting ATN\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		scmd_printk(KERN_INFO, cmd, "Device is active, asserting ATN\n");
 		wait = TRUE;
 	} else if (disconnected) {
 
@@ -2344,9 +2336,7 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		printf("Device is disconnected, re-queuing SCB\n");
 		wait = TRUE;
 	} else {
-		printf("%s:%d:%d:%d: Unable to deliver message\n",
-		       ahc_name(ahc), cmd->device->channel, cmd->device->id,
-		       cmd->device->lun);
+		scmd_printk(KERN_INFO, cmd, "Unable to deliver message\n");
 		retval = FAILED;
 		goto done;
 	}
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index a8cfbef..b150bd8 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -297,11 +297,10 @@ stop_dma:
 			}
 			workreq = dev->id[c][target_id].curr_req;
 #ifdef ED_DBGP			
-			printk(KERN_DEBUG "Channel = %d ID = %d LUN = %d CDB",c,workreq->device->id,workreq->device->lun);
-			for(l=0;l<workreq->cmd_len;l++)
-			{
+			scmd_printk(KERN_DEBUG, workreq, "CDB");
+			for (l = 0; l < workreq->cmd_len; l++)
 				printk(KERN_DEBUG " %x",workreq->cmnd[l]);
-			}
+			printk("\n");
 #endif	
 			
 			tmport = workport + 0x0f;
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index da6e51c..8332415 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -940,9 +940,7 @@ static int ch_probe(struct device *dev)
 			    MKDEV(SCSI_CHANGER_MAJOR,ch->minor),
 			    dev, "s%s", ch->name);
 
-	printk(KERN_INFO "Attached scsi changer %s "
-	       "at scsi%d, channel %d, id %d, lun %d\n", 
-	       ch->name, sd->host->host_no, sd->channel, sd->id, sd->lun);
+	sdev_printk(KERN_INFO, sd, "Attached scsi changer %s\n", ch->name);
 	
 	spin_lock(&ch_devlist_lock);
 	list_add_tail(&ch->list,&ch_devlist);
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index c10e45b..c5f7d6c 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -941,8 +941,6 @@ static int eata2x_slave_configure(struct
 {
 	int tqd, utqd;
 	char *tag_suffix, *link_suffix;
-	struct Scsi_Host *shost = dev->host;
-	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 
 	utqd = MAX_CMD_PER_LUN;
 	tqd = max_queue_depth;
@@ -973,8 +971,8 @@ static int eata2x_slave_configure(struct
 	else
 		link_suffix = "";
 
-	printk("%s: scsi%d, channel %d, id %d, lun %d, cmds/lun %d%s%s.\n",
-	       ha->board_name, shost->host_no, dev->channel, dev->id, dev->lun,
+	sdev_printk(KERN_INFO, dev,
+		"cmds/lun %d%s%s.\n",
 	       dev->queue_depth, link_suffix, tag_suffix);
 
 	return 0;
@@ -1813,9 +1811,8 @@ static int eata2x_queuecommand(struct sc
 	SCpnt->host_scribble = (unsigned char *)&cpp->cpp_index;
 
 	if (do_trace)
-		printk("%s: qcomm, mbox %d, target %d.%d:%d, pid %ld.\n",
-		       ha->board_name, i, SCpnt->device->channel, SCpnt->device->id,
-		       SCpnt->device->lun, SCpnt->pid);
+		scmd_printk(KERN_INFO, SCpnt,
+			"qcomm, mbox %d, pid %ld.\n", i, SCpnt->pid);
 
 	cpp->reqsen = 1;
 	cpp->dispri = 1;
@@ -1847,9 +1844,8 @@ static int eata2x_queuecommand(struct sc
 	if (do_dma(shost->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
 		unmap_dma(i, ha);
 		SCpnt->host_scribble = NULL;
-		printk("%s: qcomm, target %d.%d:%d, pid %ld, adapter busy.\n",
-		       ha->board_name, SCpnt->device->channel, SCpnt->device->id,
-		       SCpnt->device->lun, SCpnt->pid);
+		scmd_printk(KERN_INFO, SCpnt,
+			"qcomm, pid %ld, adapter busy.\n", SCpnt->pid);
 		return 1;
 	}
 
@@ -1864,16 +1860,14 @@ static int eata2x_eh_abort(struct scsi_c
 	unsigned int i;
 
 	if (SCarg->host_scribble == NULL) {
-		printk("%s: abort, target %d.%d:%d, pid %ld inactive.\n",
-		       ha->board_name, SCarg->device->channel, SCarg->device->id,
-		       SCarg->device->lun, SCarg->pid);
+		scmd_printk(KERN_INFO, SCarg,
+			"abort, pid %ld inactive.\n", SCarg->pid);
 		return SUCCESS;
 	}
 
 	i = *(unsigned int *)SCarg->host_scribble;
-	printk("%s: abort, mbox %d, target %d.%d:%d, pid %ld.\n",
-	       ha->board_name, i, SCarg->device->channel, SCarg->device->id,
-	       SCarg->device->lun, SCarg->pid);
+	scmd_printk(KERN_WARNING, SCarg,
+		"abort, mbox %d, pid %ld.\n", i, SCarg->pid);
 
 	if (i >= shost->can_queue)
 		panic("%s: abort, invalid SCarg->host_scribble.\n", ha->board_name);
@@ -1934,9 +1928,8 @@ static int eata2x_eh_host_reset(struct s
 	struct Scsi_Host *shost = SCarg->device->host;
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 
-	printk("%s: reset, enter, target %d.%d:%d, pid %ld.\n",
-	       ha->board_name, SCarg->device->channel, SCarg->device->id,
-	       SCarg->device->lun, SCarg->pid);
+	scmd_printk(KERN_INFO, SCarg,
+		"reset, enter, pid %ld.\n", SCarg->pid);
 
 	spin_lock_irq(shost->host_lock);
 
@@ -2253,12 +2246,11 @@ static int reorder(struct hostdata *ha, 
 			k = il[n];
 			cpp = &ha->cp[k];
 			SCpnt = cpp->SCpnt;
-			printk
-			    ("%s %d.%d:%d pid %ld mb %d fc %d nr %d sec %ld ns %ld"
+			scmd_printk(KERN_INFO, SCpnt,
+			    "%s pid %ld mb %d fc %d nr %d sec %ld ns %ld"
 			     " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
 			     (ihdlr ? "ihdlr" : "qcomm"),
-			     SCpnt->device->channel, SCpnt->device->id,
-			     SCpnt->device->lun, SCpnt->pid, k, flushcount,
+			     SCpnt->pid, k, flushcount,
 			     n_ready, SCpnt->request->sector,
 			     SCpnt->request->nr_sectors, cursec, YESNO(s),
 			     YESNO(r), YESNO(rev), YESNO(input_only),
@@ -2301,12 +2293,11 @@ static void flush_dev(struct scsi_device
 		SCpnt = cpp->SCpnt;
 
 		if (do_dma(dev->host->io_port, cpp->cp_dma_addr, SEND_CP_DMA)) {
-			printk
-			    ("%s: %s, target %d.%d:%d, pid %ld, mbox %d, adapter"
-			     " busy, will abort.\n", ha->board_name,
+			scmd_printk(KERN_INFO, SCpnt,
+			    "%s, pid %ld, mbox %d, adapter"
+			     " busy, will abort.\n",
 			     (ihdlr ? "ihdlr" : "qcomm"),
-			     SCpnt->device->channel, SCpnt->device->id,
-			     SCpnt->device->lun, SCpnt->pid, k);
+			     SCpnt->pid, k);
 			ha->cp_stat[k] = ABORTING;
 			continue;
 		}
@@ -2542,11 +2533,10 @@ static irqreturn_t ihdlr(int irq, struct
 	     spp->adapter_status != ASST && ha->iocount <= 1000) ||
 	    do_trace || msg_byte(spp->target_status))
 #endif
-		printk("%s: ihdlr, mbox %2d, err 0x%x:%x,"
-		       " target %d.%d:%d, pid %ld, reg 0x%x, count %d.\n",
-		       ha->board_name, i, spp->adapter_status, spp->target_status,
-		       SCpnt->device->channel, SCpnt->device->id,
-		       SCpnt->device->lun, SCpnt->pid, reg, ha->iocount);
+		scmd_printk(KERN_INFO, SCpnt, "ihdlr, mbox %2d, err 0x%x:%x,"
+		       " pid %ld, reg 0x%x, count %d.\n",
+		       i, spp->adapter_status, spp->target_status,
+		       SCpnt->pid, reg, ha->iocount);
 
 	unmap_dma(i, ha);
 
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 42c6e35..23beb48 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -384,7 +384,9 @@ static int eata_pio_queue(struct scsi_cm
 
 	cp->status = USED;	/* claim free slot */
 
-	DBG(DBG_QUEUE, printk(KERN_DEBUG "eata_pio_queue pid %ld, target: %x, lun:" " %x, y %d\n", cmd->pid, cmd->device->id, cmd->device->lun, y));
+	DBG(DBG_QUEUE, scmd_printk(KERN_DEBUG, cmd,
+		"eata_pio_queue pid %ld, y %d\n",
+		cmd->pid, y));
 
 	cmd->scsi_done = (void *) done;
 
@@ -427,7 +429,9 @@ static int eata_pio_queue(struct scsi_cm
 
 	if (eata_pio_send_command(base, EATA_CMD_PIO_SEND_CP)) {
 		cmd->result = DID_BUS_BUSY << 16;
-		printk(KERN_NOTICE "eata_pio_queue target %d, pid %ld, HBA busy, " "returning DID_BUS_BUSY, done.\n", cmd->device->id, cmd->pid);
+		scmd_printk(KERN_NOTICE, cmd,
+			"eata_pio_queue pid %ld, HBA busy, "
+			"returning DID_BUS_BUSY, done.\n", cmd->pid);
 		done(cmd);
 		cp->status = FREE;
 		return (0);
@@ -440,7 +444,9 @@ static int eata_pio_queue(struct scsi_cm
 	for (x = 0; x < hd->cppadlen; x++)
 		outw(0, base + HA_RDATA);
 
-	DBG(DBG_QUEUE, printk(KERN_DEBUG "Queued base %#.4lx pid: %ld target: %x " "lun: %x slot %d irq %d\n", (long) sh->base, cmd->pid, cmd->device->id, cmd->device->lun, y, sh->irq));
+	DBG(DBG_QUEUE, scmd_printk(KERN_DEBUG, cmd,
+		"Queued base %#.4lx pid: %ld "
+		"slot %d irq %d\n", (long) sh->base, cmd->pid, y, sh->irq));
 
 	return (0);
 }
@@ -449,8 +455,9 @@ static int eata_pio_abort(struct scsi_cm
 {
 	uint loop = HZ;
 
-	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_abort called pid: %ld " "target: %x lun: %x\n", cmd->pid, cmd->device->id, cmd->device->lun));
-
+	DBG(DBG_ABNORM, scmd_printk(KERN_WARNING, cmd,
+		"eata_pio_abort called pid: %ld\n",
+		cmd->pid));
 
 	while (inb(cmd->device->host->base + HA_RAUXSTAT) & HA_ABUSY)
 		if (--loop == 0) {
@@ -484,7 +491,9 @@ static int eata_pio_host_reset(struct sc
 	struct scsi_cmnd *sp;
 	struct Scsi_Host *host = cmd->device->host;
 
-	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset called pid:%ld target:" " %x lun: %x\n", cmd->pid, cmd->device->id, cmd->device->lun));
+	DBG(DBG_ABNORM, scmd_printk(KERN_WARNING, cmd,
+		"eata_pio_reset called pid:%ld\n",
+		cmd->pid));
 
 	spin_lock_irq(host->host_lock);
 
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 19392f6..d5e9370 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -673,8 +673,9 @@ static irqreturn_t interrupt_handler(int
 	ld(ihost_index)[ldn].cmd = NULL;
 #ifdef IM_DEBUG_TIMEOUT
 	if (cmd) {
-		if ((cmd->target == TIMEOUT_PUN) && (cmd->device->lun == TIMEOUT_LUN)) {
-			printk("IBM MCA SCSI: Ignoring interrupt from pun=%x, lun=%x.\n", cmd->target, cmd->device->lun);
+		if ((cmd->target == TIMEOUT_PUN) && (scsilun_to_int(&cmd->device->lun) == TIMEOUT_LUN)) {
+			scmd_printk(KERN_INFO, cmd,
+				"IBM MCA SCSI: Ignoring interrupt\n");
 			return IRQ_HANDLED;
 		}
 	}
@@ -1860,7 +1861,10 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 					next_ldn(host_index) = 7;
 				if (current_ldn == next_ldn(host_index)) {	/* One circle done ? */
 					/* no non-processing ldn found */
-					printk("IBM MCA SCSI: Cannot assign SCSI-device dynamically!\n" "              On ldn 7-14 SCSI-commands everywhere in progress.\n" "              Reporting DID_NO_CONNECT for device (%d,%d).\n", target, cmd->device->lun);
+					scmd_printk(KERN_WARNING, cmd,
+	"IBM MCA SCSI: Cannot assign SCSI-device dynamically!\n"
+	"              On ldn 7-14 SCSI-commands everywhere in progress.\n"
+	"              Reporting DID_NO_CONNECT for device.\n");
 					cmd->result = DID_NO_CONNECT << 16;	/* return no connect */
 					if (done)
 						done(cmd);
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 3d62c9b..01f8ebf 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -893,7 +893,7 @@ static int idescsi_queue (struct scsi_cm
 	idescsi_pc_t *pc = NULL;
 
 	if (!drive) {
-		printk (KERN_ERR "ide-scsi: drive id %d not present\n", cmd->device->id);
+		scmd_printk (KERN_ERR, cmd, "drive not present\n");
 		goto abort;
 	}
 	scsi = drive_to_idescsi(drive);
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index aed7e64..fe387b5 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -343,7 +343,7 @@ static int in2000_queuecommand(Scsi_Cmnd
 	instance = cmd->device->host;
 	hostdata = (struct IN2000_hostdata *) instance->hostdata;
 
-	DB(DB_QUEUE_COMMAND, printk("Q-%d-%02x-%ld(", cmd->device->id, cmd->cmnd[0], cmd->pid))
+	DB(DB_QUEUE_COMMAND, scmd_printk(KERN_DEBUG, cmd, "Q-%02x-%ld(", cmd->cmnd[0], cmd->pid))
 
 /* Set up a few fields in the Scsi_Cmnd structure for our own use:
  *  - host_scribble is the pointer to the next cmd in the input queue
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index cbff3ea..8cf9671 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1114,9 +1114,8 @@ struct ipr_ucode_image_header {
 #define ipr_warn(...) printk(KERN_WARNING IPR_NAME": "__VA_ARGS__)
 #define ipr_dbg(...) IPR_DBG_CMD(printk(KERN_INFO IPR_NAME ": "__VA_ARGS__))
 
-#define ipr_sdev_printk(level, sdev, fmt, ...) \
-	printk(level IPR_NAME ": %d:%d:%d:%d: " fmt, sdev->host->host_no, \
-		sdev->channel, sdev->id, sdev->lun, ##__VA_ARGS__)
+#define ipr_sdev_printk(level, sdev, fmt, args...) \
+	sdev_printk(level, sdev, fmt, ## args)
 
 #define ipr_sdev_err(sdev, fmt, ...) \
 	ipr_sdev_printk(KERN_ERR, sdev, fmt, ##__VA_ARGS__)
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index c3f6373..4245d05 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -758,9 +758,8 @@ static int megasas_generic_reset(struct 
 
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
-	printk(KERN_NOTICE "megasas: RESET -%ld cmd=%x <c=%d t=%d l=%d>\n",
-	       scmd->serial_number, scmd->cmnd[0], scmd->device->channel,
-	       scmd->device->id, scmd->device->lun);
+	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET -%ld cmd=%x\n",
+	       scmd->serial_number, scmd->cmnd[0]);
 
 	if (instance->hw_crit_error) {
 		printk(KERN_ERR "megasas: cannot recover from previous reset "
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 3f2f246..1f73d67 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5817,9 +5817,9 @@ static int osst_probe(struct device *dev
 	}
 	drive->number = devfs_register_tape(SDp->devfs_name);
 
-	printk(KERN_INFO
-		"osst :I: Attached OnStream %.5s tape at scsi%d, channel %d, id %d, lun %d as %s\n",
-		SDp->model, SDp->host->host_no, SDp->channel, SDp->id, SDp->lun, tape_name(tpnt));
+	sdev_printk(KERN_INFO, SDp,
+		"osst :I: Attached OnStream %.5s tape as %s\n",
+		SDp->model, tape_name(tpnt));
 
 	return 0;
 
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 9589c67..ba61c49 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2077,8 +2077,8 @@ static int DC390_abort(struct scsi_cmnd 
 	struct dc390_acb *pACB = (struct dc390_acb*) cmd->device->host->hostdata;
 	struct dc390_dcb *pDCB = (struct dc390_dcb*) cmd->device->hostdata;
 
-	printk("DC390: Abort command (pid %li, Device %02i-%02i)\n",
-	       cmd->pid, cmd->device->id, cmd->device->lun);
+	scmd_printk(KERN_WARNING, cmd,
+		"DC390: Abort command (pid %li)\n", cmd->pid);
 
 	/* abort() is too stupid for already sent commands at the moment. 
 	 * If it's called we are in trouble anyway, so let's dump some info 
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index b0b6cdf..e778e17 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -726,8 +726,7 @@ static int u14_34f_slave_configure(struc
    else
       link_suffix = "";
 
-   printk("%s: scsi%d, channel %d, id %d, lun %d, cmds/lun %d%s%s.\n",
-          BN(j), host->host_no, dev->channel, dev->id, dev->lun,
+   sdev_printk(KERN_INFO, dev, "cmds/lun %d%s%s.\n",
           dev->queue_depth, link_suffix, tag_suffix);
 
    return FALSE;
@@ -1319,8 +1318,8 @@ static int u14_34f_queuecommand(struct s
    if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
       unmap_dma(i, j);
       SCpnt->host_scribble = NULL;
-      printk("%s: qcomm, target %d.%d:%d, pid %ld, adapter busy.\n",
-             BN(j), SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun, SCpnt->pid);
+      scmd_printk(KERN_INFO, SCpnt,
+      		"qcomm, pid %ld, adapter busy.\n", SCpnt->pid);
       return 1;
       }
 
@@ -1340,14 +1339,14 @@ static int u14_34f_eh_abort(struct scsi_
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
 
    if (SCarg->host_scribble == NULL) {
-      printk("%s: abort, target %d.%d:%d, pid %ld inactive.\n",
-             BN(j), SCarg->device->channel, SCarg->device->id, SCarg->device->lun, SCarg->pid);
+      scmd_printk(KERN_INFO, SCarg, "abort, pid %ld inactive.\n",
+             SCarg->pid);
       return SUCCESS;
       }
 
    i = *(unsigned int *)SCarg->host_scribble;
-   printk("%s: abort, mbox %d, target %d.%d:%d, pid %ld.\n",
-          BN(j), i, SCarg->device->channel, SCarg->device->id, SCarg->device->lun, SCarg->pid);
+   scmd_printk(KERN_INFO, SCarg, "abort, mbox %d, pid %ld.\n",
+	       i, SCarg->pid);
 
    if (i >= sh[j]->can_queue)
       panic("%s: abort, invalid SCarg->host_scribble.\n", BN(j));
@@ -1405,8 +1404,7 @@ static int u14_34f_eh_host_reset(struct 
    struct scsi_cmnd *SCpnt;
 
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
-   printk("%s: reset, enter, target %d.%d:%d, pid %ld.\n",
-          BN(j), SCarg->device->channel, SCarg->device->id, SCarg->device->lun, SCarg->pid);
+   scmd_printk(KERN_INFO, SCarg, "reset, enter, pid %ld.\n", SCarg->pid);
 
    spin_lock_irq(sh[j]->host_lock);
 
@@ -1709,9 +1707,10 @@ static void flush_dev(struct scsi_device
       k = il[n]; cpp = &HD(j)->cp[k]; SCpnt = cpp->SCpnt;
 
       if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
-         printk("%s: %s, target %d.%d:%d, pid %ld, mbox %d, adapter"\
-                " busy, will abort.\n", BN(j), (ihdlr ? "ihdlr" : "qcomm"),
-                SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun, SCpnt->pid, k);
+         scmd_printk(KERN_INFO, SCpnt,
+	 	"%s, pid %ld, mbox %d, adapter"
+                " busy, will abort.\n", (ihdlr ? "ihdlr" : "qcomm"),
+                SCpnt->pid, k);
          HD(j)->cp_stat[k] = ABORTING;
          continue;
          }
@@ -1914,10 +1913,9 @@ static irqreturn_t ihdlr(int irq, unsign
         spp->adapter_status != ASST && HD(j)->iocount <= 1000) ||
         do_trace || msg_byte(spp->target_status))
 #endif
-      printk("%s: ihdlr, mbox %2d, err 0x%x:%x,"\
-             " target %d.%d:%d, pid %ld, reg 0x%x, count %d.\n",
-             BN(j), i, spp->adapter_status, spp->target_status,
-             SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun, SCpnt->pid,
+      scmd_printk(KERN_INFO, SCpnt, "ihdlr, mbox %2d, err 0x%x:%x,"\
+             " pid %ld, reg 0x%x, count %d.\n",
+             i, spp->adapter_status, spp->target_status, SCpnt->pid,
              reg, HD(j)->iocount);
 
    unmap_dma(i, j);
