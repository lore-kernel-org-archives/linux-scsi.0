From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/3] pluto/fc - Remove uses of the scsi_cmnd->done
Date: Mon, 15 Oct 2007 19:25:14 +0200
Message-ID: <4713A27A.9050009@panasas.com>
References: <4713A175.9020408@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:7820 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751659AbXJORZb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 13:25:31 -0400
In-Reply-To: <4713A175.9020408@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>linux-scsi <linux>
Cc: FUJITA Tomonori <tomof@acm.org>

From: Matthew Wilcox <matthew@wil.cx>

Remove uses of the scsi_cmnd ->done method from the fc4 driver.  It was
being abused to flag commands that had already been through queuecommand;
use the fcmd->proto value for that instead.  The fcmd->done pointer now
becomes irrelevant.  Reuse the fcp_scsi_done name for an entirely different
function which provides a handy single place to call ->scsi_done (removing
some broken places that used to leak scsi_cmnds on error by calling ->done).

I had to add an include of <linux/pci.h> to get this to compile on non-sparc,
and pluto_detect_done() was unused, so remove it too.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/fc4/fc.c       |   64 ++++++++++++++++-------------------------------
 drivers/fc4/fcp_impl.h |    1 -
 drivers/scsi/pluto.c   |   10 +------
 3 files changed, 23 insertions(+), 52 deletions(-)

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
1.5.3.1


