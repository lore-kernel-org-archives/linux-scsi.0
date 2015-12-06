From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 58/72] ncr5380: Refactor command completion
Date: Sun, 06 Dec 2015 12:32:24 +1100
Message-ID: <20151206013141.355677245@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-complete_cmd
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Implement a 'complete_cmd' function to complete commands. This is needed
by the following patch; the new function provides a site for the logic
needed to correctly handle REQUEST SENSE commands.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   31 ++++++++++++++++++++++------
 drivers/scsi/atari_NCR5380.c |   46 ++++++++++++++++++++++++++++---------------
 2 files changed, 55 insertions(+), 22 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:58.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:31:01.000000000 +1100
@@ -760,6 +760,27 @@ static void NCR5380_exit(struct Scsi_Hos
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
@@ -1347,10 +1368,7 @@ static int NCR5380_select(struct Scsi_Ho
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
@@ -1861,7 +1879,7 @@ static void NCR5380_information_transfer
 				sink = 1;
 				do_abort(instance);
 				cmd->result = DID_ERROR << 16;
-				cmd->scsi_done(cmd);
+				complete_cmd(instance, cmd);
 				return;
 #endif
 			case PHASE_DATAIN:
@@ -1921,7 +1939,7 @@ static void NCR5380_information_transfer
 						sink = 1;
 						do_abort(instance);
 						cmd->result = DID_ERROR << 16;
-						cmd->scsi_done(cmd);
+						complete_cmd(instance, cmd);
 						/* XXX - need to source or sink data here, as appropriate */
 					} else {
 #ifdef REAL_DMA
@@ -1977,8 +1995,6 @@ static void NCR5380_information_transfer
 						if (ta->queue_size > ta->nr_allocated)
 							ta->queue_size = ta->nr_allocated;
 					}
-#else
-					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 #endif
 
 					/*
@@ -2016,8 +2032,13 @@ static void NCR5380_information_transfer
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
@@ -2188,15 +2209,10 @@ static void NCR5380_information_transfer
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
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:30:58.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:31:01.000000000 +1100
@@ -721,6 +721,24 @@ static void NCR5380_exit(struct Scsi_Hos
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
@@ -1166,7 +1184,7 @@ static int NCR5380_select(struct Scsi_Ho
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		cmd->result = DID_BAD_TARGET << 16;
-		cmd->scsi_done(cmd);
+		complete_cmd(instance, cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		dprintk(NDEBUG_SELECTION, "scsi%d : target did not respond within 250ms\n",
 		        instance->host_no);
@@ -1754,7 +1772,7 @@ static void NCR5380_information_transfer
 				sink = 1;
 				do_abort(instance);
 				cmd->result = DID_ERROR << 16;
-				cmd->scsi_done(cmd);
+				complete_cmd(instance, cmd);
 				return;
 #endif
 			case PHASE_DATAIN:
@@ -1799,7 +1817,7 @@ static void NCR5380_information_transfer
 						sink = 1;
 						do_abort(instance);
 						cmd->result = DID_ERROR << 16;
-						cmd->scsi_done(cmd);
+						complete_cmd(instance, cmd);
 						/* XXX - need to source or sink data here, as appropriate */
 					} else
 						cmd->SCp.this_residual -= transfersize - len;
@@ -1829,7 +1847,6 @@ static void NCR5380_information_transfer
 					         cmd, scmd_id(cmd), cmd->device->lun);
 
 					hostdata->connected = NULL;
-					hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
 
 					/* 
 					 * I'm not sure what the correct thing to do here is : 
@@ -1865,8 +1882,9 @@ static void NCR5380_information_transfer
 						dsprintk(NDEBUG_AUTOSENSE | NDEBUG_QUEUES,
 						         instance, "REQUEST SENSE cmd %p added to head of issue queue\n",
 						         cmd);
+						hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
 					} else {
-						cmd->scsi_done(cmd);
+						complete_cmd(instance, cmd);
 					}
 
 					/* 
@@ -2013,10 +2031,9 @@ static void NCR5380_information_transfer
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
