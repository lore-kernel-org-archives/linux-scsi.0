From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 26/33][SCSI] NCR53C9x: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:05:02 +0100 (MET)
Message-ID: <20080106030502.30002.83258.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:54017 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbYAFDFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:05:15 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.
Cleaned up checkpatch.pl-errors (so no '> 80 lines'-warning).


diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 5b0efc9..edf81e3 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -278,7 +278,7 @@ static char *phase_string(int phase)
 }
 
 #ifdef DEBUG_STATE_MACHINE
-static inline void esp_advance_phase(Scsi_Cmnd *s, int newphase)
+static inline void esp_advance_phase(struct scsi_cmnd *s, int newphase)
 {
 	ESPLOG(("<%s>", phase_string(newphase)));
 	s->SCp.sent_command = s->SCp.phase;
@@ -323,49 +323,49 @@ static inline void esp_cmd(struct NCR_ESP *esp, struct ESP_regs *eregs,
  * Note that these are per-ESP queues, not global queues like
  * the aha152x driver uses.
  */
-static inline void append_SC(Scsi_Cmnd **SC, Scsi_Cmnd *new_SC)
+static inline void append_SC(struct scsi_cmnd **SC, struct scsi_cmnd *new_SC)
 {
-	Scsi_Cmnd *end;
+	struct scsi_cmnd *end;
 
 	new_SC->host_scribble = (unsigned char *) NULL;
 	if(!*SC)
 		*SC = new_SC;
 	else {
-		for(end=*SC;end->host_scribble;end=(Scsi_Cmnd *)end->host_scribble)
+		for (end = *SC; end->host_scribble; end = (struct scsi_cmnd *)end->host_scribble)
 			;
 		end->host_scribble = (unsigned char *) new_SC;
 	}
 }
 
-static inline void prepend_SC(Scsi_Cmnd **SC, Scsi_Cmnd *new_SC)
+static inline void prepend_SC(struct scsi_cmnd **SC, struct scsi_cmnd *new_SC)
 {
 	new_SC->host_scribble = (unsigned char *) *SC;
 	*SC = new_SC;
 }
 
-static inline Scsi_Cmnd *remove_first_SC(Scsi_Cmnd **SC)
+static inline struct scsi_cmnd *remove_first_SC(struct scsi_cmnd **SC)
 {
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 
 	ptr = *SC;
 	if(ptr)
-		*SC = (Scsi_Cmnd *) (*SC)->host_scribble;
+		*SC = (struct scsi_cmnd *) (*SC)->host_scribble;
 	return ptr;
 }
 
-static inline Scsi_Cmnd *remove_SC(Scsi_Cmnd **SC, int target, int lun)
+static inline struct scsi_cmnd *remove_SC(struct scsi_cmnd **SC, int target, int lun)
 {
-	Scsi_Cmnd *ptr, *prev;
+	struct scsi_cmnd *ptr, *prev;
 
 	for(ptr = *SC, prev = NULL;
 	    ptr && ((ptr->device->id != target) || (ptr->device->lun != lun));
-	    prev = ptr, ptr = (Scsi_Cmnd *) ptr->host_scribble)
+	    prev = ptr, ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		;
 	if(ptr) {
 		if(prev)
 			prev->host_scribble=ptr->host_scribble;
 		else
-			*SC=(Scsi_Cmnd *)ptr->host_scribble;
+			*SC = (struct scsi_cmnd *)ptr->host_scribble;
 	}
 	return ptr;
 }
@@ -908,7 +908,7 @@ int esp_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t off
 }
 EXPORT_SYMBOL(esp_proc_info);
 
-static void esp_get_dmabufs(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static void esp_get_dmabufs(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 	if(sp->use_sg == 0) {
 		sp->SCp.this_residual = sp->request_bufflen;
@@ -931,7 +931,7 @@ static void esp_get_dmabufs(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 	}
 }
 
-static void esp_release_dmabufs(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static void esp_release_dmabufs(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 	if(sp->use_sg == 0) {
 		if (esp->dma_mmu_release_scsi_one)
@@ -942,7 +942,7 @@ static void esp_release_dmabufs(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 	}
 }
 
-static void esp_restore_pointers(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static void esp_restore_pointers(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 	struct esp_pointers *ep = &esp->data_pointers[scmd_id(sp)];
 
@@ -952,7 +952,7 @@ static void esp_restore_pointers(struct NCR_ESP *esp, Scsi_Cmnd *sp)
 	sp->SCp.buffers_residual = ep->saved_buffers_residual;
 }
 
-static void esp_save_pointers(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static void esp_save_pointers(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 	struct esp_pointers *ep = &esp->data_pointers[scmd_id(sp)];
 
@@ -982,7 +982,7 @@ static void esp_save_pointers(struct NCR_ESP *esp, Scsi_Cmnd *sp)
  * case where we could see an interrupt is where we have disconnected
  * commands active and they are trying to reselect us.
  */
-static inline void esp_check_cmd(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static inline void esp_check_cmd(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 	switch(sp->cmd_len) {
 	case 6:
@@ -1013,7 +1013,7 @@ static void esp_exec_cmd(struct NCR_ESP *esp)
 {
 	struct ESP_regs *eregs = esp->eregs;
 	struct esp_device *esp_dev;
-	Scsi_Cmnd *SCptr;
+	struct scsi_cmnd *SCptr;
 	struct scsi_device *SDptr;
 	volatile unchar *cmdp = esp->esp_command;
 	unsigned char the_esp_command;
@@ -1239,7 +1239,7 @@ do_sync_known:
 }
 
 /* Queue a SCSI command delivered from the mid-level Linux SCSI code. */
-int esp_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+int esp_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	struct NCR_ESP *esp;
 
@@ -1280,7 +1280,7 @@ int esp_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 }
 
 /* Dump driver state. */
-static void esp_dump_cmd(Scsi_Cmnd *SCptr)
+static void esp_dump_cmd(struct scsi_cmnd *SCptr)
 {
 	ESPLOG(("[tgt<%02x> lun<%02x> "
 		"pphase<%s> cphase<%s>]",
@@ -1292,7 +1292,7 @@ static void esp_dump_cmd(Scsi_Cmnd *SCptr)
 static void esp_dump_state(struct NCR_ESP *esp, 
 			   struct ESP_regs *eregs)
 {
-	Scsi_Cmnd *SCptr = esp->current_SC;
+	struct scsi_cmnd *SCptr = esp->current_SC;
 #ifdef DEBUG_ESP_CMDS
 	int i;
 #endif
@@ -1337,13 +1337,13 @@ static void esp_dump_state(struct NCR_ESP *esp,
 	ESPLOG(("esp%d: disconnected ", esp->esp_id));
 	while(SCptr) {
 		esp_dump_cmd(SCptr);
-		SCptr = (Scsi_Cmnd *) SCptr->host_scribble;
+		SCptr = (struct scsi_cmnd *) SCptr->host_scribble;
 	}
 	ESPLOG(("\n"));
 }
 
 /* Abort a command.  The host_lock is acquired by caller. */
-int esp_abort(Scsi_Cmnd *SCptr)
+int esp_abort(struct scsi_cmnd *SCptr)
 {
 	struct NCR_ESP *esp = (struct NCR_ESP *) SCptr->device->host->hostdata;
 	struct ESP_regs *eregs = esp->eregs;
@@ -1375,13 +1375,13 @@ int esp_abort(Scsi_Cmnd *SCptr)
 		synchronize_irq(esp->irq);
 	}
 	if(esp->issue_SC) {
-		Scsi_Cmnd **prev, *this;
+		struct scsi_cmnd **prev, *this;
 		for(prev = (&esp->issue_SC), this = esp->issue_SC;
 		    this;
-		    prev = (Scsi_Cmnd **) &(this->host_scribble),
-		    this = (Scsi_Cmnd *) this->host_scribble) {
+		    prev = (struct scsi_cmnd **) &(this->host_scribble),
+		    this = (struct scsi_cmnd *) this->host_scribble) {
 			if(this == SCptr) {
-				*prev = (Scsi_Cmnd *) this->host_scribble;
+				*prev = (struct scsi_cmnd *) this->host_scribble;
 				this->host_scribble = NULL;
 				esp_release_dmabufs(esp, this);
 				this->result = DID_ABORT << 16;
@@ -1424,7 +1424,7 @@ int esp_abort(Scsi_Cmnd *SCptr)
 static int esp_finish_reset(struct NCR_ESP *esp,
 			    struct ESP_regs *eregs)
 {
-	Scsi_Cmnd *sp = esp->current_SC;
+	struct scsi_cmnd *sp = esp->current_SC;
 
 	/* Clean up currently executing command, if any. */
 	if (sp != NULL) {
@@ -1471,7 +1471,7 @@ static int esp_do_resetbus(struct NCR_ESP *esp,
  *
  * The host_lock is acquired by caller.
  */
-int esp_reset(Scsi_Cmnd *SCptr)
+int esp_reset(struct scsi_cmnd *SCptr)
 {
 	struct NCR_ESP *esp = (struct NCR_ESP *) SCptr->device->host->hostdata;
 
@@ -1487,7 +1487,7 @@ int esp_reset(Scsi_Cmnd *SCptr)
 /* Internal ESP done function. */
 static void esp_done(struct NCR_ESP *esp, int error)
 {
-	Scsi_Cmnd *done_SC;
+	struct scsi_cmnd *done_SC;
 
 	if(esp->current_SC) {
 		done_SC = esp->current_SC;
@@ -1528,7 +1528,7 @@ static int esp_do_cmdbegin(struct NCR_ESP *esp, struct ESP_regs *eregs);
  * has gotten far enough yet.  Hence the following.
  */
 static inline int skipahead1(struct NCR_ESP *esp, struct ESP_regs *eregs,
-			     Scsi_Cmnd *scp, int prev_phase, int new_phase)
+			     struct scsi_cmnd *scp, int prev_phase, int new_phase)
 {
 	if(scp->SCp.sent_command != prev_phase)
 		return 0;
@@ -1549,7 +1549,7 @@ static inline int skipahead1(struct NCR_ESP *esp, struct ESP_regs *eregs,
 
 static inline int skipahead2(struct NCR_ESP *esp,
 			     struct ESP_regs *eregs,
-			     Scsi_Cmnd *scp, int prev_phase1, int prev_phase2,
+			     struct scsi_cmnd *scp, int prev_phase1, int prev_phase2,
 			     int new_phase)
 {
 	if(scp->SCp.sent_command != prev_phase1 &&
@@ -1604,7 +1604,7 @@ static inline int skipahead2(struct NCR_ESP *esp,
  * to the next phase.
  */
 static inline int esp100_sync_hwbug(struct NCR_ESP *esp, struct ESP_regs *eregs,
-				    Scsi_Cmnd *sp, int fifocnt)
+				    struct scsi_cmnd *sp, int fifocnt)
 {
 	/* Do not touch this piece of code. */
 	if((!(esp->erev == esp100)) ||
@@ -1693,7 +1693,7 @@ static inline int reconnect_lun(struct NCR_ESP *esp, struct ESP_regs *eregs)
  * is being continued due to reselection.
  */
 static inline void esp_connect(struct NCR_ESP *esp, struct ESP_regs *eregs,
-			       Scsi_Cmnd *sp)
+			       struct scsi_cmnd *sp)
 {
 	struct scsi_device *dp = sp->device;
 	struct esp_device *esp_dev = dp->hostdata;
@@ -1717,7 +1717,7 @@ static inline void esp_connect(struct NCR_ESP *esp, struct ESP_regs *eregs,
 /* This will place the current working command back into the issue queue
  * if we are to receive a reselection amidst a selection attempt.
  */
-static inline void esp_reconnect(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static inline void esp_reconnect(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 	if(!esp->disconnected_SC)
 		ESPLOG(("esp%d: Weird, being reselected but disconnected "
@@ -1740,7 +1740,7 @@ static int esp_do_msgin(struct NCR_ESP *esp, struct ESP_regs *eregs)
 	return do_work_bus;
 }
 
-static inline void advance_sg(struct NCR_ESP *esp, Scsi_Cmnd *sp)
+static inline void advance_sg(struct NCR_ESP *esp, struct scsi_cmnd *sp)
 {
 	++sp->SCp.buffer;
 	--sp->SCp.buffers_residual;
@@ -1772,7 +1772,7 @@ static inline void advance_sg(struct NCR_ESP *esp, Scsi_Cmnd *sp)
  */
 static int esp_do_data(struct NCR_ESP *esp, struct ESP_regs *eregs)
 {
-	Scsi_Cmnd *SCptr = esp->current_SC;
+	struct scsi_cmnd *SCptr = esp->current_SC;
 	int thisphase, hmuch;
 
 	ESPDATA(("esp_do_data: "));
@@ -1985,7 +1985,7 @@ static int esp_do_data(struct NCR_ESP *esp, struct ESP_regs *eregs)
 static int esp_do_data_finale(struct NCR_ESP *esp,
 			      struct ESP_regs *eregs)
 {
-	Scsi_Cmnd *SCptr = esp->current_SC;
+	struct scsi_cmnd *SCptr = esp->current_SC;
 	struct esp_device *esp_dev = SCptr->device->hostdata;
 	int bogus_data = 0, bytes_sent = 0, fifocnt, ecount = 0;
 
@@ -2159,7 +2159,7 @@ static int esp_do_data_finale(struct NCR_ESP *esp,
  * a tape, we don't want to go into a loop re-negotiating
  * synchronous capabilities over and over.
  */
-static int esp_should_clear_sync(Scsi_Cmnd *sp)
+static int esp_should_clear_sync(struct scsi_cmnd *sp)
 {
 	unchar cmd = sp->cmnd[0];
 
@@ -2187,7 +2187,7 @@ static int esp_should_clear_sync(Scsi_Cmnd *sp)
  */
 static int esp_do_freebus(struct NCR_ESP *esp, struct ESP_regs *eregs)
 {
-	Scsi_Cmnd *SCptr = esp->current_SC;
+	struct scsi_cmnd *SCptr = esp->current_SC;
 	int rval;
 
 	rval = skipahead2(esp, eregs, SCptr, in_status, in_msgindone, in_freeing);
@@ -2258,7 +2258,7 @@ static int esp_do_freebus(struct NCR_ESP *esp, struct ESP_regs *eregs)
  */
 static int esp_bad_reconnect(struct NCR_ESP *esp)
 {
-	Scsi_Cmnd *sp;
+	struct scsi_cmnd *sp;
 
 	ESPLOG(("esp%d: Eieeee, reconnecting unknown command!\n",
 		esp->esp_id));
@@ -2267,21 +2267,21 @@ static int esp_bad_reconnect(struct NCR_ESP *esp)
 	ESPLOG(("esp%d: issue_SC[", esp->esp_id));
 	while(sp) {
 		ESPLOG(("<%02x,%02x>", sp->device->id, sp->device->lun));
-		sp = (Scsi_Cmnd *) sp->host_scribble;
+		sp = (struct scsi_cmnd *) sp->host_scribble;
 	}
 	ESPLOG(("]\n"));
 	sp = esp->current_SC;
 	ESPLOG(("esp%d: current_SC[", esp->esp_id));
 	while(sp) {
 		ESPLOG(("<%02x,%02x>", sp->device->id, sp->device->lun));
-		sp = (Scsi_Cmnd *) sp->host_scribble;
+		sp = (struct scsi_cmnd *) sp->host_scribble;
 	}
 	ESPLOG(("]\n"));
 	sp = esp->disconnected_SC;
 	ESPLOG(("esp%d: disconnected_SC[", esp->esp_id));
 	while(sp) {
 		ESPLOG(("<%02x,%02x>", sp->device->id, sp->device->lun));
-		sp = (Scsi_Cmnd *) sp->host_scribble;
+		sp = (struct scsi_cmnd *) sp->host_scribble;
 	}
 	ESPLOG(("]\n"));
 	return do_reset_bus;
@@ -2292,7 +2292,7 @@ static int esp_do_reconnect(struct NCR_ESP *esp,
 			    struct ESP_regs *eregs)
 {
 	int lun, target;
-	Scsi_Cmnd *SCptr;
+	struct scsi_cmnd *SCptr;
 
 	/* Check for all bogus conditions first. */
 	target = reconnect_target(esp, eregs);
@@ -2334,7 +2334,7 @@ static int esp_do_reconnect(struct NCR_ESP *esp,
  */
 static int esp_do_status(struct NCR_ESP *esp, struct ESP_regs *eregs)
 {
-	Scsi_Cmnd *SCptr = esp->current_SC;
+	struct scsi_cmnd *SCptr = esp->current_SC;
 	int intr, rval;
 
 	rval = skipahead1(esp, eregs, SCptr, in_the_dark, in_status);
@@ -2475,7 +2475,7 @@ static int esp_enter_status(struct NCR_ESP *esp,
 static int esp_disconnect_amidst_phases(struct NCR_ESP *esp,
 					struct ESP_regs *eregs)
 {
-	Scsi_Cmnd *sp = esp->current_SC;
+	struct scsi_cmnd *sp = esp->current_SC;
 	struct esp_device *esp_dev = sp->device->hostdata;
 
 	/* This means real problems if we see this
@@ -2574,7 +2574,7 @@ static int esp_do_phase_determine(struct NCR_ESP *esp,
 /* First interrupt after exec'ing a cmd comes here. */
 static int esp_select_complete(struct NCR_ESP *esp, struct ESP_regs *eregs)
 {
-	Scsi_Cmnd *SCptr = esp->current_SC;
+	struct scsi_cmnd *SCptr = esp->current_SC;
 	struct esp_device *esp_dev = SCptr->device->hostdata;
 	int cmd_bytes_sent, fcnt;
 
@@ -2928,7 +2928,7 @@ static int check_singlebyte_msg(struct NCR_ESP *esp,
  * this because so many initiators cannot cope with this occurring.
  */
 static int target_with_ants_in_pants(struct NCR_ESP *esp,
-				     Scsi_Cmnd *SCptr,
+				     struct scsi_cmnd *SCptr,
 				     struct esp_device *esp_dev)
 {
 	if(esp_dev->sync || SCptr->device->borken) {
@@ -2983,7 +2983,7 @@ static void sync_report(struct NCR_ESP *esp)
 static int check_multibyte_msg(struct NCR_ESP *esp,
 			       struct ESP_regs *eregs)
 {
-	Scsi_Cmnd *SCptr = esp->current_SC;
+	struct scsi_cmnd *SCptr = esp->current_SC;
 	struct esp_device *esp_dev = SCptr->device->hostdata;
 	unchar regval = 0;
 	int message_out = 0;
@@ -3121,7 +3121,7 @@ static int check_multibyte_msg(struct NCR_ESP *esp,
 
 static int esp_do_msgindone(struct NCR_ESP *esp, struct ESP_regs *eregs)
 {
-	Scsi_Cmnd *SCptr = esp->current_SC;
+	struct scsi_cmnd *SCptr = esp->current_SC;
 	int message_out = 0, it = 0, rval;
 
 	rval = skipahead1(esp, eregs, SCptr, in_msgin, in_msgindone);
@@ -3196,7 +3196,7 @@ static int esp_do_msgindone(struct NCR_ESP *esp, struct ESP_regs *eregs)
 static int esp_do_cmdbegin(struct NCR_ESP *esp, struct ESP_regs *eregs)
 {
 	unsigned char tmp;
-	Scsi_Cmnd *SCptr = esp->current_SC;
+	struct scsi_cmnd *SCptr = esp->current_SC;
 
 	esp_advance_phase(SCptr, in_cmdend);
 	esp_cmd(esp, eregs, ESP_CMD_FLUSH);
@@ -3368,7 +3368,7 @@ static espfunc_t bus_vector[] = {
 /* This is the second tier in our dual-level SCSI state machine. */
 static int esp_work_bus(struct NCR_ESP *esp, struct ESP_regs *eregs)
 {
-	Scsi_Cmnd *SCptr = esp->current_SC;
+	struct scsi_cmnd *SCptr = esp->current_SC;
 	unsigned int phase;
 
 	ESPBUS(("esp_work_bus: "));
@@ -3397,7 +3397,7 @@ static espfunc_t isvc_vector[] = {
 void esp_handle(struct NCR_ESP *esp)
 {
 	struct ESP_regs *eregs;
-	Scsi_Cmnd *SCptr;
+	struct scsi_cmnd *SCptr;
 	int what_next = do_intr_end;
 	eregs = esp->eregs;
 	SCptr = esp->current_SC;
diff --git a/drivers/scsi/NCR53C9x.h b/drivers/scsi/NCR53C9x.h
index d85cb73..5a38f7f 100644
--- a/drivers/scsi/NCR53C9x.h
+++ b/drivers/scsi/NCR53C9x.h
@@ -392,9 +392,9 @@ struct NCR_ESP {
   int slot;                               /* Slot the adapter occupies */
 
   /* Our command queues, only one cmd lives in the current_SC queue. */
-  Scsi_Cmnd *issue_SC;           /* Commands to be issued */
-  Scsi_Cmnd *current_SC;         /* Who is currently working the bus */
-  Scsi_Cmnd *disconnected_SC;    /* Commands disconnected from the bus */
+  struct scsi_cmnd *issue_SC;           /* Commands to be issued */
+  struct scsi_cmnd *current_SC;         /* Who is currently working the bus */
+  struct scsi_cmnd *disconnected_SC;    /* Commands disconnected from the bus */
 
   /* Message goo */
   unchar cur_msgout[16];
@@ -418,7 +418,7 @@ struct NCR_ESP {
    */ 
   /* Required functions */
   int  (*dma_bytes_sent)(struct NCR_ESP *, int);
-  int  (*dma_can_transfer)(struct NCR_ESP *, Scsi_Cmnd *);
+  int  (*dma_can_transfer)(struct NCR_ESP *, struct scsi_cmnd *);
   void (*dma_dump_state)(struct NCR_ESP *);
   void (*dma_init_read)(struct NCR_ESP *, __u32, int);
   void (*dma_init_write)(struct NCR_ESP *, __u32, int);
@@ -440,11 +440,11 @@ struct NCR_ESP {
   void (*dma_reset)(struct NCR_ESP *);
     
   /* Optional virtual DMA functions */
-  void (*dma_mmu_get_scsi_one)(struct NCR_ESP *, Scsi_Cmnd *);
-  void (*dma_mmu_get_scsi_sgl)(struct NCR_ESP *, Scsi_Cmnd *);
-  void (*dma_mmu_release_scsi_one)(struct NCR_ESP *, Scsi_Cmnd *);
-  void (*dma_mmu_release_scsi_sgl)(struct NCR_ESP *, Scsi_Cmnd *);
-  void (*dma_advance_sg)(Scsi_Cmnd *);
+  void (*dma_mmu_get_scsi_one)(struct NCR_ESP *, struct scsi_cmnd *);
+  void (*dma_mmu_get_scsi_sgl)(struct NCR_ESP *, struct scsi_cmnd *);
+  void (*dma_mmu_release_scsi_one)(struct NCR_ESP *, struct scsi_cmnd *);
+  void (*dma_mmu_release_scsi_sgl)(struct NCR_ESP *, struct scsi_cmnd *);
+  void (*dma_advance_sg)(struct scsi_cmnd *);
 };
 
 /* Bitfield meanings for the above registers. */
@@ -658,9 +658,9 @@ extern void esp_release(void);
 extern void esp_initialize(struct NCR_ESP *);
 extern irqreturn_t esp_intr(int, void *);
 extern const char *esp_info(struct Scsi_Host *);
-extern int esp_queue(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-extern int esp_abort(Scsi_Cmnd *);
-extern int esp_reset(Scsi_Cmnd *);
+extern int esp_queue(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+extern int esp_abort(struct scsi_cmnd *);
+extern int esp_reset(struct scsi_cmnd *);
 extern int esp_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t offset, int length,
 			 int inout);
 extern int esp_slave_alloc(struct scsi_device *);
