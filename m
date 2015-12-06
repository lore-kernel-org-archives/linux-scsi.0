From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 57/72] ncr5380: Use standard list data structure
Date: Sun, 06 Dec 2015 12:32:23 +1100
Message-ID: <20151206013141.095512248@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline; filename=ncr5380-use-list_head
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

The NCR5380 drivers have a home-spun linked list implementation for
scsi_cmnd structs that uses cmd->host_scribble as a 'next' pointer. Adopt
the standard list_head data structure and list operations instead. Remove
the eh_abort_handler rather than convert it. Doing the conversion would
only be churn because the existing EH handlers don't work and get replaced
in a subsequent patch.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |  214 +++++---------------------------
 drivers/scsi/NCR5380.h       |   16 ++
 drivers/scsi/arm/cumana_1.c  |    1 
 drivers/scsi/arm/oak.c       |    1 
 drivers/scsi/atari_NCR5380.c |  285 ++++++-------------------------------------
 drivers/scsi/atari_scsi.c    |    1 
 drivers/scsi/dmx3191d.c      |    1 
 drivers/scsi/dtc.c           |    1 
 drivers/scsi/g_NCR5380.c     |    1 
 drivers/scsi/mac_scsi.c      |    1 
 drivers/scsi/pas16.c         |    1 
 drivers/scsi/sun3_scsi.c     |    1 
 drivers/scsi/t128.c          |    1 
 13 files changed, 105 insertions(+), 420 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:30:56.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:30:58.000000000 +1100
@@ -622,8 +622,9 @@ static int NCR5380_init(struct Scsi_Host
 #endif
 	spin_lock_init(&hostdata->lock);
 	hostdata->connected = NULL;
-	hostdata->issue_queue = NULL;
-	hostdata->disconnected_queue = NULL;
+	INIT_LIST_HEAD(&hostdata->unissued);
+	INIT_LIST_HEAD(&hostdata->disconnected);
+
 	hostdata->flags = flags;
 	
 	INIT_WORK(&hostdata->main_task, NCR5380_main);
@@ -733,7 +734,7 @@ static int NCR5380_queue_command(struct
                                  struct scsi_cmnd *cmd)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	struct scsi_cmnd *tmp;
+	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
 	unsigned long flags;
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
@@ -747,12 +748,6 @@ static int NCR5380_queue_command(struct
 	}
 #endif				/* (NDEBUG & NDEBUG_NO_WRITE) */
 
-	/* 
-	 * We use the host_scribble field as a pointer to the next command  
-	 * in a queue 
-	 */
-
-	cmd->host_scribble = NULL;
 	cmd->result = 0;
 
 	spin_lock_irqsave(&hostdata->lock, flags);
@@ -764,13 +759,11 @@ static int NCR5380_queue_command(struct
 	 * sense data is only guaranteed to be valid while the condition exists.
 	 */
 
-	if (!(hostdata->issue_queue) || (cmd->cmnd[0] == REQUEST_SENSE)) {
-		cmd->host_scribble = (unsigned char *) hostdata->issue_queue;
-		hostdata->issue_queue = cmd;
-	} else {
-		for (tmp = (struct scsi_cmnd *) hostdata->issue_queue; tmp->host_scribble; tmp = (struct scsi_cmnd *) tmp->host_scribble);
-		tmp->host_scribble = (unsigned char *) cmd;
-	}
+	if (cmd->cmnd[0] == REQUEST_SENSE)
+		list_add(&ncmd->list, &hostdata->unissued);
+	else
+		list_add_tail(&ncmd->list, &hostdata->unissued);
+
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	dsprintk(NDEBUG_QUEUES, instance, "command %p added to %s of queue\n",
@@ -798,7 +791,7 @@ static void NCR5380_main(struct work_str
 	struct NCR5380_hostdata *hostdata =
 		container_of(work, struct NCR5380_hostdata, main_task);
 	struct Scsi_Host *instance = hostdata->host;
-	struct scsi_cmnd *tmp, *prev;
+	struct NCR5380_cmd *ncmd, *n;
 	int done;
 	
 	spin_lock_irq(&hostdata->lock);
@@ -811,23 +804,20 @@ static void NCR5380_main(struct work_str
 			 * Search through the issue_queue for a command destined
 			 * for a target that's not busy.
 			 */
-			for (tmp = (struct scsi_cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (struct scsi_cmnd *) tmp->host_scribble)
-			{
+			list_for_each_entry_safe(ncmd, n, &hostdata->unissued,
+			                         list) {
+				struct scsi_cmnd *tmp = NCR5380_to_scmd(ncmd);
+
 				dsprintk(NDEBUG_QUEUES, instance, "main: tmp=%p target=%d busy=%d lun=%llu\n",
 				         tmp, scmd_id(tmp), hostdata->busy[scmd_id(tmp)],
 				         tmp->device->lun);
 				/*  When we find one, remove it from the issue queue. */
 				if (!(hostdata->busy[tmp->device->id] &
 				      (1 << (u8)(tmp->device->lun & 0xff)))) {
-					if (prev) {
-						prev->host_scribble = tmp->host_scribble;
-					} else {
-						hostdata->issue_queue = (struct scsi_cmnd *) tmp->host_scribble;
-					}
-					tmp->host_scribble = NULL;
+					list_del(&ncmd->list);
 					dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
-					         instance, "main: removed %p from issue queue %p\n",
-					         tmp, prev);
+					         instance, "main: removed %p from issue queue\n",
+					         tmp);
 
 					/* 
 					 * Attempt to establish an I_T_L nexus here. 
@@ -846,8 +836,7 @@ static void NCR5380_main(struct work_str
 						/* OK or bad target */
 					} else {
 						/* Need to retry */
-						tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
-						hostdata->issue_queue = tmp;
+						list_add(&ncmd->list, &hostdata->unissued);
 						dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
 						         instance, "main: select() failed, %p returned to issue queue\n",
 						         tmp);
@@ -1739,6 +1728,8 @@ static void NCR5380_information_transfer
 	struct scsi_cmnd *cmd;
 
 	while ((cmd = hostdata->connected)) {
+		struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
+
 		tmp = NCR5380_read(STATUS_REG);
 		/* We only have a valid SCSI phase when REQ is asserted */
 		if (tmp & SR_REQ) {
@@ -1870,9 +1861,7 @@ static void NCR5380_information_transfer
 					if ((cmd->cmnd[0] != REQUEST_SENSE) && (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
-						cmd->host_scribble = (unsigned char *)
-						    hostdata->issue_queue;
-						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
+						list_add(&ncmd->list, &hostdata->unissued);
 						dsprintk(NDEBUG_AUTOSENSE | NDEBUG_QUEUES,
 						         instance, "REQUEST SENSE cmd %p added to head of issue queue\n",
 						         cmd);
@@ -1906,10 +1895,8 @@ static void NCR5380_information_transfer
 				case DISCONNECT:{
 						/* Accept message by clearing ACK */
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-						cmd->host_scribble = (unsigned char *)
-						    hostdata->disconnected_queue;
 						hostdata->connected = NULL;
-						hostdata->disconnected_queue = cmd;
+						list_add(&ncmd->list, &hostdata->disconnected);
 						dsprintk(NDEBUG_INFORMATION | NDEBUG_QUEUES,
 						         instance, "connected command %p for target %d lun %llu moved to disconnected queue\n",
 						         cmd, scmd_id(cmd), cmd->device->lun);
@@ -2082,7 +2069,8 @@ static void NCR5380_reselect(struct Scsi
 	int len;
 	unsigned char msg[3];
 	unsigned char *data;
-	struct scsi_cmnd *tmp = NULL, *prev;
+	struct NCR5380_cmd *ncmd;
+	struct scsi_cmnd *tmp;
 
 	/*
 	 * Disable arbitration, etc. since the host adapter obviously
@@ -2151,16 +2139,14 @@ static void NCR5380_reselect(struct Scsi
 	 * just reestablished, and remove it from the disconnected queue.
 	 */
 
-	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue, prev = NULL;
-	     tmp; prev = tmp, tmp = (struct scsi_cmnd *) tmp->host_scribble) {
-		if ((target_mask == (1 << tmp->device->id)) && (lun == (u8)tmp->device->lun)) {
-			if (prev) {
-				prev->host_scribble = tmp->host_scribble;
-			} else {
-				hostdata->disconnected_queue =
-					(struct scsi_cmnd *) tmp->host_scribble;
-			}
-			tmp->host_scribble = NULL;
+	tmp = NULL;
+	list_for_each_entry(ncmd, &hostdata->disconnected, list) {
+		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
+
+		if (target_mask == (1 << scmd_id(cmd)) &&
+		    lun == (u8)cmd->device->lun) {
+			list_del(&ncmd->list);
+			tmp = cmd;
 			break;
 		}
 	}
@@ -2256,146 +2242,18 @@ static int NCR5380_abort(struct scsi_cmn
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	struct scsi_cmnd *tmp, **prev;
 	unsigned long flags;
 
-	scmd_printk(KERN_WARNING, cmd, "aborting command\n");
-
 	spin_lock_irqsave(&hostdata->lock, flags);
 
+#if (NDEBUG & NDEBUG_ANY)
+	scmd_printk(KERN_INFO, cmd, "aborting command\n");
+#endif
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
-	dprintk(NDEBUG_ABORT, "scsi%d : abort called\n", instance->host_no);
-	dprintk(NDEBUG_ABORT, "        basr 0x%X, sr 0x%X\n", NCR5380_read(BUS_AND_STATUS_REG), NCR5380_read(STATUS_REG));
-
-#if 0
-/*
- * Case 1 : If the command is the currently executing command, 
- * we'll set the aborted flag and return control so that 
- * information transfer routine can exit cleanly.
- */
-
-	if (hostdata->connected == cmd) {
-		dprintk(NDEBUG_ABORT, "scsi%d : aborting connected command\n", instance->host_no);
-/*
- * We should perform BSY checking, and make sure we haven't slipped
- * into BUS FREE.
- */
-
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_ASSERT_ATN);
-/* 
- * Since we can't change phases until we've completed the current 
- * handshake, we have to source or sink a byte of data if the current
- * phase is not MSGOUT.
- */
-
-/* 
- * Return control to the executing NCR drive so we can clear the
- * aborted flag and get back into our main loop.
- */
-
-		return SUCCESS;
-	}
-#endif
-
-/* 
- * Case 2 : If the command hasn't been issued yet, we simply remove it 
- *          from the issue queue.
- */
- 
-	dprintk(NDEBUG_ABORT, "scsi%d : abort going into loop.\n", instance->host_no);
-	for (prev = (struct scsi_cmnd **) &(hostdata->issue_queue), tmp = (struct scsi_cmnd *) hostdata->issue_queue; tmp; prev = (struct scsi_cmnd **) &(tmp->host_scribble), tmp = (struct scsi_cmnd *) tmp->host_scribble)
-		if (cmd == tmp) {
-			(*prev) = (struct scsi_cmnd *) tmp->host_scribble;
-			tmp->host_scribble = NULL;
-			spin_unlock_irqrestore(&hostdata->lock, flags);
-			tmp->result = DID_ABORT << 16;
-			dprintk(NDEBUG_ABORT, "scsi%d : abort removed command from issue queue.\n", instance->host_no);
-			tmp->scsi_done(tmp);
-			return SUCCESS;
-		}
-#if (NDEBUG  & NDEBUG_ABORT)
-	/* KLL */
-		else if (prev == tmp)
-			printk(KERN_ERR "scsi%d : LOOP\n", instance->host_no);
-#endif
-
-/* 
- * Case 3 : If any commands are connected, we're going to fail the abort
- *          and let the high level SCSI driver retry at a later time or 
- *          issue a reset.
- *
- *          Timeouts, and therefore aborted commands, will be highly unlikely
- *          and handling them cleanly in this situation would make the common
- *          case of noresets less efficient, and would pollute our code.  So,
- *          we fail.
- */
-
-	if (hostdata->connected) {
-		spin_unlock_irqrestore(&hostdata->lock, flags);
-		dprintk(NDEBUG_ABORT, "scsi%d : abort failed, command connected.\n", instance->host_no);
-		return FAILED;
-	}
-/*
- * Case 4: If the command is currently disconnected from the bus, and 
- *      there are no connected commands, we reconnect the I_T_L or 
- *      I_T_L_Q nexus associated with it, go into message out, and send 
- *      an abort message.
- *
- * This case is especially ugly. In order to reestablish the nexus, we
- * need to call NCR5380_select().  The easiest way to implement this 
- * function was to abort if the bus was busy, and let the interrupt
- * handler triggered on the SEL for reselect take care of lost arbitrations
- * where necessary, meaning interrupts need to be enabled.
- *
- * When interrupts are enabled, the queues may change - so we 
- * can't remove it from the disconnected queue before selecting it
- * because that could cause a failure in hashing the nexus if that 
- * device reselected.
- * 
- * Since the queues may change, we can't use the pointers from when we
- * first locate it.
- *
- * So, we must first locate the command, and if NCR5380_select()
- * succeeds, then issue the abort, relocate the command and remove
- * it from the disconnected queue.
- */
-
-	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue; tmp; tmp = (struct scsi_cmnd *) tmp->host_scribble)
-		if (cmd == tmp) {
-			dprintk(NDEBUG_ABORT, "scsi%d : aborting disconnected command.\n", instance->host_no);
-
-			if (NCR5380_select(instance, cmd)) {
-				spin_unlock_irq(&hostdata->lock);
-				return FAILED;
-			}
-			dprintk(NDEBUG_ABORT, "scsi%d : nexus reestablished.\n", instance->host_no);
-
-			do_abort(instance);
-
-			for (prev = (struct scsi_cmnd **) &(hostdata->disconnected_queue), tmp = (struct scsi_cmnd *) hostdata->disconnected_queue; tmp; prev = (struct scsi_cmnd **) &(tmp->host_scribble), tmp = (struct scsi_cmnd *) tmp->host_scribble)
-				if (cmd == tmp) {
-					*prev = (struct scsi_cmnd *) tmp->host_scribble;
-					tmp->host_scribble = NULL;
-					spin_unlock_irqrestore(&hostdata->lock, flags);
-					tmp->result = DID_ABORT << 16;
-					tmp->scsi_done(tmp);
-					return SUCCESS;
-				}
-		}
-/*
- * Case 5 : If we reached this point, the command was not found in any of 
- *          the queues.
- *
- * We probably reached this point because of an unlikely race condition
- * between the command completing successfully and the abortion code,
- * so we won't panic, but we will notify the user in case something really
- * broke.
- */
 	spin_unlock_irqrestore(&hostdata->lock, flags);
-	printk(KERN_WARNING "scsi%d : warning : SCSI command probably completed successfully\n"
-			"         before abortion\n", instance->host_no);
+
 	return FAILED;
 }
 
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:57.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:58.000000000 +1100
@@ -175,10 +175,6 @@
  * possible) function may be used.
  */
 
-#define	NEXT(cmd)		((struct scsi_cmnd *)(cmd)->host_scribble)
-#define	SET_NEXT(cmd,next)	((cmd)->host_scribble = (void *)(next))
-#define	NEXTADDR(cmd)		((struct scsi_cmnd **)&(cmd)->host_scribble)
-
 #define	HOSTNO		instance->host_no
 
 static int do_abort(struct Scsi_Host *);
@@ -665,8 +661,9 @@ static int __init NCR5380_init(struct Sc
 #endif
 	spin_lock_init(&hostdata->lock);
 	hostdata->connected = NULL;
-	hostdata->issue_queue = NULL;
-	hostdata->disconnected_queue = NULL;
+	INIT_LIST_HEAD(&hostdata->unissued);
+	INIT_LIST_HEAD(&hostdata->disconnected);
+
 	hostdata->flags = flags;
 
 	INIT_WORK(&hostdata->main_task, NCR5380_main);
@@ -776,7 +773,7 @@ static int NCR5380_queue_command(struct
                                  struct scsi_cmnd *cmd)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	struct scsi_cmnd *tmp;
+	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
 	unsigned long flags;
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
@@ -790,12 +787,6 @@ static int NCR5380_queue_command(struct
 	}
 #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
 
-	/*
-	 * We use the host_scribble field as a pointer to the next command
-	 * in a queue
-	 */
-
-	SET_NEXT(cmd, NULL);
 	cmd->result = 0;
 
 	/*
@@ -829,15 +820,11 @@ static int NCR5380_queue_command(struct
 	 * sense data is only guaranteed to be valid while the condition exists.
 	 */
 
-	if (!(hostdata->issue_queue) || (cmd->cmnd[0] == REQUEST_SENSE)) {
-		SET_NEXT(cmd, hostdata->issue_queue);
-		hostdata->issue_queue = cmd;
-	} else {
-		for (tmp = (struct scsi_cmnd *)hostdata->issue_queue;
-		     NEXT(tmp); tmp = NEXT(tmp))
-			;
-		SET_NEXT(tmp, cmd);
-	}
+	if (cmd->cmnd[0] == REQUEST_SENSE)
+		list_add(&ncmd->list, &hostdata->unissued);
+	else
+		list_add_tail(&ncmd->list, &hostdata->unissued);
+
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	dsprintk(NDEBUG_QUEUES, instance, "command %p added to %s of queue\n",
@@ -853,8 +840,8 @@ static inline void maybe_release_dma_irq
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
 	/* Caller does the locking needed to set & test these data atomically */
-	if (!hostdata->disconnected_queue &&
-	    !hostdata->issue_queue &&
+	if (list_empty(&hostdata->disconnected) &&
+	    list_empty(&hostdata->unissued) &&
 	    !hostdata->connected &&
 	    !hostdata->retain_dma_intr)
 		NCR5380_release_dma_irq(instance);
@@ -876,7 +863,7 @@ static void NCR5380_main(struct work_str
 	struct NCR5380_hostdata *hostdata =
 		container_of(work, struct NCR5380_hostdata, main_task);
 	struct Scsi_Host *instance = hostdata->host;
-	struct scsi_cmnd *tmp, *prev;
+	struct NCR5380_cmd *ncmd, *n;
 	int done;
 
 	/*
@@ -895,17 +882,9 @@ static void NCR5380_main(struct work_str
 			 * Search through the issue_queue for a command destined
 			 * for a target that's not busy.
 			 */
-#if (NDEBUG & NDEBUG_LISTS)
-			for (tmp = (struct scsi_cmnd *) hostdata->issue_queue, prev = NULL;
-			     tmp && (tmp != prev); prev = tmp, tmp = NEXT(tmp))
-				;
-			/*printk("%p  ", tmp);*/
-			if ((tmp == prev) && tmp)
-				printk(" LOOP\n");
-			/* else printk("\n"); */
-#endif
-			for (tmp = (struct scsi_cmnd *) hostdata->issue_queue,
-			     prev = NULL; tmp; prev = tmp, tmp = NEXT(tmp)) {
+			list_for_each_entry_safe(ncmd, n, &hostdata->unissued,
+			                         list) {
+				struct scsi_cmnd *tmp = NCR5380_to_scmd(ncmd);
 				u8 lun = tmp->device->lun;
 
 				dsprintk(NDEBUG_QUEUES, instance, "main: tmp=%p target=%d busy=%d lun=%d\n",
@@ -918,15 +897,10 @@ static void NCR5380_main(struct work_str
 				    !(hostdata->busy[tmp->device->id] & (1 << lun))
 #endif
 				    ) {
-					if (prev) {
-						SET_NEXT(prev, NEXT(tmp));
-					} else {
-						hostdata->issue_queue = NEXT(tmp);
-					}
-					SET_NEXT(tmp, NULL);
+					list_del(&ncmd->list);
 					dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
-					         instance, "main: removed %p from issue queue %p\n",
-					         tmp, prev);
+					         instance, "main: removed %p from issue queue\n",
+					         tmp);
 
 					hostdata->retain_dma_intr++;
 
@@ -955,8 +929,7 @@ static void NCR5380_main(struct work_str
 						maybe_release_dma_irq(instance);
 					} else {
 						/* Need to retry */
-						SET_NEXT(tmp, hostdata->issue_queue);
-						hostdata->issue_queue = tmp;
+						list_add(&ncmd->list, &hostdata->unissued);
 						dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
 						         instance, "main: select() failed, %p returned to issue queue\n",
 						         tmp);
@@ -1829,6 +1802,8 @@ static void NCR5380_information_transfer
 #endif
 
 	while ((cmd = hostdata->connected)) {
+		struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
+
 		tmp = NCR5380_read(STATUS_REG);
 		/* We only have a valid SCSI phase when REQ is asserted */
 		if (tmp & SR_REQ) {
@@ -2037,8 +2012,7 @@ static void NCR5380_information_transfer
 					    (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
-						SET_NEXT(cmd, hostdata->issue_queue);
-						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
+						list_add(&ncmd->list, &hostdata->unissued);
 						dsprintk(NDEBUG_AUTOSENSE | NDEBUG_QUEUES,
 						         instance, "REQUEST SENSE cmd %p added to head of issue queue\n",
 						         cmd);
@@ -2087,9 +2061,8 @@ static void NCR5380_information_transfer
 				case DISCONNECT:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					SET_NEXT(cmd, hostdata->disconnected_queue);
 					hostdata->connected = NULL;
-					hostdata->disconnected_queue = cmd;
+					list_add(&ncmd->list, &hostdata->disconnected);
 					dsprintk(NDEBUG_INFORMATION | NDEBUG_QUEUES,
 					         instance, "connected command %p for target %d lun %llu moved to disconnected queue\n",
 					         cmd, scmd_id(cmd), cmd->device->lun);
@@ -2283,7 +2256,8 @@ static void NCR5380_reselect(struct Scsi
 	unsigned char msg[3];
 	int __maybe_unused len;
 	unsigned char __maybe_unused *data, __maybe_unused phase;
-	struct scsi_cmnd *tmp = NULL, *prev;
+	struct NCR5380_cmd *ncmd;
+	struct scsi_cmnd *tmp;
 
 	/*
 	 * Disable arbitration, etc. since the host adapter obviously
@@ -2374,19 +2348,18 @@ static void NCR5380_reselect(struct Scsi
 	 * just reestablished, and remove it from the disconnected queue.
 	 */
 
-	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue, prev = NULL;
-	     tmp; prev = tmp, tmp = NEXT(tmp)) {
-		if ((target_mask == (1 << tmp->device->id)) && (lun == (u8)tmp->device->lun)
+	tmp = NULL;
+	list_for_each_entry(ncmd, &hostdata->disconnected, list) {
+		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
+
+		if (target_mask == (1 << scmd_id(cmd)) &&
+		    lun == (u8)cmd->device->lun
 #ifdef SUPPORT_TAGS
 		    && (tag == tmp->tag)
 #endif
 		    ) {
-			if (prev) {
-				SET_NEXT(prev, NEXT(tmp));
-			} else {
-				hostdata->disconnected_queue = NEXT(tmp);
-			}
-			SET_NEXT(tmp, NULL);
+			list_del(&ncmd->list);
+			tmp = cmd;
 			break;
 		}
 	}
@@ -2484,188 +2457,18 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	struct scsi_cmnd *tmp, **prev;
 	unsigned long flags;
 
-	scmd_printk(KERN_NOTICE, cmd, "aborting command\n");
-
 	spin_lock_irqsave(&hostdata->lock, flags);
 
+#if (NDEBUG & NDEBUG_ANY)
+	scmd_printk(KERN_INFO, cmd, "aborting command\n");
+#endif
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
-	dprintk(NDEBUG_ABORT, "scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
-		    NCR5380_read(BUS_AND_STATUS_REG),
-		    NCR5380_read(STATUS_REG));
-
-#if 1
-	/*
-	 * Case 1 : If the command is the currently executing command,
-	 * we'll set the aborted flag and return control so that
-	 * information transfer routine can exit cleanly.
-	 */
-
-	if (hostdata->connected == cmd) {
-
-		dprintk(NDEBUG_ABORT, "scsi%d: aborting connected command\n", HOSTNO);
-		/*
-		 * We should perform BSY checking, and make sure we haven't slipped
-		 * into BUS FREE.
-		 */
-
-		/*	NCR5380_write(INITIATOR_COMMAND_REG, ICR_ASSERT_ATN); */
-		/*
-		 * Since we can't change phases until we've completed the current
-		 * handshake, we have to source or sink a byte of data if the current
-		 * phase is not MSGOUT.
-		 */
-
-		/*
-		 * Return control to the executing NCR drive so we can clear the
-		 * aborted flag and get back into our main loop.
-		 */
-
-		if (do_abort(instance) == 0) {
-			hostdata->connected = NULL;
-			cmd->result = DID_ABORT << 16;
-#ifdef SUPPORT_TAGS
-			cmd_free_tag(cmd);
-#else
-			hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
-#endif
-			maybe_release_dma_irq(instance);
-			spin_unlock_irqrestore(&hostdata->lock, flags);
-			cmd->scsi_done(cmd);
-			return SUCCESS;
-		} else {
-			spin_unlock_irqrestore(&hostdata->lock, flags);
-			printk("scsi%d: abort of connected command failed!\n", HOSTNO);
-			return FAILED;
-		}
-	}
-#endif
-
-	/*
-	 * Case 2 : If the command hasn't been issued yet, we simply remove it
-	 *	    from the issue queue.
-	 */
-	for (prev = (struct scsi_cmnd **)&(hostdata->issue_queue),
-	     tmp = (struct scsi_cmnd *)hostdata->issue_queue;
-	     tmp; prev = NEXTADDR(tmp), tmp = NEXT(tmp)) {
-		if (cmd == tmp) {
-			(*prev) = NEXT(tmp);
-			SET_NEXT(tmp, NULL);
-			tmp->result = DID_ABORT << 16;
-			maybe_release_dma_irq(instance);
-			spin_unlock_irqrestore(&hostdata->lock, flags);
-			dprintk(NDEBUG_ABORT, "scsi%d: abort removed command from issue queue.\n",
-				    HOSTNO);
-			/* Tagged queuing note: no tag to free here, hasn't been assigned
-			 * yet... */
-			tmp->scsi_done(tmp);
-			return SUCCESS;
-		}
-	}
-
-	/*
-	 * Case 3 : If any commands are connected, we're going to fail the abort
-	 *	    and let the high level SCSI driver retry at a later time or
-	 *	    issue a reset.
-	 *
-	 *	    Timeouts, and therefore aborted commands, will be highly unlikely
-	 *          and handling them cleanly in this situation would make the common
-	 *	    case of noresets less efficient, and would pollute our code.  So,
-	 *	    we fail.
-	 */
-
-	if (hostdata->connected) {
-		spin_unlock_irqrestore(&hostdata->lock, flags);
-		dprintk(NDEBUG_ABORT, "scsi%d: abort failed, command connected.\n", HOSTNO);
-		return FAILED;
-	}
-
-	/*
-	 * Case 4: If the command is currently disconnected from the bus, and
-	 *	there are no connected commands, we reconnect the I_T_L or
-	 *	I_T_L_Q nexus associated with it, go into message out, and send
-	 *      an abort message.
-	 *
-	 * This case is especially ugly. In order to reestablish the nexus, we
-	 * need to call NCR5380_select().  The easiest way to implement this
-	 * function was to abort if the bus was busy, and let the interrupt
-	 * handler triggered on the SEL for reselect take care of lost arbitrations
-	 * where necessary, meaning interrupts need to be enabled.
-	 *
-	 * When interrupts are enabled, the queues may change - so we
-	 * can't remove it from the disconnected queue before selecting it
-	 * because that could cause a failure in hashing the nexus if that
-	 * device reselected.
-	 *
-	 * Since the queues may change, we can't use the pointers from when we
-	 * first locate it.
-	 *
-	 * So, we must first locate the command, and if NCR5380_select()
-	 * succeeds, then issue the abort, relocate the command and remove
-	 * it from the disconnected queue.
-	 */
-
-	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue; tmp;
-	     tmp = NEXT(tmp)) {
-		if (cmd == tmp) {
-			dprintk(NDEBUG_ABORT, "scsi%d: aborting disconnected command.\n", HOSTNO);
-
-			if (NCR5380_select(instance, cmd)) {
-				spin_unlock_irq(&hostdata->lock);
-				return FAILED;
-			}
-			dprintk(NDEBUG_ABORT, "scsi%d: nexus reestablished.\n", HOSTNO);
-
-			do_abort(instance);
-
-			for (prev = (struct scsi_cmnd **)&(hostdata->disconnected_queue),
-			     tmp = (struct scsi_cmnd *)hostdata->disconnected_queue;
-			     tmp; prev = NEXTADDR(tmp), tmp = NEXT(tmp)) {
-				if (cmd == tmp) {
-					*prev = NEXT(tmp);
-					SET_NEXT(tmp, NULL);
-					tmp->result = DID_ABORT << 16;
-					/* We must unlock the tag/LUN immediately here, since the
-					 * target goes to BUS FREE and doesn't send us another
-					 * message (COMMAND_COMPLETE or the like)
-					 */
-#ifdef SUPPORT_TAGS
-					cmd_free_tag(tmp);
-#else
-					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
-#endif
-					maybe_release_dma_irq(instance);
-					spin_unlock_irqrestore(&hostdata->lock, flags);
-					tmp->scsi_done(tmp);
-					return SUCCESS;
-				}
-			}
-		}
-	}
-
-	/* Maybe it is sufficient just to release the ST-DMA lock... (if
-	 * possible at all) At least, we should check if the lock could be
-	 * released after the abort, in case it is kept due to some bug.
-	 */
-	maybe_release_dma_irq(instance);
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
-	/*
-	 * Case 5 : If we reached this point, the command was not found in any of
-	 *	    the queues.
-	 *
-	 * We probably reached this point because of an unlikely race condition
-	 * between the command completing successfully and the abortion code,
-	 * so we won't panic, but we will notify the user in case something really
-	 * broke.
-	 */
-
-	printk(KERN_INFO "scsi%d: warning : SCSI command probably completed successfully before abortion\n", HOSTNO);
-
 	return FAILED;
 }
 
@@ -2705,16 +2508,18 @@ static int NCR5380_bus_reset(struct scsi
 	 * commands!
 	 */
 
-	if (hostdata->issue_queue)
-		dsprintk(NDEBUG_ABORT, instance, "reset aborted issued command(s)\n");
 	if (hostdata->connected)
 		dsprintk(NDEBUG_ABORT, instance, "reset aborted a connected command\n");
-	if (hostdata->disconnected_queue)
-		dsprintk(NDEBUG_ABORT, instance, "reset aborted disconnected command(s)\n");
-
-	hostdata->issue_queue = NULL;
 	hostdata->connected = NULL;
-	hostdata->disconnected_queue = NULL;
+
+	if (!list_empty(&hostdata->unissued))
+		dsprintk(NDEBUG_ABORT, instance, "reset aborted unissued list\n");
+	INIT_LIST_HEAD(&hostdata->unissued);
+
+	if (!list_empty(&hostdata->disconnected))
+		dsprintk(NDEBUG_ABORT, instance, "reset aborted disconnected list\n");
+	INIT_LIST_HEAD(&hostdata->disconnected);
+
 #ifdef SUPPORT_TAGS
 	free_all_tags(hostdata);
 #endif
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-12-06 12:30:57.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-12-06 12:30:58.000000000 +1100
@@ -24,6 +24,7 @@
 
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/list.h>
 #include <linux/workqueue.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
@@ -254,8 +255,8 @@ struct NCR5380_hostdata {
 #endif
 	unsigned char last_message;		/* last message OUT */
 	struct scsi_cmnd *connected;		/* currently connected cmnd */
-	struct scsi_cmnd *issue_queue;		/* waiting to be issued */
-	struct scsi_cmnd *disconnected_queue;	/* waiting for reconnect */
+	struct list_head unissued;		/* waiting to be issued */
+	struct list_head disconnected;		/* waiting for reconnect */
 	spinlock_t lock;			/* protects this struct */
 	int flags;
 	struct scsi_eh_save ses;
@@ -277,6 +278,17 @@ struct NCR5380_hostdata {
 
 #ifdef __KERNEL__
 
+struct NCR5380_cmd {
+	struct list_head list;
+};
+
+#define NCR5380_CMD_SIZE		(sizeof(struct NCR5380_cmd))
+
+static inline struct scsi_cmnd *NCR5380_to_scmd(struct NCR5380_cmd *ncmd_ptr)
+{
+	return ((struct scsi_cmnd *)ncmd_ptr) - 1;
+}
+
 #ifndef NDEBUG
 #define NDEBUG (0)
 #endif
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2015-12-06 12:30:39.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2015-12-06 12:30:58.000000000 +1100
@@ -208,6 +208,7 @@ static struct scsi_host_template cumanas
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.proc_name		= "CumanaSCSI-1",
+	.cmd_size		= NCR5380_CMD_SIZE,
 };
 
 static int cumanascsi1_probe(struct expansion_card *ec,
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2015-12-06 12:30:50.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2015-12-06 12:30:58.000000000 +1100
@@ -114,6 +114,7 @@ static struct scsi_host_template oakscsi
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.proc_name		= "oakscsi",
+	.cmd_size		= NCR5380_CMD_SIZE,
 };
 
 static int oakscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2015-12-06 12:30:50.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2015-12-06 12:30:58.000000000 +1100
@@ -780,6 +780,7 @@ static struct scsi_host_template atari_s
 	.eh_bus_reset_handler	= atari_scsi_bus_reset,
 	.this_id		= 7,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.cmd_size		= NCR5380_CMD_SIZE,
 };
 
 static int __init atari_scsi_probe(struct platform_device *pdev)
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2015-12-06 12:30:46.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2015-12-06 12:30:58.000000000 +1100
@@ -61,6 +61,7 @@ static struct scsi_host_template dmx3191
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.cmd_size		= NCR5380_CMD_SIZE,
 };
 
 static int dmx3191d_probe_one(struct pci_dev *pdev,
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2015-12-06 12:30:42.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2015-12-06 12:30:58.000000000 +1100
@@ -452,5 +452,6 @@ static struct scsi_host_template driver_
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.cmd_size		= NCR5380_CMD_SIZE,
 };
 #include "scsi_module.c"
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-12-06 12:30:50.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-12-06 12:30:58.000000000 +1100
@@ -728,6 +728,7 @@ static struct scsi_host_template driver_
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.cmd_size		= NCR5380_CMD_SIZE,
 };
 
 #include "scsi_module.c"
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2015-12-06 12:30:42.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2015-12-06 12:30:58.000000000 +1100
@@ -323,6 +323,7 @@ static struct scsi_host_template mac_scs
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.cmd_size		= NCR5380_CMD_SIZE,
 };
 
 static int __init mac_scsi_probe(struct platform_device *pdev)
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2015-12-06 12:30:42.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2015-12-06 12:30:58.000000000 +1100
@@ -562,6 +562,7 @@ static struct scsi_host_template driver_
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.cmd_size		= NCR5380_CMD_SIZE,
 };
 #include "scsi_module.c"
 
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2015-12-06 12:30:50.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2015-12-06 12:30:58.000000000 +1100
@@ -468,6 +468,7 @@ static struct scsi_host_template sun3_sc
 	.sg_tablesize		= SG_NONE,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.cmd_size		= NCR5380_CMD_SIZE,
 };
 
 static int __init sun3_scsi_probe(struct platform_device *pdev)
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2015-12-06 12:30:42.000000000 +1100
+++ linux/drivers/scsi/t128.c	2015-12-06 12:30:58.000000000 +1100
@@ -406,5 +406,6 @@ static struct scsi_host_template driver_
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
+	.cmd_size		= NCR5380_CMD_SIZE,
 };
 #include "scsi_module.c"
