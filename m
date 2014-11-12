From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 07/37] ncr5380: Cleanup TAG_NEXT and TAG_NONE macros
Date: Wed, 12 Nov 2014 16:11:53 +1100
Message-ID: <20141112051148.175453066@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-cleanup-TAG_NONE-and-TAG_NEXT
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Both atari_NCR5380.c and sun3_NCR5380.c core drivers #undef TAG_NONE and
then redefine it. But the original definition is unused because NCR5380.c
lacks support for tagged queueing. So just define it once.

The TAG_NEXT macro only appears in the arguments to NCR5380_select() calls.
But that routine doesn't use its tag argument as the tag was already
assigned in NCR5380_main(). So remove the unused argument and the macro.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |   29 +++++++++++++----------------
 drivers/scsi/NCR5380.h       |   11 ++++-------
 drivers/scsi/atari_NCR5380.c |   19 +++++--------------
 drivers/scsi/sun3_NCR5380.c  |   19 +++++--------------
 4 files changed, 27 insertions(+), 51 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-11-12 16:10:54.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-11-12 16:10:55.000000000 +1100
@@ -316,10 +316,6 @@ static struct scsi_host_template *the_te
  * important: the tag bit must be cleared before 'nr_allocated' is decreased.
  */
 
-/* -1 for TAG_NONE is not possible with unsigned char cmd->tag */
-#undef TAG_NONE
-#define TAG_NONE 0xff
-
 typedef struct {
 	DECLARE_BITMAP(allocated, MAX_TAGS);
 	int nr_allocated;
@@ -1118,9 +1114,7 @@ static void NCR5380_main(struct work_str
 #ifdef SUPPORT_TAGS
 					cmd_get_tag(tmp, tmp->cmnd[0] != REQUEST_SENSE);
 #endif
-					if (!NCR5380_select(instance, tmp,
-					    (tmp->cmnd[0] == REQUEST_SENSE) ? TAG_NONE :
-					    TAG_NEXT)) {
+					if (!NCR5380_select(instance, tmp)) {
 						falcon_dont_release--;
 						/* release if target did not response! */
 						falcon_release_lock_if_possible(hostdata);
@@ -1351,17 +1345,14 @@ static void collect_stats(struct NCR5380
 #endif
 
 /*
- * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd,
- *	int tag);
+ * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd)
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
  *	including ARBITRATION, SELECTION, and initial message out for
  *	IDENTIFY and queue messages.
  *
  * Inputs : instance - instantiation of the 5380 driver on which this
- *	target lives, cmd - SCSI command to execute, tag - set to TAG_NEXT for
- *	new tag, TAG_NONE for untagged queueing, otherwise set to the tag for
- *	the command that is presently connected.
+ *	target lives, cmd - SCSI command to execute.
  *
  * Returns : -1 if selection could not execute for some reason,
  *	0 if selection succeeded or failed because the target
@@ -1381,7 +1372,7 @@ static void collect_stats(struct NCR5380
  *		cmd->result host byte set to DID_BAD_TARGET.
  */
 
-static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd *cmd, int tag)
+static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd *cmd)
 {
 	SETUP_HOSTDATA(instance);
 	unsigned char tmp[3], phase;
@@ -2758,7 +2749,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 			local_irq_restore(flags);
 			dprintk(NDEBUG_ABORT, "scsi%d: aborting disconnected command.\n", HOSTNO);
 
-			if (NCR5380_select(instance, cmd, (int)cmd->tag))
+			if (NCR5380_select(instance, cmd))
 				return FAILED;
 
 			dprintk(NDEBUG_ABORT, "scsi%d: nexus reestablished.\n", HOSTNO);
Index: linux/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/sun3_NCR5380.c	2014-11-12 16:10:54.000000000 +1100
+++ linux/drivers/scsi/sun3_NCR5380.c	2014-11-12 16:10:55.000000000 +1100
@@ -305,10 +305,6 @@ static struct scsi_host_template *the_te
  * important: the tag bit must be cleared before 'nr_allocated' is decreased.
  */
 
-/* -1 for TAG_NONE is not possible with unsigned char cmd->tag */
-#undef TAG_NONE
-#define TAG_NONE 0xff
-
 /* For the m68k, the number of bits in 'allocated' must be a multiple of 32! */
 #if (MAX_TAGS % 32) != 0
 #error "MAX_TAGS must be a multiple of 32!"
@@ -1057,9 +1053,7 @@ static void NCR5380_main (struct work_st
 #ifdef SUPPORT_TAGS
 		    cmd_get_tag( tmp, tmp->cmnd[0] != REQUEST_SENSE );
 #endif
-		    if (!NCR5380_select(instance, tmp, 
-			    (tmp->cmnd[0] == REQUEST_SENSE) ? TAG_NONE : 
-			    TAG_NEXT)) {
+		    if (!NCR5380_select(instance, tmp)) {
 			break;
 		    } else {
 			local_irq_disable();
@@ -1292,16 +1286,14 @@ static void collect_stats(struct NCR5380
 
 /* 
  * Function : int NCR5380_select(struct Scsi_Host *instance,
- * 				 struct scsi_cmnd *cmd,	int tag);
+ *				 struct scsi_cmnd *cmd)
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
  *	including ARBITRATION, SELECTION, and initial message out for 
  *	IDENTIFY and queue messages. 
  *
  * Inputs : instance - instantiation of the 5380 driver on which this 
- * 	target lives, cmd - SCSI command to execute, tag - set to TAG_NEXT for 
- *	new tag, TAG_NONE for untagged queueing, otherwise set to the tag for 
- *	the command that is presently connected.
+ *	target lives, cmd - SCSI command to execute.
  * 
  * Returns : -1 if selection could not execute for some reason,
  *	0 if selection succeeded or failed because the target 
@@ -1321,8 +1313,7 @@ static void collect_stats(struct NCR5380
  *		cmd->result host byte set to DID_BAD_TARGET.
  */
 
-static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd,
-			  int tag)
+static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 {
     SETUP_HOSTDATA(instance);
     unsigned char tmp[3], phase;
@@ -2736,7 +2727,7 @@ static int NCR5380_abort(struct scsi_cmn
             local_irq_restore(flags);
 	    dprintk(NDEBUG_ABORT, "scsi%d: aborting disconnected command.\n", HOSTNO);
   
-            if (NCR5380_select (instance, cmd, (int) cmd->tag)) 
+	    if (NCR5380_select(instance, cmd))
 		return FAILED;
 
 	    dprintk(NDEBUG_ABORT, "scsi%d: nexus reestablished.\n", HOSTNO);
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2014-11-12 16:10:49.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2014-11-12 16:10:55.000000000 +1100
@@ -1073,14 +1073,14 @@ static void NCR5380_main(struct work_str
 					hostdata->selecting = NULL;
 					/* RvC: have to preset this to indicate a new command is being performed */
 
-					if (!NCR5380_select(instance, tmp,
-							    /* 
-							     * REQUEST SENSE commands are issued without tagged
-							     * queueing, even on SCSI-II devices because the 
-							     * contingent allegiance condition exists for the 
-							     * entire unit.
-							     */
-							    (tmp->cmnd[0] == REQUEST_SENSE) ? TAG_NONE : TAG_NEXT)) {
+					/*
+					 * REQUEST SENSE commands are issued without tagged
+					 * queueing, even on SCSI-II devices because the
+					 * contingent allegiance condition exists for the
+					 * entire unit.
+					 */
+
+					if (!NCR5380_select(instance, tmp)) {
 						break;
 					} else {
 						LIST(tmp, hostdata->issue_queue);
@@ -1097,7 +1097,7 @@ static void NCR5380_main(struct work_str
 		if (hostdata->selecting) {
 			tmp = (Scsi_Cmnd *) hostdata->selecting;
 			/* Selection will drop and retake the lock */
-			if (!NCR5380_select(instance, tmp, (tmp->cmnd[0] == REQUEST_SENSE) ? TAG_NONE : TAG_NEXT)) {
+			if (!NCR5380_select(instance, tmp)) {
 				/* Ok ?? */
 			} else {
 				/* RvC: device failed, so we wait a long time
@@ -1246,17 +1246,14 @@ static void collect_stats(struct NCR5380
 
 
 /* 
- * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd, 
- *      int tag);
+ * Function : int NCR5380_select (struct Scsi_Host *instance, Scsi_Cmnd *cmd)
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
  *      including ARBITRATION, SELECTION, and initial message out for 
  *      IDENTIFY and queue messages. 
  *
  * Inputs : instance - instantiation of the 5380 driver on which this 
- *      target lives, cmd - SCSI command to execute, tag - set to TAG_NEXT for 
- *      new tag, TAG_NONE for untagged queueing, otherwise set to the tag for 
- *      the command that is presently connected.
+ *      target lives, cmd - SCSI command to execute.
  * 
  * Returns : -1 if selection could not execute for some reason,
  *      0 if selection succeeded or failed because the target 
@@ -1278,7 +1275,7 @@ static void collect_stats(struct NCR5380
  *	Locks: caller holds hostdata lock in IRQ mode
  */
  
-static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag) 
+static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd *cmd)
 {
 	NCR5380_local_declare();
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
@@ -2774,7 +2771,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
 		if (cmd == tmp) {
 			dprintk(NDEBUG_ABORT, "scsi%d : aborting disconnected command.\n", instance->host_no);
 
-			if (NCR5380_select(instance, cmd, (int) cmd->tag))
+			if (NCR5380_select(instance, cmd))
 				return FAILED;
 			dprintk(NDEBUG_ABORT, "scsi%d : nexus reestablished.\n", instance->host_no);
 
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-11-12 16:10:54.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-11-12 16:10:55.000000000 +1100
@@ -224,14 +224,11 @@
 #define DISCONNECT_LONG		2
 
 /* 
- * These are "special" values for the tag parameter passed to NCR5380_select.
+ * "Special" value for the (unsigned char) command tag, to indicate
+ * I_T_L nexus instead of I_T_L_Q.
  */
 
-#define TAG_NEXT	-1	/* Use next free tag */
-#define TAG_NONE	-2	/* 
-				 * Establish I_T_L nexus instead of I_T_L_Q
-				 * even on SCSI-II devices.
-				 */
+#define TAG_NONE	0xff
 
 /*
  * These are "special" values for the irq and dma_channel fields of the 
@@ -323,7 +320,7 @@ static irqreturn_t NCR5380_intr(int irq,
 static void NCR5380_main(struct work_struct *work);
 static void __maybe_unused NCR5380_print_options(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
-static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag);
+static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd *cmd);
 #if defined(PSEUDO_DMA) || defined(REAL_DMA) || defined(REAL_DMA_POLL)
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 #endif
