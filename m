From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 24/33][SCSI] NCR5380: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:04:52 +0100 (MET)
Message-ID: <20080106030452.30002.32837.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53999 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbYAFDFC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:05:02 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.
Cleaned up checkpatch.pl-errors (so no '> 80 lines'-warning, and etc).


diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 2597209..6c09976 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -288,7 +288,7 @@ static void do_reset(struct Scsi_Host *host);
  *	Set up the internal fields in the SCSI command.
  */
 
-static __inline__ void initialize_SCp(Scsi_Cmnd * cmd)
+static inline void initialize_SCp(struct scsi_cmnd *cmd)
 {
 	/* 
 	 * Initialize the Scsi Pointer field so that all of the commands in the 
@@ -698,7 +698,7 @@ static void NCR5380_print_status(struct Scsi_Host *instance)
 #undef SPRINTF
 #define SPRINTF(args...) do { if(pos < buffer + length-80) pos += sprintf(pos, ## args); } while(0)
 static
-char *lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, char *pos, char *buffer, int length);
+char *lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, char *pos, char *buffer, int length);
 static
 char *lprint_command(unsigned char *cmd, char *pos, char *buffer, int len);
 static
@@ -709,7 +709,7 @@ static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
 {
 	char *pos = buffer;
 	struct NCR5380_hostdata *hostdata;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 
 	hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
@@ -755,13 +755,13 @@ static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
 	if (!hostdata->connected)
 		SPRINTF("scsi%d: no currently connected command\n", instance->host_no);
 	else
-		pos = lprint_Scsi_Cmnd((Scsi_Cmnd *) hostdata->connected, pos, buffer, length);
+		pos = lprint_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected, pos, buffer, length);
 	SPRINTF("scsi%d: issue_queue\n", instance->host_no);
-	for (ptr = (Scsi_Cmnd *) hostdata->issue_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
+	for (ptr = (struct scsi_cmnd *) hostdata->issue_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		pos = lprint_Scsi_Cmnd(ptr, pos, buffer, length);
 
 	SPRINTF("scsi%d: disconnected_queue\n", instance->host_no);
-	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
+	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		pos = lprint_Scsi_Cmnd(ptr, pos, buffer, length);
 	spin_unlock_irq(instance->host_lock);
 	
@@ -773,7 +773,7 @@ static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
 	return length;
 }
 
-static char *lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, char *pos, char *buffer, int length)
+static char *lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, char *pos, char *buffer, int length)
 {
 	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
 	SPRINTF("        command = ");
@@ -952,11 +952,11 @@ static void __devexit NCR5380_exit(struct Scsi_Host *instance)
  *	Locks: host lock taken by caller
  */
 
-static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *)) 
+static int NCR5380_queue_command(struct scsi_cmnd *cmd, void (*done) (struct scsi_cmnd *))
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
-	Scsi_Cmnd *tmp;
+	struct scsi_cmnd *tmp;
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
 	switch (cmd->cmnd[0]) {
@@ -1009,7 +1009,7 @@ static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 		cmd->host_scribble = (unsigned char *) hostdata->issue_queue;
 		hostdata->issue_queue = cmd;
 	} else {
-		for (tmp = (Scsi_Cmnd *) hostdata->issue_queue; tmp->host_scribble; tmp = (Scsi_Cmnd *) tmp->host_scribble);
+		for (tmp = (struct scsi_cmnd *) hostdata->issue_queue; tmp->host_scribble; tmp = (struct scsi_cmnd *) tmp->host_scribble);
 		LIST(cmd, tmp);
 		tmp->host_scribble = (unsigned char *) cmd;
 	}
@@ -1039,7 +1039,7 @@ static void NCR5380_main(struct work_struct *work)
 	struct NCR5380_hostdata *hostdata =
 		container_of(work, struct NCR5380_hostdata, coroutine.work);
 	struct Scsi_Host *instance = hostdata->host;
-	Scsi_Cmnd *tmp, *prev;
+	struct scsi_cmnd *tmp, *prev;
 	int done;
 	
 	spin_lock_irq(instance->host_lock);
@@ -1052,7 +1052,7 @@ static void NCR5380_main(struct work_struct *work)
 			 * Search through the issue_queue for a command destined
 			 * for a target that's not busy.
 			 */
-			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble) 
+			for (tmp = (struct scsi_cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (struct scsi_cmnd *) tmp->host_scribble)
 			{
 				if (prev != tmp)
 					dprintk(NDEBUG_LISTS, ("MAIN tmp=%p   target=%d   busy=%d lun=%d\n", tmp, tmp->target, hostdata->busy[tmp->target], tmp->lun));
@@ -1063,7 +1063,7 @@ static void NCR5380_main(struct work_struct *work)
 						prev->host_scribble = tmp->host_scribble;
 					} else {
 						REMOVE(-1, hostdata->issue_queue, tmp, tmp->host_scribble);
-						hostdata->issue_queue = (Scsi_Cmnd *) tmp->host_scribble;
+						hostdata->issue_queue = (struct scsi_cmnd *) tmp->host_scribble;
 					}
 					tmp->host_scribble = NULL;
 
@@ -1110,7 +1110,7 @@ static void NCR5380_main(struct work_struct *work)
 			/* exited locked */
 		}	/* if (!hostdata->connected) */
 		if (hostdata->selecting) {
-			tmp = (Scsi_Cmnd *) hostdata->selecting;
+			tmp = (struct scsi_cmnd *) hostdata->selecting;
 			/* Selection will drop and retake the lock */
 			if (!NCR5380_select(instance, tmp, (tmp->cmnd[0] == REQUEST_SENSE) ? TAG_NONE : TAG_NEXT)) {
 				/* Ok ?? */
@@ -1238,7 +1238,7 @@ static irqreturn_t NCR5380_intr(int irq, void *dev_id)
  *	Update the statistical data by parsing the command in question
  */
  
-static void collect_stats(struct NCR5380_hostdata *hostdata, Scsi_Cmnd * cmd) 
+static void collect_stats(struct NCR5380_hostdata *hostdata, struct scsi_cmnd *cmd)
 {
 #ifdef NCR5380_STATS
 	switch (cmd->cmnd[0]) {
@@ -1260,7 +1260,7 @@ static void collect_stats(struct NCR5380_hostdata *hostdata, Scsi_Cmnd * cmd)
 
 
 /* 
- * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd, 
+ * Function : int NCR5380_select (struct Scsi_Host *instance, struct scsi_cmnd *cmd,
  *      int tag);
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
@@ -1292,7 +1292,7 @@ static void collect_stats(struct NCR5380_hostdata *hostdata, Scsi_Cmnd * cmd)
  *	Locks: caller holds hostdata lock in IRQ mode
  */
  
-static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag) 
+static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd, int tag)
 {
 	NCR5380_local_declare();
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
@@ -2098,7 +2098,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 #endif
 	unsigned char *data;
 	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
-	Scsi_Cmnd *cmd = (Scsi_Cmnd *) hostdata->connected;
+	struct scsi_cmnd *cmd = (struct scsi_cmnd *) hostdata->connected;
 	/* RvC: we need to set the end of the polling time */
 	unsigned long poll_time = jiffies + USLEEP_POLL;
 
@@ -2290,7 +2290,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 						LIST(cmd, hostdata->issue_queue);
 						cmd->host_scribble = (unsigned char *)
 						    hostdata->issue_queue;
-						hostdata->issue_queue = (Scsi_Cmnd *) cmd;
+						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
 						dprintk(NDEBUG_QUEUES, ("scsi%d : REQUEST SENSE added to head of issue queue\n", instance->host_no));
 					} else
 #endif				/* def AUTOSENSE */
@@ -2491,7 +2491,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
  * Function : void NCR5380_reselect (struct Scsi_Host *instance)
  *
  * Purpose : does reselection, initializing the instance->connected 
- *      field to point to the Scsi_Cmnd for which the I_T_L or I_T_L_Q 
+ *      field to point to the scsi_cmnd for which the I_T_L or I_T_L_Q
  *      nexus has been reestablished,
  *      
  * Inputs : instance - this instance of the NCR5380.
@@ -2508,7 +2508,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 	int len;
 	unsigned char msg[3];
 	unsigned char *data;
-	Scsi_Cmnd *tmp = NULL, *prev;
+	struct scsi_cmnd *tmp = NULL, *prev;
 	int abort = 0;
 	NCR5380_setup(instance);
 
@@ -2574,7 +2574,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 		 */
 
 
-		for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble)
+		for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue, prev = NULL; tmp; prev = tmp, tmp = (struct scsi_cmnd *) tmp->host_scribble)
 			if ((target_mask == (1 << tmp->device->id)) && (lun == tmp->device->lun)
 			    ) {
 				if (prev) {
@@ -2582,7 +2582,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 					prev->host_scribble = tmp->host_scribble;
 				} else {
 					REMOVE(-1, hostdata->disconnected_queue, tmp, tmp->host_scribble);
-					hostdata->disconnected_queue = (Scsi_Cmnd *) tmp->host_scribble;
+					hostdata->disconnected_queue = (struct scsi_cmnd *) tmp->host_scribble;
 				}
 				tmp->host_scribble = NULL;
 				break;
@@ -2613,7 +2613,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
  *
  * Inputs : instance - this instance of the NCR5380.
  *
- * Returns : pointer to the Scsi_Cmnd structure for which the I_T_L
+ * Returns : pointer to the scsi_cmnd structure for which the I_T_L
  *      nexus has been reestablished, on failure NULL is returned.
  */
 
@@ -2655,11 +2655,11 @@ static void NCR5380_dma_complete(NCR5380_instance * instance) {
 #endif				/* def REAL_DMA */
 
 /*
- * Function : int NCR5380_abort (Scsi_Cmnd *cmd)
+ * Function : int NCR5380_abort (struct scsi_cmnd *cmd)
  *
  * Purpose : abort a command
  *
- * Inputs : cmd - the Scsi_Cmnd to abort, code - code to set the 
+ * Inputs : cmd - the scsi_cmnd to abort, code - code to set the
  *      host byte of the result field to, if zero DID_ABORTED is 
  *      used.
  *
@@ -2673,11 +2673,12 @@ static void NCR5380_dma_complete(NCR5380_instance * instance) {
  * Locks: host lock taken by caller
  */
 
-static int NCR5380_abort(Scsi_Cmnd * cmd) {
+static int NCR5380_abort(struct scsi_cmnd *cmd)
+{
 	NCR5380_local_declare();
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
-	Scsi_Cmnd *tmp, **prev;
+	struct scsi_cmnd *tmp, **prev;
 	
 	printk(KERN_WARNING "scsi%d : aborting command\n", instance->host_no);
 	scsi_print_command(cmd);
@@ -2726,10 +2726,10 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
  */
  
 	dprintk(NDEBUG_ABORT, ("scsi%d : abort going into loop.\n", instance->host_no));
-	for (prev = (Scsi_Cmnd **) & (hostdata->issue_queue), tmp = (Scsi_Cmnd *) hostdata->issue_queue; tmp; prev = (Scsi_Cmnd **) & (tmp->host_scribble), tmp = (Scsi_Cmnd *) tmp->host_scribble)
+	for (prev = (struct scsi_cmnd **) &(hostdata->issue_queue), tmp = (struct scsi_cmnd *) hostdata->issue_queue; tmp; prev = (struct scsi_cmnd **) &(tmp->host_scribble), tmp = (struct scsi_cmnd *) tmp->host_scribble)
 		if (cmd == tmp) {
 			REMOVE(5, *prev, tmp, tmp->host_scribble);
-			(*prev) = (Scsi_Cmnd *) tmp->host_scribble;
+			(*prev) = (struct scsi_cmnd *) tmp->host_scribble;
 			tmp->host_scribble = NULL;
 			tmp->result = DID_ABORT << 16;
 			dprintk(NDEBUG_ABORT, ("scsi%d : abort removed command from issue queue.\n", instance->host_no));
@@ -2782,7 +2782,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
  * it from the disconnected queue.
  */
 
-	for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue; tmp; tmp = (Scsi_Cmnd *) tmp->host_scribble)
+	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue; tmp; tmp = (struct scsi_cmnd *) tmp->host_scribble)
 		if (cmd == tmp) {
 			dprintk(NDEBUG_ABORT, ("scsi%d : aborting disconnected command.\n", instance->host_no));
 
@@ -2792,10 +2792,10 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 
 			do_abort(instance);
 
-			for (prev = (Scsi_Cmnd **) & (hostdata->disconnected_queue), tmp = (Scsi_Cmnd *) hostdata->disconnected_queue; tmp; prev = (Scsi_Cmnd **) & (tmp->host_scribble), tmp = (Scsi_Cmnd *) tmp->host_scribble)
+			for (prev = (struct scsi_cmnd **) &(hostdata->disconnected_queue), tmp = (struct scsi_cmnd *) hostdata->disconnected_queue; tmp; prev = (struct scsi_cmnd **) &(tmp->host_scribble), tmp = (struct scsi_cmnd *) tmp->host_scribble)
 				if (cmd == tmp) {
 					REMOVE(5, *prev, tmp, tmp->host_scribble);
-					*prev = (Scsi_Cmnd *) tmp->host_scribble;
+					*prev = (struct scsi_cmnd *) tmp->host_scribble;
 					tmp->host_scribble = NULL;
 					tmp->result = DID_ABORT << 16;
 					tmp->scsi_done(tmp);
@@ -2818,7 +2818,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 
 
 /* 
- * Function : int NCR5380_bus_reset (Scsi_Cmnd *cmd)
+ * Function : int NCR5380_bus_reset (struct scsi_cmnd *cmd)
  * 
  * Purpose : reset the SCSI bus.
  *
@@ -2827,7 +2827,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
  * Locks: host lock taken by caller
  */
 
-static int NCR5380_bus_reset(Scsi_Cmnd * cmd)
+static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *instance = cmd->device->host;
 
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index bdc468c..ff73046 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -264,9 +264,9 @@ struct NCR5380_hostdata {
 	volatile int dma_len;			/* requested length of DMA */
 #endif
 	volatile unsigned char last_message;	/* last message OUT */
-	volatile Scsi_Cmnd *connected;		/* currently connected command */
-	volatile Scsi_Cmnd *issue_queue;	/* waiting to be issued */
-	volatile Scsi_Cmnd *disconnected_queue;	/* waiting for reconnect */
+	volatile struct scsi_cmnd *connected;	/* currently connected command */
+	volatile struct scsi_cmnd *issue_queue;	/* waiting to be issued */
+	volatile struct scsi_cmnd *disconnected_queue;	/* waiting for reconnect */
 	volatile int restart_select;		/* we have disconnected,
 						   used to restart 
 						   NCR5380_select() */
@@ -274,7 +274,7 @@ struct NCR5380_hostdata {
 	int flags;
 	unsigned long time_expires;		/* in jiffies, set prior to sleeping */
 	int select_time;			/* timer in select for target response */
-	volatile Scsi_Cmnd *selecting;
+	volatile struct scsi_cmnd *selecting;
 	struct delayed_work coroutine;		/* our co-routine */
 #ifdef NCR5380_STATS
 	unsigned timebase;			/* Base for time calcs */
@@ -311,14 +311,14 @@ static void __maybe_unused NCR5380_print_options(struct Scsi_Host *instance);
 static void NCR5380_print_phase(struct Scsi_Host *instance);
 static void NCR5380_print(struct Scsi_Host *instance);
 #endif
-static int NCR5380_abort(Scsi_Cmnd * cmd);
-static int NCR5380_bus_reset(Scsi_Cmnd * cmd);
-static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
+static int NCR5380_abort(struct scsi_cmnd *cmd);
+static int NCR5380_bus_reset(struct scsi_cmnd *cmd);
+static int NCR5380_queue_command(struct scsi_cmnd *cmd, void (*done) (struct scsi_cmnd *));
 static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
 	char *buffer, char **start, off_t offset, int length, int inout);
 
 static void NCR5380_reselect(struct Scsi_Host *instance);
-static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag);
+static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd, int tag);
 #if defined(PSEUDO_DMA) || defined(REAL_DMA) || defined(REAL_DMA_POLL)
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 #endif
