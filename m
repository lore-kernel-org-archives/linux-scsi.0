From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 16/36] ncr5380: Drop legacy scsi.h include
Date: Mon, 27 Oct 2014 16:26:23 +1100
Message-ID: <20141027052611.005417244@telegraphics.com.au>
References: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:48335 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaJ0KcI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 06:32:08 -0400
Content-Disposition: inline; filename=ncr5380-drop-legacy-scsi-h-include
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org

Convert Scsi_Cmnd to struct scsi_cmnd and drop the #include "scsi.h".
The sun3_NCR5380.c core driver already uses struct scsi_cmnd so converting
the other core drivers reduces the diff which makes them easier to unify.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Line length issues have not been addressed here because comparison of the
three core drivers (NCR5380.c, atari_NCR5380.c and sun3_NCR5380.c) becomes
too messy. These lines get shorter once the type casting is fixed (work in
progress).

---
 drivers/scsi/NCR5380.c       |   70 +++++++++++++++--------------
 drivers/scsi/NCR5380.h       |   10 ++--
 drivers/scsi/arm/cumana_1.c  |    1 
 drivers/scsi/arm/oak.c       |    1 
 drivers/scsi/atari_NCR5380.c |  102 +++++++++++++++++++++----------------------
 drivers/scsi/atari_scsi.c    |    5 --
 drivers/scsi/dmx3191d.c      |    1 
 drivers/scsi/dtc.c           |    1 
 drivers/scsi/g_NCR5380.c     |    1 
 drivers/scsi/mac_scsi.c      |    1 
 drivers/scsi/pas16.c         |    1 
 drivers/scsi/sun3_NCR5380.c  |   20 ++++----
 drivers/scsi/sun3_scsi.c     |    1 
 drivers/scsi/t128.c          |    1 
 14 files changed, 105 insertions(+), 111 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2014-10-27 16:25:33.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2014-10-27 16:25:36.000000000 +1100
@@ -277,7 +277,7 @@ static void do_reset(struct Scsi_Host *h
  *	Set up the internal fields in the SCSI command.
  */
 
-static __inline__ void initialize_SCp(Scsi_Cmnd * cmd)
+static inline void initialize_SCp(struct scsi_cmnd *cmd)
 {
 	/* 
 	 * Initialize the Scsi Pointer field so that all of the commands in the 
@@ -719,7 +719,7 @@ static int __maybe_unused NCR5380_write_
 #undef SPRINTF
 #define SPRINTF(args...) seq_printf(m, ## args)
 static
-void lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, struct seq_file *m);
+void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m);
 static
 void lprint_command(unsigned char *cmd, struct seq_file *m);
 static
@@ -729,7 +729,7 @@ static int __maybe_unused NCR5380_show_i
 	struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 
 	hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
@@ -741,19 +741,19 @@ static int __maybe_unused NCR5380_show_i
 	if (!hostdata->connected)
 		SPRINTF("scsi%d: no currently connected command\n", instance->host_no);
 	else
-		lprint_Scsi_Cmnd((Scsi_Cmnd *) hostdata->connected, m);
+		lprint_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected, m);
 	SPRINTF("scsi%d: issue_queue\n", instance->host_no);
-	for (ptr = (Scsi_Cmnd *) hostdata->issue_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
+	for (ptr = (struct scsi_cmnd *) hostdata->issue_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		lprint_Scsi_Cmnd(ptr, m);
 
 	SPRINTF("scsi%d: disconnected_queue\n", instance->host_no);
-	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
+	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		lprint_Scsi_Cmnd(ptr, m);
 	spin_unlock_irq(instance->host_lock);
 	return 0;
 }
 
-static void lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, struct seq_file *m)
+static void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m)
 {
 	SPRINTF("scsi%d : destination target %d, lun %llu\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
 	SPRINTF("        command = ");
@@ -912,11 +912,11 @@ static void NCR5380_exit(struct Scsi_Hos
  *	Locks: host lock taken by caller
  */
 
-static int NCR5380_queue_command_lck(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
+static int NCR5380_queue_command_lck(struct scsi_cmnd *cmd, void (*done) (struct scsi_cmnd *))
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
-	Scsi_Cmnd *tmp;
+	struct scsi_cmnd *tmp;
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
 	switch (cmd->cmnd[0]) {
@@ -950,7 +950,7 @@ static int NCR5380_queue_command_lck(Scs
 		cmd->host_scribble = (unsigned char *) hostdata->issue_queue;
 		hostdata->issue_queue = cmd;
 	} else {
-		for (tmp = (Scsi_Cmnd *) hostdata->issue_queue; tmp->host_scribble; tmp = (Scsi_Cmnd *) tmp->host_scribble);
+		for (tmp = (struct scsi_cmnd *) hostdata->issue_queue; tmp->host_scribble; tmp = (struct scsi_cmnd *) tmp->host_scribble);
 		LIST(cmd, tmp);
 		tmp->host_scribble = (unsigned char *) cmd;
 	}
@@ -981,7 +981,7 @@ static void NCR5380_main(struct work_str
 	struct NCR5380_hostdata *hostdata =
 		container_of(work, struct NCR5380_hostdata, coroutine.work);
 	struct Scsi_Host *instance = hostdata->host;
-	Scsi_Cmnd *tmp, *prev;
+	struct scsi_cmnd *tmp, *prev;
 	int done;
 	
 	spin_lock_irq(instance->host_lock);
@@ -994,7 +994,7 @@ static void NCR5380_main(struct work_str
 			 * Search through the issue_queue for a command destined
 			 * for a target that's not busy.
 			 */
-			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble) 
+			for (tmp = (struct scsi_cmnd *) hostdata->issue_queue, prev = NULL; tmp; prev = tmp, tmp = (struct scsi_cmnd *) tmp->host_scribble)
 			{
 				if (prev != tmp)
 				    dprintk(NDEBUG_LISTS, "MAIN tmp=%p   target=%d   busy=%d lun=%llu\n", tmp, tmp->device->id, hostdata->busy[tmp->device->id], tmp->device->lun);
@@ -1006,7 +1006,7 @@ static void NCR5380_main(struct work_str
 						prev->host_scribble = tmp->host_scribble;
 					} else {
 						REMOVE(-1, hostdata->issue_queue, tmp, tmp->host_scribble);
-						hostdata->issue_queue = (Scsi_Cmnd *) tmp->host_scribble;
+						hostdata->issue_queue = (struct scsi_cmnd *) tmp->host_scribble;
 					}
 					tmp->host_scribble = NULL;
 
@@ -1053,7 +1053,7 @@ static void NCR5380_main(struct work_str
 			/* exited locked */
 		}	/* if (!hostdata->connected) */
 		if (hostdata->selecting) {
-			tmp = (Scsi_Cmnd *) hostdata->selecting;
+			tmp = (struct scsi_cmnd *) hostdata->selecting;
 			/* Selection will drop and retake the lock */
 			if (!NCR5380_select(instance, tmp)) {
 				/* Ok ?? */
@@ -1175,7 +1175,8 @@ static irqreturn_t NCR5380_intr(int dumm
 #endif 
 
 /* 
- * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd)
+ * Function : int NCR5380_select(struct Scsi_Host *instance,
+ *                               struct scsi_cmnd *cmd)
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
  *      including ARBITRATION, SELECTION, and initial message out for 
@@ -1204,7 +1205,7 @@ static irqreturn_t NCR5380_intr(int dumm
  *	Locks: caller holds hostdata lock in IRQ mode
  */
  
-static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd *cmd)
+static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 {
 	NCR5380_local_declare();
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
@@ -2011,7 +2012,7 @@ static void NCR5380_information_transfer
 #endif
 	unsigned char *data;
 	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
-	Scsi_Cmnd *cmd = (Scsi_Cmnd *) hostdata->connected;
+	struct scsi_cmnd *cmd = (struct scsi_cmnd *) hostdata->connected;
 	/* RvC: we need to set the end of the polling time */
 	unsigned long poll_time = jiffies + USLEEP_POLL;
 
@@ -2201,7 +2202,7 @@ static void NCR5380_information_transfer
 						LIST(cmd, hostdata->issue_queue);
 						cmd->host_scribble = (unsigned char *)
 						    hostdata->issue_queue;
-						hostdata->issue_queue = (Scsi_Cmnd *) cmd;
+						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
 						dprintk(NDEBUG_QUEUES, "scsi%d : REQUEST SENSE added to head of issue queue\n", instance->host_no);
 					} else {
 						cmd->scsi_done(cmd);
@@ -2398,7 +2399,7 @@ static void NCR5380_information_transfer
  * Function : void NCR5380_reselect (struct Scsi_Host *instance)
  *
  * Purpose : does reselection, initializing the instance->connected 
- *      field to point to the Scsi_Cmnd for which the I_T_L or I_T_L_Q 
+ *      field to point to the scsi_cmnd for which the I_T_L or I_T_L_Q
  *      nexus has been reestablished,
  *      
  * Inputs : instance - this instance of the NCR5380.
@@ -2415,7 +2416,7 @@ static void NCR5380_reselect(struct Scsi
 	int len;
 	unsigned char msg[3];
 	unsigned char *data;
-	Scsi_Cmnd *tmp = NULL, *prev;
+	struct scsi_cmnd *tmp = NULL, *prev;
 	int abort = 0;
 	NCR5380_setup(instance);
 
@@ -2481,7 +2482,7 @@ static void NCR5380_reselect(struct Scsi
 		 */
 
 
-		for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue, prev = NULL; tmp; prev = tmp, tmp = (Scsi_Cmnd *) tmp->host_scribble)
+		for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue, prev = NULL; tmp; prev = tmp, tmp = (struct scsi_cmnd *) tmp->host_scribble)
 			if ((target_mask == (1 << tmp->device->id)) && (lun == (u8)tmp->device->lun)
 			    ) {
 				if (prev) {
@@ -2489,7 +2490,7 @@ static void NCR5380_reselect(struct Scsi
 					prev->host_scribble = tmp->host_scribble;
 				} else {
 					REMOVE(-1, hostdata->disconnected_queue, tmp, tmp->host_scribble);
-					hostdata->disconnected_queue = (Scsi_Cmnd *) tmp->host_scribble;
+					hostdata->disconnected_queue = (struct scsi_cmnd *) tmp->host_scribble;
 				}
 				tmp->host_scribble = NULL;
 				break;
@@ -2520,7 +2521,7 @@ static void NCR5380_reselect(struct Scsi
  *
  * Inputs : instance - this instance of the NCR5380.
  *
- * Returns : pointer to the Scsi_Cmnd structure for which the I_T_L
+ * Returns : pointer to the scsi_cmnd structure for which the I_T_L
  *      nexus has been reestablished, on failure NULL is returned.
  */
 
@@ -2562,11 +2563,11 @@ static void NCR5380_dma_complete(NCR5380
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
@@ -2580,11 +2581,12 @@ static void NCR5380_dma_complete(NCR5380
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
@@ -2633,10 +2635,10 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
  */
  
 	dprintk(NDEBUG_ABORT, "scsi%d : abort going into loop.\n", instance->host_no);
-	for (prev = (Scsi_Cmnd **) & (hostdata->issue_queue), tmp = (Scsi_Cmnd *) hostdata->issue_queue; tmp; prev = (Scsi_Cmnd **) & (tmp->host_scribble), tmp = (Scsi_Cmnd *) tmp->host_scribble)
+	for (prev = (struct scsi_cmnd **) &(hostdata->issue_queue), tmp = (struct scsi_cmnd *) hostdata->issue_queue; tmp; prev = (struct scsi_cmnd **) &(tmp->host_scribble), tmp = (struct scsi_cmnd *) tmp->host_scribble)
 		if (cmd == tmp) {
 			REMOVE(5, *prev, tmp, tmp->host_scribble);
-			(*prev) = (Scsi_Cmnd *) tmp->host_scribble;
+			(*prev) = (struct scsi_cmnd *) tmp->host_scribble;
 			tmp->host_scribble = NULL;
 			tmp->result = DID_ABORT << 16;
 			dprintk(NDEBUG_ABORT, "scsi%d : abort removed command from issue queue.\n", instance->host_no);
@@ -2689,7 +2691,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
  * it from the disconnected queue.
  */
 
-	for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue; tmp; tmp = (Scsi_Cmnd *) tmp->host_scribble)
+	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue; tmp; tmp = (struct scsi_cmnd *) tmp->host_scribble)
 		if (cmd == tmp) {
 			dprintk(NDEBUG_ABORT, "scsi%d : aborting disconnected command.\n", instance->host_no);
 
@@ -2699,10 +2701,10 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
 
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
@@ -2725,7 +2727,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
 
 
 /* 
- * Function : int NCR5380_bus_reset (Scsi_Cmnd *cmd)
+ * Function : int NCR5380_bus_reset (struct scsi_cmnd *cmd)
  * 
  * Purpose : reset the SCSI bus.
  *
@@ -2734,7 +2736,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
  * Locks: host lock taken by caller
  */
 
-static int NCR5380_bus_reset(Scsi_Cmnd * cmd)
+static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *instance = cmd->device->host;
 
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-10-27 16:25:33.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-10-27 16:25:36.000000000 +1100
@@ -255,9 +255,9 @@ struct NCR5380_hostdata {
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
@@ -265,7 +265,7 @@ struct NCR5380_hostdata {
 	int flags;
 	unsigned long time_expires;		/* in jiffies, set prior to sleeping */
 	int select_time;			/* timer in select for target response */
-	volatile Scsi_Cmnd *selecting;
+	volatile struct scsi_cmnd *selecting;
 	struct delayed_work coroutine;		/* our co-routine */
 	struct scsi_eh_save ses;
 	char info[256];
@@ -309,7 +309,7 @@ static irqreturn_t NCR5380_intr(int irq,
 static void NCR5380_main(struct work_struct *work);
 static const char *NCR5380_info(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
-static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd *cmd);
+static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd);
 #if defined(PSEUDO_DMA) || defined(REAL_DMA) || defined(REAL_DMA_POLL)
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 #endif
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2014-10-27 16:25:33.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2014-10-27 16:25:36.000000000 +1100
@@ -13,7 +13,6 @@
 #include <asm/ecard.h>
 #include <asm/io.h>
 
-#include "../scsi.h"
 #include <scsi/scsi_host.h>
 
 #include <scsi/scsicam.h>
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2014-10-27 16:25:33.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2014-10-27 16:25:36.000000000 +1100
@@ -14,7 +14,6 @@
 #include <asm/ecard.h>
 #include <asm/io.h>
 
-#include "../scsi.h"
 #include <scsi/scsi_host.h>
 
 /*#define PSEUDO_DMA*/
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:33.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:25:36.000000000 +1100
@@ -262,9 +262,9 @@ static struct scsi_host_template *the_te
 	(struct NCR5380_hostdata *)(in)->hostdata
 #define	HOSTDATA(in) ((struct NCR5380_hostdata *)(in)->hostdata)
 
-#define	NEXT(cmd)		((Scsi_Cmnd *)(cmd)->host_scribble)
+#define	NEXT(cmd)		((struct scsi_cmnd *)(cmd)->host_scribble)
 #define	SET_NEXT(cmd,next)	((cmd)->host_scribble = (void *)(next))
-#define	NEXTADDR(cmd)		((Scsi_Cmnd **)&(cmd)->host_scribble)
+#define	NEXTADDR(cmd)		((struct scsi_cmnd **)&(cmd)->host_scribble)
 
 #define	HOSTNO		instance->host_no
 #define	H_NO(cmd)	(cmd)->device->host->host_no
@@ -345,7 +345,7 @@ static void __init init_tags(void)
  * conditions.
  */
 
-static int is_lun_busy(Scsi_Cmnd *cmd, int should_be_tagged)
+static int is_lun_busy(struct scsi_cmnd *cmd, int should_be_tagged)
 {
 	u8 lun = cmd->device->lun;
 	SETUP_HOSTDATA(cmd->device->host);
@@ -370,7 +370,7 @@ static int is_lun_busy(Scsi_Cmnd *cmd, i
  * untagged.
  */
 
-static void cmd_get_tag(Scsi_Cmnd *cmd, int should_be_tagged)
+static void cmd_get_tag(struct scsi_cmnd *cmd, int should_be_tagged)
 {
 	u8 lun = cmd->device->lun;
 	SETUP_HOSTDATA(cmd->device->host);
@@ -402,7 +402,7 @@ static void cmd_get_tag(Scsi_Cmnd *cmd,
  * unlock the LUN.
  */
 
-static void cmd_free_tag(Scsi_Cmnd *cmd)
+static void cmd_free_tag(struct scsi_cmnd *cmd)
 {
 	u8 lun = cmd->device->lun;
 	SETUP_HOSTDATA(cmd->device->host);
@@ -445,18 +445,18 @@ static void free_all_tags(void)
 
 
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
  *    assumed to be already transferred into ptr/this_residual.
  */
 
-static void merge_contiguous_buffers(Scsi_Cmnd *cmd)
+static void merge_contiguous_buffers(struct scsi_cmnd *cmd)
 {
 	unsigned long endaddr;
 #if (NDEBUG & NDEBUG_MERGING)
@@ -485,15 +485,15 @@ static void merge_contiguous_buffers(Scs
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
@@ -714,7 +714,7 @@ static void prepare_info(struct Scsi_Hos
  * Inputs : instance, pointer to this instance.
  */
 
-static void lprint_Scsi_Cmnd(Scsi_Cmnd *cmd)
+static void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd)
 {
 	int i, s;
 	unsigned char *command;
@@ -731,7 +731,7 @@ static void lprint_Scsi_Cmnd(Scsi_Cmnd *
 static void NCR5380_print_status(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	unsigned long flags;
 
 	NCR5380_dprint(NDEBUG_ANY, instance);
@@ -745,13 +745,13 @@ static void NCR5380_print_status(struct
 	if (!hostdata->connected)
 		printk("scsi%d: no currently connected command\n", HOSTNO);
 	else
-		lprint_Scsi_Cmnd((Scsi_Cmnd *) hostdata->connected);
+		lprint_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected);
 	printk("scsi%d: issue_queue\n", HOSTNO);
-	for (ptr = (Scsi_Cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
+	for (ptr = (struct scsi_cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
 		lprint_Scsi_Cmnd(ptr);
 
 	printk("scsi%d: disconnected_queue\n", HOSTNO);
-	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr;
+	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
 	     ptr = NEXT(ptr))
 		lprint_Scsi_Cmnd(ptr);
 
@@ -759,7 +759,7 @@ static void NCR5380_print_status(struct
 	printk("\n");
 }
 
-static void show_Scsi_Cmnd(Scsi_Cmnd *cmd, struct seq_file *m)
+static void show_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m)
 {
 	int i, s;
 	unsigned char *command;
@@ -777,7 +777,7 @@ static int __maybe_unused NCR5380_show_i
                                             struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	unsigned long flags;
 
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
@@ -788,13 +788,13 @@ static int __maybe_unused NCR5380_show_i
 	if (!hostdata->connected)
 		seq_printf(m, "scsi%d: no currently connected command\n", HOSTNO);
 	else
-		show_Scsi_Cmnd((Scsi_Cmnd *) hostdata->connected, m);
+		show_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected, m);
 	seq_printf(m, "scsi%d: issue_queue\n", HOSTNO);
-	for (ptr = (Scsi_Cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
+	for (ptr = (struct scsi_cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
 		show_Scsi_Cmnd(ptr, m);
 
 	seq_printf(m, "scsi%d: disconnected_queue\n", HOSTNO);
-	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr;
+	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
 	     ptr = NEXT(ptr))
 		show_Scsi_Cmnd(ptr, m);
 
@@ -862,8 +862,8 @@ static void NCR5380_exit(struct Scsi_Hos
 }
 
 /*
- * Function : int NCR5380_queue_command (Scsi_Cmnd *cmd,
- *	void (*done)(Scsi_Cmnd *))
+ * Function : int NCR5380_queue_command (struct scsi_cmnd *cmd,
+ *	void (*done)(struct scsi_cmnd *))
  *
  * Purpose :  enqueues a SCSI command
  *
@@ -879,10 +879,11 @@ static void NCR5380_exit(struct Scsi_Hos
  *
  */
 
-static int NCR5380_queue_command_lck(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
+static int NCR5380_queue_command_lck(struct scsi_cmnd *cmd,
+                                     void (*done)(struct scsi_cmnd *))
 {
 	SETUP_HOSTDATA(cmd->device->host);
-	Scsi_Cmnd *tmp;
+	struct scsi_cmnd *tmp;
 	unsigned long flags;
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
@@ -937,7 +938,7 @@ static int NCR5380_queue_command_lck(Scs
 		SET_NEXT(cmd, hostdata->issue_queue);
 		hostdata->issue_queue = cmd;
 	} else {
-		for (tmp = (Scsi_Cmnd *)hostdata->issue_queue;
+		for (tmp = (struct scsi_cmnd *)hostdata->issue_queue;
 		     NEXT(tmp); tmp = NEXT(tmp))
 			;
 		LIST(cmd, tmp);
@@ -978,7 +979,7 @@ static DEF_SCSI_QCMD(NCR5380_queue_comma
 
 static void NCR5380_main(struct work_struct *work)
 {
-	Scsi_Cmnd *tmp, *prev;
+	struct scsi_cmnd *tmp, *prev;
 	struct Scsi_Host *instance = first_instance;
 	struct NCR5380_hostdata *hostdata = HOSTDATA(instance);
 	int done;
@@ -1021,7 +1022,7 @@ static void NCR5380_main(struct work_str
 			 * for a target that's not busy.
 			 */
 #if (NDEBUG & NDEBUG_LISTS)
-			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue, prev = NULL;
+			for (tmp = (struct scsi_cmnd *) hostdata->issue_queue, prev = NULL;
 			     tmp && (tmp != prev); prev = tmp, tmp = NEXT(tmp))
 				;
 			/*printk("%p  ", tmp);*/
@@ -1029,7 +1030,7 @@ static void NCR5380_main(struct work_str
 				printk(" LOOP\n");
 			/* else printk("\n"); */
 #endif
-			for (tmp = (Scsi_Cmnd *) hostdata->issue_queue,
+			for (tmp = (struct scsi_cmnd *) hostdata->issue_queue,
 			     prev = NULL; tmp; prev = tmp, tmp = NEXT(tmp)) {
 				u8 lun = tmp->device->lun;
 
@@ -1291,7 +1292,8 @@ static irqreturn_t NCR5380_intr(int irq,
 }
 
 /*
- * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd)
+ * Function : int NCR5380_select(struct Scsi_Host *instance,
+ *                               struct scsi_cmnd *cmd)
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
  *	including ARBITRATION, SELECTION, and initial message out for
@@ -1318,7 +1320,7 @@ static irqreturn_t NCR5380_intr(int irq,
  *		cmd->result host byte set to DID_BAD_TARGET.
  */
 
-static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd *cmd)
+static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 {
 	SETUP_HOSTDATA(instance);
 	unsigned char tmp[3], phase;
@@ -1917,7 +1919,7 @@ static void NCR5380_information_transfer
 #endif
 	unsigned char *data;
 	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
-	Scsi_Cmnd *cmd = (Scsi_Cmnd *) hostdata->connected;
+	struct scsi_cmnd *cmd = (struct scsi_cmnd *) hostdata->connected;
 
 	while (1) {
 		tmp = NCR5380_read(STATUS_REG);
@@ -2154,7 +2156,7 @@ static void NCR5380_information_transfer
 						local_irq_save(flags);
 						LIST(cmd,hostdata->issue_queue);
 						SET_NEXT(cmd, hostdata->issue_queue);
-						hostdata->issue_queue = (Scsi_Cmnd *) cmd;
+						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
 						local_irq_restore(flags);
 						dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
 							  "issue queue\n", H_NO(cmd));
@@ -2378,7 +2380,7 @@ static void NCR5380_information_transfer
  * Function : void NCR5380_reselect (struct Scsi_Host *instance)
  *
  * Purpose : does reselection, initializing the instance->connected
- *	field to point to the Scsi_Cmnd for which the I_T_L or I_T_L_Q
+ *	field to point to the scsi_cmnd for which the I_T_L or I_T_L_Q
  *	nexus has been reestablished,
  *
  * Inputs : instance - this instance of the NCR5380.
@@ -2397,7 +2399,7 @@ static void NCR5380_reselect(struct Scsi
 #endif
 	unsigned char msg[3];
 	unsigned char *data;
-	Scsi_Cmnd *tmp = NULL, *prev;
+	struct scsi_cmnd *tmp = NULL, *prev;
 /*	unsigned long flags; */
 
 	/*
@@ -2471,7 +2473,7 @@ static void NCR5380_reselect(struct Scsi
 	 * just reestablished, and remove it from the disconnected queue.
 	 */
 
-	for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue, prev = NULL;
+	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue, prev = NULL;
 	     tmp; prev = tmp, tmp = NEXT(tmp)) {
 		if ((target_mask == (1 << tmp->device->id)) && (lun == tmp->device->lun)
 #ifdef SUPPORT_TAGS
@@ -2522,11 +2524,11 @@ static void NCR5380_reselect(struct Scsi
 
 
 /*
- * Function : int NCR5380_abort (Scsi_Cmnd *cmd)
+ * Function : int NCR5380_abort (struct scsi_cmnd *cmd)
  *
  * Purpose : abort a command
  *
- * Inputs : cmd - the Scsi_Cmnd to abort, code - code to set the
+ * Inputs : cmd - the scsi_cmnd to abort, code - code to set the
  *	host byte of the result field to, if zero DID_ABORTED is
  *	used.
  *
@@ -2539,11 +2541,11 @@ static void NCR5380_reselect(struct Scsi
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
@@ -2613,8 +2615,8 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
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
@@ -2674,7 +2676,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 	 * it from the disconnected queue.
 	 */
 
-	for (tmp = (Scsi_Cmnd *) hostdata->disconnected_queue; tmp;
+	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue; tmp;
 	     tmp = NEXT(tmp)) {
 		if (cmd == tmp) {
 			local_irq_restore(flags);
@@ -2688,8 +2690,8 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 			do_abort(instance);
 
 			local_irq_save(flags);
-			for (prev = (Scsi_Cmnd **)&(hostdata->disconnected_queue),
-			     tmp = (Scsi_Cmnd *)hostdata->disconnected_queue;
+			for (prev = (struct scsi_cmnd **)&(hostdata->disconnected_queue),
+			     tmp = (struct scsi_cmnd *)hostdata->disconnected_queue;
 			     tmp; prev = NEXTADDR(tmp), tmp = NEXT(tmp)) {
 				if (cmd == tmp) {
 					REMOVE(5, *prev, tmp, NEXT(tmp));
@@ -2738,7 +2740,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 
 
 /*
- * Function : int NCR5380_reset (Scsi_Cmnd *cmd)
+ * Function : int NCR5380_reset (struct scsi_cmnd *cmd)
  *
  * Purpose : reset the SCSI bus.
  *
@@ -2746,13 +2748,13 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
  *
  */
 
-static int NCR5380_bus_reset(Scsi_Cmnd *cmd)
+static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
 {
 	SETUP_HOSTDATA(cmd->device->host);
 	int i;
 	unsigned long flags;
 #if defined(RESET_RUN_DONE)
-	Scsi_Cmnd *connected, *disconnected_queue;
+	struct scsi_cmnd *connected, *disconnected_queue;
 #endif
 
 	if (!IS_A_TT() && !falcon_got_lock)
@@ -2794,9 +2796,9 @@ static int NCR5380_bus_reset(Scsi_Cmnd *
 	 * remembered in local variables first.
 	 */
 	local_irq_save(flags);
-	connected = (Scsi_Cmnd *)hostdata->connected;
+	connected = (struct scsi_cmnd *)hostdata->connected;
 	hostdata->connected = NULL;
-	disconnected_queue = (Scsi_Cmnd *)hostdata->disconnected_queue;
+	disconnected_queue = (struct scsi_cmnd *)hostdata->disconnected_queue;
 	hostdata->disconnected_queue = NULL;
 #ifdef SUPPORT_TAGS
 	free_all_tags();
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-10-27 16:25:32.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2014-10-27 16:25:36.000000000 +1100
@@ -93,7 +93,6 @@
 #include <asm/irq.h>
 #include <asm/traps.h>
 
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "atari_scsi.h"
 #include "NCR5380.h"
@@ -880,7 +879,7 @@ static long atari_scsi_dma_residual(stru
 #define	CMD_SURELY_BYTE_MODE	1
 #define	CMD_MODE_UNKNOWN		2
 
-static int falcon_classify_cmd(Scsi_Cmnd *cmd)
+static int falcon_classify_cmd(struct scsi_cmnd *cmd)
 {
 	unsigned char opcode = cmd->cmnd[0];
 
@@ -912,7 +911,7 @@ static int falcon_classify_cmd(Scsi_Cmnd
  */
 
 static unsigned long atari_dma_xfer_len(unsigned long wanted_len,
-					Scsi_Cmnd *cmd, int write_flag)
+					struct scsi_cmnd *cmd, int write_flag)
 {
 	unsigned long	possible_len, limit;
 
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2014-10-27 16:25:26.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2014-10-27 16:25:36.000000000 +1100
@@ -45,7 +45,6 @@
  * Includes needed for NCR5380.[ch] (XXX: Move them to NCR5380.h)
  */
 #include <linux/delay.h>
-#include "scsi.h"
 
 #include "NCR5380.h"
 #include "NCR5380.c"
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2014-10-27 16:25:33.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2014-10-27 16:25:36.000000000 +1100
@@ -58,7 +58,6 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "dtc.h"
 #define AUTOPROBE_IRQ
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2014-10-27 16:25:33.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2014-10-27 16:25:36.000000000 +1100
@@ -72,7 +72,6 @@
 #include <asm/io.h>
 #include <linux/signal.h>
 #include <linux/blkdev.h>
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "g_NCR5380.h"
 #include "NCR5380.h"
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-10-27 16:25:33.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2014-10-27 16:25:36.000000000 +1100
@@ -30,7 +30,6 @@
 #include <asm/macints.h>
 #include <asm/mac_via.h>
 
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "mac_scsi.h"
 
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2014-10-27 16:25:30.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2014-10-27 16:25:36.000000000 +1100
@@ -81,7 +81,6 @@
 #include <linux/stat.h>
 #include <linux/init.h>
 
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "pas16.h"
 #define AUTOPROBE_IRQ
Index: linux/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/sun3_NCR5380.c	2014-10-27 16:25:33.000000000 +1100
+++ linux/drivers/scsi/sun3_NCR5380.c	2014-10-27 16:25:36.000000000 +1100
@@ -660,7 +660,7 @@ static void prepare_info(struct Scsi_Hos
  * Inputs : instance, pointer to this instance.  
  */
 
-static void lprint_Scsi_Cmnd(Scsi_Cmnd *cmd)
+static void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd)
 {
 	int i, s;
 	unsigned char *command;
@@ -677,7 +677,7 @@ static void lprint_Scsi_Cmnd(Scsi_Cmnd *
 static void NCR5380_print_status(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	unsigned long flags;
 
 	NCR5380_dprint(NDEBUG_ANY, instance);
@@ -691,13 +691,13 @@ static void NCR5380_print_status(struct
 	if (!hostdata->connected)
 		printk("scsi%d: no currently connected command\n", HOSTNO);
 	else
-		lprint_Scsi_Cmnd((Scsi_Cmnd *) hostdata->connected);
+		lprint_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected);
 	printk("scsi%d: issue_queue\n", HOSTNO);
-	for (ptr = (Scsi_Cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
+	for (ptr = (struct scsi_cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
 		lprint_Scsi_Cmnd(ptr);
 
 	printk("scsi%d: disconnected_queue\n", HOSTNO);
-	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr;
+	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
 	     ptr = NEXT(ptr))
 		lprint_Scsi_Cmnd(ptr);
 
@@ -705,7 +705,7 @@ static void NCR5380_print_status(struct
 	printk("\n");
 }
 
-static void show_Scsi_Cmnd(Scsi_Cmnd *cmd, struct seq_file *m)
+static void show_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m)
 {
 	int i, s;
 	unsigned char *command;
@@ -723,7 +723,7 @@ static int __maybe_unused NCR5380_show_i
                                             struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	unsigned long flags;
 
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
@@ -734,13 +734,13 @@ static int __maybe_unused NCR5380_show_i
 	if (!hostdata->connected)
 		seq_printf(m, "scsi%d: no currently connected command\n", HOSTNO);
 	else
-		show_Scsi_Cmnd((Scsi_Cmnd *) hostdata->connected, m);
+		show_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected, m);
 	seq_printf(m, "scsi%d: issue_queue\n", HOSTNO);
-	for (ptr = (Scsi_Cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
+	for (ptr = (struct scsi_cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
 		show_Scsi_Cmnd(ptr, m);
 
 	seq_printf(m, "scsi%d: disconnected_queue\n", HOSTNO);
-	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr;
+	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
 	     ptr = NEXT(ptr))
 		show_Scsi_Cmnd(ptr, m);
 
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-27 16:25:33.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-27 16:25:36.000000000 +1100
@@ -43,7 +43,6 @@
 /* dma on! */
 #define REAL_DMA
 
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
 #include "NCR5380.h"
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2014-10-27 16:25:33.000000000 +1100
+++ linux/drivers/scsi/t128.c	2014-10-27 16:25:36.000000000 +1100
@@ -77,7 +77,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "t128.h"
 #define AUTOPROBE_IRQ


