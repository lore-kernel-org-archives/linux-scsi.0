From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 05/12] scsi/NCR5380: fix build failures when debugging is enabled
Date: Wed, 19 Mar 2014 23:35:21 +1100
Message-ID: <20140319123518.052427772@telegraphics.com.au>
References: <20140319123516.542623278@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-debug-macros-build-failures
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The change from cmd->target to cmd->device->id was apparently the purpose of
commit a7f251228390e87d86c5e3846f99a455517fdd8e in
kernel/git/tglx/history.git but some instances have been missed.

Also fix the "NDEBUG_LAST_WRITE_SENT" and "NDEBUG_ALL" typo's.

Also fix some format strings (%ul becomes %lu) that caused compiler warnings.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Changes since v1:

- Fixed a build failure in sun3_NCR5380.c with NDEBUG_LISTS.

---
 drivers/scsi/NCR5380.c      |   14 +++++++-------
 drivers/scsi/sun3_NCR5380.c |   10 +++-------
 2 files changed, 10 insertions(+), 14 deletions(-)

Index: linux-m68k/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_NCR5380.c	2014-03-19 23:23:02.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_NCR5380.c	2014-03-19 23:34:42.000000000 +1100
@@ -1012,12 +1012,8 @@ static void NCR5380_main (struct work_st
 	    for (tmp = (struct scsi_cmnd *) hostdata->issue_queue,
 		 prev = NULL; tmp; prev = tmp, tmp = NEXT(tmp) ) {
 
-#if (NDEBUG & NDEBUG_LISTS)
 		if (prev != tmp)
-		    printk("MAIN tmp=%p   target=%d   busy=%d lun=%d\n",
-			   tmp, tmp->target, hostdata->busy[tmp->target],
-			   tmp->lun);
-#endif
+			dprintk(NDEBUG_LISTS, ("MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun));
 		/*  When we find one, remove it from the issue queue. */
 		/* ++guenther: possible race with Falcon locking */
 		if (
@@ -1049,7 +1045,7 @@ static void NCR5380_main (struct work_st
 		     */
 		    MAIN_PRINTK("scsi%d: main(): command for target %d "
 				"lun %d removed from issue_queue\n",
-				HOSTNO, tmp->target, tmp->lun);
+				HOSTNO, tmp->device->id, tmp->device->lun);
 		    /* 
 		     * REQUEST SENSE commands are issued without tagged
 		     * queueing, even on SCSI-II devices because the 
@@ -2587,7 +2583,7 @@ static void NCR5380_reselect (struct Scs
     
     hostdata->connected = tmp;
     RSL_PRINTK("scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
-	       HOSTNO, tmp->target, tmp->lun, tmp->tag);
+	       HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
 }
 
 
Index: linux-m68k/drivers/scsi/NCR5380.c
===================================================================
--- linux-m68k.orig/drivers/scsi/NCR5380.c	2014-03-19 23:34:41.000000000 +1100
+++ linux-m68k/drivers/scsi/NCR5380.c	2014-03-19 23:34:42.000000000 +1100
@@ -1046,7 +1046,7 @@ static void NCR5380_main(struct work_str
 			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble) 
 			{
 				if (prev != tmp)
-					dprintk(NDEBUG_LISTS, ("MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->target, hostdata->busy[tmp->target], tmp->lun));
+					dprintk(NDEBUG_LISTS, ("MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun));
 				/*  When we find one, remove it from the issue queue. */
 				if (!(hostdata->busy[tmp->device->id] & (1 << tmp->device->lun))) {
 					if (prev) {
@@ -1064,7 +1064,7 @@ static void NCR5380_main(struct work_str
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying. 
 					 */
-					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, ("scsi%d : main() : command for target %d lun %d removed from issue_queue\n", instance->host_no, tmp->target, tmp->lun));
+					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, ("scsi%d : main() : command for target %d lun %d removed from issue_queue\n", instance->host_no, tmp->device->id, tmp->device->lun));
 	
 					/*
 					 * A successful selection is defined as one that 
@@ -2028,7 +2028,7 @@ static int NCR5380_transfer_dma(struct S
 					hostdata->flags &= ~FLAG_CHECK_LAST_BYTE_SENT;
 					if (NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT) {
 						hostdata->flags |= FLAG_HAS_LAST_BYTE_SENT;
-						dprintk(NDEBUG_LAST_WRITE_SENT, ("scsi%d : last bit sent works\n", instance->host_no));
+						dprintk(NDEBUG_LAST_BYTE_SENT, ("scsi%d : last byte sent works\n", instance->host_no));
 					}
 				}
 			} else {
@@ -2454,7 +2454,7 @@ static void NCR5380_information_transfer
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (!cmd->device->disconnect && should_disconnect(cmd->cmnd[0])) {
 					NCR5380_set_timer(hostdata, USLEEP_SLEEP);
-					dprintk(NDEBUG_USLEEP, ("scsi%d : issued command, sleeping until %ul\n", instance->host_no, hostdata->time_expires));
+					dprintk(NDEBUG_USLEEP, ("scsi%d : issued command, sleeping until %lu\n", instance->host_no, hostdata->time_expires));
 					return;
 				}
 				break;
@@ -2466,7 +2466,7 @@ static void NCR5380_information_transfer
 				break;
 			default:
 				printk("scsi%d : unknown phase\n", instance->host_no);
-				NCR5380_dprint(NDEBUG_ALL, instance);
+				NCR5380_dprint(NDEBUG_ANY, instance);
 			}	/* switch(phase) */
 		}		/* if (tmp * SR_REQ) */
 		else {
@@ -2474,7 +2474,7 @@ static void NCR5380_information_transfer
 			 */
 			if (!cmd->device->disconnect && time_after_eq(jiffies, poll_time)) {
 				NCR5380_set_timer(hostdata, USLEEP_SLEEP);
-				dprintk(NDEBUG_USLEEP, ("scsi%d : poll timed out, sleeping until %ul\n", instance->host_no, hostdata->time_expires));
+				dprintk(NDEBUG_USLEEP, ("scsi%d : poll timed out, sleeping until %lu\n", instance->host_no, hostdata->time_expires));
 				return;
 			}
 		}
@@ -2595,7 +2595,7 @@ static void NCR5380_reselect(struct Scsi
 		do_abort(instance);
 	} else {
 		hostdata->connected = tmp;
-		dprintk(NDEBUG_RESELECTION, ("scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->target, tmp->lun, tmp->tag));
+		dprintk(NDEBUG_RESELECTION, ("scsi%d : nexus established, target = %d, lun = %d, tag = %d\n", instance->host_no, tmp->device->id, tmp->device->lun, tmp->tag));
 	}
 }
 
