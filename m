From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/27] aha152x: Debug output update and whitespace cleanup
Date: Fri, 24 Oct 2014 14:26:43 +0200
Message-ID: <1414153627-2863-4-git-send-email-hare@suse.de>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308AbaJXM1M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2014 08:27:12 -0400
In-Reply-To: <1414153627-2863-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Remove all uncommented debugging code and move all
printk() statements over to dev_printk().
And while we're at it we should be doing a whitespace
cleanup, too.

Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aha152x.c | 994 +++++++++++--------------------------------------
 1 file changed, 224 insertions(+), 770 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index e77b72f..2b960b3 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -230,7 +230,7 @@
  *
  *
  **************************************************************************
- 
+
  see Documentation/scsi/aha152x.txt for configuration details
 
  **************************************************************************/
@@ -279,45 +279,11 @@ static LIST_HEAD(aha152x_host_list);
 #error define AUTOCONF or SETUP0
 #endif
 
-#if defined(AHA152X_DEBUG)
-#define DEBUG_DEFAULT debug_eh
-
-#define DPRINTK(when,msgs...) \
-	do { if(HOSTDATA(shpnt)->debug & (when)) printk(msgs); } while(0)
-
-#define DO_LOCK(flags)	\
-	do { \
-		if(spin_is_locked(&QLOCK)) { \
-			DPRINTK(debug_intr, DEBUG_LEAD "(%s:%d) already locked at %s:%d\n", CMDINFO(CURRENT_SC), __func__, __LINE__, QLOCKER, QLOCKERL); \
-		} \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
-		spin_lock_irqsave(&QLOCK,flags); \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
-		QLOCKER=__func__; \
-		QLOCKERL=__LINE__; \
-	} while(0)
-
-#define DO_UNLOCK(flags)	\
-	do { \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocking (locked at %s:%d)\n", CMDINFO(CURRENT_SC), __func__, __LINE__, QLOCKER, QLOCKERL); \
-		spin_unlock_irqrestore(&QLOCK,flags); \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocked\n", CMDINFO(CURRENT_SC), __func__, __LINE__); \
-		QLOCKER="(not locked)"; \
-		QLOCKERL=0; \
-	} while(0)
-
-#else
-#define DPRINTK(when,msgs...)
 #define	DO_LOCK(flags)		spin_lock_irqsave(&QLOCK,flags)
 #define	DO_UNLOCK(flags)	spin_unlock_irqrestore(&QLOCK,flags)
-#endif
 
 #define LEAD		"(scsi%d:%d:%d) "
-#define WARN_LEAD	KERN_WARNING	LEAD
 #define INFO_LEAD	KERN_INFO	LEAD
-#define NOTE_LEAD	KERN_NOTICE	LEAD
-#define ERR_LEAD	KERN_ERR	LEAD
-#define DEBUG_LEAD	KERN_DEBUG	LEAD
 #define CMDINFO(cmd) \
 			(cmd) ? ((cmd)->device->host->host_no) : -1, \
                         (cmd) ? ((cmd)->device->id & 0x0f) : -1, \
@@ -345,10 +311,10 @@ CMD_INC_RESID(struct scsi_cmnd *cmd, int inc)
 
 enum {
 	not_issued	= 0x0001,	/* command not yet issued */
-	selecting	= 0x0002, 	/* target is beeing selected */
+	selecting	= 0x0002,	/* target is being selected */
 	identified	= 0x0004,	/* IDENTIFY was sent */
 	disconnected	= 0x0008,	/* target disconnected */
-	completed	= 0x0010,	/* target sent COMMAND COMPLETE */ 
+	completed	= 0x0010,	/* target sent COMMAND COMPLETE */
 	aborted		= 0x0020,	/* ABORT was sent */
 	resetted	= 0x0040,	/* BUS DEVICE RESET was sent */
 	spiordy		= 0x0080,	/* waiting for SPIORDY to raise */
@@ -396,7 +362,6 @@ static int exttrans[] = {0, 0};
 module_param_array(exttrans, int, NULL, 0);
 MODULE_PARM_DESC(exttrans,"use extended translation");
 
-#if !defined(AHA152X_DEBUG)
 static int aha152x[] = {0, 11, 7, 1, 1, 0, DELAY_DEFAULT, 0};
 module_param_array(aha152x, int, NULL, 0);
 MODULE_PARM_DESC(aha152x, "parameters for first controller");
@@ -404,19 +369,6 @@ MODULE_PARM_DESC(aha152x, "parameters for first controller");
 static int aha152x1[] = {0, 11, 7, 1, 1, 0, DELAY_DEFAULT, 0};
 module_param_array(aha152x1, int, NULL, 0);
 MODULE_PARM_DESC(aha152x1, "parameters for second controller");
-#else
-static int debug[] = {DEBUG_DEFAULT, DEBUG_DEFAULT};
-module_param_array(debug, int, NULL, 0);
-MODULE_PARM_DESC(debug, "flags for driver debugging");
-
-static int aha152x[]   = {0, 11, 7, 1, 1, 1, DELAY_DEFAULT, 0, DEBUG_DEFAULT};
-module_param_array(aha152x, int, NULL, 0);
-MODULE_PARM_DESC(aha152x, "parameters for first controller");
-
-static int aha152x1[]  = {0, 11, 7, 1, 1, 1, DELAY_DEFAULT, 0, DEBUG_DEFAULT};
-module_param_array(aha152x1, int, NULL, 0);
-MODULE_PARM_DESC(aha152x1, "parameters for second controller");
-#endif /* !defined(AHA152X_DEBUG) */
 #endif /* MODULE */
 
 #ifdef __ISAPNP__
@@ -446,7 +398,7 @@ static struct scsi_host_template aha152x_driver_template;
 /*
  * internal states of the host
  *
- */ 
+ */
 enum aha152x_state {
 	idle=0,
 	unknown,
@@ -485,24 +437,16 @@ struct aha152x_hostdata {
 	spinlock_t lock;
 		/* host lock */
 
-#if defined(AHA152X_DEBUG)
-	const char *locker;
-		/* which function has the lock */
-	int lockerl;	/* where did it get it */
-
-	int debug;	/* current debugging setting */
-#endif
-
 #if defined(AHA152X_STAT)
-	int           total_commands;
+	int	      total_commands;
 	int	      disconnections;
 	int	      busfree_without_any_action;
 	int	      busfree_without_old_command;
 	int	      busfree_without_new_command;
 	int	      busfree_without_done_command;
 	int	      busfree_with_check_condition;
-	int           count[maxstate];
-	int           count_trans[maxstate];
+	int	      count[maxstate];
+	int	      count_trans[maxstate];
 	unsigned long time[maxstate];
 #endif
 
@@ -514,7 +458,7 @@ struct aha152x_hostdata {
 	int delay;		/* reset out delay */
 	int ext_trans;		/* extended translation enabled */
 
-	int swint; 		/* software-interrupt was fired during detect() */
+	int swint;		/* software-interrupt was fired during detect() */
 	int service;		/* bh needs to be run */
 	int in_intr;		/* bh is running */
 
@@ -543,7 +487,7 @@ struct aha152x_hostdata {
 	unsigned char msgi[256];
 		/* received message bytes */
 
-	int msgo_i, msgo_len;	
+	int msgo_i, msgo_len;
 		/* number of sent bytes and length of current messages */
 	unsigned char msgo[256];
 		/* pending messages */
@@ -689,7 +633,6 @@ static void aha152x_error(struct Scsi_Host *shpnt, char *msg);
 static void done(struct Scsi_Host *shpnt, int error);
 
 /* diagnostics */
-static void disp_ports(struct Scsi_Host *shpnt);
 static void show_command(Scsi_Cmnd * ptr);
 static void show_queues(struct Scsi_Host *shpnt);
 static void disp_enintr(struct Scsi_Host *shpnt);
@@ -812,10 +755,6 @@ struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 	DELAY       = setup->delay;
 	EXT_TRANS   = setup->ext_trans;
 
-#if defined(AHA152X_DEBUG)
-	HOSTDATA(shpnt)->debug = setup->debug;
-#endif
-
 	SETPORT(SCSIID, setup->scsiid << 4);
 	shpnt->this_id = setup->scsiid;
 
@@ -941,31 +880,24 @@ void aha152x_release(struct Scsi_Host *shpnt)
  * setup controller to generate interrupts depending
  * on current state (lock has to be acquired)
  *
- */ 
+ */
 static int setup_expected_interrupts(struct Scsi_Host *shpnt)
 {
 	if(CURRENT_SC) {
 		CURRENT_SC->SCp.phase |= 1 << 16;
-	
+
 		if(CURRENT_SC->SCp.phase & selecting) {
-			DPRINTK(debug_intr, DEBUG_LEAD "expecting: (seldo) (seltimo) (seldi)\n", CMDINFO(CURRENT_SC));
 			SETPORT(SSTAT1, SELTO);
 			SETPORT(SIMODE0, ENSELDO | (DISCONNECTED_SC ? ENSELDI : 0));
 			SETPORT(SIMODE1, ENSELTIMO);
 		} else {
-			DPRINTK(debug_intr, DEBUG_LEAD "expecting: (phase change) (busfree) %s\n", CMDINFO(CURRENT_SC), CURRENT_SC->SCp.phase & spiordy ? "(spiordy)" : "");
 			SETPORT(SIMODE0, (CURRENT_SC->SCp.phase & spiordy) ? ENSPIORDY : 0);
-			SETPORT(SIMODE1, ENPHASEMIS | ENSCSIRST | ENSCSIPERR | ENBUSFREE); 
+			SETPORT(SIMODE1, ENPHASEMIS | ENSCSIRST | ENSCSIPERR | ENBUSFREE);
 		}
 	} else if(STATE==seldi) {
-		DPRINTK(debug_intr, DEBUG_LEAD "expecting: (phase change) (identify)\n", CMDINFO(CURRENT_SC));
 		SETPORT(SIMODE0, 0);
-		SETPORT(SIMODE1, ENPHASEMIS | ENSCSIRST | ENSCSIPERR | ENBUSFREE); 
+		SETPORT(SIMODE1, ENPHASEMIS | ENSCSIRST | ENSCSIPERR | ENBUSFREE);
 	} else {
-		DPRINTK(debug_intr, DEBUG_LEAD "expecting: %s %s\n",
-			CMDINFO(CURRENT_SC),
-			DISCONNECTED_SC ? "(reselection)" : "",
-			ISSUE_SC ? "(busfree)" : "");
 		SETPORT(SIMODE0, DISCONNECTED_SC ? ENSELDI : 0);
 		SETPORT(SIMODE1, ENSCSIRST | ( (ISSUE_SC||DONE_SC) ? ENBUSFREE : 0));
 	}
@@ -977,7 +909,7 @@ static int setup_expected_interrupts(struct Scsi_Host *shpnt)
 }
 
 
-/* 
+/*
  *  Queue a command and setup interrupts for a free bus.
  */
 static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
@@ -986,15 +918,6 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
 
-#if defined(AHA152X_DEBUG)
-	if (HOSTDATA(shpnt)->debug & debug_queue) {
-		printk(INFO_LEAD "queue: %p; cmd_len=%d pieces=%d size=%u cmnd=",
-		       CMDINFO(SCpnt), SCpnt, SCpnt->cmd_len,
-		       scsi_sg_count(SCpnt), scsi_bufflen(SCpnt));
-		__scsi_print_command(SCpnt->cmnd);
-	}
-#endif
-
 	SCpnt->scsi_done	= done;
 	SCpnt->SCp.phase	= not_issued | phase;
 	SCpnt->SCp.Status	= 0x1; /* Ilegal status by SCSI standard */
@@ -1004,13 +927,13 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
 
 	if(SCpnt->SCp.phase & (resetting|check_condition)) {
 		if (!SCpnt->host_scribble || SCSEM(SCpnt) || SCNEXT(SCpnt)) {
-			printk(ERR_LEAD "cannot reuse command\n", CMDINFO(SCpnt));
+			scmd_printk(KERN_ERR, SCpnt, "cannot reuse command\n");
 			return FAILED;
 		}
 	} else {
 		SCpnt->host_scribble = kmalloc(sizeof(struct aha152x_scdata), GFP_ATOMIC);
 		if(!SCpnt->host_scribble) {
-			printk(ERR_LEAD "allocation failed\n", CMDINFO(SCpnt));
+			scmd_printk(KERN_ERR, SCpnt, "allocation failed\n");
 			return FAILED;
 		}
 	}
@@ -1066,15 +989,6 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
  */
 static int aha152x_queue_lck(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 {
-#if 0
-	if(*SCpnt->cmnd == REQUEST_SENSE) {
-		SCpnt->result = 0;
-		done(SCpnt);
-
-		return 0;
-	}
-#endif
-
 	return aha152x_internal_queue(SCpnt, NULL, 0, done);
 }
 
@@ -1082,15 +996,10 @@ static DEF_SCSI_QCMD(aha152x_queue)
 
 
 /*
- *  
  *
  */
 static void reset_done(Scsi_Cmnd *SCpnt)
 {
-#if 0
-	struct Scsi_Host *shpnt = SCpnt->host;
-	DPRINTK(debug_eh, INFO_LEAD "reset_done called\n", CMDINFO(SCpnt));
-#endif
 	if(SCSEM(SCpnt)) {
 		complete(SCSEM(SCpnt));
 	} else {
@@ -1108,20 +1017,11 @@ static int aha152x_abort(Scsi_Cmnd *SCpnt)
 	Scsi_Cmnd *ptr;
 	unsigned long flags;
 
-#if defined(AHA152X_DEBUG)
-	if(HOSTDATA(shpnt)->debug & debug_eh) {
-		printk(DEBUG_LEAD "abort(%p)", CMDINFO(SCpnt), SCpnt);
-		show_queues(shpnt);
-	}
-#endif
-
 	DO_LOCK(flags);
 
 	ptr=remove_SC(&ISSUE_SC, SCpnt);
 
 	if(ptr) {
-		DPRINTK(debug_eh, DEBUG_LEAD "not yet issued - SUCCESS\n", CMDINFO(SCpnt));
-
 		HOSTDATA(shpnt)->commands--;
 		if (!HOSTDATA(shpnt)->commands)
 			SETPORT(PORTA, 0);
@@ -1131,7 +1031,7 @@ static int aha152x_abort(Scsi_Cmnd *SCpnt)
 		SCpnt->host_scribble=NULL;
 
 		return SUCCESS;
-	} 
+	}
 
 	DO_UNLOCK(flags);
 
@@ -1142,7 +1042,8 @@ static int aha152x_abort(Scsi_Cmnd *SCpnt)
 	 *
 	 */
 
-	printk(ERR_LEAD "cannot abort running or disconnected command\n", CMDINFO(SCpnt));
+	scmd_printk(KERN_ERR, SCpnt,
+		    "cannot abort running or disconnected command\n");
 
 	return FAILED;
 }
@@ -1160,15 +1061,8 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 	unsigned long flags;
 	unsigned long timeleft;
 
-#if defined(AHA152X_DEBUG)
-	if(HOSTDATA(shpnt)->debug & debug_eh) {
-		printk(INFO_LEAD "aha152x_device_reset(%p)", CMDINFO(SCpnt), SCpnt);
-		show_queues(shpnt);
-	}
-#endif
-
 	if(CURRENT_SC==SCpnt) {
-		printk(ERR_LEAD "cannot reset current device\n", CMDINFO(SCpnt));
+		scmd_printk(KERN_ERR, SCpnt, "cannot reset current device\n");
 		return FAILED;
 	}
 
@@ -1208,7 +1102,7 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 		} else if(disconnected) {
 			append_SC(&DISCONNECTED_SC, SCpnt);
 		}
-	
+
 		ret = FAILED;
 	}
 
@@ -1227,12 +1121,12 @@ static void free_hard_reset_SCs(struct Scsi_Host *shpnt, Scsi_Cmnd **SCs)
 		if(SCDATA(ptr)) {
 			next = SCNEXT(ptr);
 		} else {
-			printk(DEBUG_LEAD "queue corrupted at %p\n", CMDINFO(ptr), ptr);
+			scmd_printk(KERN_DEBUG, ptr,
+				    "queue corrupted at %p\n", ptr);
 			next = NULL;
 		}
 
 		if (!ptr->device->soft_reset) {
-			DPRINTK(debug_eh, DEBUG_LEAD "disconnected command %p removed\n", CMDINFO(ptr), ptr);
 			remove_SC(SCs, ptr);
 			HOSTDATA(shpnt)->commands--;
 			kfree(ptr->host_scribble);
@@ -1253,25 +1147,14 @@ static int aha152x_bus_reset_host(struct Scsi_Host *shpnt)
 
 	DO_LOCK(flags);
 
-#if defined(AHA152X_DEBUG)
-	if(HOSTDATA(shpnt)->debug & debug_eh) {
-		printk(KERN_DEBUG "scsi%d: bus reset", shpnt->host_no);
-		show_queues(shpnt);
-	}
-#endif
-
 	free_hard_reset_SCs(shpnt, &ISSUE_SC);
 	free_hard_reset_SCs(shpnt, &DISCONNECTED_SC);
 
-	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: resetting bus\n", shpnt->host_no);
-
 	SETPORT(SCSISEQ, SCSIRSTO);
 	mdelay(256);
 	SETPORT(SCSISEQ, 0);
 	mdelay(DELAY);
 
-	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: bus resetted\n", shpnt->host_no);
-
 	setup_expected_interrupts(shpnt);
 	if(HOSTDATA(shpnt)->commands==0)
 		SETPORT(PORTA, 0);
@@ -1333,11 +1216,7 @@ static void reset_ports(struct Scsi_Host *shpnt)
  */
 int aha152x_host_reset_host(struct Scsi_Host *shpnt)
 {
-	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: host reset\n", shpnt->host_no);
-
 	aha152x_bus_reset_host(shpnt);
-
-	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: resetting ports\n", shpnt->host_no);
 	reset_ports(shpnt);
 
 	return SUCCESS;
@@ -1345,7 +1224,7 @@ int aha152x_host_reset_host(struct Scsi_Host *shpnt)
 
 /*
  * Reset the host (bus and controller)
- * 
+ *
  */
 static int aha152x_host_reset(Scsi_Cmnd *SCpnt)
 {
@@ -1411,7 +1290,9 @@ static void done(struct Scsi_Host *shpnt, int error)
 {
 	if (CURRENT_SC) {
 		if(DONE_SC)
-			printk(ERR_LEAD "there's already a completed command %p - will cause abort\n", CMDINFO(CURRENT_SC), DONE_SC);
+			scmd_printk(KERN_ERR, CURRENT_SC,
+				    "there's already a completed command %p "
+				    "- will cause abort\n", DONE_SC);
 
 		DONE_SC = CURRENT_SC;
 		CURRENT_SC = NULL;
@@ -1466,7 +1347,7 @@ static irqreturn_t intr(int irqno, void *dev_id)
 		return IRQ_NONE;
 
 	if( TESTLO(DMASTAT, INTSTAT) )
-		return IRQ_NONE;	
+		return IRQ_NONE;
 
 	/* no more interrupts from the controller, while we're busy.
 	   INTEN is restored by the BH handler */
@@ -1501,7 +1382,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 	SETPORT(SXFRCTL0, CH1);
 
 	SETPORT(SSTAT1, CLRBUSFREE);
-	
+
 	if(CURRENT_SC) {
 #if defined(AHA152X_STAT)
 		action++;
@@ -1513,19 +1394,13 @@ static void busfree_run(struct Scsi_Host *shpnt)
 			done(shpnt, (CURRENT_SC->SCp.Status & 0xff) | ((CURRENT_SC->SCp.Message & 0xff) << 8) | (DID_OK << 16));
 
 		} else if(CURRENT_SC->SCp.phase & aborted) {
-			DPRINTK(debug_eh, DEBUG_LEAD "ABORT sent\n", CMDINFO(CURRENT_SC));
 			done(shpnt, (CURRENT_SC->SCp.Status & 0xff) | ((CURRENT_SC->SCp.Message & 0xff) << 8) | (DID_ABORT << 16));
 
 		} else if(CURRENT_SC->SCp.phase & resetted) {
-			DPRINTK(debug_eh, DEBUG_LEAD "BUS DEVICE RESET sent\n", CMDINFO(CURRENT_SC));
 			done(shpnt, (CURRENT_SC->SCp.Status & 0xff) | ((CURRENT_SC->SCp.Message & 0xff) << 8) | (DID_RESET << 16));
 
 		} else if(CURRENT_SC->SCp.phase & disconnected) {
 			/* target sent DISCONNECT */
-			DPRINTK(debug_selection, DEBUG_LEAD "target disconnected at %d/%d\n",
-				CMDINFO(CURRENT_SC),
-				scsi_get_resid(CURRENT_SC),
-				scsi_bufflen(CURRENT_SC));
 #if defined(AHA152X_STAT)
 			HOSTDATA(shpnt)->disconnections++;
 #endif
@@ -1553,13 +1428,6 @@ static void busfree_run(struct Scsi_Host *shpnt)
 			struct scsi_cmnd *cmd = HOSTDATA(shpnt)->done_SC;
 			struct aha152x_scdata *sc = SCDATA(cmd);
 
-#if 0
-			if(HOSTDATA(shpnt)->debug & debug_eh) {
-				printk(ERR_LEAD "received sense: ", CMDINFO(DONE_SC));
-				scsi_print_sense("bh", DONE_SC);
-			}
-#endif
-
 			scsi_eh_restore_cmnd(cmd, &sc->ses);
 
 			cmd->SCp.Status = SAM_STAT_CHECK_CONDITION;
@@ -1571,17 +1439,11 @@ static void busfree_run(struct Scsi_Host *shpnt)
 #if defined(AHA152X_STAT)
 			HOSTDATA(shpnt)->busfree_with_check_condition++;
 #endif
-#if 0
-			DPRINTK(debug_eh, ERR_LEAD "CHECK CONDITION found\n", CMDINFO(DONE_SC));
-#endif
 
 			if(!(DONE_SC->SCp.phase & not_issued)) {
 				struct aha152x_scdata *sc;
 				Scsi_Cmnd *ptr = DONE_SC;
 				DONE_SC=NULL;
-#if 0
-				DPRINTK(debug_eh, ERR_LEAD "requesting sense\n", CMDINFO(ptr));
-#endif
 
 				sc = SCDATA(ptr);
 				/* It was allocated in aha152x_internal_queue? */
@@ -1591,19 +1453,10 @@ static void busfree_run(struct Scsi_Host *shpnt)
 				DO_UNLOCK(flags);
 				aha152x_internal_queue(ptr, NULL, check_condition, ptr->scsi_done);
 				DO_LOCK(flags);
-#if 0
-			} else {
-				DPRINTK(debug_eh, ERR_LEAD "command not issued - CHECK CONDITION ignored\n", CMDINFO(DONE_SC));
-#endif
 			}
 		}
 
 		if(DONE_SC && DONE_SC->scsi_done) {
-#if defined(AHA152X_DEBUG)
-			int hostno=DONE_SC->device->host->host_no;
-			int id=DONE_SC->device->id & 0xf;
-			int lun=((u8)DONE_SC->device->lun) & 0x7;
-#endif
 			Scsi_Cmnd *ptr = DONE_SC;
 			DONE_SC=NULL;
 
@@ -1618,9 +1471,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 			}
 
 			DO_UNLOCK(flags);
-			DPRINTK(debug_done, DEBUG_LEAD "calling scsi_done(%p)\n", hostno, id, lun, ptr);
-                	ptr->scsi_done(ptr);
-			DPRINTK(debug_done, DEBUG_LEAD "scsi_done(%p) returned\n", hostno, id, lun, ptr);
+			ptr->scsi_done(ptr);
 			DO_LOCK(flags);
 		}
 
@@ -1640,9 +1491,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 #if defined(AHA152X_STAT)
 		action++;
 #endif
-	    	CURRENT_SC->SCp.phase |= selecting;
-
-		DPRINTK(debug_selection, DEBUG_LEAD "selecting target\n", CMDINFO(CURRENT_SC));
+		CURRENT_SC->SCp.phase |= selecting;
 
 		/* clear selection timeout */
 		SETPORT(SSTAT1, SELTO);
@@ -1674,18 +1523,19 @@ static void seldo_run(struct Scsi_Host *shpnt)
 	SETPORT(SSTAT1, CLRBUSFREE);
 	SETPORT(SSTAT1, CLRPHASECHG);
 
-    	CURRENT_SC->SCp.phase &= ~(selecting|not_issued);
+	CURRENT_SC->SCp.phase &= ~(selecting|not_issued);
 
 	SETPORT(SCSISEQ, 0);
 
 	if (TESTLO(SSTAT0, SELDO)) {
-		printk(ERR_LEAD "aha152x: passing bus free condition\n", CMDINFO(CURRENT_SC));
+		scmd_printk(KERN_ERR, CURRENT_SC,
+			    "aha152x: passing bus free condition\n");
 		done(shpnt, DID_NO_CONNECT << 16);
 		return;
 	}
 
 	SETPORT(SSTAT0, CLRSELDO);
-	
+
 	ADDMSGO(IDENTIFY(RECONNECT, CURRENT_SC->device->lun));
 
 	if (CURRENT_SC->SCp.phase & aborting) {
@@ -1693,7 +1543,7 @@ static void seldo_run(struct Scsi_Host *shpnt)
 	} else if (CURRENT_SC->SCp.phase & resetting) {
 		ADDMSGO(BUS_DEVICE_RESET);
 	} else if (SYNCNEG==0 && SYNCHRONOUS) {
-    		CURRENT_SC->SCp.phase |= syncneg;
+		CURRENT_SC->SCp.phase |= syncneg;
 		MSGOLEN += spi_populate_sync_msg(&MSGO(MSGOLEN), 50, 8);
 		SYNCNEG=1;		/* negotiation in progress */
 	}
@@ -1708,29 +1558,21 @@ static void seldo_run(struct Scsi_Host *shpnt)
  */
 static void selto_run(struct Scsi_Host *shpnt)
 {
-	SETPORT(SCSISEQ, 0);		
+	SETPORT(SCSISEQ, 0);
 	SETPORT(SSTAT1, CLRSELTIMO);
 
-	DPRINTK(debug_selection, DEBUG_LEAD "selection timeout\n", CMDINFO(CURRENT_SC));
-
-	if(!CURRENT_SC) {
-		DPRINTK(debug_selection, DEBUG_LEAD "!CURRENT_SC\n", CMDINFO(CURRENT_SC));
+	if (!CURRENT_SC)
 		return;
-	}
 
-    	CURRENT_SC->SCp.phase &= ~selecting;
+	CURRENT_SC->SCp.phase &= ~selecting;
 
-	if (CURRENT_SC->SCp.phase & aborted) {
-		DPRINTK(debug_selection, DEBUG_LEAD "aborted\n", CMDINFO(CURRENT_SC));
+	if (CURRENT_SC->SCp.phase & aborted)
 		done(shpnt, DID_ABORT << 16);
-	} else if (TESTLO(SSTAT0, SELINGO)) {
-		DPRINTK(debug_selection, DEBUG_LEAD "arbitration not won\n", CMDINFO(CURRENT_SC));
+	else if (TESTLO(SSTAT0, SELINGO))
 		done(shpnt, DID_BUS_BUSY << 16);
-	} else {
+	else
 		/* ARBITRATION won, but SELECTION failed */
-		DPRINTK(debug_selection, DEBUG_LEAD "selection failed\n", CMDINFO(CURRENT_SC));
 		done(shpnt, DID_NO_CONNECT << 16);
-	}
 }
 
 /*
@@ -1753,9 +1595,8 @@ static void seldi_run(struct Scsi_Host *shpnt)
 
 	if(CURRENT_SC) {
 		if(!(CURRENT_SC->SCp.phase & not_issued))
-			printk(ERR_LEAD "command should not have been issued yet\n", CMDINFO(CURRENT_SC));
-
-		DPRINTK(debug_selection, ERR_LEAD "command requeued - reselection\n", CMDINFO(CURRENT_SC));
+			scmd_printk(KERN_ERR, CURRENT_SC,
+				    "command should not have been issued yet\n");
 
 		DO_LOCK(flags);
 		append_SC(&ISSUE_SC, CURRENT_SC);
@@ -1764,17 +1605,16 @@ static void seldi_run(struct Scsi_Host *shpnt)
 		CURRENT_SC = NULL;
 	}
 
-	if(!DISCONNECTED_SC) {
-		DPRINTK(debug_selection, DEBUG_LEAD "unexpected SELDI ", CMDINFO(CURRENT_SC));
+	if (!DISCONNECTED_SC)
 		return;
-	}
 
 	RECONN_TARGET=-1;
 
 	selid = GETPORT(SELID) & ~(1 << shpnt->this_id);
 
 	if (selid==0) {
-		printk("aha152x%d: target id unknown (%02x)\n", HOSTNO, selid);
+		shost_printk(KERN_INFO, shpnt,
+			     "target id unknown (%02x)\n", selid);
 		return;
 	}
 
@@ -1782,8 +1622,8 @@ static void seldi_run(struct Scsi_Host *shpnt)
 		;
 
 	if(selid & ~(1 << target)) {
-		printk("aha152x%d: multiple targets reconnected (%02x)\n",
-		       HOSTNO, selid);
+		shost_printk(KERN_INFO, shpnt,
+			     "multiple targets reconnected (%02x)\n", selid);
 	}
 
 
@@ -1793,7 +1633,6 @@ static void seldi_run(struct Scsi_Host *shpnt)
 	SETRATE(HOSTDATA(shpnt)->syncrate[target]);
 
 	RECONN_TARGET=target;
-	DPRINTK(debug_selection, DEBUG_LEAD "target %d reselected (%02x).\n", CMDINFO(CURRENT_SC), target, selid);
 }
 
 /*
@@ -1817,31 +1656,24 @@ static void msgi_run(struct Scsi_Host *shpnt)
 		if(sstat1 & (PHASECHG|PHASEMIS|BUSFREE) || !(sstat1 & REQINIT))
 			return;
 
-		if(TESTLO(SSTAT0,SPIORDY)) {
-			DPRINTK(debug_msgi, DEBUG_LEAD "!SPIORDY\n", CMDINFO(CURRENT_SC));
+		if (TESTLO(SSTAT0, SPIORDY))
 			return;
-		}	
 
 		ADDMSGI(GETPORT(SCSIDAT));
 
-#if defined(AHA152X_DEBUG)
-		if (HOSTDATA(shpnt)->debug & debug_msgi) {
-			printk(INFO_LEAD "inbound message %02x ", CMDINFO(CURRENT_SC), MSGI(0));
-			spi_print_msg(&MSGI(0));
-			printk("\n");
-		}
-#endif
-
 		if(!CURRENT_SC) {
 			if(LASTSTATE!=seldi) {
-				printk(KERN_ERR "aha152x%d: message in w/o current command not after reselection\n", HOSTNO);
+				shost_printk(KERN_ERR, shpnt,
+					     "message in w/o current command"
+					     " not after reselection\n");
 			}
 
 			/*
-	 	 	 * Handle reselection
-	 		 */
+			 * Handle reselection
+			 */
 			if(!(MSGI(0) & IDENTIFY_BASE)) {
-				printk(KERN_ERR "aha152x%d: target didn't identify after reselection\n", HOSTNO);
+				shost_printk(KERN_ERR, shpnt,
+					     "target didn't identify after reselection\n");
 				continue;
 			}
 
@@ -1849,12 +1681,13 @@ static void msgi_run(struct Scsi_Host *shpnt)
 
 			if (!CURRENT_SC) {
 				show_queues(shpnt);
-				printk(KERN_ERR "aha152x%d: no disconnected command for target %d/%d\n", HOSTNO, RECONN_TARGET, MSGI(0) & 0x3f);
+				shost_printk(KERN_ERR, shpnt,
+					     "no disconnected command"
+					     " for target %d/%d\n",
+					     RECONN_TARGET, MSGI(0) & 0x3f);
 				continue;
 			}
 
-			DPRINTK(debug_msgi, DEBUG_LEAD "target reconnected\n", CMDINFO(CURRENT_SC));
-
 			CURRENT_SC->SCp.Message = MSGI(0);
 			CURRENT_SC->SCp.phase &= ~disconnected;
 
@@ -1862,31 +1695,32 @@ static void msgi_run(struct Scsi_Host *shpnt)
 
 			/* next message if any */
 			continue;
-		} 
+		}
 
 		CURRENT_SC->SCp.Message = MSGI(0);
 
 		switch (MSGI(0)) {
 		case DISCONNECT:
 			if (!RECONNECT)
-				printk(WARN_LEAD "target was not allowed to disconnect\n", CMDINFO(CURRENT_SC));
+				scmd_printk(KERN_WARNING, CURRENT_SC,
+					    "target was not allowed to disconnect\n");
 
 			CURRENT_SC->SCp.phase |= disconnected;
 			break;
 
 		case COMMAND_COMPLETE:
-			if(CURRENT_SC->SCp.phase & completed)
-				DPRINTK(debug_msgi, DEBUG_LEAD "again COMMAND COMPLETE\n", CMDINFO(CURRENT_SC));
-
 			CURRENT_SC->SCp.phase |= completed;
 			break;
 
 		case MESSAGE_REJECT:
 			if (SYNCNEG==1) {
-				printk(INFO_LEAD "Synchronous Data Transfer Request was rejected\n", CMDINFO(CURRENT_SC));
+				scmd_printk(KERN_INFO, CURRENT_SC,
+					    "Synchronous Data Transfer Request"
+					    " was rejected\n");
 				SYNCNEG=2;	/* negotiation completed */
 			} else
-				printk(INFO_LEAD "inbound message (MESSAGE REJECT)\n", CMDINFO(CURRENT_SC));
+				scmd_printk(KERN_INFO, CURRENT_SC,
+					    "inbound message (MESSAGE REJECT)\n");
 			break;
 
 		case SAVE_POINTERS:
@@ -1907,7 +1741,8 @@ static void msgi_run(struct Scsi_Host *shpnt)
 					long ticks;
 
 					if (MSGI(1) != 3) {
-						printk(ERR_LEAD "SDTR message length!=3\n", CMDINFO(CURRENT_SC));
+						scmd_printk(KERN_ERR, CURRENT_SC,
+							    "SDTR message length!=3\n");
 						break;
 					}
 
@@ -1924,10 +1759,12 @@ static void msgi_run(struct Scsi_Host *shpnt)
 						/* negotiation in progress */
 						if (ticks > 9 || MSGI(4) < 1 || MSGI(4) > 8) {
 							ADDMSGO(MESSAGE_REJECT);
-							printk(INFO_LEAD "received Synchronous Data Transfer Request invalid - rejected\n", CMDINFO(CURRENT_SC));
+							scmd_printk(KERN_INFO,
+								    CURRENT_SC,
+								    "received Synchronous Data Transfer Request invalid - rejected\n");
 							break;
 						}
-						
+
 						SYNCRATE |= ((ticks - 2) << 4) + MSGI(4);
 					} else if (ticks <= 9 && MSGI(4) >= 1) {
 						ADDMSGO(EXTENDED_MESSAGE);
@@ -1947,11 +1784,14 @@ static void msgi_run(struct Scsi_Host *shpnt)
 						SYNCRATE |= ((ticks - 2) << 4) + MSGI(4);
 					} else {
 						/* requested SDTR is too slow, do it asynchronously */
-						printk(INFO_LEAD "Synchronous Data Transfer Request too slow - Rejecting\n", CMDINFO(CURRENT_SC));
+						scmd_printk(KERN_INFO,
+							    CURRENT_SC,
+							    "Synchronous Data Transfer Request too slow - Rejecting\n");
 						ADDMSGO(MESSAGE_REJECT);
 					}
 
-					SYNCNEG=2;		/* negotiation completed */
+					/* negotiation completed */
+					SYNCNEG=2;
 					SETRATE(SYNCRATE);
 				}
 				break;
@@ -1985,12 +1825,12 @@ static void msgi_run(struct Scsi_Host *shpnt)
 static void msgi_end(struct Scsi_Host *shpnt)
 {
 	if(MSGILEN>0)
-		printk(WARN_LEAD "target left before message completed (%d)\n", CMDINFO(CURRENT_SC), MSGILEN);
+		scmd_printk(KERN_WARNING, CURRENT_SC,
+			    "target left before message completed (%d)\n",
+			    MSGILEN);
 
-	if (MSGOLEN > 0 && !(GETPORT(SSTAT1) & BUSFREE)) {
-		DPRINTK(debug_msgi, DEBUG_LEAD "msgo pending\n", CMDINFO(CURRENT_SC));
+	if (MSGOLEN > 0 && !(GETPORT(SSTAT1) & BUSFREE))
 		SETPORT(SCSISIG, P_MSGI | SIG_ATNO);
-	} 
 }
 
 /*
@@ -2003,21 +1843,12 @@ static void msgo_init(struct Scsi_Host *shpnt)
 		if((CURRENT_SC->SCp.phase & syncneg) && SYNCNEG==2 && SYNCRATE==0) {
 			ADDMSGO(IDENTIFY(RECONNECT, CURRENT_SC->device->lun));
 		} else {
-			printk(INFO_LEAD "unexpected MESSAGE OUT phase; rejecting\n", CMDINFO(CURRENT_SC));
+			scmd_printk(KERN_INFO, CURRENT_SC,
+				    "unexpected MESSAGE OUT phase; rejecting\n");
 			ADDMSGO(MESSAGE_REJECT);
 		}
 	}
 
-#if defined(AHA152X_DEBUG)
-	if(HOSTDATA(shpnt)->debug & debug_msgo) {
-		int i;
-
-		printk(DEBUG_LEAD "messages( ", CMDINFO(CURRENT_SC));
-		for (i=0; i<MSGOLEN; i+=spi_print_msg(&MSGO(i)), printk(" "))
-			;
-		printk(")\n");
-	}
-#endif
 }
 
 /*
@@ -2026,16 +1857,9 @@ static void msgo_init(struct Scsi_Host *shpnt)
  */
 static void msgo_run(struct Scsi_Host *shpnt)
 {
-	if(MSGO_I==MSGOLEN)
-		DPRINTK(debug_msgo, DEBUG_LEAD "messages all sent (%d/%d)\n", CMDINFO(CURRENT_SC), MSGO_I, MSGOLEN);
-
 	while(MSGO_I<MSGOLEN) {
-		DPRINTK(debug_msgo, DEBUG_LEAD "message byte %02x (%d/%d)\n", CMDINFO(CURRENT_SC), MSGO(MSGO_I), MSGO_I, MSGOLEN);
-
-		if(TESTLO(SSTAT0, SPIORDY)) {
-			DPRINTK(debug_msgo, DEBUG_LEAD "!SPIORDY\n", CMDINFO(CURRENT_SC));
+		if (TESTLO(SSTAT0, SPIORDY))
 			return;
-		}
 
 		if (MSGO_I==MSGOLEN-1) {
 			/* Leave MESSAGE OUT after transfer */
@@ -2059,36 +1883,33 @@ static void msgo_run(struct Scsi_Host *shpnt)
 static void msgo_end(struct Scsi_Host *shpnt)
 {
 	if(MSGO_I<MSGOLEN) {
-		printk(ERR_LEAD "message sent incompletely (%d/%d)\n", CMDINFO(CURRENT_SC), MSGO_I, MSGOLEN);
+		scmd_printk(KERN_ERR, CURRENT_SC,
+			    "message sent incompletely (%d/%d)\n",
+			    MSGO_I, MSGOLEN);
 		if(SYNCNEG==1) {
-			printk(INFO_LEAD "Synchronous Data Transfer Request was rejected\n", CMDINFO(CURRENT_SC));
+			scmd_printk(KERN_INFO, CURRENT_SC,
+				    "Synchronous Data Transfer Request was rejected\n");
 			SYNCNEG=2;
 		}
 	}
-		
+
 	MSGO_I  = 0;
 	MSGOLEN = 0;
 }
 
-/* 
+/*
  * command phase
  *
  */
 static void cmd_init(struct Scsi_Host *shpnt)
 {
 	if (CURRENT_SC->SCp.sent_command) {
-		printk(ERR_LEAD "command already sent\n", CMDINFO(CURRENT_SC));
+		scmd_printk(KERN_ERR, CURRENT_SC,
+			    "command already sent\n");
 		done(shpnt, DID_ERROR << 16);
 		return;
 	}
 
-#if defined(AHA152X_DEBUG)
-	if (HOSTDATA(shpnt)->debug & debug_cmd) {
-		printk(DEBUG_LEAD "cmd_init: ", CMDINFO(CURRENT_SC));
-		__scsi_print_command(CURRENT_SC->cmnd);
-	}
-#endif
-
 	CMD_I=0;
 }
 
@@ -2098,18 +1919,9 @@ static void cmd_init(struct Scsi_Host *shpnt)
  */
 static void cmd_run(struct Scsi_Host *shpnt)
 {
-	if(CMD_I==CURRENT_SC->cmd_len) {
-		DPRINTK(debug_cmd, DEBUG_LEAD "command already completely sent (%d/%d)", CMDINFO(CURRENT_SC), CMD_I, CURRENT_SC->cmd_len);
-		disp_ports(shpnt);
-	}
-
 	while(CMD_I<CURRENT_SC->cmd_len) {
-		DPRINTK(debug_cmd, DEBUG_LEAD "command byte %02x (%d/%d)\n", CMDINFO(CURRENT_SC), CURRENT_SC->cmnd[CMD_I], CMD_I, CURRENT_SC->cmd_len);
-
-		if(TESTLO(SSTAT0, SPIORDY)) {
-			DPRINTK(debug_cmd, DEBUG_LEAD "!SPIORDY\n", CMDINFO(CURRENT_SC));
+		if (TESTLO(SSTAT0, SPIORDY))
 			return;
-		}
 
 		SETPORT(SCSIDAT, CURRENT_SC->cmnd[CMD_I++]);
 	}
@@ -2118,7 +1930,9 @@ static void cmd_run(struct Scsi_Host *shpnt)
 static void cmd_end(struct Scsi_Host *shpnt)
 {
 	if(CMD_I<CURRENT_SC->cmd_len)
-		printk(ERR_LEAD "command sent incompletely (%d/%d)\n", CMDINFO(CURRENT_SC), CMD_I, CURRENT_SC->cmd_len);
+		scmd_printk(KERN_ERR, CURRENT_SC,
+			    "command sent incompletely (%d/%d)\n",
+			    CMD_I, CURRENT_SC->cmd_len);
 	else
 		CURRENT_SC->SCp.sent_command++;
 }
@@ -2129,20 +1943,11 @@ static void cmd_end(struct Scsi_Host *shpnt)
  */
 static void status_run(struct Scsi_Host *shpnt)
 {
-	if(TESTLO(SSTAT0,SPIORDY)) {
-		DPRINTK(debug_status, DEBUG_LEAD "!SPIORDY\n", CMDINFO(CURRENT_SC));
+	if (TESTLO(SSTAT0, SPIORDY))
 		return;
-	}
 
 	CURRENT_SC->SCp.Status = GETPORT(SCSIDAT);
 
-#if defined(AHA152X_DEBUG)
-	if (HOSTDATA(shpnt)->debug & debug_status) {
-		printk(DEBUG_LEAD "inbound status %02x ", CMDINFO(CURRENT_SC), CURRENT_SC->SCp.Status);
-		scsi_print_status(CURRENT_SC->SCp.Status);
-		printk("\n");
-	}
-#endif
 }
 
 /*
@@ -2161,10 +1966,6 @@ static void datai_init(struct Scsi_Host *shpnt)
 	SETPORT(SIMODE1, ENSCSIPERR | ENSCSIRST | ENPHASEMIS | ENBUSFREE);
 
 	DATA_LEN=0;
-	DPRINTK(debug_datai,
-		DEBUG_LEAD "datai_init: request_bufflen=%d resid=%d\n",
-		CMDINFO(CURRENT_SC), scsi_bufflen(CURRENT_SC),
-		scsi_get_resid(CURRENT_SC));
 }
 
 static void datai_run(struct Scsi_Host *shpnt)
@@ -2186,8 +1987,7 @@ static void datai_run(struct Scsi_Host *shpnt)
 			barrier();
 
 		if(TESTLO(DMASTAT, DFIFOFULL|INTSTAT)) {
-			printk(ERR_LEAD "datai timeout", CMDINFO(CURRENT_SC));
-			disp_ports(shpnt);
+			scmd_printk(KERN_ERR, CURRENT_SC, "datai timeout\n");
 			break;
 		}
 
@@ -2199,8 +1999,8 @@ static void datai_run(struct Scsi_Host *shpnt)
 				barrier();
 
 			if(TESTLO(SSTAT2, SEMPTY)) {
-				printk(ERR_LEAD "datai sempty timeout", CMDINFO(CURRENT_SC));
-				disp_ports(shpnt);
+				scmd_printk(KERN_ERR, CURRENT_SC,
+					    "datai sempty timeout");
 				break;
 			}
 
@@ -2209,48 +2009,49 @@ static void datai_run(struct Scsi_Host *shpnt)
 
 		if(CURRENT_SC->SCp.this_residual>0) {
 			while(fifodata>0 && CURRENT_SC->SCp.this_residual>0) {
-                        	data_count = fifodata>CURRENT_SC->SCp.this_residual ?
+				data_count = fifodata > CURRENT_SC->SCp.this_residual ?
 						CURRENT_SC->SCp.this_residual :
 						fifodata;
 				fifodata -= data_count;
 
-                        	if(data_count & 1) {
-					DPRINTK(debug_datai, DEBUG_LEAD "8bit\n", CMDINFO(CURRENT_SC));
-                                	SETPORT(DMACNTRL0, ENDMA|_8BIT);
-                                	*CURRENT_SC->SCp.ptr++ = GETPORT(DATAPORT);
-                                	CURRENT_SC->SCp.this_residual--;
-                                	DATA_LEN++;
-                                	SETPORT(DMACNTRL0, ENDMA);
-                        	}
-	
-                        	if(data_count > 1) {
-					DPRINTK(debug_datai, DEBUG_LEAD "16bit(%d)\n", CMDINFO(CURRENT_SC), data_count);
-                                	data_count >>= 1;
-                                	insw(DATAPORT, CURRENT_SC->SCp.ptr, data_count);
-                                	CURRENT_SC->SCp.ptr           += 2 * data_count;
-                                	CURRENT_SC->SCp.this_residual -= 2 * data_count;
-                                	DATA_LEN                      += 2 * data_count;
-                        	}
-	
-                        	if(CURRENT_SC->SCp.this_residual==0 && CURRENT_SC->SCp.buffers_residual>0) {
-                               		/* advance to next buffer */
-                               		CURRENT_SC->SCp.buffers_residual--;
-                               		CURRENT_SC->SCp.buffer++;
-                               		CURRENT_SC->SCp.ptr           = SG_ADDRESS(CURRENT_SC->SCp.buffer);
-                               		CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length;
-				} 
-                	}
-		} else if(fifodata>0) { 
-			printk(ERR_LEAD "no buffers left for %d(%d) bytes (data overrun!?)\n", CMDINFO(CURRENT_SC), fifodata, GETPORT(FIFOSTAT));
-                        SETPORT(DMACNTRL0, ENDMA|_8BIT);
+				if (data_count & 1) {
+					SETPORT(DMACNTRL0, ENDMA|_8BIT);
+					*CURRENT_SC->SCp.ptr++ = GETPORT(DATAPORT);
+					CURRENT_SC->SCp.this_residual--;
+					DATA_LEN++;
+					SETPORT(DMACNTRL0, ENDMA);
+				}
+
+				if (data_count > 1) {
+					data_count >>= 1;
+					insw(DATAPORT, CURRENT_SC->SCp.ptr, data_count);
+					CURRENT_SC->SCp.ptr += 2 * data_count;
+					CURRENT_SC->SCp.this_residual -= 2 * data_count;
+					DATA_LEN += 2 * data_count;
+				}
+
+				if (CURRENT_SC->SCp.this_residual == 0 &&
+				    CURRENT_SC->SCp.buffers_residual > 0) {
+					/* advance to next buffer */
+					CURRENT_SC->SCp.buffers_residual--;
+					CURRENT_SC->SCp.buffer++;
+					CURRENT_SC->SCp.ptr           = SG_ADDRESS(CURRENT_SC->SCp.buffer);
+					CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length;
+				}
+			}
+		} else if (fifodata > 0) {
+			scmd_printk(KERN_ERR, CURRENT_SC,
+				    "no buffers left for %d(%d) bytes"
+				    " (data overrun!?)\n",
+				    fifodata, GETPORT(FIFOSTAT));
+			SETPORT(DMACNTRL0, ENDMA|_8BIT);
 			while(fifodata>0) {
 				int data;
 				data=GETPORT(DATAPORT);
-				DPRINTK(debug_datai, DEBUG_LEAD "data=%02x\n", CMDINFO(CURRENT_SC), data);
 				fifodata--;
 				DATA_LEN++;
 			}
-                        SETPORT(DMACNTRL0, ENDMA|_8BIT);
+			SETPORT(DMACNTRL0, ENDMA|_8BIT);
 		}
 	}
 
@@ -2258,19 +2059,20 @@ static void datai_run(struct Scsi_Host *shpnt)
 	   TESTLO(DMASTAT, DFIFOEMP) ||
 	   TESTLO(SSTAT2, SEMPTY) ||
 	   GETPORT(FIFOSTAT)>0) {
-	   	/*
+		/*
 		 * something went wrong, if there's something left in the fifos
 		 * or the phase didn't change
 		 */
-		printk(ERR_LEAD "fifos should be empty and phase should have changed\n", CMDINFO(CURRENT_SC));
-		disp_ports(shpnt);
+		scmd_printk(KERN_ERR, CURRENT_SC,
+			    "fifos should be empty and phase should have changed\n");
 	}
 
 	if(DATA_LEN!=GETSTCNT()) {
-		printk(ERR_LEAD
-		       "manual transfer count differs from automatic (count=%d;stcnt=%d;diff=%d;fifostat=%d)",
-		       CMDINFO(CURRENT_SC), DATA_LEN, GETSTCNT(), GETSTCNT()-DATA_LEN, GETPORT(FIFOSTAT));
-		disp_ports(shpnt);
+		scmd_printk(KERN_ERR, CURRENT_SC,
+			    "manual transfer count differs from automatic "
+			    "(count=%d;stcnt=%d;diff=%d;fifostat=%d)",
+			    DATA_LEN, GETSTCNT(), GETSTCNT()-DATA_LEN,
+			    GETPORT(FIFOSTAT));
 		mdelay(10000);
 	}
 }
@@ -2279,11 +2081,6 @@ static void datai_end(struct Scsi_Host *shpnt)
 {
 	CMD_INC_RESID(CURRENT_SC, -GETSTCNT());
 
-	DPRINTK(debug_datai,
-		DEBUG_LEAD "datai_end: request_bufflen=%d resid=%d stcnt=%d\n",
-		CMDINFO(CURRENT_SC), scsi_bufflen(CURRENT_SC),
-		scsi_get_resid(CURRENT_SC), GETSTCNT());
-
 	SETPORT(SXFRCTL0, CH1|CLRSTCNT);
 	SETPORT(DMACNTRL0, 0);
 }
@@ -2304,11 +2101,6 @@ static void datao_init(struct Scsi_Host *shpnt)
 	SETPORT(SIMODE1, ENSCSIPERR | ENSCSIRST | ENPHASEMIS | ENBUSFREE );
 
 	DATA_LEN = scsi_get_resid(CURRENT_SC);
-
-	DPRINTK(debug_datao,
-		DEBUG_LEAD "datao_init: request_bufflen=%d; resid=%d\n",
-		CMDINFO(CURRENT_SC), scsi_bufflen(CURRENT_SC),
-		scsi_get_resid(CURRENT_SC));
 }
 
 static void datao_run(struct Scsi_Host *shpnt)
@@ -2323,8 +2115,9 @@ static void datao_run(struct Scsi_Host *shpnt)
 			data_count=CURRENT_SC->SCp.this_residual;
 
 		if(TESTLO(DMASTAT, DFIFOEMP)) {
-			printk(ERR_LEAD "datao fifo not empty (%d)", CMDINFO(CURRENT_SC), GETPORT(FIFOSTAT));
-			disp_ports(shpnt);
+			scmd_printk(KERN_ERR, CURRENT_SC,
+				    "datao fifo not empty (%d)",
+				    GETPORT(FIFOSTAT));
 			break;
 		}
 
@@ -2342,7 +2135,7 @@ static void datao_run(struct Scsi_Host *shpnt)
 			CURRENT_SC->SCp.ptr           += 2 * data_count;
 			CURRENT_SC->SCp.this_residual -= 2 * data_count;
 			CMD_INC_RESID(CURRENT_SC, -2 * data_count);
-	  	}
+		}
 
 		if(CURRENT_SC->SCp.this_residual==0 && CURRENT_SC->SCp.buffers_residual>0) {
 			/* advance to next buffer */
@@ -2357,8 +2150,7 @@ static void datao_run(struct Scsi_Host *shpnt)
 			barrier();
 
 		if(TESTLO(DMASTAT, DFIFOEMP|INTSTAT)) {
-			printk(ERR_LEAD "dataout timeout", CMDINFO(CURRENT_SC));
-			disp_ports(shpnt);
+			scmd_printk(KERN_ERR, CURRENT_SC, "dataout timeout\n");
 			break;
 		}
 	}
@@ -2368,35 +2160,23 @@ static void datao_end(struct Scsi_Host *shpnt)
 {
 	if(TESTLO(DMASTAT, DFIFOEMP)) {
 		int data_count = (DATA_LEN - scsi_get_resid(CURRENT_SC)) -
-		                                                    GETSTCNT();
-
-		DPRINTK(debug_datao, DEBUG_LEAD "datao: %d bytes to resend (%d written, %d transferred)\n",
-			CMDINFO(CURRENT_SC),
-			data_count,
-			DATA_LEN - scsi_get_resid(CURRENT_SC),
-			GETSTCNT());
+			GETSTCNT();
 
 		CMD_INC_RESID(CURRENT_SC, data_count);
 
 		data_count -= CURRENT_SC->SCp.ptr -
-		                             SG_ADDRESS(CURRENT_SC->SCp.buffer);
+			SG_ADDRESS(CURRENT_SC->SCp.buffer);
 		while(data_count>0) {
 			CURRENT_SC->SCp.buffer--;
 			CURRENT_SC->SCp.buffers_residual++;
 			data_count -= CURRENT_SC->SCp.buffer->length;
 		}
 		CURRENT_SC->SCp.ptr = SG_ADDRESS(CURRENT_SC->SCp.buffer) -
-		                                                     data_count;
+			data_count;
 		CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length +
-		                                                     data_count;
+			data_count;
 	}
 
-	DPRINTK(debug_datao, DEBUG_LEAD "datao_end: request_bufflen=%d; resid=%d; stcnt=%d\n",
-		CMDINFO(CURRENT_SC),
-		scsi_bufflen(CURRENT_SC),
-		scsi_get_resid(CURRENT_SC),
-		GETSTCNT());
-
 	SETPORT(SXFRCTL0, CH1|CLRCH1|CLRSTCNT);
 	SETPORT(SXFRCTL0, CH1);
 
@@ -2420,7 +2200,7 @@ static int update_state(struct Scsi_Host *shpnt)
 		STATE=rsti;
 		SETPORT(SCSISEQ,0);
 		SETPORT(SSTAT1,SCSIRSTI);
-  	} else if(stat0 & SELDI && PREVSTATE==busfree) {
+	} else if (stat0 & SELDI && PREVSTATE == busfree) {
 		STATE=seldi;
 	} else if(stat0 & SELDO && CURRENT_SC && (CURRENT_SC->SCp.phase & selecting)) {
 		STATE=seldo;
@@ -2445,8 +2225,7 @@ static int update_state(struct Scsi_Host *shpnt)
 	}
 
 	if((stat0 & SELDI) && STATE!=seldi && !dataphase) {
-		printk(INFO_LEAD "reselection missed?", CMDINFO(CURRENT_SC));
-		disp_ports(shpnt);
+		scmd_printk(KERN_INFO, CURRENT_SC, "reselection missed?");
 	}
 
 	if(STATE!=PREVSTATE) {
@@ -2464,7 +2243,7 @@ static int update_state(struct Scsi_Host *shpnt)
  */
 static void parerr_run(struct Scsi_Host *shpnt)
 {
-	printk(ERR_LEAD "parity error\n", CMDINFO(CURRENT_SC));
+	scmd_printk(KERN_ERR, CURRENT_SC, "parity error\n");
 	done(shpnt, DID_PARITY << 16);
 }
 
@@ -2476,8 +2255,8 @@ static void rsti_run(struct Scsi_Host *shpnt)
 {
 	Scsi_Cmnd *ptr;
 
-	printk(KERN_NOTICE "aha152x%d: scsi reset in\n", HOSTNO);
-	
+	shost_printk(KERN_NOTICE, shpnt, "scsi reset in\n");
+
 	ptr=DISCONNECTED_SC;
 	while(ptr) {
 		Scsi_Cmnd *next = SCNEXT(ptr);
@@ -2539,8 +2318,6 @@ static void is_complete(struct Scsi_Host *shpnt)
 
 		dataphase=update_state(shpnt);
 
-		DPRINTK(debug_phases, LEAD "start %s %s(%s)\n", CMDINFO(CURRENT_SC), states[STATE].name, states[PREVSTATE].name, states[LASTSTATE].name);
-
 		/*
 		 * end previous state
 		 *
@@ -2567,9 +2344,9 @@ static void is_complete(struct Scsi_Host *shpnt)
 		if(dataphase) {
 			SETPORT(SSTAT0, REQINIT);
 			SETPORT(SCSISIG, GETPORT(SCSISIG) & P_MASK);
-			SETPORT(SSTAT1, PHASECHG);  
+			SETPORT(SSTAT1, PHASECHG);
 		}
-		
+
 		/*
 		 * enable SPIO mode if previous didn't use it
 		 * and this one does
@@ -2581,14 +2358,14 @@ static void is_complete(struct Scsi_Host *shpnt)
 			if(CURRENT_SC)
 				CURRENT_SC->SCp.phase |= spiordy;
 		}
-		
+
 		/*
 		 * initialize for new state
 		 *
 		 */
 		if(PREVSTATE!=STATE && states[STATE].init)
 			states[STATE].init(shpnt);
-		
+
 		/*
 		 * handle current state
 		 *
@@ -2596,8 +2373,9 @@ static void is_complete(struct Scsi_Host *shpnt)
 		if(states[STATE].run)
 			states[STATE].run(shpnt);
 		else
-			printk(ERR_LEAD "unexpected state (%x)\n", CMDINFO(CURRENT_SC), STATE);
-		
+			scmd_printk(KERN_ERR, CURRENT_SC,
+				    "unexpected state (%x)\n", STATE);
+
 		/*
 		 * setup controller to interrupt on
 		 * the next expected condition and
@@ -2613,7 +2391,6 @@ static void is_complete(struct Scsi_Host *shpnt)
 		HOSTDATA(shpnt)->time[STATE] += jiffies-start;
 #endif
 
-		DPRINTK(debug_phases, LEAD "end %s %s(%s)\n", CMDINFO(CURRENT_SC), states[STATE].name, states[PREVSTATE].name, states[LASTSTATE].name);
 	} while(pending);
 
 	/*
@@ -2626,289 +2403,42 @@ static void is_complete(struct Scsi_Host *shpnt)
 }
 
 
-/* 
+/*
  * Dump the current driver status and panic
  */
 static void aha152x_error(struct Scsi_Host *shpnt, char *msg)
 {
-	printk(KERN_EMERG "\naha152x%d: %s\n", HOSTNO, msg);
+	shost_printk(KERN_EMERG, shpnt, "%s\n", msg);
 	show_queues(shpnt);
 	panic("aha152x panic\n");
 }
 
 /*
- * Display registers of AIC-6260
- */
-static void disp_ports(struct Scsi_Host *shpnt)
-{
-#if defined(AHA152X_DEBUG)
-	int s;
-
-	printk("\n%s: %s(%s) ",
-		CURRENT_SC ? "busy" : "waiting",
-		states[STATE].name,
-		states[PREVSTATE].name);
-
-	s = GETPORT(SCSISEQ);
-	printk("SCSISEQ( ");
-	if (s & TEMODEO)
-		printk("TARGET MODE ");
-	if (s & ENSELO)
-		printk("SELO ");
-	if (s & ENSELI)
-		printk("SELI ");
-	if (s & ENRESELI)
-		printk("RESELI ");
-	if (s & ENAUTOATNO)
-		printk("AUTOATNO ");
-	if (s & ENAUTOATNI)
-		printk("AUTOATNI ");
-	if (s & ENAUTOATNP)
-		printk("AUTOATNP ");
-	if (s & SCSIRSTO)
-		printk("SCSIRSTO ");
-	printk(");");
-
-	printk(" SCSISIG(");
-	s = GETPORT(SCSISIG);
-	switch (s & P_MASK) {
-	case P_DATAO:
-		printk("DATA OUT");
-		break;
-	case P_DATAI:
-		printk("DATA IN");
-		break;
-	case P_CMD:
-		printk("COMMAND");
-		break;
-	case P_STATUS:
-		printk("STATUS");
-		break;
-	case P_MSGO:
-		printk("MESSAGE OUT");
-		break;
-	case P_MSGI:
-		printk("MESSAGE IN");
-		break;
-	default:
-		printk("*invalid*");
-		break;
-	}
-
-	printk("); ");
-
-	printk("INTSTAT (%s); ", TESTHI(DMASTAT, INTSTAT) ? "hi" : "lo");
-
-	printk("SSTAT( ");
-	s = GETPORT(SSTAT0);
-	if (s & TARGET)
-		printk("TARGET ");
-	if (s & SELDO)
-		printk("SELDO ");
-	if (s & SELDI)
-		printk("SELDI ");
-	if (s & SELINGO)
-		printk("SELINGO ");
-	if (s & SWRAP)
-		printk("SWRAP ");
-	if (s & SDONE)
-		printk("SDONE ");
-	if (s & SPIORDY)
-		printk("SPIORDY ");
-	if (s & DMADONE)
-		printk("DMADONE ");
-
-	s = GETPORT(SSTAT1);
-	if (s & SELTO)
-		printk("SELTO ");
-	if (s & ATNTARG)
-		printk("ATNTARG ");
-	if (s & SCSIRSTI)
-		printk("SCSIRSTI ");
-	if (s & PHASEMIS)
-		printk("PHASEMIS ");
-	if (s & BUSFREE)
-		printk("BUSFREE ");
-	if (s & SCSIPERR)
-		printk("SCSIPERR ");
-	if (s & PHASECHG)
-		printk("PHASECHG ");
-	if (s & REQINIT)
-		printk("REQINIT ");
-	printk("); ");
-
-
-	printk("SSTAT( ");
-
-	s = GETPORT(SSTAT0) & GETPORT(SIMODE0);
-
-	if (s & TARGET)
-		printk("TARGET ");
-	if (s & SELDO)
-		printk("SELDO ");
-	if (s & SELDI)
-		printk("SELDI ");
-	if (s & SELINGO)
-		printk("SELINGO ");
-	if (s & SWRAP)
-		printk("SWRAP ");
-	if (s & SDONE)
-		printk("SDONE ");
-	if (s & SPIORDY)
-		printk("SPIORDY ");
-	if (s & DMADONE)
-		printk("DMADONE ");
-
-	s = GETPORT(SSTAT1) & GETPORT(SIMODE1);
-
-	if (s & SELTO)
-		printk("SELTO ");
-	if (s & ATNTARG)
-		printk("ATNTARG ");
-	if (s & SCSIRSTI)
-		printk("SCSIRSTI ");
-	if (s & PHASEMIS)
-		printk("PHASEMIS ");
-	if (s & BUSFREE)
-		printk("BUSFREE ");
-	if (s & SCSIPERR)
-		printk("SCSIPERR ");
-	if (s & PHASECHG)
-		printk("PHASECHG ");
-	if (s & REQINIT)
-		printk("REQINIT ");
-	printk("); ");
-
-	printk("SXFRCTL0( ");
-
-	s = GETPORT(SXFRCTL0);
-	if (s & SCSIEN)
-		printk("SCSIEN ");
-	if (s & DMAEN)
-		printk("DMAEN ");
-	if (s & CH1)
-		printk("CH1 ");
-	if (s & CLRSTCNT)
-		printk("CLRSTCNT ");
-	if (s & SPIOEN)
-		printk("SPIOEN ");
-	if (s & CLRCH1)
-		printk("CLRCH1 ");
-	printk("); ");
-
-	printk("SIGNAL( ");
-
-	s = GETPORT(SCSISIG);
-	if (s & SIG_ATNI)
-		printk("ATNI ");
-	if (s & SIG_SELI)
-		printk("SELI ");
-	if (s & SIG_BSYI)
-		printk("BSYI ");
-	if (s & SIG_REQI)
-		printk("REQI ");
-	if (s & SIG_ACKI)
-		printk("ACKI ");
-	printk("); ");
-
-	printk("SELID (%02x), ", GETPORT(SELID));
-
-	printk("STCNT (%d), ", GETSTCNT());
-	
-	printk("SSTAT2( ");
-
-	s = GETPORT(SSTAT2);
-	if (s & SOFFSET)
-		printk("SOFFSET ");
-	if (s & SEMPTY)
-		printk("SEMPTY ");
-	if (s & SFULL)
-		printk("SFULL ");
-	printk("); SFCNT (%d); ", s & (SFULL | SFCNT));
-
-	s = GETPORT(SSTAT3);
-	printk("SCSICNT (%d), OFFCNT(%d), ", (s & 0xf0) >> 4, s & 0x0f);
-
-	printk("SSTAT4( ");
-	s = GETPORT(SSTAT4);
-	if (s & SYNCERR)
-		printk("SYNCERR ");
-	if (s & FWERR)
-		printk("FWERR ");
-	if (s & FRERR)
-		printk("FRERR ");
-	printk("); ");
-
-	printk("DMACNTRL0( ");
-	s = GETPORT(DMACNTRL0);
-	printk("%s ", s & _8BIT ? "8BIT" : "16BIT");
-	printk("%s ", s & DMA ? "DMA" : "PIO");
-	printk("%s ", s & WRITE_READ ? "WRITE" : "READ");
-	if (s & ENDMA)
-		printk("ENDMA ");
-	if (s & INTEN)
-		printk("INTEN ");
-	if (s & RSTFIFO)
-		printk("RSTFIFO ");
-	if (s & SWINT)
-		printk("SWINT ");
-	printk("); ");
-
-	printk("DMASTAT( ");
-	s = GETPORT(DMASTAT);
-	if (s & ATDONE)
-		printk("ATDONE ");
-	if (s & WORDRDY)
-		printk("WORDRDY ");
-	if (s & DFIFOFULL)
-		printk("DFIFOFULL ");
-	if (s & DFIFOEMP)
-		printk("DFIFOEMP ");
-	printk(")\n");
-#endif
-}
-
-/*
  * display enabled interrupts
  */
 static void disp_enintr(struct Scsi_Host *shpnt)
 {
-	int s;
-
-	printk(KERN_DEBUG "enabled interrupts ( ");
-
-	s = GETPORT(SIMODE0);
-	if (s & ENSELDO)
-		printk("ENSELDO ");
-	if (s & ENSELDI)
-		printk("ENSELDI ");
-	if (s & ENSELINGO)
-		printk("ENSELINGO ");
-	if (s & ENSWRAP)
-		printk("ENSWRAP ");
-	if (s & ENSDONE)
-		printk("ENSDONE ");
-	if (s & ENSPIORDY)
-		printk("ENSPIORDY ");
-	if (s & ENDMADONE)
-		printk("ENDMADONE ");
-
-	s = GETPORT(SIMODE1);
-	if (s & ENSELTIMO)
-		printk("ENSELTIMO ");
-	if (s & ENATNTARG)
-		printk("ENATNTARG ");
-	if (s & ENPHASEMIS)
-		printk("ENPHASEMIS ");
-	if (s & ENBUSFREE)
-		printk("ENBUSFREE ");
-	if (s & ENSCSIPERR)
-		printk("ENSCSIPERR ");
-	if (s & ENPHASECHG)
-		printk("ENPHASECHG ");
-	if (s & ENREQINIT)
-		printk("ENREQINIT ");
-	printk(")\n");
+	int s0, s1;
+
+	s0 = GETPORT(SIMODE0);
+	s1 = GETPORT(SIMODE1);
+
+	shost_printk(KERN_DEBUG, shpnt,
+		     "enabled interrupts (%s%s%s%s%s%s%s%s%s%s%s%s%s%s)\n",
+		     (s0 & ENSELDO) ? "ENSELDO " : "",
+		     (s0 & ENSELDI) ? "ENSELDI " : "",
+		     (s0 & ENSELINGO) ? "ENSELINGO " : "",
+		     (s0 & ENSWRAP) ? "ENSWRAP " : "",
+		     (s0 & ENSDONE) ? "ENSDONE " : "",
+		     (s0 & ENSPIORDY) ? "ENSPIORDY " : "",
+		     (s0 & ENDMADONE) ? "ENDMADONE " : "",
+		     (s1 & ENSELTIMO) ? "ENSELTIMO " : "",
+		     (s1 & ENATNTARG) ? "ENATNTARG " : "",
+		     (s1 & ENPHASEMIS) ? "ENPHASEMIS " : "",
+		     (s1 & ENBUSFREE) ? "ENBUSFREE " : "",
+		     (s1 & ENSCSIPERR) ? "ENSCSIPERR " : "",
+		     (s1 & ENPHASECHG) ? "ENPHASECHG " : "",
+		     (s1 & ENREQINIT) ? "ENREQINIT " : "");
 }
 
 /*
@@ -2916,36 +2446,21 @@ static void disp_enintr(struct Scsi_Host *shpnt)
  */
 static void show_command(Scsi_Cmnd *ptr)
 {
-	scmd_printk(KERN_DEBUG, ptr, "%p: cmnd=(", ptr);
-
-	__scsi_print_command(ptr->cmnd);
-
-	printk(KERN_DEBUG "); request_bufflen=%d; resid=%d; phase |",
-	       scsi_bufflen(ptr), scsi_get_resid(ptr));
-
-	if (ptr->SCp.phase & not_issued)
-		printk("not issued|");
-	if (ptr->SCp.phase & selecting)
-		printk("selecting|");
-	if (ptr->SCp.phase & identified)
-		printk("identified|");
-	if (ptr->SCp.phase & disconnected)
-		printk("disconnected|");
-	if (ptr->SCp.phase & completed)
-		printk("completed|");
-	if (ptr->SCp.phase & spiordy)
-		printk("spiordy|");
-	if (ptr->SCp.phase & syncneg)
-		printk("syncneg|");
-	if (ptr->SCp.phase & aborted)
-		printk("aborted|");
-	if (ptr->SCp.phase & resetted)
-		printk("resetted|");
-	if( SCDATA(ptr) ) {
-		printk("; next=0x%p\n", SCNEXT(ptr));
-	} else {
-		printk("; next=(host scribble NULL)\n");
-	}
+	scsi_print_command(ptr);
+	scmd_printk(KERN_DEBUG, ptr,
+		    "request_bufflen=%d; resid=%d; "
+		    "phase |%s%s%s%s%s%s%s%s%s; next=0x%p",
+		    scsi_bufflen(ptr), scsi_get_resid(ptr),
+		    (ptr->SCp.phase & not_issued) ? "not issued|" : "",
+		    (ptr->SCp.phase & selecting) ? "selecting|" : "",
+		    (ptr->SCp.phase & identified) ? "identified|" : "",
+		    (ptr->SCp.phase & disconnected) ? "disconnected|" : "",
+		    (ptr->SCp.phase & completed) ? "completed|" : "",
+		    (ptr->SCp.phase & spiordy) ? "spiordy|" : "",
+		    (ptr->SCp.phase & syncneg) ? "syncneg|" : "",
+		    (ptr->SCp.phase & aborted) ? "aborted|" : "",
+		    (ptr->SCp.phase & resetted) ? "resetted|" : "",
+		    (SCDATA(ptr)) ? SCNEXT(ptr) : NULL);
 }
 
 /*
@@ -2972,7 +2487,6 @@ static void show_queues(struct Scsi_Host *shpnt)
 	for (ptr = DISCONNECTED_SC; ptr; ptr = SCDATA(ptr) ? SCNEXT(ptr) : NULL)
 		show_command(ptr);
 
-	disp_ports(shpnt);
 	disp_enintr(shpnt);
 }
 
@@ -3276,15 +2790,6 @@ static int aha152x_set_info(struct Scsi_Host *shpnt, char *buffer, int length)
 	if(!shpnt || !buffer || length<8 || strncmp("aha152x ", buffer, 8)!=0)
 		return -EINVAL;
 
-#if defined(AHA152X_DEBUG)
-	if(length>14 && strncmp("debug ", buffer+8, 6)==0) {
-		int debug = HOSTDATA(shpnt)->debug;
-
-		HOSTDATA(shpnt)->debug = simple_strtoul(buffer+14, NULL, 0);
-
-		printk(KERN_INFO "aha152x%d: debugging options set to 0x%04x (were 0x%04x)\n", HOSTNO, HOSTDATA(shpnt)->debug, debug);
-	} else
-#endif
 #if defined(AHA152X_STAT)
 	if(length>13 && strncmp("reset", buffer+8, 5)==0) {
 		int i;
@@ -3302,7 +2807,7 @@ static int aha152x_set_info(struct Scsi_Host *shpnt, char *buffer, int length)
 			HOSTDATA(shpnt)->time[i]=0;
 		}
 
-		printk(KERN_INFO "aha152x%d: stats reseted.\n", HOSTNO);
+		shost_printk(KERN_INFO, shpnt, "aha152x: stats reset.\n");
 
 	} else
 #endif
@@ -3343,29 +2848,6 @@ static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 					(((HOSTDATA(shpnt)->syncrate[i] & 0x70) >> 4) + 2) * 50,
 				    HOSTDATA(shpnt)->syncrate[i] & 0x0f);
 	}
-#if defined(AHA152X_DEBUG)
-#define PDEBUG(flags,txt) \
-	if(HOSTDATA(shpnt)->debug & flags) SPRINTF("(%s) ", txt);
-
-	SPRINTF("enabled debugging options: ");
-
-	PDEBUG(debug_procinfo, "procinfo");
-	PDEBUG(debug_queue, "queue");
-	PDEBUG(debug_intr, "interrupt");
-	PDEBUG(debug_selection, "selection");
-	PDEBUG(debug_msgo, "message out");
-	PDEBUG(debug_msgi, "message in");
-	PDEBUG(debug_status, "status");
-	PDEBUG(debug_cmd, "command");
-	PDEBUG(debug_datai, "data in");
-	PDEBUG(debug_datao, "data out");
-	PDEBUG(debug_eh, "eh");
-	PDEBUG(debug_locking, "locks");
-	PDEBUG(debug_phases, "phases");
-
-	SPRINTF("\n");
-#endif
-
 	SPRINTF("\nqueue status:\n");
 	DO_LOCK(flags);
 	if (ISSUE_SC) {
@@ -3393,8 +2875,8 @@ static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 
 #if defined(AHA152X_STAT)
 	SPRINTF("statistics:\n"
-	        "total commands:               %d\n"
-	        "disconnections:               %d\n"
+		"total commands:               %d\n"
+		"disconnections:               %d\n"
 		"busfree with check condition: %d\n"
 		"busfree without old command:  %d\n"
 		"busfree without new command:  %d\n"
@@ -3413,7 +2895,7 @@ static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 		HOSTDATA(shpnt)->busfree_without_any_action);
 	for(i=0; i<maxstate; i++) {
 		SPRINTF("%-10s %-12d %-12d %-12ld\n",
-		        states[i].name,
+			states[i].name,
 			HOSTDATA(shpnt)->count_trans[i],
 			HOSTDATA(shpnt)->count[i],
 			HOSTDATA(shpnt)->time[i]);
@@ -3671,25 +3153,19 @@ static int __init aha152x_init(void)
 			setup[setup_count].synchronous = aha152x[5];
 			setup[setup_count].delay       = aha152x[6];
 			setup[setup_count].ext_trans   = aha152x[7];
-#if defined(AHA152X_DEBUG)
-			setup[setup_count].debug       = aha152x[8];
-#endif
-	  	} else if(io[0]!=0 || irq[0]!=0) {
+		} else if (io[0] != 0 || irq[0] != 0) {
 			if(io[0]!=0)  setup[setup_count].io_port = io[0];
 			if(irq[0]!=0) setup[setup_count].irq     = irq[0];
 
-	    		setup[setup_count].scsiid      = scsiid[0];
-	    		setup[setup_count].reconnect   = reconnect[0];
-	    		setup[setup_count].parity      = parity[0];
-	    		setup[setup_count].synchronous = sync[0];
-	    		setup[setup_count].delay       = delay[0];
-	    		setup[setup_count].ext_trans   = exttrans[0];
-#if defined(AHA152X_DEBUG)
-			setup[setup_count].debug       = debug[0];
-#endif
+			setup[setup_count].scsiid      = scsiid[0];
+			setup[setup_count].reconnect   = reconnect[0];
+			setup[setup_count].parity      = parity[0];
+			setup[setup_count].synchronous = sync[0];
+			setup[setup_count].delay       = delay[0];
+			setup[setup_count].ext_trans   = exttrans[0];
 		}
 
-          	if (checksetup(&setup[setup_count]))
+		if (checksetup(&setup[setup_count]))
 			setup_count++;
 		else
 			printk(KERN_ERR "aha152x: invalid module params io=0x%x, irq=%d,scsiid=%d,reconnect=%d,parity=%d,sync=%d,delay=%d,exttrans=%d\n",
@@ -3714,22 +3190,16 @@ static int __init aha152x_init(void)
 			setup[setup_count].synchronous = aha152x1[5];
 			setup[setup_count].delay       = aha152x1[6];
 			setup[setup_count].ext_trans   = aha152x1[7];
-#if defined(AHA152X_DEBUG)
-			setup[setup_count].debug       = aha152x1[8];
-#endif
-	  	} else if(io[1]!=0 || irq[1]!=0) {
+		} else if (io[1] != 0 || irq[1] != 0) {
 			if(io[1]!=0)  setup[setup_count].io_port = io[1];
 			if(irq[1]!=0) setup[setup_count].irq     = irq[1];
 
-	    		setup[setup_count].scsiid      = scsiid[1];
-	    		setup[setup_count].reconnect   = reconnect[1];
-	    		setup[setup_count].parity      = parity[1];
-	    		setup[setup_count].synchronous = sync[1];
-	    		setup[setup_count].delay       = delay[1];
-	    		setup[setup_count].ext_trans   = exttrans[1];
-#if defined(AHA152X_DEBUG)
-			setup[setup_count].debug       = debug[1];
-#endif
+			setup[setup_count].scsiid      = scsiid[1];
+			setup[setup_count].reconnect   = reconnect[1];
+			setup[setup_count].parity      = parity[1];
+			setup[setup_count].synchronous = sync[1];
+			setup[setup_count].delay       = delay[1];
+			setup[setup_count].ext_trans   = exttrans[1];
 		}
 		if (checksetup(&setup[setup_count]))
 			setup_count++;
@@ -3776,9 +3246,6 @@ static int __init aha152x_init(void)
 			setup[setup_count].synchronous = 1;
 			setup[setup_count].delay       = DELAY_DEFAULT;
 			setup[setup_count].ext_trans   = 0;
-#if defined(AHA152X_DEBUG)
-			setup[setup_count].debug       = DEBUG_DEFAULT;
-#endif
 #if defined(__ISAPNP__)
 			pnpdev[setup_count]            = dev;
 #endif
@@ -3847,9 +3314,6 @@ static int __init aha152x_init(void)
 			setup[setup_count].synchronous = conf.cf_syncneg;
 			setup[setup_count].delay = DELAY_DEFAULT;
 			setup[setup_count].ext_trans = 0;
-#if defined(AHA152X_DEBUG)
-			setup[setup_count].debug = DEBUG_DEFAULT;
-#endif
 			setup_count++;
 
 		}
@@ -3903,11 +3367,8 @@ module_exit(aha152x_exit);
 #if !defined(MODULE)
 static int __init aha152x_setup(char *str)
 {
-#if defined(AHA152X_DEBUG)
-	int ints[11];
-#else
 	int ints[10];
-#endif
+
 	get_options(str, ARRAY_SIZE(ints), ints);
 
 	if(setup_count>=ARRAY_SIZE(setup)) {
@@ -3924,16 +3385,9 @@ static int __init aha152x_setup(char *str)
 	setup[setup_count].synchronous = ints[0] >= 6 ? ints[6] : 1;
 	setup[setup_count].delay       = ints[0] >= 7 ? ints[7] : DELAY_DEFAULT;
 	setup[setup_count].ext_trans   = ints[0] >= 8 ? ints[8] : 0;
-#if defined(AHA152X_DEBUG)
-	setup[setup_count].debug       = ints[0] >= 9 ? ints[9] : DEBUG_DEFAULT;
-	if (ints[0] > 9) {
-		printk(KERN_NOTICE "aha152x: usage: aha152x=<IOBASE>[,<IRQ>[,<SCSI ID>"
-		       "[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY>[,<EXT_TRANS>[,<DEBUG>]]]]]]]]\n");
-#else
 	if (ints[0] > 8) {                                                /*}*/
 		printk(KERN_NOTICE "aha152x: usage: aha152x=<IOBASE>[,<IRQ>[,<SCSI ID>"
 		       "[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY>[,<EXT_TRANS>]]]]]]]\n");
-#endif
 	} else {
 		setup_count++;
 		return 0;
-- 
1.8.5.2

