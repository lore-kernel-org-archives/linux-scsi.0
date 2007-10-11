From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: drivers/fc4/fc.c in git-scsi-misc
Date: Thu, 11 Oct 2007 06:03:36 -0600
Message-ID: <20071011120336.GH2730@parisc-linux.org>
References: <20071011025203.e95690ee.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45850 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbXJKMDi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2007 08:03:38 -0400
Content-Disposition: inline
In-Reply-To: <20071011025203.e95690ee.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>

On Thu, Oct 11, 2007 at 02:52:03AM -0700, Andrew Morton wrote:
> davem won't be happy

I'm not happy either.  I think this should fix it, but obviously I have
no sparc machines of my own to test it, let alone a pluto.

----

Remove uses of the scsi_cmnd ->done method from the fc4 driver.  It was
being abused to flag commands that had already been through queuecommand;
use the fcmd->proto value for that instead.  The fcmd->done pointer now
becomes irrelevant.  Reuse the fcp_scsi_done name for an entirely different
function which provides a handy single place to call ->scsi_done (removing
some broken places that used to leak scsi_cmnds on error by calling ->done).

I had to add an include of <linux/pci.h> to get this to compile on non-sparc,
and pluto_detect_done() was unused, so remove it too.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/fc4/fc.c b/drivers/fc4/fc.c
index 82de9e1..4d71e64 100644
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
@@ -890,8 +876,7 @@ int fcp_scsi_abort(struct scsi_cmnd *SCpnt)
 	 */
 
 	if (++fc->abort_count < (fc->can_queue >> 1)) {
-		SCpnt->result = DID_ABORT;
-		fcmd->done(SCpnt);
+		fcp_scsi_done(SCpnt, DID_ABORT);
 		printk("FC: soft abort\n");
 		return SUCCESS;
 	} else {
@@ -949,8 +934,6 @@ int fcp_scsi_dev_reset(struct scsi_cmnd *SCpnt)
 		if (fc->rst_pkt->eh_state == SCSI_STATE_QUEUED)
 			return FAILED; /* or SUCCESS. Only these */
 	}
-	fc->rst_pkt->done = NULL;
-
 
         fc->rst_pkt->eh_state = SCSI_STATE_QUEUED;
 	init_timer(&fc->rst_pkt->eh_timeout);
@@ -966,7 +949,7 @@ int fcp_scsi_dev_reset(struct scsi_cmnd *SCpnt)
 
 	fc->rst_pkt->device->host->eh_action = &sem;
 
-	fc->rst_pkt->done = fcp_scsi_reset_done;
+	fc->rst_pkt->scsi_done = fcp_scsi_reset_done;
 
 	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
 	fcp_scsi_queue_it(fc, fc->rst_pkt, fcmd, 0);
@@ -1000,8 +983,7 @@ static int __fcp_scsi_host_reset(struct scsi_cmnd *SCpnt)
 
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
index 0363c1c..c9279e7 100644
--- a/drivers/scsi/pluto.c
+++ b/drivers/scsi/pluto.c
@@ -55,11 +55,6 @@ static DECLARE_COMPLETION(fc_detect_complete);
 
 static int pluto_encode_addr(Scsi_Cmnd *SCpnt, u16 *addr, fc_channel *fc, fcp_cmnd *fcmd);
 
-static void __init pluto_detect_done(Scsi_Cmnd *SCpnt)
-{
-	/* Do nothing */
-}
-
 static void __init pluto_detect_scsi_done(Scsi_Cmnd *SCpnt)
 {
 	PLND(("Detect done %08lx\n", (long)SCpnt))

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
