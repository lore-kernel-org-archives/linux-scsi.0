From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 58/78] ncr5380: Refactor command completion
Date: Sun, 03 Jan 2016 16:05:59 +1100
Message-ID: <20160103050516.381766256@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49445 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbcACFS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 00:18:26 -0500
Content-Disposition: inline; filename=ncr5380-complete_cmd
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Implement a 'complete_cmd' function to complete commands. This is needed
by the following patch; the new function provides a site for the logic
needed to correctly handle REQUEST SENSE commands.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |   31 ++++++++++++++++++++++------
 drivers/scsi/atari_NCR5380.c |   46 ++++++++++++++++++++++++++++---------------
 2 files changed, 55 insertions(+), 22 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:20.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:24.000000000 +1100
@@ -765,6 +765,27 @@ static void NCR5380_exit(struct Scsi_Hos
 }
 
 /**
+ * complete_cmd - finish processing a command and return it to the SCSI ML
+ * @instance: the host instance
+ * @cmd: command to complete
+ */
+
+static void complete_cmd(struct Scsi_Host *instance,
+                         struct scsi_cmnd *cmd)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	dsprintk(NDEBUG_QUEUES, instance, "complete_cmd: cmd %p\n", cmd);
+
+#ifdef SUPPORT_TAGS
+	cmd_free_tag(cmd);
+#else
+	hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
+#endif
+	cmd->scsi_done(cmd);
+}
+
+/**
  * NCR5380_queue_command - queue a command
  * @instance: the relevant SCSI adapter
  * @cmd: SCSI command
@@ -1352,10 +1373,7 @@ static int NCR5380_select(struct Scsi_Ho
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		cmd->result = DID_BAD_TARGET << 16;
-#ifdef SUPPORT_TAGS
-		cmd_free_tag(cmd);
-#endif
-		cmd->scsi_done(cmd);
+		complete_cmd(instance, cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		dprintk(NDEBUG_SELECTION, "scsi%d: target did not respond within 250ms\n", HOSTNO);
 		return 0;
@@ -1866,7 +1884,7 @@ static void NCR5380_information_transfer
 				sink = 1;
 				do_abort(instance);
 				cmd->result = DID_ERROR << 16;
-				cmd->scsi_done(cmd);
+				complete_cmd(instance, cmd);
 				return;
 #endif
 			case PHASE_DATAIN:
@@ -1926,7 +1944,7 @@ static void NCR5380_information_transfer
 						sink = 1;
 						do_abort(instance);
 						cmd->result = DID_ERROR << 16;
-						cmd->scsi_done(cmd);
+						complete_cmd(instance, cmd);
 						/* XXX - need to source or sink data here, as appropriate */
 					} else {
 #ifdef REAL_DMA
@@ -1982,8 +2000,6 @@ static void NCR5380_information_transfer
 						if (ta->queue_size > ta->nr_allocated)
 							ta->queue_size = ta->nr_allocated;
 					}
-#else
-					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 #endif
 
 					/*
@@ -2021,8 +2037,13 @@ static void NCR5380_information_transfer
 						dsprintk(NDEBUG_AUTOSENSE | NDEBUG_QUEUES,
 						         instance, "REQUEST SENSE cmd %p added to head of issue queue\n",
 						         cmd);
+#ifdef SUPPORT_TAGS
+						cmd_free_tag(cmd);
+#else
+						hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+#endif
 					} else {
-						cmd->scsi_done(cmd);
+						complete_cmd(instance, cmd);
 					}
 
 					/*
@@ -2193,15 +2214,10 @@ static void NCR5380_information_transfer
 				hostdata->last_message = msgout;
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (msgout == ABORT) {
-#ifdef SUPPORT_TAGS
-					cmd_free_tag(cmd);
-#else
-					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
-#endif
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
+					complete_cmd(instance, cmd);
 					maybe_release_dma_irq(instance);
-					cmd->scsi_done(cmd);
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					return;
 				}
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:04:20.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:24.000000000 +1100
@@ -726,6 +726,24 @@ static void NCR5380_exit(struct Scsi_Hos
 }
 
 /**
+ * complete_cmd - finish processing a command and return it to the SCSI ML
+ * @instance: the host instance
+ * @cmd: command to complete
+ */
+
+static void complete_cmd(struct Scsi_Host *instance,
+                         struct scsi_cmnd *cmd)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	dsprintk(NDEBUG_QUEUES, instance, "complete_cmd: cmd %p\n", cmd);
+
+	hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
+
+	cmd->scsi_done(cmd);
+}
+
+/**
  * NCR5380_queue_command - queue a command
  * @instance: the relevant SCSI adapter
  * @cmd: SCSI command
@@ -1171,7 +1189,7 @@ static int NCR5380_select(struct Scsi_Ho
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		cmd->result = DID_BAD_TARGET << 16;
-		cmd->scsi_done(cmd);
+		complete_cmd(instance, cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		dprintk(NDEBUG_SELECTION, "scsi%d : target did not respond within 250ms\n",
 		        instance->host_no);
@@ -1759,7 +1777,7 @@ static void NCR5380_information_transfer
 				sink = 1;
 				do_abort(instance);
 				cmd->result = DID_ERROR << 16;
-				cmd->scsi_done(cmd);
+				complete_cmd(instance, cmd);
 				return;
 #endif
 			case PHASE_DATAIN:
@@ -1804,7 +1822,7 @@ static void NCR5380_information_transfer
 						sink = 1;
 						do_abort(instance);
 						cmd->result = DID_ERROR << 16;
-						cmd->scsi_done(cmd);
+						complete_cmd(instance, cmd);
 						/* XXX - need to source or sink data here, as appropriate */
 					} else
 						cmd->SCp.this_residual -= transfersize - len;
@@ -1834,7 +1852,6 @@ static void NCR5380_information_transfer
 					         cmd, scmd_id(cmd), cmd->device->lun);
 
 					hostdata->connected = NULL;
-					hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
 
 					/* 
 					 * I'm not sure what the correct thing to do here is : 
@@ -1870,8 +1887,9 @@ static void NCR5380_information_transfer
 						dsprintk(NDEBUG_AUTOSENSE | NDEBUG_QUEUES,
 						         instance, "REQUEST SENSE cmd %p added to head of issue queue\n",
 						         cmd);
+						hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
 					} else {
-						cmd->scsi_done(cmd);
+						complete_cmd(instance, cmd);
 					}
 
 					/* 
@@ -2018,10 +2036,9 @@ static void NCR5380_information_transfer
 				hostdata->last_message = msgout;
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (msgout == ABORT) {
-					hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
-					cmd->scsi_done(cmd);
+					complete_cmd(instance, cmd);
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					return;
 				}


