From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 06/20] scsi/atari_NCR5380: No longer use Scsi_Cmd typedef
Date: Sun, 08 Nov 2009 17:17:09 -0300
Message-ID: <1257711429.4759.112.camel@dbueso-pc>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754615AbZKHU0B@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
drivers/scsi/atari_NCR5380.c |   94 +++++++++++++++++++++---------------------
 1 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 4240b05..d5f85e7 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -272,9 +272,9 @@ static struct scsi_host_template *the_template = NULL;
 	(struct NCR5380_hostdata *)(in)->hostdata
 #define	HOSTDATA(in) ((struct NCR5380_hostdata *)(in)->hostdata)
 
-#define	NEXT(cmd)		((Scsi_Cmnd *)(cmd)->host_scribble)
+#define	NEXT(cmd)		((struct scsi_cmnd *)(cmd)->host_scribble)
 #define	SET_NEXT(cmd,next)	((cmd)->host_scribble = (void *)(next))
-#define	NEXTADDR(cmd)		((Scsi_Cmnd **)&(cmd)->host_scribble)
+#define	NEXTADDR(cmd)		((struct scsi_cmnd **)&(cmd)->host_scribble)
 
 #define	HOSTNO		instance->host_no
 #define	H_NO(cmd)	(cmd)->device->host->host_no
@@ -359,7 +359,7 @@ static void __init init_tags(void)
  * conditions.
  */
 
-static int is_lun_busy(Scsi_Cmnd *cmd, int should_be_tagged)
+static int is_lun_busy(struct scsi_cmnd *cmd, int should_be_tagged)
 {
 	SETUP_HOSTDATA(cmd->device->host);
 
@@ -383,7 +383,7 @@ static int is_lun_busy(Scsi_Cmnd *cmd, int should_be_tagged)
  * untagged.
  */
 
-static void cmd_get_tag(Scsi_Cmnd *cmd, int should_be_tagged)
+static void cmd_get_tag(struct scsi_cmnd *cmd, int should_be_tagged)
 {
 	SETUP_HOSTDATA(cmd->device->host);
 
@@ -414,7 +414,7 @@ static void cmd_get_tag(Scsi_Cmnd *cmd, int should_be_tagged)
  * unlock the LUN.
  */
 
-static void cmd_free_tag(Scsi_Cmnd *cmd)
+static void cmd_free_tag(struct scsi_cmnd *cmd)
 {
 	SETUP_HOSTDATA(cmd->device->host);
 
@@ -456,18 +456,18 @@ static void free_all_tags(void)
 

 /*
- * Function: void merge_contiguous_buffers( Scsi_Cmnd *cmd )
+ * Function: void merge_contiguous_buffers( struct scsi_cmnd *cmd )
  *
  * Purpose: Try to merge several scatter-gather requests into one DMA
  *    transfer. This is possible if the scatter buffers lie on
  *    physical contiguous addresses.
  *
- * Parameters: Scsi_Cmnd *cmd
+ * Parameters: struct scsi_cmnd *cmd
  *    The command to work on. The first scatter buffer's data are
  *    assumed to be already transfered into ptr/this_residual.
  */
 
-static void merge_contiguous_buffers(Scsi_Cmnd *cmd)
+static void merge_contiguous_buffers(struct scsi_cmnd *cmd)
 {
 	unsigned long endaddr;
 #if (NDEBUG & NDEBUG_MERGING)
@@ -496,15 +496,15 @@ static void merge_contiguous_buffers(Scsi_Cmnd *cmd)
 }
 
 /*
- * Function : void initialize_SCp(Scsi_Cmnd *cmd)
+ * Function : void initialize_SCp(struct scsi_cmnd *cmd)
  *
  * Purpose : initialize the saved data pointers for cmd to point to the
  *	start of the buffer.
  *
- * Inputs : cmd - Scsi_Cmnd structure to have pointers reset.
+ * Inputs : cmd - scsi_cmnd structure to have pointers reset.
  */
 
-static inline void initialize_SCp(Scsi_Cmnd *cmd)
+static inline void initialize_SCp(struct scsi_cmnd *cmd)
 {
 	/*
 	 * Initialize the Scsi Pointer field so that all of the commands in the
@@ -759,14 +759,14 @@ static void NCR5380_print_status(struct Scsi_Host *instance)
 		if (pos + strlen(fmt) + 20 /* slop */ < buffer + length)	\
 			pos += sprintf(pos, fmt , ## args);			\
 	} while(0)
-static char *lprint_Scsi_Cmnd(Scsi_Cmnd *cmd, char *pos, char *buffer, int length);
+static char *lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, char *pos, char *buffer, int length);
 
 static int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer,
 			     char **start, off_t offset, int length, int inout)
 {
 	char *pos = buffer;
 	struct NCR5380_hostdata *hostdata;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	unsigned long flags;
 	off_t begin = 0;
 #define check_offset()					\
@@ -790,18 +790,18 @@ static int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer,
 	if (!hostdata->connected)
 		SPRINTF("scsi%d: no currently connected command\n", HOSTNO);
 	else
-		pos = lprint_Scsi_Cmnd((Scsi_Cmnd *) hostdata->connected,
+		pos = lprint_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected,
 				       pos, buffer, length);
 	SPRINTF("scsi%d: issue_queue\n", HOSTNO);
 	check_offset();
-	for (ptr = (Scsi_Cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr)) {
+	for (ptr = (struct scsi_cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr)) {
 		pos = lprint_Scsi_Cmnd(ptr, pos, buffer, length);
 		check_offset();
 	}
 
 	SPRINTF("scsi%d: disconnected_queue\n", HOSTNO);
 	check_offset();
-	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr;
+	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
 	     ptr = NEXT(ptr)) {
 		pos = lprint_Scsi_Cmnd(ptr, pos, buffer, length);
 		check_offset();
@@ -816,7 +816,7 @@ static int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer,
 	return length;
 }
 
-static char *lprint_Scsi_Cmnd(Scsi_Cmnd *cmd, char *pos, char *buffer, int length)
+static char *lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, char *pos, char *buffer, int length)
 {
 	int i, s;
 	unsigned char *command;
@@ -892,8 +892,8 @@ static int __init NCR5380_init(struct Scsi_Host *instance, int flags)
 }
 
 /*
- * Function : int NCR5380_queue_command (Scsi_Cmnd *cmd,
- *	void (*done)(Scsi_Cmnd *))
+ * Function : int NCR5380_queue_command (struct scsi_cmnd *cmd,
+ *	void (*done)(struct scsi_cmnd *))
  *
  * Purpose :  enqueues a SCSI command
  *
@@ -909,10 +909,10 @@ static int __init NCR5380_init(struct Scsi_Host *instance, int flags)
  *
  */
 
-static int NCR5380_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
+static int NCR5380_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	SETUP_HOSTDATA(cmd->device->host);
-	Scsi_Cmnd *tmp;
+	struct scsi_cmnd *tmp;
 	int oldto;
 	unsigned long flags;
 
@@ -996,7 +996,7 @@ static int NCR5380_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 		SET_NEXT(cmd, hostdata->issue_queue);
 		hostdata->issue_queue = cmd;
 	} else {
-		for (tmp = (Scsi_Cmnd *)hostdata->issue_queue;
+		for (tmp = (struct scsi_cmnd *)hostdata->issue_queue;
 		     NEXT(tmp); tmp = NEXT(tmp))
 			;
 		LIST(cmd, tmp);
@@ -1035,7 +1035,7 @@ static int NCR5380_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 
 static void NCR5380_main(struct work_struct *work)
 {
-	Scsi_Cmnd *tmp, *prev;
+	struct scsi_cmnd *tmp, *prev;
 	struct Scsi_Host *instance = first_instance;
 	struct NCR5380_hostdata *hostdata = HOSTDATA(instance);
 	int done;
@@ -1078,7 +1078,7 @@ static void NCR5380_main(struct work_struct *work)
 			 * for a target that's not busy.
 			 */
 #if (NDEBUG & NDEBUG_LISTS)
-			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL;
+			for (tmp = (struct scsi_cmnd *) hostdata->issue_queue, prev = NULL;
 			     tmp && (tmp != prev); prev = tmp, tmp = NEXT(tmp))
 				;
 			/*printk("%p  ", tmp);*/
@@ -1086,7 +1086,7 @@ static void NCR5380_main(struct work_struct *work)
 				printk(" LOOP\n");
 			/* else printk("\n"); */
 #endif
-			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue,
+			for (tmp = (struct csi_cmnd *) hostdata->issue_queue,
 			     prev = NULL; tmp; prev = tmp, tmp = NEXT(tmp)) {
 
 #if (NDEBUG & NDEBUG_LISTS)
@@ -1349,7 +1349,7 @@ static irqreturn_t NCR5380_intr(int irq, void *dev_id)
 }
 
 #ifdef NCR5380_STATS
-static void collect_stats(struct NCR5380_hostdata* hostdata, Scsi_Cmnd *cmd)
+static void collect_stats(struct NCR5380_hostdata* hostdata, struct scsi_cmnd *cmd)
 {
 # ifdef NCR5380_STAT_LIMIT
 	if (scsi_bufflen(cmd) > NCR5380_STAT_LIMIT)
@@ -1374,7 +1374,7 @@ static void collect_stats(struct NCR5380_hostdata* hostdata, Scsi_Cmnd *cmd)
 #endif
 
 /*
- * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd,
+ * Function : int NCR5380_select (struct Scsi_Host *instance, struct scsi_cmnd *cmd,
  *	int tag);
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
@@ -1404,7 +1404,7 @@ static void collect_stats(struct NCR5380_hostdata* hostdata, Scsi_Cmnd *cmd)
  *		cmd->result host byte set to DID_BAD_TARGET.
  */
 
-static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd *cmd, int tag)
+static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd, int tag)
 {
 	SETUP_HOSTDATA(instance);
 	unsigned char tmp[3], phase;
@@ -2006,7 +2006,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 #endif
 	unsigned char *data;
 	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
-	Scsi_Cmnd *cmd = (Scsi_Cmnd *) hostdata->connected;
+	struct scsi_cmnd *cmd = (struct scsi_cmnd *) hostdata->connected;
 
 	while (1) {
 		tmp = NCR5380_read(STATUS_REG);
@@ -2247,7 +2247,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						local_irq_save(flags);
 						LIST(cmd,hostdata->issue_queue);
 						SET_NEXT(cmd, hostdata->issue_queue);
-						hostdata->issue_queue = (Scsi_Cmnd *) cmd;
+						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
 						local_irq_restore(flags);
 						QU_PRINTK("scsi%d: REQUEST SENSE added to head of "
 							  "issue queue\n", H_NO(cmd));
@@ -2479,7 +2479,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
  * Function : void NCR5380_reselect (struct Scsi_Host *instance)
  *
  * Purpose : does reselection, initializing the instance->connected
- *	field to point to the Scsi_Cmnd for which the I_T_L or I_T_L_Q
+ *	field to point to the scsi_cmnd for which the I_T_L or I_T_L_Q
  *	nexus has been reestablished,
  *
  * Inputs : instance - this instance of the NCR5380.
@@ -2498,7 +2498,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 #endif
 	unsigned char msg[3];
 	unsigned char *data;
-	Scsi_Cmnd *tmp = NULL, *prev;
+	struct scsi_cmnd *tmp = NULL, *prev;
 /*	unsigned long flags; */
 
 	/*
@@ -2572,7 +2572,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	 * just reestablished, and remove it from the disconnected queue.
 	 */
 
-	for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue, prev = NULL;
+	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue, prev = NULL;
 	     tmp; prev = tmp, tmp = NEXT(tmp)) {
 		if ((target_mask == (1 << tmp->device->id)) && (lun == tmp->device->lun)
 #ifdef SUPPORT_TAGS
@@ -2623,11 +2623,11 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 

 /*
- * Function : int NCR5380_abort (Scsi_Cmnd *cmd)
+ * Function : int NCR5380_abort (struct scsi_cmnd *cmd)
  *
  * Purpose : abort a command
  *
- * Inputs : cmd - the Scsi_Cmnd to abort, code - code to set the
+ * Inputs : cmd - the struct scsi_cmnd to abort, code - code to set the
  *	host byte of the result field to, if zero DID_ABORTED is
  *	used.
  *
@@ -2640,11 +2640,11 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
  */
 
 static
-int NCR5380_abort(Scsi_Cmnd *cmd)
+int NCR5380_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	SETUP_HOSTDATA(instance);
-	Scsi_Cmnd *tmp, **prev;
+	struct scsi_cmnd *tmp, **prev;
 	unsigned long flags;
 
 	printk(KERN_NOTICE "scsi%d: aborting command\n", HOSTNO);
@@ -2714,8 +2714,8 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 	 * Case 2 : If the command hasn't been issued yet, we simply remove it
 	 *	    from the issue queue.
 	 */
-	for (prev = (Scsi_Cmnd **)&(hostdata->issue_queue),
-	     tmp = (Scsi_Cmnd *)hostdata->issue_queue;
+	for (prev = (struct scsi_cmnd **)&(hostdata->issue_queue),
+	     tmp = (struct scsi_cmnd *)hostdata->issue_queue;
 	     tmp; prev = NEXTADDR(tmp), tmp = NEXT(tmp)) {
 		if (cmd == tmp) {
 			REMOVE(5, *prev, tmp, NEXT(tmp));
@@ -2775,7 +2775,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 	 * it from the disconnected queue.
 	 */
 
-	for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue; tmp;
+	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue; tmp;
 	     tmp = NEXT(tmp)) {
 		if (cmd == tmp) {
 			local_irq_restore(flags);
@@ -2789,8 +2789,8 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 			do_abort(instance);
 
 			local_irq_save(flags);
-			for (prev = (Scsi_Cmnd **)&(hostdata->disconnected_queue),
-			     tmp = (Scsi_Cmnd *)hostdata->disconnected_queue;
+			for (prev = (struct scsi_cmnd **)&(hostdata->disconnected_queue),
+			     tmp = (struct csi_cmnd *)hostdata->disconnected_queue;
 			     tmp; prev = NEXTADDR(tmp), tmp = NEXT(tmp)) {
 				if (cmd == tmp) {
 					REMOVE(5, *prev, tmp, NEXT(tmp));
@@ -2839,7 +2839,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 

 /*
- * Function : int NCR5380_reset (Scsi_Cmnd *cmd)
+ * Function : int NCR5380_reset (struct scsi_cmnd *cmd)
  *
  * Purpose : reset the SCSI bus.
  *
@@ -2847,13 +2847,13 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
  *
  */
 
-static int NCR5380_bus_reset(Scsi_Cmnd *cmd)
+static int NCR5380_bus_reset(struct csi_cmnd *cmd)
 {
 	SETUP_HOSTDATA(cmd->device->host);
 	int i;
 	unsigned long flags;
 #if 1
-	Scsi_Cmnd *connected, *disconnected_queue;
+	struct scsi_cmnd *connected, *disconnected_queue;
 #endif
 
 	if (!IS_A_TT() && !falcon_got_lock)
@@ -2888,9 +2888,9 @@ static int NCR5380_bus_reset(Scsi_Cmnd *cmd)
 	 * remembered in local variables first.
 	 */
 	local_irq_save(flags);
-	connected = (Scsi_Cmnd *)hostdata->connected;
+	connected = (struct csi_cmnd *)hostdata->connected;
 	hostdata->connected = NULL;
-	disconnected_queue = (Scsi_Cmnd *)hostdata->disconnected_queue;
+	disconnected_queue = (struct scsi_cmnd *)hostdata->disconnected_queue;
 	hostdata->disconnected_queue = NULL;
 #ifdef SUPPORT_TAGS
 	free_all_tags();
