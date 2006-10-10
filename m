From: akpm@osdl.org
Subject: [patch 28/36] scsi: Scsi_Cmnd convertion in sun3-driver
Date: Tue, 10 Oct 2006 14:41:44 -0700
Message-ID: <200610102141.k9ALfi5O025444@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:28322 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030553AbWJJVvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 17:51:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtwindheim.de

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Change the obsolete Scsi_Cmnd to struct scsi_cmnd in the sun3-driver.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sun3_NCR5380.c  |  109 +++++++++++++++++----------------
 drivers/scsi/sun3_scsi.c     |    7 +-
 drivers/scsi/sun3_scsi.h     |    7 +-
 drivers/scsi/sun3_scsi_vme.c |    7 +-
 4 files changed, 69 insertions(+), 61 deletions(-)

diff -puN drivers/scsi/sun3_NCR5380.c~scsi-scsi_cmnd-convertion-in-sun3-driver drivers/scsi/sun3_NCR5380.c
--- a/drivers/scsi/sun3_NCR5380.c~scsi-scsi_cmnd-convertion-in-sun3-driver
+++ a/drivers/scsi/sun3_NCR5380.c
@@ -266,8 +266,8 @@ static struct scsi_host_template *the_te
 	(struct NCR5380_hostdata *)(in)->hostdata
 #define	HOSTDATA(in) ((struct NCR5380_hostdata *)(in)->hostdata)
 
-#define	NEXT(cmd)	((Scsi_Cmnd *)((cmd)->host_scribble))
-#define	NEXTADDR(cmd)	((Scsi_Cmnd **)&((cmd)->host_scribble))
+#define	NEXT(cmd)	((struct scsi_cmnd *)((cmd)->host_scribble))
+#define	NEXTADDR(cmd)	((struct scsi_cmnd **)&((cmd)->host_scribble))
 
 #define	HOSTNO		instance->host_no
 #define	H_NO(cmd)	(cmd)->device->host->host_no
@@ -360,7 +360,7 @@ static void __init init_tags( void )
  * conditions.
  */ 
 
-static int is_lun_busy( Scsi_Cmnd *cmd, int should_be_tagged )
+static int is_lun_busy(struct scsi_cmnd *cmd, int should_be_tagged)
 {
     SETUP_HOSTDATA(cmd->device->host);
 
@@ -384,7 +384,7 @@ static int is_lun_busy( Scsi_Cmnd *cmd, 
  * untagged.
  */
 
-static void cmd_get_tag( Scsi_Cmnd *cmd, int should_be_tagged )
+static void cmd_get_tag(struct scsi_cmnd *cmd, int should_be_tagged)
 {
     SETUP_HOSTDATA(cmd->device->host);
 
@@ -416,7 +416,7 @@ static void cmd_get_tag( Scsi_Cmnd *cmd,
  * unlock the LUN.
  */
 
-static void cmd_free_tag( Scsi_Cmnd *cmd )
+static void cmd_free_tag(struct scsi_cmnd *cmd)
 {
     SETUP_HOSTDATA(cmd->device->host);
 
@@ -460,18 +460,18 @@ static void free_all_tags( void )
 
 
 /*
- * Function: void merge_contiguous_buffers( Scsi_Cmnd *cmd )
+ * Function: void merge_contiguous_buffers(struct scsi_cmnd *cmd)
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
 
-static void merge_contiguous_buffers( Scsi_Cmnd *cmd )
+static void merge_contiguous_buffers(struct scsi_cmnd *cmd)
 {
     unsigned long endaddr;
 #if (NDEBUG & NDEBUG_MERGING)
@@ -501,15 +501,15 @@ static void merge_contiguous_buffers( Sc
 }
 
 /*
- * Function : void initialize_SCp(Scsi_Cmnd *cmd)
+ * Function : void initialize_SCp(struct scsi_cmnd *cmd)
  *
  * Purpose : initialize the saved data pointers for cmd to point to the 
  *	start of the buffer.
  *
- * Inputs : cmd - Scsi_Cmnd structure to have pointers reset.
+ * Inputs : cmd - struct scsi_cmnd structure to have pointers reset.
  */
 
-static __inline__ void initialize_SCp(Scsi_Cmnd *cmd)
+static __inline__ void initialize_SCp(struct scsi_cmnd *cmd)
 {
     /* 
      * Initialize the Scsi Pointer field so that all of the commands in the 
@@ -753,14 +753,15 @@ static void NCR5380_print_status (struct
   do { if (pos + strlen(fmt) + 20 /* slop */ < buffer + length) \
 	 pos += sprintf(pos, fmt , ## args); } while(0)
 static
-char *lprint_Scsi_Cmnd (Scsi_Cmnd *cmd, char *pos, char *buffer, int length);
+char *lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, char *pos, char *buffer,
+		       int length);
 
-static int NCR5380_proc_info (struct Scsi_Host *instance, char *buffer, char **start,
-		       off_t offset, int length, int inout)
+static int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer,
+			     char **start, off_t offset, int length, int inout)
 {
     char *pos = buffer;
     struct NCR5380_hostdata *hostdata;
-    Scsi_Cmnd *ptr;
+    struct scsi_cmnd *ptr;
     unsigned long flags;
     off_t begin = 0;
 #define check_offset()				\
@@ -784,18 +785,19 @@ static int NCR5380_proc_info (struct Scs
     if (!hostdata->connected)
 	SPRINTF("scsi%d: no currently connected command\n", HOSTNO);
     else
-	pos = lprint_Scsi_Cmnd ((Scsi_Cmnd *) hostdata->connected,
+	pos = lprint_Scsi_Cmnd ((struct scsi_cmnd *) hostdata->connected,
 				pos, buffer, length);
     SPRINTF("scsi%d: issue_queue\n", HOSTNO);
     check_offset();
-    for (ptr = (Scsi_Cmnd *) hostdata->issue_queue; ptr; ptr = NEXT(ptr)) {
+    for (ptr = (struct scsi_cmnd *) hostdata->issue_queue; ptr; ptr = NEXT(ptr))
+    {
 	pos = lprint_Scsi_Cmnd (ptr, pos, buffer, length);
 	check_offset();
     }
 
     SPRINTF("scsi%d: disconnected_queue\n", HOSTNO);
     check_offset();
-    for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr;
+    for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
 	 ptr = NEXT(ptr)) {
 	pos = lprint_Scsi_Cmnd (ptr, pos, buffer, length);
 	check_offset();
@@ -810,8 +812,8 @@ static int NCR5380_proc_info (struct Scs
     return length;
 }
 
-static char *
-lprint_Scsi_Cmnd (Scsi_Cmnd *cmd, char *pos, char *buffer, int length)
+static char *lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, char *pos, char *buffer,
+			      int length)
 {
     int i, s;
     unsigned char *command;
@@ -888,8 +890,8 @@ static int NCR5380_init (struct Scsi_Hos
 }
 
 /* 
- * Function : int NCR5380_queue_command (Scsi_Cmnd *cmd, 
- *	void (*done)(Scsi_Cmnd *)) 
+ * Function : int NCR5380_queue_command (struct scsi_cmnd *cmd,
+ *	void (*done)(struct scsi_cmnd *))
  *
  * Purpose :  enqueues a SCSI command
  *
@@ -906,10 +908,11 @@ static int NCR5380_init (struct Scsi_Hos
  */
 
 /* Only make static if a wrapper function is used */
-static int NCR5380_queue_command (Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
+static int NCR5380_queue_command(struct scsi_cmnd *cmd,
+				 void (*done)(struct scsi_cmnd *))
 {
     SETUP_HOSTDATA(cmd->device->host);
-    Scsi_Cmnd *tmp;
+    struct scsi_cmnd *tmp;
     unsigned long flags;
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
@@ -990,7 +993,7 @@ static int NCR5380_queue_command (Scsi_C
 	NEXT(cmd) = hostdata->issue_queue;
 	hostdata->issue_queue = cmd;
     } else {
-	for (tmp = (Scsi_Cmnd *)hostdata->issue_queue;
+	for (tmp = (struct scsi_cmnd *)hostdata->issue_queue;
 	     NEXT(tmp); tmp = NEXT(tmp))
 	    ;
 	LIST(cmd, tmp);
@@ -1030,7 +1033,7 @@ static int NCR5380_queue_command (Scsi_C
     
 static void NCR5380_main (void *bl)
 {
-    Scsi_Cmnd *tmp, *prev;
+    struct scsi_cmnd *tmp, *prev;
     struct Scsi_Host *instance = first_instance;
     struct NCR5380_hostdata *hostdata = HOSTDATA(instance);
     int done;
@@ -1073,12 +1076,12 @@ static void NCR5380_main (void *bl)
 	     * for a target that's not busy.
 	     */
 #if (NDEBUG & NDEBUG_LISTS)
-	    for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL;
+	    for (tmp = (struct scsi_cmnd *) hostdata->issue_queue, prev = NULL;
 		 tmp && (tmp != prev); prev = tmp, tmp = NEXT(tmp))
 		;
 	    if ((tmp == prev) && tmp) printk(" LOOP\n");/* else printk("\n");*/
 #endif
-	    for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, 
+	    for (tmp = (struct scsi_cmnd *) hostdata->issue_queue,
 		 prev = NULL; tmp; prev = tmp, tmp = NEXT(tmp) ) {
 
 #if (NDEBUG & NDEBUG_LISTS)
@@ -1339,7 +1342,8 @@ static irqreturn_t NCR5380_intr (int irq
 }
 
 #ifdef NCR5380_STATS
-static void collect_stats(struct NCR5380_hostdata* hostdata, Scsi_Cmnd* cmd)
+static void collect_stats(struct NCR5380_hostdata *hostdata,
+			  struct scsi_cmnd *cmd)
 {
 # ifdef NCR5380_STAT_LIMIT
     if (cmd->request_bufflen > NCR5380_STAT_LIMIT)
@@ -1365,8 +1369,8 @@ static void collect_stats(struct NCR5380
 #endif
 
 /* 
- * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd, 
- *	int tag);
+ * Function : int NCR5380_select(struct Scsi_Host *instance,
+ * 				 struct scsi_cmnd *cmd,	int tag);
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
  *	including ARBITRATION, SELECTION, and initial message out for 
@@ -1395,7 +1399,8 @@ static void collect_stats(struct NCR5380
  *		cmd->result host byte set to DID_BAD_TARGET.
  */
 
-static int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd, int tag)
+static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd,
+			  int tag)
 {
     SETUP_HOSTDATA(instance);
     unsigned char tmp[3], phase;
@@ -1985,7 +1990,7 @@ static void NCR5380_information_transfer
 #endif
     unsigned char *data;
     unsigned char phase, tmp, extended_msg[10], old_phase=0xff;
-    Scsi_Cmnd *cmd = (Scsi_Cmnd *) hostdata->connected;
+    struct scsi_cmnd *cmd = (struct scsi_cmnd *) hostdata->connected;
 
 #ifdef SUN3_SCSI_VME
     dregs->csr |= CSR_INTR;
@@ -2272,7 +2277,7 @@ static void NCR5380_information_transfer
 			local_irq_save(flags);
 			LIST(cmd,hostdata->issue_queue);
 			NEXT(cmd) = hostdata->issue_queue;
-		        hostdata->issue_queue = (Scsi_Cmnd *) cmd;
+		        hostdata->issue_queue = (struct scsi_cmnd *) cmd;
 		        local_irq_restore(flags);
 			QU_PRINTK("scsi%d: REQUEST SENSE added to head of "
 				  "issue queue\n", H_NO(cmd));
@@ -2502,7 +2507,7 @@ static void NCR5380_information_transfer
  * Function : void NCR5380_reselect (struct Scsi_Host *instance)
  *
  * Purpose : does reselection, initializing the instance->connected 
- *	field to point to the Scsi_Cmnd for which the I_T_L or I_T_L_Q 
+ *	field to point to the struct scsi_cmnd for which the I_T_L or I_T_L_Q
  *	nexus has been reestablished,
  *	
  * Inputs : instance - this instance of the NCR5380.
@@ -2521,7 +2526,7 @@ static void NCR5380_reselect (struct Scs
     unsigned char tag;
 #endif
     unsigned char msg[3];
-    Scsi_Cmnd *tmp = NULL, *prev;
+    struct scsi_cmnd *tmp = NULL, *prev;
 /*    unsigned long flags; */
 
     /*
@@ -2577,7 +2582,7 @@ static void NCR5380_reselect (struct Scs
      * just reestablished, and remove it from the disconnected queue.
      */
 
-    for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue, prev = NULL; 
+    for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue, prev = NULL;
 	 tmp; prev = tmp, tmp = NEXT(tmp) ) {
 	if ((target_mask == (1 << tmp->device->id)) && (lun == tmp->device->lun)
 #ifdef SUPPORT_TAGS
@@ -2668,11 +2673,11 @@ static void NCR5380_reselect (struct Scs
 
 
 /*
- * Function : int NCR5380_abort (Scsi_Cmnd *cmd)
+ * Function : int NCR5380_abort(struct scsi_cmnd *cmd)
  *
  * Purpose : abort a command
  *
- * Inputs : cmd - the Scsi_Cmnd to abort, code - code to set the 
+ * Inputs : cmd - the struct scsi_cmnd to abort, code - code to set the
  * 	host byte of the result field to, if zero DID_ABORTED is 
  *	used.
  *
@@ -2684,11 +2689,11 @@ static void NCR5380_reselect (struct Scs
  * 	 called where the loop started in NCR5380_main().
  */
 
-static int NCR5380_abort (Scsi_Cmnd *cmd)
+static int NCR5380_abort(struct scsi_cmnd *cmd)
 {
     struct Scsi_Host *instance = cmd->device->host;
     SETUP_HOSTDATA(instance);
-    Scsi_Cmnd *tmp, **prev;
+    struct scsi_cmnd *tmp, **prev;
     unsigned long flags;
 
     printk(KERN_NOTICE "scsi%d: aborting command\n", HOSTNO);
@@ -2753,9 +2758,9 @@ static int NCR5380_abort (Scsi_Cmnd *cmd
  * Case 2 : If the command hasn't been issued yet, we simply remove it 
  * 	    from the issue queue.
  */
-    for (prev = (Scsi_Cmnd **) &(hostdata->issue_queue), 
-	tmp = (Scsi_Cmnd *) hostdata->issue_queue;
-	tmp; prev = NEXTADDR(tmp), tmp = NEXT(tmp) )
+    for (prev = (struct scsi_cmnd **) &(hostdata->issue_queue),
+	tmp = (struct scsi_cmnd *) hostdata->issue_queue;
+	tmp; prev = NEXTADDR(tmp), tmp = NEXT(tmp))
 	if (cmd == tmp) {
 	    REMOVE(5, *prev, tmp, NEXT(tmp));
 	    (*prev) = NEXT(tmp);
@@ -2812,7 +2817,7 @@ static int NCR5380_abort (Scsi_Cmnd *cmd
  * it from the disconnected queue.
  */
 
-    for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue; tmp;
+    for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue; tmp;
 	 tmp = NEXT(tmp)) 
         if (cmd == tmp) {
             local_irq_restore(flags);
@@ -2826,8 +2831,8 @@ static int NCR5380_abort (Scsi_Cmnd *cmd
 	    do_abort (instance);
 
 	    local_irq_save(flags);
-	    for (prev = (Scsi_Cmnd **) &(hostdata->disconnected_queue), 
-		tmp = (Scsi_Cmnd *) hostdata->disconnected_queue;
+	    for (prev = (struct scsi_cmnd **) &(hostdata->disconnected_queue),
+		tmp = (struct scsi_cmnd *) hostdata->disconnected_queue;
 		tmp; prev = NEXTADDR(tmp), tmp = NEXT(tmp) )
 		    if (cmd == tmp) {
 		    REMOVE(5, *prev, tmp, NEXT(tmp));
@@ -2868,7 +2873,7 @@ static int NCR5380_abort (Scsi_Cmnd *cmd
 
 
 /* 
- * Function : int NCR5380_bus_reset (Scsi_Cmnd *cmd)
+ * Function : int NCR5380_bus_reset(struct scsi_cmnd *cmd)
  * 
  * Purpose : reset the SCSI bus.
  *
@@ -2876,13 +2881,13 @@ static int NCR5380_abort (Scsi_Cmnd *cmd
  *
  */ 
 
-static int NCR5380_bus_reset( Scsi_Cmnd *cmd)
+static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
 {
     SETUP_HOSTDATA(cmd->device->host);
     int           i;
     unsigned long flags;
 #if 1
-    Scsi_Cmnd *connected, *disconnected_queue;
+    struct scsi_cmnd *connected, *disconnected_queue;
 #endif
 
 
@@ -2914,9 +2919,9 @@ static int NCR5380_bus_reset( Scsi_Cmnd 
      * remembered in local variables first.
      */
     local_irq_save(flags);
-    connected = (Scsi_Cmnd *)hostdata->connected;
+    connected = (struct scsi_cmnd *)hostdata->connected;
     hostdata->connected = NULL;
-    disconnected_queue = (Scsi_Cmnd *)hostdata->disconnected_queue;
+    disconnected_queue = (struct scsi_cmnd *)hostdata->disconnected_queue;
     hostdata->disconnected_queue = NULL;
 #ifdef SUPPORT_TAGS
     free_all_tags();
diff -puN drivers/scsi/sun3_scsi.c~scsi-scsi_cmnd-convertion-in-sun3-driver drivers/scsi/sun3_scsi.c
--- a/drivers/scsi/sun3_scsi.c~scsi-scsi_cmnd-convertion-in-sun3-driver
+++ a/drivers/scsi/sun3_scsi.c
@@ -119,7 +119,7 @@ module_param(setup_use_tagged_queuing, i
 static int setup_hostid = -1;
 module_param(setup_hostid, int, 0);
 
-static Scsi_Cmnd *sun3_dma_setup_done = NULL;
+static struct scsi_cmnd *sun3_dma_setup_done = NULL;
 
 #define	AFTER_RESET_DELAY	(HZ/2)
 
@@ -526,8 +526,9 @@ static inline unsigned long sun3scsi_dma
 	return last_residual;
 }
 
-static inline unsigned long sun3scsi_dma_xfer_len(unsigned long wanted, Scsi_Cmnd *cmd,
-				    int write_flag)
+static inline unsigned long sun3scsi_dma_xfer_len(unsigned long wanted,
+						  struct scsi_cmnd *cmd,
+						  int write_flag)
 {
 	if(blk_fs_request(cmd->request))
  		return wanted;
diff -puN drivers/scsi/sun3_scsi.h~scsi-scsi_cmnd-convertion-in-sun3-driver drivers/scsi/sun3_scsi.h
--- a/drivers/scsi/sun3_scsi.h~scsi-scsi_cmnd-convertion-in-sun3-driver
+++ a/drivers/scsi/sun3_scsi.h
@@ -47,11 +47,12 @@
 
 #define IOBASE_SUN3_VMESCSI 0xff200000
 
-static int sun3scsi_abort (Scsi_Cmnd *);
+static int sun3scsi_abort(struct scsi_cmnd *);
 static int sun3scsi_detect (struct scsi_host_template *);
 static const char *sun3scsi_info (struct Scsi_Host *);
-static int sun3scsi_bus_reset(Scsi_Cmnd *);
-static int sun3scsi_queue_command (Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
+static int sun3scsi_bus_reset(struct scsi_cmnd *);
+static int sun3scsi_queue_command(struct scsi_cmnd *,
+				  void (*done)(struct scsi_cmnd *));
 static int sun3scsi_release (struct Scsi_Host *);
 
 #ifndef CMD_PER_LUN
diff -puN drivers/scsi/sun3_scsi_vme.c~scsi-scsi_cmnd-convertion-in-sun3-driver drivers/scsi/sun3_scsi_vme.c
--- a/drivers/scsi/sun3_scsi_vme.c~scsi-scsi_cmnd-convertion-in-sun3-driver
+++ a/drivers/scsi/sun3_scsi_vme.c
@@ -84,7 +84,7 @@ module_param(setup_use_tagged_queuing, i
 static int setup_hostid = -1;
 module_param(setup_hostid, int, 0);
 
-static Scsi_Cmnd *sun3_dma_setup_done = NULL;
+static struct scsi_cmnd *sun3_dma_setup_done = NULL;
 
 #define	AFTER_RESET_DELAY	(HZ/2)
 
@@ -458,8 +458,9 @@ static inline unsigned long sun3scsi_dma
 	return last_residual;
 }
 
-static inline unsigned long sun3scsi_dma_xfer_len(unsigned long wanted, Scsi_Cmnd *cmd,
-				    int write_flag)
+static inline unsigned long sun3scsi_dma_xfer_len(unsigned long wanted,
+						  struct scsi_cmnd *cmd,
+						  int write_flag)
 {
 	if(blk_fs_request(cmd->request))
  		return wanted;
_
