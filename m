From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 54/78] ncr5380: Use dsprintk() for queue debugging
Date: Sun, 03 Jan 2016 16:05:55 +1100
Message-ID: <20160103050515.341849728@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-use-dsprintk-for-queue-debugging
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Print the command pointers in the log messages for debugging queue data
structures. The LIST and REMOVE macros can then be removed.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |   36 ++++++++++++++++++++++++------------
 drivers/scsi/atari_NCR5380.c |   43 +++++++++++++++++++++++--------------------
 2 files changed, 47 insertions(+), 32 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:15.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:17.000000000 +1100
@@ -936,10 +936,8 @@ static void NCR5380_main(struct work_str
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
@@ -956,6 +954,10 @@ static void NCR5380_main(struct work_str
 						hostdata->issue_queue = NEXT(tmp);
 					}
 					SET_NEXT(tmp, NULL);
+					dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
+					         instance, "main: removed %p from issue queue %p\n",
+					         tmp, prev);
+
 					hostdata->retain_dma_intr++;
 
 					/*
@@ -964,9 +966,6 @@ static void NCR5380_main(struct work_str
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying.
 					 */
-					dprintk(NDEBUG_MAIN, "scsi%d: main(): command for target %d "
-						    "lun %d removed from issue_queue\n",
-						    HOSTNO, tmp->device->id, lun);
 					/*
 					 * REQUEST SENSE commands are issued without tagged
 					 * queueing, even on SCSI-II devices because the
@@ -989,13 +988,14 @@ static void NCR5380_main(struct work_str
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
@@ -2017,8 +2017,9 @@ static void NCR5380_information_transfer
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
@@ -2067,13 +2068,11 @@ static void NCR5380_information_transfer
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
@@ -2124,10 +2123,10 @@ static void NCR5380_information_transfer
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
@@ -2427,7 +2426,11 @@ static void NCR5380_reselect(struct Scsi
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
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:04:15.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:17.000000000 +1100
@@ -828,8 +828,9 @@ static void NCR5380_main(struct work_str
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
@@ -841,6 +842,9 @@ static void NCR5380_main(struct work_str
 						hostdata->issue_queue = (struct scsi_cmnd *) tmp->host_scribble;
 					}
 					tmp->host_scribble = NULL;
+					dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
+					         instance, "main: removed %p from issue queue %p\n",
+					         tmp, prev);
 
 					/* 
 					 * Attempt to establish an I_T_L nexus here. 
@@ -848,8 +852,6 @@ static void NCR5380_main(struct work_str
 					 * On failure, we must add the command back to the
 					 *   issue queue so we can keep trying. 
 					 */
-					dprintk(NDEBUG_MAIN|NDEBUG_QUEUES, "scsi%d : main() : command for target %d lun %llu removed from issue_queue\n", instance->host_no, tmp->device->id, tmp->device->lun);
-	
 					/*
 					 * REQUEST SENSE commands are issued without tagged
 					 * queueing, even on SCSI-II devices because the
@@ -864,8 +866,10 @@ static void NCR5380_main(struct work_str
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
@@ -1847,8 +1851,11 @@ static void NCR5380_information_transfer
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
@@ -1881,14 +1888,12 @@ static void NCR5380_information_transfer
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
@@ -1925,7 +1930,10 @@ static void NCR5380_information_transfer
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
@@ -2178,7 +2186,11 @@ static void NCR5380_reselect(struct Scsi
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
