From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 55/72] ncr5380: Remove LIST and REMOVE macros
Date: Sun, 06 Dec 2015 12:32:21 +1100
Message-ID: <20151206013140.615500788@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-LIST-and-REMOVE-macros
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Printing command pointers can be useful when debugging queues. Other than
that, the LIST and REMOVE macros are just clutter. These macros are
redundant now that NDEBUG_QUEUES causes pointers to be printed, so remove
them.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   19 -------------------
 drivers/scsi/atari_NCR5380.c |   32 --------------------------------
 2 files changed, 51 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:30:54.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:30:56.000000000 +1100
@@ -80,14 +80,6 @@
  *      tagged queueing)
  */
 
-#if (NDEBUG & NDEBUG_LISTS)
-#define LIST(x,y) {printk("LINE:%d   Adding %p to %p\n", __LINE__, (void*)(x), (void*)(y)); if ((x)==(y)) udelay(5); }
-#define REMOVE(w,x,y,z) {printk("LINE:%d   Removing: %p->%p  %p->%p \n", __LINE__, (void*)(w), (void*)(x), (void*)(y), (void*)(z)); if ((x)==(y)) udelay(5); }
-#else
-#define LIST(x,y)
-#define REMOVE(w,x,y,z)
-#endif
-
 #ifndef notyet
 #undef REAL_DMA
 #endif
@@ -773,12 +765,10 @@ static int NCR5380_queue_command(struct
 	 */
 
 	if (!(hostdata->issue_queue) || (cmd->cmnd[0] == REQUEST_SENSE)) {
-		LIST(cmd, hostdata->issue_queue);
 		cmd->host_scribble = (unsigned char *) hostdata->issue_queue;
 		hostdata->issue_queue = cmd;
 	} else {
 		for (tmp = (struct scsi_cmnd *) hostdata->issue_queue; tmp->host_scribble; tmp = (struct scsi_cmnd *) tmp->host_scribble);
-		LIST(cmd, tmp);
 		tmp->host_scribble = (unsigned char *) cmd;
 	}
 	spin_unlock_irqrestore(&hostdata->lock, flags);
@@ -830,10 +820,8 @@ static void NCR5380_main(struct work_str
 				if (!(hostdata->busy[tmp->device->id] &
 				      (1 << (u8)(tmp->device->lun & 0xff)))) {
 					if (prev) {
-						REMOVE(prev, prev->host_scribble, tmp, tmp->host_scribble);
 						prev->host_scribble = tmp->host_scribble;
 					} else {
-						REMOVE(-1, hostdata->issue_queue, tmp, tmp->host_scribble);
 						hostdata->issue_queue = (struct scsi_cmnd *) tmp->host_scribble;
 					}
 					tmp->host_scribble = NULL;
@@ -858,7 +846,6 @@ static void NCR5380_main(struct work_str
 						/* OK or bad target */
 					} else {
 						/* Need to retry */
-						LIST(tmp, hostdata->issue_queue);
 						tmp->host_scribble = (unsigned char *) hostdata->issue_queue;
 						hostdata->issue_queue = tmp;
 						dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
@@ -1883,7 +1870,6 @@ static void NCR5380_information_transfer
 					if ((cmd->cmnd[0] != REQUEST_SENSE) && (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
-						LIST(cmd, hostdata->issue_queue);
 						cmd->host_scribble = (unsigned char *)
 						    hostdata->issue_queue;
 						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
@@ -1920,7 +1906,6 @@ static void NCR5380_information_transfer
 				case DISCONNECT:{
 						/* Accept message by clearing ACK */
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-						LIST(cmd, hostdata->disconnected_queue);
 						cmd->host_scribble = (unsigned char *)
 						    hostdata->disconnected_queue;
 						hostdata->connected = NULL;
@@ -2170,10 +2155,8 @@ static void NCR5380_reselect(struct Scsi
 	     tmp; prev = tmp, tmp = (struct scsi_cmnd *) tmp->host_scribble) {
 		if ((target_mask == (1 << tmp->device->id)) && (lun == (u8)tmp->device->lun)) {
 			if (prev) {
-				REMOVE(prev, prev->host_scribble, tmp, tmp->host_scribble);
 				prev->host_scribble = tmp->host_scribble;
 			} else {
-				REMOVE(-1, hostdata->disconnected_queue, tmp, tmp->host_scribble);
 				hostdata->disconnected_queue =
 					(struct scsi_cmnd *) tmp->host_scribble;
 			}
@@ -2324,7 +2307,6 @@ static int NCR5380_abort(struct scsi_cmn
 	dprintk(NDEBUG_ABORT, "scsi%d : abort going into loop.\n", instance->host_no);
 	for (prev = (struct scsi_cmnd **) &(hostdata->issue_queue), tmp = (struct scsi_cmnd *) hostdata->issue_queue; tmp; prev = (struct scsi_cmnd **) &(tmp->host_scribble), tmp = (struct scsi_cmnd *) tmp->host_scribble)
 		if (cmd == tmp) {
-			REMOVE(5, *prev, tmp, tmp->host_scribble);
 			(*prev) = (struct scsi_cmnd *) tmp->host_scribble;
 			tmp->host_scribble = NULL;
 			spin_unlock_irqrestore(&hostdata->lock, flags);
@@ -2394,7 +2376,6 @@ static int NCR5380_abort(struct scsi_cmn
 
 			for (prev = (struct scsi_cmnd **) &(hostdata->disconnected_queue), tmp = (struct scsi_cmnd *) hostdata->disconnected_queue; tmp; prev = (struct scsi_cmnd **) &(tmp->host_scribble), tmp = (struct scsi_cmnd *) tmp->host_scribble)
 				if (cmd == tmp) {
-					REMOVE(5, *prev, tmp, tmp->host_scribble);
 					*prev = (struct scsi_cmnd *) tmp->host_scribble;
 					tmp->host_scribble = NULL;
 					spin_unlock_irqrestore(&hostdata->lock, flags);
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:54.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:56.000000000 +1100
@@ -68,27 +68,6 @@
 
 /* Adapted for the sun3 by Sam Creasey. */
 
-#if (NDEBUG & NDEBUG_LISTS)
-#define LIST(x, y)						\
-	do {							\
-		printk("LINE:%d   Adding %p to %p\n",		\
-		       __LINE__, (void*)(x), (void*)(y));	\
-		if ((x) == (y))					\
-			udelay(5);				\
-	} while (0)
-#define REMOVE(w, x, y, z)					\
-	do {							\
-		printk("LINE:%d   Removing: %p->%p  %p->%p \n",	\
-		       __LINE__, (void*)(w), (void*)(x),	\
-		       (void*)(y), (void*)(z));			\
-		if ((x) == (y))					\
-			udelay(5);				\
-	} while (0)
-#else
-#define LIST(x,y)
-#define REMOVE(w,x,y,z)
-#endif
-
 /*
  * Design
  *
@@ -851,14 +830,12 @@ static int NCR5380_queue_command(struct
 	 */
 
 	if (!(hostdata->issue_queue) || (cmd->cmnd[0] == REQUEST_SENSE)) {
-		LIST(cmd, hostdata->issue_queue);
 		SET_NEXT(cmd, hostdata->issue_queue);
 		hostdata->issue_queue = cmd;
 	} else {
 		for (tmp = (struct scsi_cmnd *)hostdata->issue_queue;
 		     NEXT(tmp); tmp = NEXT(tmp))
 			;
-		LIST(cmd, tmp);
 		SET_NEXT(tmp, cmd);
 	}
 	spin_unlock_irqrestore(&hostdata->lock, flags);
@@ -942,10 +919,8 @@ static void NCR5380_main(struct work_str
 #endif
 				    ) {
 					if (prev) {
-						REMOVE(prev, NEXT(prev), tmp, NEXT(tmp));
 						SET_NEXT(prev, NEXT(tmp));
 					} else {
-						REMOVE(-1, hostdata->issue_queue, tmp, NEXT(tmp));
 						hostdata->issue_queue = NEXT(tmp);
 					}
 					SET_NEXT(tmp, NULL);
@@ -980,7 +955,6 @@ static void NCR5380_main(struct work_str
 						maybe_release_dma_irq(instance);
 					} else {
 						/* Need to retry */
-						LIST(tmp, hostdata->issue_queue);
 						SET_NEXT(tmp, hostdata->issue_queue);
 						hostdata->issue_queue = tmp;
 						dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES,
@@ -2063,7 +2037,6 @@ static void NCR5380_information_transfer
 					    (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
-						LIST(cmd,hostdata->issue_queue);
 						SET_NEXT(cmd, hostdata->issue_queue);
 						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
 						dsprintk(NDEBUG_AUTOSENSE | NDEBUG_QUEUES,
@@ -2114,7 +2087,6 @@ static void NCR5380_information_transfer
 				case DISCONNECT:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					LIST(cmd,hostdata->disconnected_queue);
 					SET_NEXT(cmd, hostdata->disconnected_queue);
 					hostdata->connected = NULL;
 					hostdata->disconnected_queue = cmd;
@@ -2410,10 +2382,8 @@ static void NCR5380_reselect(struct Scsi
 #endif
 		    ) {
 			if (prev) {
-				REMOVE(prev, NEXT(prev), tmp, NEXT(tmp));
 				SET_NEXT(prev, NEXT(tmp));
 			} else {
-				REMOVE(-1, hostdata->disconnected_queue, tmp, NEXT(tmp));
 				hostdata->disconnected_queue = NEXT(tmp);
 			}
 			SET_NEXT(tmp, NULL);
@@ -2583,7 +2553,6 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 	     tmp = (struct scsi_cmnd *)hostdata->issue_queue;
 	     tmp; prev = NEXTADDR(tmp), tmp = NEXT(tmp)) {
 		if (cmd == tmp) {
-			REMOVE(5, *prev, tmp, NEXT(tmp));
 			(*prev) = NEXT(tmp);
 			SET_NEXT(tmp, NULL);
 			tmp->result = DID_ABORT << 16;
@@ -2657,7 +2626,6 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 			     tmp = (struct scsi_cmnd *)hostdata->disconnected_queue;
 			     tmp; prev = NEXTADDR(tmp), tmp = NEXT(tmp)) {
 				if (cmd == tmp) {
-					REMOVE(5, *prev, tmp, NEXT(tmp));
 					*prev = NEXT(tmp);
 					SET_NEXT(tmp, NULL);
 					tmp->result = DID_ABORT << 16;
