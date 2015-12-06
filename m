From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 14/72] ncr5380: Use return instead of goto in NCR5380_select()
Date: Sun, 06 Dec 2015 12:31:40 +1100
Message-ID: <20151206013130.445515834@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-use-return-instead-of-goto
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The "failed" label in NCR5380_select() is not helpful. Some failures
return 0, others -1. Use return instead of goto to improve clarity and
brevity, like atari_NCR5380.c does. Fix the relevant comments.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/NCR5380.c       |   30 ++++++++----------------------
 drivers/scsi/atari_NCR5380.c |    6 +++---
 2 files changed, 11 insertions(+), 25 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:29:40.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:29:42.000000000 +1100
@@ -997,16 +997,6 @@ static void NCR5380_main(struct work_str
 					 */
 					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main() : command for target %d lun %llu removed from issue_queue\n", instance->host_no, tmp->device->id, tmp->device->lun);
 	
-					/*
-					 * A successful selection is defined as one that 
-					 * leaves us with the command connected and 
-					 * in hostdata->connected, OR has terminated the
-					 * command.
-					 *
-					 * With successful commands, we fall through
-					 * and see if we can do an information transfer,
-					 * with failures we will restart.
-					 */
 					hostdata->selecting = NULL;
 					/* RvC: have to preset this to indicate a new command is being performed */
 
@@ -1162,9 +1152,10 @@ static irqreturn_t NCR5380_intr(int dumm
  * Inputs : instance - instantiation of the 5380 driver on which this 
  *      target lives, cmd - SCSI command to execute.
  * 
- * Returns : -1 if selection could not execute for some reason,
- *      0 if selection succeeded or failed because the target 
- *      did not respond.
+ * Returns : -1 if selection failed but should be retried.
+ *      0 if selection failed and should not be retried.
+ *      0 if selection succeeded completely (hostdata->connected == cmd).
+ *      0 if selection in progress (hostdata->selecting == cmd).
  *
  * Side effects : 
  *      If bus busy, arbitration failed, etc, NCR5380_select() will exit 
@@ -1224,7 +1215,7 @@ static int NCR5380_select(struct Scsi_Ho
 		printk(KERN_DEBUG "scsi: arbitration timeout at %d\n", __LINE__);
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		goto failed;
+		return -1;
 	}
 
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : arbitration complete\n", instance->host_no);
@@ -1242,7 +1233,7 @@ static int NCR5380_select(struct Scsi_Ho
 	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) || (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) || (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting MR_ARBITRATE\n", instance->host_no);
-		goto failed;
+		return -1;
 	}
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_SEL);
 
@@ -1255,7 +1246,7 @@ static int NCR5380_select(struct Scsi_Ho
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting ICR_ASSERT_SEL\n", instance->host_no);
-		goto failed;
+		return -1;
 	}
 	/* 
 	 * Again, bus clear + bus settle time is 1.2us, however, this is 
@@ -1412,7 +1403,7 @@ part2:
 	if(err) {
 		printk(KERN_ERR "scsi%d: timeout at NCR5380.c:%d\n", instance->host_no, __LINE__);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		goto failed;
+		return -1;
 	}
 
 	dprintk(NDEBUG_SELECTION, "scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id);
@@ -1433,11 +1424,6 @@ part2:
 	initialize_SCp(cmd);
 
 	return 0;
-
-	/* Selection failed */
-failed:
-	return -1;
-
 }
 
 /* 
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:40.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:42.000000000 +1100
@@ -1382,9 +1382,9 @@ static irqreturn_t NCR5380_intr(int irq,
  * Inputs : instance - instantiation of the 5380 driver on which this
  *	target lives, cmd - SCSI command to execute.
  *
- * Returns : -1 if selection could not execute for some reason,
- *	0 if selection succeeded or failed because the target
- *	did not respond.
+ * Returns : -1 if selection failed but should be retried.
+ *      0 if selection failed and should not be retried.
+ *      0 if selection succeeded completely (hostdata->connected == cmd).
  *
  * Side effects :
  *	If bus busy, arbitration failed, etc, NCR5380_select() will exit
