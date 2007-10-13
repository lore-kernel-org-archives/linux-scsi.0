From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: drivers/fc4/fc.c in git-scsi-misc
Date: Sat, 13 Oct 2007 11:34:46 -0600
Message-ID: <20071013173446.GC29934@parisc-linux.org>
References: <20071011112058.d95fe040.akpm@linux-foundation.org> <20071011.173842.98873625.davem@davemloft.net> <1192212273.3342.34.camel@localhost.localdomain> <20071012.152508.30182036.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55323 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbXJMRes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Oct 2007 13:34:48 -0400
Content-Disposition: inline
In-Reply-To: <20071012.152508.30182036.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@SteelEye.com, akpm@linux-foundation.org, bharrosh@panasas.com, linux-scsi@vger.kernel.org

On Fri, Oct 12, 2007 at 03:25:08PM -0700, David Miller wrote:
> Unfortunately it doesn't build.  The drivers/scsi/pluto.c part
> fails with:
> 
> drivers/scsi/pluto.c: In function $,1rxpluto_detect$,1ry:
> drivers/scsi/pluto.c:159: error: $,1rxpluto_detect_done$,1ry undeclared (first use in this function)

I bet you didn't try this patch on top of scsi-misc.  The assignment of
pluto_detect_done was removed in an earlier patch, but I neglected to
remove the definition of pluto_detect_done.

Looking at that patch again, I may have made the cardinal mistake of
believing the comment instead of the code:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=4ad9c591633c117d013b40a146825666f9accf30;hp=2e4eab24e9597920e761a1fd4b1c4f278ae3b01e

I replaced an indirect call to pluto_detect_done with a call to
pluto_detect_scsi_done.  Whoops.  I think the call should simply be
deleted (since pluto_detect_done is a no-op).

> Also, drivers/fc4/fc.c gives a warning:

Fix incorporated ... patch against scsi-misc.

diff --git a/drivers/fc4/fc.c b/drivers/fc4/fc.c
index 82de9e1..48c3b62 100644
--- a/drivers/fc4/fc.c
+++ b/drivers/fc4/fc.c
@@ -33,6 +33,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/init.h>
+#include <linux/pci.h>
 
 #include <asm/pgtable.h>
 #include <asm/irq.h>
@@ -378,7 +379,12 @@ void fcp_register(fc_channel *fc, u8 type, int unregister)
 		printk ("FC: %segistering unknown type %02x\n", unregister ? "Unr" : "R", type);
 }
 
-static void fcp_scsi_done(struct scsi_cmnd *SCpnt);
+static void fcp_scsi_done(struct scsi_cmnd *SCpnt, unsigned int result)
+{
+	SCpnt->result = result;
+	FCD(("Calling scsi_done with %08x\n", SCpnt->result))
+	SCpnt->scsi_done(SCpnt);
+}
 
 static inline void fcp_scsi_receive(fc_channel *fc, int token, int status, fc_hdr *fch)
 {
@@ -394,9 +400,6 @@ static inline void fcp_scsi_receive(fc_channel *fc, int token, int status, fc_hd
 	rsp = (fcp_rsp *) (fc->scsi_rsp_pool + fc->rsp_size * token);
 	SCpnt = SC_FCMND(fcmd);
 
-	if (SCpnt->done != fcp_scsi_done)
-		return;
-
 	rsp_status = rsp->fcp_status;
 	FCD(("rsp_status %08x status %08x\n", rsp_status, status))
 	switch (status) {
@@ -442,17 +445,9 @@ static inline void fcp_scsi_receive(fc_channel *fc, int token, int status, fc_hd
 		printk ("%s: (%d,%d) Received rsp_status 0x%x\n", fc->name, SCpnt->device->channel, SCpnt->device->id, rsp_status);
 	}	
 	
-	SCpnt->result = (host_status << 16) | (rsp_status & 0xff);
-#ifdef FCDEBUG	
-	if (host_status || SCpnt->result || rsp_status) printk("FC: host_status %d, packet status %d\n",
-			host_status, SCpnt->result);
-#endif
-	SCpnt->done = fcmd->done;
-	fcmd->done=NULL;
 	clear_bit(token, fc->scsi_bitmap);
 	fc->scsi_free++;
-	FCD(("Calling scsi_done with %08x\n", SCpnt->result))
-	SCpnt->scsi_done(SCpnt);
+	fcp_scsi_done(SCpnt, (host_status << 16) | (rsp_status & 0xff));
 }
 
 void fcp_receive_solicited(fc_channel *fc, int proto, int token, int status, fc_hdr *fch)
@@ -751,13 +746,6 @@ void fcp_release(fc_channel *fcchain, int count)  /* count must > 0 */
 	 */
 }
 
-
-static void fcp_scsi_done(struct scsi_cmnd *SCpnt)
-{
-	if (FCP_CMND(SCpnt)->done)
-		FCP_CMND(SCpnt)->done(SCpnt);
-}
-
 static int fcp_scsi_queue_it(fc_channel *fc, struct scsi_cmnd *SCpnt,
 			     fcp_cmnd *fcmd, int prepare)
 {
@@ -773,8 +761,7 @@ static int fcp_scsi_queue_it(fc_channel *fc, struct scsi_cmnd *SCpnt,
 		if (fc->encode_addr (SCpnt, cmd->fcp_addr, fc, fcmd)) {
 			/* Invalid channel/id/lun and couldn't map it into fcp_addr */
 			clear_bit (i, fc->scsi_bitmap);
-			SCpnt->result = (DID_BAD_TARGET << 16);
-			SCpnt->scsi_done(SCpnt);
+			fcp_scsi_done(SCpnt, (DID_BAD_TARGET << 16));
 			return 0;
 		}
 		fc->scsi_free--;
@@ -834,21 +821,20 @@ int fcp_scsi_queuecommand(struct scsi_cmnd *SCpnt,
 	fc_channel *fc = FC_SCMND(SCpnt);
 	
 	FCD(("Entering SCSI queuecommand %p\n", fcmd))
-	if (SCpnt->done != fcp_scsi_done) {
-		fcmd->done = SCpnt->done;
-		SCpnt->done = fcp_scsi_done;
-		SCpnt->scsi_done = done;
-		fcmd->proto = TYPE_SCSI_FCP;
-		if (!fc->scsi_free) {
-			FCD(("FC: !scsi_free, putting cmd on ML queue\n"))
+	SCpnt->scsi_done = done;
+	if (!fc->scsi_free) {
+		FCD(("FC: !scsi_free, putting cmd on ML queue\n"))
 #if (FCP_SCSI_USE_NEW_EH_CODE == 0)
-			printk("fcp_scsi_queue_command: queue full, losing cmd, bad\n");
+		printk("fcp_scsi_queue_command: queue full, losing cmd, bad\n");
 #endif
-			return 1;
-		}
+		return 1;
+	}
+	if (fcmd->proto == TYPE_SCSI_FCP) {
+		return fcp_scsi_queue_it(fc, SCpnt, fcmd, 0);
+	} else {
+		fcmd->proto = TYPE_SCSI_FCP;
 		return fcp_scsi_queue_it(fc, SCpnt, fcmd, 1);
 	}
-	return fcp_scsi_queue_it(fc, SCpnt, fcmd, 0);
 }
 
 void fcp_queue_empty(fc_channel *fc)
@@ -867,7 +853,6 @@ void fcp_queue_empty(fc_channel *fc)
 int fcp_scsi_abort(struct scsi_cmnd *SCpnt)
 {
 	/* Internal bookkeeping only. Lose 1 cmd_slots slot. */
-	fcp_cmnd *fcmd = FCP_CMND(SCpnt);
 	fc_channel *fc = FC_SCMND(SCpnt);
 	
 	/*
@@ -890,8 +875,7 @@ int fcp_scsi_abort(struct scsi_cmnd *SCpnt)
 	 */
 
 	if (++fc->abort_count < (fc->can_queue >> 1)) {
-		SCpnt->result = DID_ABORT;
-		fcmd->done(SCpnt);
+		fcp_scsi_done(SCpnt, DID_ABORT);
 		printk("FC: soft abort\n");
 		return SUCCESS;
 	} else {
@@ -949,8 +933,6 @@ int fcp_scsi_dev_reset(struct scsi_cmnd *SCpnt)
 		if (fc->rst_pkt->eh_state == SCSI_STATE_QUEUED)
 			return FAILED; /* or SUCCESS. Only these */
 	}
-	fc->rst_pkt->done = NULL;
-
 
         fc->rst_pkt->eh_state = SCSI_STATE_QUEUED;
 	init_timer(&fc->rst_pkt->eh_timeout);
@@ -966,7 +948,7 @@ int fcp_scsi_dev_reset(struct scsi_cmnd *SCpnt)
 
 	fc->rst_pkt->device->host->eh_action = &sem;
 
-	fc->rst_pkt->done = fcp_scsi_reset_done;
+	fc->rst_pkt->scsi_done = fcp_scsi_reset_done;
 
 	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
 	fcp_scsi_queue_it(fc, fc->rst_pkt, fcmd, 0);
@@ -993,15 +975,13 @@ int fcp_scsi_dev_reset(struct scsi_cmnd *SCpnt)
 static int __fcp_scsi_host_reset(struct scsi_cmnd *SCpnt)
 {
 	fc_channel *fc = FC_SCMND(SCpnt);
-	fcp_cmnd *fcmd = FCP_CMND(SCpnt);
 	int i;
 
 	printk ("FC: host reset\n");
 
 	for (i=0; i < fc->can_queue; i++) {
 		if (fc->cmd_slots[i] && SCpnt->result != DID_ABORT) {
-			SCpnt->result = DID_RESET;
-			fcmd->done(SCpnt);
+			fcp_scsi_done(SCpnt, DID_RESET);
 			fc->cmd_slots[i] = NULL;
 		}
 	}
diff --git a/drivers/fc4/fcp_impl.h b/drivers/fc4/fcp_impl.h
index 1ac6133..41fa149 100644
--- a/drivers/fc4/fcp_impl.h
+++ b/drivers/fc4/fcp_impl.h
@@ -39,7 +39,6 @@ struct _fc_channel;
 typedef struct fcp_cmnd {
 	struct fcp_cmnd		*next;
 	struct fcp_cmnd		*prev;
-	void			(*done)(struct scsi_cmnd *);
 	unsigned short		proto;
 	unsigned short		token;
 	unsigned int		did;
diff --git a/drivers/scsi/pluto.c b/drivers/scsi/pluto.c
index 0363c1c..e598a90 100644
--- a/drivers/scsi/pluto.c
+++ b/drivers/scsi/pluto.c
@@ -55,14 +55,9 @@ static DECLARE_COMPLETION(fc_detect_complete);
 
 static int pluto_encode_addr(Scsi_Cmnd *SCpnt, u16 *addr, fc_channel *fc, fcp_cmnd *fcmd);
 
-static void __init pluto_detect_done(Scsi_Cmnd *SCpnt)
-{
-	/* Do nothing */
-}
-
 static void __init pluto_detect_scsi_done(Scsi_Cmnd *SCpnt)
 {
-	PLND(("Detect done %08lx\n", (long)SCpnt))
+	PLND(("Detect done %p\n", SCpnt))
 	if (atomic_dec_and_test (&fcss))
 		complete(&fc_detect_complete);
 }
@@ -193,9 +188,6 @@ int __init pluto_detect(struct scsi_host_template *tpnt)
 	
 		SCpnt = &(fcs[i].cmd);
 		
-		/* Let FC mid-level free allocated resources */
-		pluto_detect_scsi_done(SCpnt);
-		
 		if (!SCpnt->result) {
 			struct pluto_inquiry *inq;
 			struct pluto *pluto;

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
