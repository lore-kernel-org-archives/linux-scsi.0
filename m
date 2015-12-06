From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 54/72] ncr5380: Use dsprintk() for queue debugging
Date: Sun, 06 Dec 2015 12:32:20 +1100
Message-ID: <20151206013140.375520062@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:53118 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbbLFDoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2015 22:44:13 -0500
Content-Disposition: inline; filename=ncr5380-use-dsprintk-for-queue-debugging
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Print the command pointers in the log messages for debugging queue data
structures. The LIST and REMOVE macros can then be removed.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   36 ++++++++++++++++++++++++------------
 drivers/scsi/atari_NCR5380.c |   43 +++++++++++++++++++++++--------------------
 2 files changed, 47 insertions(+), 32 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:53.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:54.000000000 +1100
@@ -931,10 +931,8 @@ static void NCR5380_main(struct work_str
 			     prev = NULL; tmp; prev = tmp, tmp = NEXT(tmp)) {
 				u8 lun = tmp->device->lun;
 
-				dprintk(NDEBUG_LISTS,
-				        "MAIN tmp=%p target=%d busy=%d lun=%d\n",
-				        tmp, scmd_id(tmp), hostdata->busy[scmd_id(tmp)],
-				        lun);
+				dsprintk(NDEBUG_QUEUES, instance, "main: tmp=%p target=%d busy=%d lun=%d\n",
+				         tmp, scmd_id(tmp), hostdata->busy[scmd_id(tmp)], lun);
 				/*  When we find one, remove it from the issue queue. */
 				if (
 #ifdef SUPPORT_TAGS
@@ -951,6 +949,10 @@ static void NCR5380_main(struct work_str
 						hostdata->issue_queue = NEXT(tmp);
 					}
 					SET_NEXT(tmp, NULL);
+					dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
+					         instance, "main: removed %p from issue queue %p\n",
+					         tmp, prev);
+
 					hostdata->retain_dma_intr++;
 
 					/*
@@ -959,9 +961,6 @@ static void NCR5380_main(struct work_str
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying.
 					 */
-					dprintk(NDEBUG_MAIN, "scsi%d: main(): command for target %d "
-						    "lun %d removed from issue_queue\n",
-						    HOSTNO, tmp->device->id, lun);
 					/*
 					 * REQUEST SENSE commands are issued without tagged
 					 * queueing, even on SCSI-II devices because the
@@ -984,13 +983,14 @@ static void NCR5380_main(struct work_str
 						LIST(tmp, hostdata->issue_queue);
 						SET_NEXT(tmp, hostdata->issue_queue);
 						hostdata->issue_queue = tmp;
+						dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
+						         instance, "main: select() failed, %p returned to issue queue\n",
+						         tmp);
 #ifdef SUPPORT_TAGS
 						cmd_free_tag(tmp);
 #endif
 						hostdata->retain_dma_intr--;
 						done = 0;
-						dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
-							    "returned to issue_queue\n", HOSTNO);
 					}
 					if (hostdata->connected)
 						break;
@@ -2012,8 +2012,9 @@ static void NCR5380_information_transfer
 				case COMMAND_COMPLETE:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %llu "
-						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
+					dsprintk(NDEBUG_QUEUES, instance,
+					         "COMMAND COMPLETE %p target %d lun %llu\n",
+					         cmd, scmd_id(cmd), cmd->device->lun);
 
 					hostdata->connected = NULL;
 #ifdef SUPPORT_TAGS
@@ -2062,13 +2063,11 @@ static void NCR5380_information_transfer
 					    (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
-						dprintk(NDEBUG_AUTOSENSE, "scsi%d: performing request sense\n", HOSTNO);
-
 						LIST(cmd,hostdata->issue_queue);
 						SET_NEXT(cmd, hostdata->issue_queue);
 						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
-						dsprintk(NDEBUG_QUEUES, instance,
-						         "REQUEST SENSE cmd %p added to head of issue queue\n",
+						dsprintk(NDEBUG_AUTOSENSE | NDEBUG_QUEUES,
+						         instance, "REQUEST SENSE cmd %p added to head of issue queue\n",
 						         cmd);
 					} else {
 						cmd->scsi_done(cmd);
@@ -2119,10 +2118,10 @@ static void NCR5380_information_transfer
 					SET_NEXT(cmd, hostdata->disconnected_queue);
 					hostdata->connected = NULL;
 					hostdata->disconnected_queue = cmd;
-					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %llu was "
-						  "moved from connected to the "
-						  "disconnected_queue\n", HOSTNO,
-						  cmd->device->id, cmd->device->lun);
+					dsprintk(NDEBUG_INFORMATION | NDEBUG_QUEUES,
+					         instance, "connected command %p for target %d lun %llu moved to disconnected queue\n",
+					         cmd, scmd_id(cmd), cmd->device->lun);
+
 					/*
 					 * Restore phase bits to 0 so an interrupted selection,
 					 * arbitration can resume.
@@ -2422,7 +2421,11 @@ static void NCR5380_reselect(struct Scsi
 		}
 	}
 
-	if (!tmp) {
+	if (tmp) {
+		dsprintk(NDEBUG_RESELECTION | NDEBUG_QUEUES, instance,
+		         "reselect: removed %p from disconnected queue\n", tmp);
+	} else {
+
 #ifdef SUPPORT_TAGS
 		shost_printk(KERN_ERR, instance, "target bitmask 0x%02x lun %d tag %d not in disconnected queue.\n",
 		             target_mask, lun, tag);
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:30:53.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:30:54.000000000 +1100
@@ -823,8 +823,9 @@ static void NCR5380_main(struct work_str
 			 */
 			for (tmp = (struct scsi_cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (struct scsi_cmnd *) tmp->host_scribble)
 			{
-				if (prev != tmp)
-				    dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%llu\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun);
+				dsprintk(NDEBUG_QUEUES, instance, "main: tmp=%p target=%d busy=%d lun=%llu\n",
+				         tmp, scmd_id(tmp), hostdata->busy[scmd_id(tmp)],
+				         tmp->device->lun);
 				/*  When we find one, remove it from the issue queue. */
 				if (!(hostdata->busy[tmp->device->id] &
 				      (1 << (u8)(tmp->device->lun & 0xff)))) {
@@ -836,6 +837,9 @@ static void NCR5380_main(struct work_str
 						hostdata->issue_queue = (struct scsi_cmnd *) tmp->host_scribble;
 					}
 					tmp->host_scribble = NULL;
+					dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
+					         instance, "main: removed %p from issue queue %p\n",
+					         tmp, prev);
 
 					/* 
 					 * Attempt to establish an I_T_L nexus here. 
@@ -843,8 +847,6 @@ static void NCR5380_main(struct work_str
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying. 
 					 */
-					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main() : command for target %d lun %llu removed from issue_queue\n", instance->host_no, tmp->device->id, tmp->device->lun);
-	
 					/*
 					 * REQUEST SENSE commands are issued without tagged
 					 * queueing, even on SCSI-II devices because the
@@ -859,8 +861,10 @@ static void NCR5380_main(struct work_str
 						LIST(tmp, hostdata->issue_queue);
 						tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
 						hostdata->issue_queue = tmp;
+						dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
+						         instance, "main: select() failed, %p returned to issue queue\n",
+						         tmp);
 						done = 0;
-						dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main(): select() failed, returned to issue_queue\n", instance->host_no);
 					}
 					if (hostdata->connected)
 						break;
@@ -1842,8 +1846,11 @@ static void NCR5380_information_transfer
 					/* Accept message by clearing ACK */
 					sink = 1;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+					dsprintk(NDEBUG_QUEUES, instance,
+					         "COMMAND COMPLETE %p target %d lun %llu\n",
+					         cmd, scmd_id(cmd), cmd->device->lun);
+
 					hostdata->connected = NULL;
-					dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d, lun %llu completed\n", instance->host_no, cmd->device->id, cmd->device->lun);
 					hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
 
 					/* 
@@ -1876,14 +1883,12 @@ static void NCR5380_information_transfer
 					if ((cmd->cmnd[0] != REQUEST_SENSE) && (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
-						dprintk(NDEBUG_AUTOSENSE, "scsi%d : performing request sense\n", instance->host_no);
-
 						LIST(cmd, hostdata->issue_queue);
 						cmd->host_scribble = (unsigned char *)
 						    hostdata->issue_queue;
 						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
-						dsprintk(NDEBUG_QUEUES, instance,
-						         "REQUEST SENSE cmd %p added to head of issue queue\n",
+						dsprintk(NDEBUG_AUTOSENSE | NDEBUG_QUEUES,
+						         instance, "REQUEST SENSE cmd %p added to head of issue queue\n",
 						         cmd);
 					} else {
 						cmd->scsi_done(cmd);
@@ -1920,7 +1925,10 @@ static void NCR5380_information_transfer
 						    hostdata->disconnected_queue;
 						hostdata->connected = NULL;
 						hostdata->disconnected_queue = cmd;
-						dprintk(NDEBUG_QUEUES, "scsi%d : command for target %d lun %llu was moved from connected to" "  the disconnected_queue\n", instance->host_no, cmd->device->id, cmd->device->lun);
+						dsprintk(NDEBUG_INFORMATION | NDEBUG_QUEUES,
+						         instance, "connected command %p for target %d lun %llu moved to disconnected queue\n",
+						         cmd, scmd_id(cmd), cmd->device->lun);
+
 						/* 
 						 * Restore phase bits to 0 so an interrupted selection, 
 						 * arbitration can resume.
@@ -2173,7 +2181,11 @@ static void NCR5380_reselect(struct Scsi
 			break;
 		}
 	}
-	if (!tmp) {
+
+	if (tmp) {
+		dsprintk(NDEBUG_RESELECTION | NDEBUG_QUEUES, instance,
+		         "reselect: removed %p from disconnected queue\n", tmp);
+	} else {
 		shost_printk(KERN_ERR, instance, "target bitmask 0x%02x lun %d not in disconnected queue.\n",
 		             target_mask, lun);
 		/*


