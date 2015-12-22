From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 59/77] ncr5380: Fix autosense bugs
Date: Tue, 22 Dec 2015 12:18:37 +1100
Message-ID: <20151222011754.046134198@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-autosense-queue
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

NCR5380_information_transfer() may re-queue a command for autosense,
after calling scsi_eh_prep_cmnd(). This creates several possibilities:

1. Reselection may intervene before the re-queued command gets processed.
   If the reconnected command then undergoes autosense, this causes the
   scsi_eh_save data from the previous command to be overwritten.

2. After NCR5380_information_transfer() calls scsi_eh_prep_cmnd(),
   a new REQUEST SENSE command may arrive. This would be queued ahead
   of any command already undergoing autosense, which means the
   scsi_eh_save data might be restored to the wrong command.

3. After NCR5380_information_transfer() calls scsi_eh_prep_cmnd(),
   eh_abort_handler() may abort the command. But the scsi_eh_save data is
   not discarded, which means the scsi_eh_save data might be incorrectly
   restored to the next REQUEST SENSE command issued.

This patch adds a new autosense list so that commands that are re-queued
because of a CHECK CONDITION result can be kept apart from the REQUEST
SENSE commands that arrive via queuecommand.

This patch also adds a function dedicated to dequeueing and preparing the
next command for processing. By refactoring the main loop in this way,
scsi_eh_save takes place when an autosense command is dequeued rather
than when re-queued.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |  194 +++++++++++++++++++---------------
 drivers/scsi/NCR5380.h       |    2 
 drivers/scsi/atari_NCR5380.c |  239 ++++++++++++++++++++++++-------------------
 3 files changed, 249 insertions(+), 186 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-12-22 12:16:58.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-12-22 12:17:03.000000000 +1100
@@ -256,10 +256,12 @@ struct NCR5380_hostdata {
 	unsigned char last_message;		/* last message OUT */
 	struct scsi_cmnd *connected;		/* currently connected cmnd */
 	struct list_head unissued;		/* waiting to be issued */
+	struct list_head autosense;		/* priority issue queue */
 	struct list_head disconnected;		/* waiting for reconnect */
 	spinlock_t lock;			/* protects this struct */
 	int flags;
 	struct scsi_eh_save ses;
+	struct scsi_cmnd *sensing;
 	char info[256];
 	int read_overruns;                /* number of bytes to cut from a
 	                                   * transfer to handle chip overruns */
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:02.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:03.000000000 +1100
@@ -418,6 +418,9 @@ static inline void initialize_SCp(struct
 		cmd->SCp.ptr = NULL;
 		cmd->SCp.this_residual = 0;
 	}
+
+	cmd->SCp.Status = 0;
+	cmd->SCp.Message = 0;
 }
 
 /**
@@ -661,6 +664,8 @@ static int __init NCR5380_init(struct Sc
 #endif
 	spin_lock_init(&hostdata->lock);
 	hostdata->connected = NULL;
+	hostdata->sensing = NULL;
+	INIT_LIST_HEAD(&hostdata->autosense);
 	INIT_LIST_HEAD(&hostdata->unissued);
 	INIT_LIST_HEAD(&hostdata->disconnected);
 
@@ -777,6 +782,16 @@ static void complete_cmd(struct Scsi_Hos
 
 	dsprintk(NDEBUG_QUEUES, instance, "complete_cmd: cmd %p\n", cmd);
 
+	if (hostdata->sensing == cmd) {
+		/* Autosense processing ends here */
+		if ((cmd->result & 0xff) != SAM_STAT_GOOD) {
+			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
+			set_host_byte(cmd, DID_ERROR);
+		} else
+			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
+		hostdata->sensing = NULL;
+	}
+
 #ifdef SUPPORT_TAGS
 	cmd_free_tag(cmd);
 #else
@@ -868,12 +883,77 @@ static inline void maybe_release_dma_irq
 	/* Caller does the locking needed to set & test these data atomically */
 	if (list_empty(&hostdata->disconnected) &&
 	    list_empty(&hostdata->unissued) &&
+	    list_empty(&hostdata->autosense) &&
 	    !hostdata->connected &&
 	    !hostdata->retain_dma_intr)
 		NCR5380_release_dma_irq(instance);
 }
 
 /**
+ * dequeue_next_cmd - dequeue a command for processing
+ * @instance: the scsi host instance
+ *
+ * Priority is given to commands on the autosense queue. These commands
+ * need autosense because of a CHECK CONDITION result.
+ *
+ * Returns a command pointer if a command is found for a target that is
+ * not already busy. Otherwise returns NULL.
+ */
+
+static struct scsi_cmnd *dequeue_next_cmd(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	struct NCR5380_cmd *ncmd;
+	struct scsi_cmnd *cmd;
+
+	if (list_empty(&hostdata->autosense)) {
+		list_for_each_entry(ncmd, &hostdata->unissued, list) {
+			cmd = NCR5380_to_scmd(ncmd);
+			dsprintk(NDEBUG_QUEUES, instance, "dequeue: cmd=%p target=%d busy=0x%02x lun=%llu\n",
+			         cmd, scmd_id(cmd), hostdata->busy[scmd_id(cmd)], cmd->device->lun);
+
+			if (
+#ifdef SUPPORT_TAGS
+			    !is_lun_busy(cmd, 1)
+#else
+			    !(hostdata->busy[scmd_id(cmd)] & (1 << cmd->device->lun))
+#endif
+			) {
+				list_del(&ncmd->list);
+				dsprintk(NDEBUG_QUEUES, instance,
+				         "dequeue: removed %p from issue queue\n", cmd);
+				return cmd;
+			}
+		}
+	} else {
+		/* Autosense processing begins here */
+		ncmd = list_first_entry(&hostdata->autosense,
+		                        struct NCR5380_cmd, list);
+		list_del(&ncmd->list);
+		cmd = NCR5380_to_scmd(ncmd);
+		dsprintk(NDEBUG_QUEUES, instance,
+		         "dequeue: removed %p from autosense queue\n", cmd);
+		scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
+		hostdata->sensing = cmd;
+		return cmd;
+	}
+	return NULL;
+}
+
+static void requeue_cmd(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
+
+	if (hostdata->sensing) {
+		scsi_eh_restore_cmnd(cmd, &hostdata->ses);
+		list_add(&ncmd->list, &hostdata->autosense);
+		hostdata->sensing = NULL;
+	} else
+		list_add(&ncmd->list, &hostdata->unissued);
+}
+
+/**
  * NCR5380_main - NCR state machines
  *
  * NCR5380_main is a coroutine that runs as long as more work can
@@ -889,7 +969,7 @@ static void NCR5380_main(struct work_str
 	struct NCR5380_hostdata *hostdata =
 		container_of(work, struct NCR5380_hostdata, main_task);
 	struct Scsi_Host *instance = hostdata->host;
-	struct NCR5380_cmd *ncmd, *n;
+	struct scsi_cmnd *cmd;
 	int done;
 
 	/*
@@ -902,75 +982,46 @@ static void NCR5380_main(struct work_str
 	do {
 		done = 1;
 
-		if (!hostdata->connected) {
-			dprintk(NDEBUG_MAIN, "scsi%d: not connected\n", HOSTNO);
-			/*
-			 * Search through the issue_queue for a command destined
-			 * for a target that's not busy.
-			 */
-			list_for_each_entry_safe(ncmd, n, &hostdata->unissued,
-			                         list) {
-				struct scsi_cmnd *tmp = NCR5380_to_scmd(ncmd);
-				u8 lun = tmp->device->lun;
-
-				dsprintk(NDEBUG_QUEUES, instance, "main: tmp=%p target=%d busy=%d lun=%d\n",
-				         tmp, scmd_id(tmp), hostdata->busy[scmd_id(tmp)], lun);
-				/*  When we find one, remove it from the issue queue. */
-				if (
-#ifdef SUPPORT_TAGS
-				    !is_lun_busy( tmp, tmp->cmnd[0] != REQUEST_SENSE)
-#else
-				    !(hostdata->busy[tmp->device->id] & (1 << lun))
-#endif
-				    ) {
-					list_del(&ncmd->list);
-					dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
-					         instance, "main: removed %p from issue queue\n",
-					         tmp);
+		while (!hostdata->connected &&
+		       (cmd = dequeue_next_cmd(instance))) {
 
-					hostdata->retain_dma_intr++;
+			dsprintk(NDEBUG_MAIN, instance, "main: dequeued %p\n", cmd);
 
-					/*
-					 * Attempt to establish an I_T_L nexus here.
-					 * On success, instance->hostdata->connected is set.
-					 * On failure, we must add the command back to the
-					 *   issue queue so we can keep trying.
-					 */
-					/*
-					 * REQUEST SENSE commands are issued without tagged
-					 * queueing, even on SCSI-II devices because the
-					 * contingent allegiance condition exists for the
-					 * entire unit.
-					 */
-					/* ++roman: ...and the standard also requires that
-					 * REQUEST SENSE command are untagged.
-					 */
+			/*
+			 * Attempt to establish an I_T_L nexus here.
+			 * On success, instance->hostdata->connected is set.
+			 * On failure, we must add the command back to the
+			 * issue queue so we can keep trying.
+			 */
+			/*
+			 * REQUEST SENSE commands are issued without tagged
+			 * queueing, even on SCSI-II devices because the
+			 * contingent allegiance condition exists for the
+			 * entire unit.
+			 */
+			/* ++roman: ...and the standard also requires that
+			 * REQUEST SENSE command are untagged.
+			 */
 
 #ifdef SUPPORT_TAGS
-					cmd_get_tag(tmp, tmp->cmnd[0] != REQUEST_SENSE);
+			cmd_get_tag(cmd, cmd->cmnd[0] != REQUEST_SENSE);
 #endif
-					if (!NCR5380_select(instance, tmp)) {
-						/* OK or bad target */
-						hostdata->retain_dma_intr--;
-						maybe_release_dma_irq(instance);
-					} else {
-						/* Need to retry */
-						list_add(&ncmd->list, &hostdata->unissued);
-						dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
-						         instance, "main: select() failed, %p returned to issue queue\n",
-						         tmp);
+			hostdata->retain_dma_intr++;
+			if (!NCR5380_select(instance, cmd)) {
+				dsprintk(NDEBUG_MAIN, instance, "main: selected target %d for command %p\n",
+				         scmd_id(cmd), cmd);
+				hostdata->retain_dma_intr--;
+				maybe_release_dma_irq(instance);
+			} else {
+				hostdata->retain_dma_intr--;
+				dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES, instance,
+				         "main: select failed, returning %p to queue\n", cmd);
+				requeue_cmd(instance, cmd);
 #ifdef SUPPORT_TAGS
-						cmd_free_tag(tmp);
+				cmd_free_tag(cmd);
 #endif
-						hostdata->retain_dma_intr--;
-						done = 0;
-					}
-					if (hostdata->connected)
-						break;
-				} /* if target/lun/target queue is not busy */
-			} /* for issue_queue */
-		} /* if (!hostdata->connected) */
-
+			}
+		}
 		if (hostdata->connected
 #ifdef REAL_DMA
 		    && !hostdata->dma_len
@@ -2002,48 +2053,21 @@ static void NCR5380_information_transfer
 					}
 #endif
 
-					/*
-					 * I'm not sure what the correct thing to do here is :
-					 *
-					 * If the command that just executed is NOT a request
-					 * sense, the obvious thing to do is to set the result
-					 * code to the values of the stored parameters.
-					 *
-					 * If it was a REQUEST SENSE command, we need some way to
-					 * differentiate between the failure code of the original
-					 * and the failure code of the REQUEST sense - the obvious
-					 * case is success, where we fall through and leave the
-					 * result code unchanged.
-					 *
-					 * The non-obvious place is where the REQUEST SENSE failed
-					 */
+					cmd->result &= ~0xffff;
+					cmd->result |= cmd->SCp.Status;
+					cmd->result |= cmd->SCp.Message << 8;
 
-					if (cmd->cmnd[0] != REQUEST_SENSE)
-						cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					else if (status_byte(cmd->SCp.Status) != GOOD)
-						cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
-
-					if ((cmd->cmnd[0] == REQUEST_SENSE) &&
-						hostdata->ses.cmd_len) {
-						scsi_eh_restore_cmnd(cmd, &hostdata->ses);
-						hostdata->ses.cmd_len = 0 ;
-					}
-
-					if ((cmd->cmnd[0] != REQUEST_SENSE) &&
-					    (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
-						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
-
-						list_add(&ncmd->list, &hostdata->unissued);
-						dsprintk(NDEBUG_AUTOSENSE | NDEBUG_QUEUES,
-						         instance, "REQUEST SENSE cmd %p added to head of issue queue\n",
-						         cmd);
-#ifdef SUPPORT_TAGS
-						cmd_free_tag(cmd);
-#else
-						hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
-#endif
-					} else {
+					if (cmd->cmnd[0] == REQUEST_SENSE)
 						complete_cmd(instance, cmd);
+					else {
+						if (cmd->SCp.Status == SAM_STAT_CHECK_CONDITION ||
+						    cmd->SCp.Status == SAM_STAT_COMMAND_TERMINATED) {
+							dsprintk(NDEBUG_QUEUES, instance, "autosense: adding cmd %p to tail of autosense queue\n",
+							         cmd);
+							list_add_tail(&ncmd->list,
+							              &hostdata->autosense);
+						} else
+							complete_cmd(instance, cmd);
 					}
 
 					/*
@@ -2533,6 +2557,15 @@ static int NCR5380_bus_reset(struct scsi
 		dsprintk(NDEBUG_ABORT, instance, "reset aborted a connected command\n");
 	hostdata->connected = NULL;
 
+	if (hostdata->sensing) {
+		complete_cmd(instance, hostdata->sensing);
+		hostdata->sensing = NULL;
+	}
+
+	if (!list_empty(&hostdata->autosense))
+		dsprintk(NDEBUG_ABORT, instance, "reset aborted autosense list\n");
+	INIT_LIST_HEAD(&hostdata->autosense);
+
 	if (!list_empty(&hostdata->unissued))
 		dsprintk(NDEBUG_ABORT, instance, "reset aborted unissued list\n");
 	INIT_LIST_HEAD(&hostdata->unissued);
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:17:02.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:17:03.000000000 +1100
@@ -244,6 +244,9 @@ static inline void initialize_SCp(struct
 		cmd->SCp.ptr = NULL;
 		cmd->SCp.this_residual = 0;
 	}
+
+	cmd->SCp.Status = 0;
+	cmd->SCp.Message = 0;
 }
 
 /**
@@ -622,6 +625,8 @@ static int NCR5380_init(struct Scsi_Host
 #endif
 	spin_lock_init(&hostdata->lock);
 	hostdata->connected = NULL;
+	hostdata->sensing = NULL;
+	INIT_LIST_HEAD(&hostdata->autosense);
 	INIT_LIST_HEAD(&hostdata->unissued);
 	INIT_LIST_HEAD(&hostdata->disconnected);
 
@@ -738,6 +743,16 @@ static void complete_cmd(struct Scsi_Hos
 
 	dsprintk(NDEBUG_QUEUES, instance, "complete_cmd: cmd %p\n", cmd);
 
+	if (hostdata->sensing == cmd) {
+		/* Autosense processing ends here */
+		if ((cmd->result & 0xff) != SAM_STAT_GOOD) {
+			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
+			set_host_byte(cmd, DID_ERROR);
+		} else
+			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
+		hostdata->sensing = NULL;
+	}
+
 	hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 
 	cmd->scsi_done(cmd);
@@ -798,6 +813,64 @@ static int NCR5380_queue_command(struct
 }
 
 /**
+ * dequeue_next_cmd - dequeue a command for processing
+ * @instance: the scsi host instance
+ *
+ * Priority is given to commands on the autosense queue. These commands
+ * need autosense because of a CHECK CONDITION result.
+ *
+ * Returns a command pointer if a command is found for a target that is
+ * not already busy. Otherwise returns NULL.
+ */
+
+static struct scsi_cmnd *dequeue_next_cmd(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	struct NCR5380_cmd *ncmd;
+	struct scsi_cmnd *cmd;
+
+	if (list_empty(&hostdata->autosense)) {
+		list_for_each_entry(ncmd, &hostdata->unissued, list) {
+			cmd = NCR5380_to_scmd(ncmd);
+			dsprintk(NDEBUG_QUEUES, instance, "dequeue: cmd=%p target=%d busy=0x%02x lun=%llu\n",
+			         cmd, scmd_id(cmd), hostdata->busy[scmd_id(cmd)], cmd->device->lun);
+
+			if (!(hostdata->busy[scmd_id(cmd)] & (1 << cmd->device->lun))) {
+				list_del(&ncmd->list);
+				dsprintk(NDEBUG_QUEUES, instance,
+				         "dequeue: removed %p from issue queue\n", cmd);
+				return cmd;
+			}
+		}
+	} else {
+		/* Autosense processing begins here */
+		ncmd = list_first_entry(&hostdata->autosense,
+		                        struct NCR5380_cmd, list);
+		list_del(&ncmd->list);
+		cmd = NCR5380_to_scmd(ncmd);
+		dsprintk(NDEBUG_QUEUES, instance,
+		         "dequeue: removed %p from autosense queue\n", cmd);
+		scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
+		hostdata->sensing = cmd;
+		return cmd;
+	}
+	return NULL;
+}
+
+static void requeue_cmd(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
+
+	if (hostdata->sensing) {
+		scsi_eh_restore_cmnd(cmd, &hostdata->ses);
+		list_add(&ncmd->list, &hostdata->autosense);
+		hostdata->sensing = NULL;
+	} else
+		list_add(&ncmd->list, &hostdata->unissued);
+}
+
+/**
  *	NCR5380_main	-	NCR state machines
  *
  *	NCR5380_main is a coroutine that runs as long as more work can 
@@ -814,63 +887,40 @@ static void NCR5380_main(struct work_str
 	struct NCR5380_hostdata *hostdata =
 		container_of(work, struct NCR5380_hostdata, main_task);
 	struct Scsi_Host *instance = hostdata->host;
-	struct NCR5380_cmd *ncmd, *n;
+	struct scsi_cmnd *cmd;
 	int done;
 	
 	spin_lock_irq(&hostdata->lock);
 	do {
 		done = 1;
 
-		if (!hostdata->connected) {
-			dprintk(NDEBUG_MAIN, "scsi%d : not connected\n", instance->host_no);
+		while (!hostdata->connected &&
+		       (cmd = dequeue_next_cmd(instance))) {
+
+			dsprintk(NDEBUG_MAIN, instance, "main: dequeued %p\n", cmd);
+
 			/*
-			 * Search through the issue_queue for a command destined
-			 * for a target that's not busy.
+			 * Attempt to establish an I_T_L nexus here.
+			 * On success, instance->hostdata->connected is set.
+			 * On failure, we must add the command back to the
+			 * issue queue so we can keep trying.
+			 */
+			/*
+			 * REQUEST SENSE commands are issued without tagged
+			 * queueing, even on SCSI-II devices because the
+			 * contingent allegiance condition exists for the
+			 * entire unit.
 			 */
-			list_for_each_entry_safe(ncmd, n, &hostdata->unissued,
-			                         list) {
-				struct scsi_cmnd *tmp = NCR5380_to_scmd(ncmd);
-
-				dsprintk(NDEBUG_QUEUES, instance, "main: tmp=%p target=%d busy=%d lun=%llu\n",
-				         tmp, scmd_id(tmp), hostdata->busy[scmd_id(tmp)],
-				         tmp->device->lun);
-				/*  When we find one, remove it from the issue queue. */
-				if (!(hostdata->busy[tmp->device->id] &
-				      (1 << (u8)(tmp->device->lun & 0xff)))) {
-					list_del(&ncmd->list);
-					dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
-					         instance, "main: removed %p from issue queue\n",
-					         tmp);
-
-					/* 
-					 * Attempt to establish an I_T_L nexus here. 
-					 * On success, instance->hostdata->connected is set.
-					 * On failure, we must add the command back to the
-					 *   issue queue so we can keep trying. 
-					 */
-					/*
-					 * REQUEST SENSE commands are issued without tagged
-					 * queueing, even on SCSI-II devices because the
-					 * contingent allegiance condition exists for the
-					 * entire unit.
-					 */
-
-					if (!NCR5380_select(instance, tmp)) {
-						/* OK or bad target */
-					} else {
-						/* Need to retry */
-						list_add(&ncmd->list, &hostdata->unissued);
-						dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
-						         instance, "main: select() failed, %p returned to issue queue\n",
-						         tmp);
-						done = 0;
-					}
-					if (hostdata->connected)
-						break;
-				}	/* if target/lun is not busy */
-			}	/* for */
-		}	/* if (!hostdata->connected) */
 
+			if (!NCR5380_select(instance, cmd)) {
+				dsprintk(NDEBUG_MAIN, instance, "main: selected target %d for command %p\n",
+				         scmd_id(cmd), cmd);
+			} else {
+				dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES, instance,
+				         "main: select failed, returning %p to queue\n", cmd);
+				requeue_cmd(instance, cmd);
+			}
+		}
 		if (hostdata->connected
 #ifdef REAL_DMA
 		    && !hostdata->dmalen
@@ -1853,43 +1903,21 @@ static void NCR5380_information_transfer
 
 					hostdata->connected = NULL;
 
-					/* 
-					 * I'm not sure what the correct thing to do here is : 
-					 * 
-					 * If the command that just executed is NOT a request 
-					 * sense, the obvious thing to do is to set the result
-					 * code to the values of the stored parameters.
-					 * 
-					 * If it was a REQUEST SENSE command, we need some way 
-					 * to differentiate between the failure code of the original
-					 * and the failure code of the REQUEST sense - the obvious
-					 * case is success, where we fall through and leave the result
-					 * code unchanged.
-					 * 
-					 * The non-obvious place is where the REQUEST SENSE failed 
-					 */
-
-					if (cmd->cmnd[0] != REQUEST_SENSE)
-						cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					else if (status_byte(cmd->SCp.Status) != GOOD)
-						cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
-
-					if ((cmd->cmnd[0] == REQUEST_SENSE) &&
-						hostdata->ses.cmd_len) {
-						scsi_eh_restore_cmnd(cmd, &hostdata->ses);
-						hostdata->ses.cmd_len = 0 ;
-					}
-
-					if ((cmd->cmnd[0] != REQUEST_SENSE) && (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
-						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
+					cmd->result &= ~0xffff;
+					cmd->result |= cmd->SCp.Status;
+					cmd->result |= cmd->SCp.Message << 8;
 
-						list_add(&ncmd->list, &hostdata->unissued);
-						dsprintk(NDEBUG_AUTOSENSE | NDEBUG_QUEUES,
-						         instance, "REQUEST SENSE cmd %p added to head of issue queue\n",
-						         cmd);
-						hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xFF));
-					} else {
+					if (cmd->cmnd[0] == REQUEST_SENSE)
 						complete_cmd(instance, cmd);
+					else {
+						if (cmd->SCp.Status == SAM_STAT_CHECK_CONDITION ||
+						    cmd->SCp.Status == SAM_STAT_COMMAND_TERMINATED) {
+							dsprintk(NDEBUG_QUEUES, instance, "autosense: adding cmd %p to tail of autosense queue\n",
+							         cmd);
+							list_add_tail(&ncmd->list,
+							              &hostdata->autosense);
+						} else
+							complete_cmd(instance, cmd);
 					}
 
 					/* 
