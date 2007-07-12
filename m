From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patch 3/4] aha152x.c - Fix check_condition code-path
Date: Thu, 12 Jul 2007 13:05:45 +0300
Message-ID: <4695FCF9.8090004@panasas.com>
References: <4695F76F.5000305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12168 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758395AbXGLKGH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 06:06:07 -0400
In-Reply-To: <4695F76F.5000305@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, =?ISO-8859-1?Q?=22J=FCrgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


  check_condition code-path was similar but more
  complicated to Reset. It went like this:
  1. extra space was allocated at aha152x_scdata for mirroring
    scsi_cmnd members.
  2. At aha152x_internal_queue() every command was saved into
     above members for optional use later.
  3. At busfree_run() in the DONE_CS phase if a Status of
    SAM_STAT_CHECK_CONDITION was detected. The command was
    re-queued internally using aha152x_internal_queue(,,check_condition,)
    The command members are over written with a REQUEST_SENSE
    command info.
  4. At busfree_run() in the DONE_CS phase again. If it is a
    check_condition command, info was restored from mirror
    made at first call to aha152x_internal_queue() (see 2)
    and the command is completed.

  What I did is:
  1. Allocate less space in aha152x_scdata only for the 16-byte
    original command. (which is actually not needed by scsi-ml
    anymore at this stage. But this is to much knowledge of scsi-ml)
  2. If Status == SAM_STAT_CHECK_CONDITION, then like before
     re-queue a REQUEST_SENSE command. But only now save original
     command members. (Less of them)
  3. In aha152x_internal_queue(), just like for Reset, use the
    check_condition hint to set differently the working members.
  4. At busfree_run() in the DONE_CS phase again. restore needed
     members.

  While At it this patch fixes a BUG. Old code when sending
  a REQUEST_SENSE for a failed command. Would than return with
  cmd->resid == 0 which was the result of the REQUEST_SENSE command.
  The failing command's resid was lost. Now when would resid
  be interesting if not on a failing command?

  One question. The BUG_ON at before last hunk. Is that
  guaranteed here? or I sould be safe with an if()?

---
 drivers/scsi/aha152x.c |   55 +++++++++++++++++++++++------------------------
 1 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index ea57ecd..c2f4823 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -552,14 +552,11 @@ struct aha152x_hostdata {
 struct aha152x_scdata {
 	Scsi_Cmnd *next;	/* next sc in queue */
 	struct completion *done;/* semaphore to block on */
-	unsigned char cmd_len;
-	unsigned char cmnd[MAX_COMMAND_SIZE];
-	unsigned short use_sg;
-	unsigned request_bufflen;
-	void *request_buffer;
+	unsigned char aha_orig_cmd_len;
+	unsigned char aha_orig_cmnd[MAX_COMMAND_SIZE];
+	int aha_orig_resid;
 };
 
-
 /* access macros for hostdata */
 
 #define HOSTDATA(shpnt)		((struct aha152x_hostdata *) &shpnt->hostdata)
@@ -997,20 +994,11 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
 			return FAILED;
 		}
 	} else {
-		struct aha152x_scdata *sc;
-
 		SCpnt->host_scribble = kmalloc(sizeof(struct aha152x_scdata), GFP_ATOMIC);
 		if(SCpnt->host_scribble==0) {
 			printk(ERR_LEAD "allocation failed\n", CMDINFO(SCpnt));
 			return FAILED;
 		}
-
-		sc = SCDATA(SCpnt);
-		memcpy(sc->cmnd, SCpnt->cmnd, sizeof(sc->cmnd));
-		sc->request_buffer  = SCpnt->request_buffer;
-		sc->request_bufflen = SCpnt->request_bufflen;
-		sc->use_sg          = SCpnt->use_sg;
-		sc->cmd_len         = SCpnt->cmd_len;
 	}
 
 	SCNEXT(SCpnt)		= NULL;
@@ -1023,10 +1011,16 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
 	   SCp.buffers_residual : left buffers in list
 	   SCp.phase            : current state of the command */
 
-	if(phase & resetting) {
-		SCpnt->SCp.ptr           = NULL;
-		SCpnt->SCp.this_residual = 0;
-		SCpnt->resid             = 0;
+	if (phase & (check_condition|resetting)) {
+		if (phase & check_condition) {
+			SCpnt->SCp.ptr           = SCpnt->sense_buffer;
+			SCpnt->SCp.this_residual = sizeof(SCpnt->sense_buffer);
+			SCpnt->resid             = sizeof(SCpnt->sense_buffer);
+		} else {
+			SCpnt->SCp.ptr           = NULL;
+			SCpnt->SCp.this_residual = 0;
+			SCpnt->resid             = 0;
+		}
 		SCpnt->SCp.buffer           = NULL;
 		SCpnt->SCp.buffers_residual = 0;
 	} else {
@@ -1563,11 +1557,9 @@ static void busfree_run(struct Scsi_Host *shpnt)
 #endif
 
 			/* restore old command */
-			memcpy(cmd->cmnd, sc->cmnd, sizeof(sc->cmnd));
-			cmd->request_buffer  = sc->request_buffer;
-			cmd->request_bufflen = sc->request_bufflen;
-			cmd->use_sg          = sc->use_sg;
-			cmd->cmd_len         = sc->cmd_len;
+			memcpy(cmd->cmnd, sc->aha_orig_cmnd, sizeof(cmd->cmnd));
+			cmd->cmd_len = sc->aha_orig_cmd_len;
+			cmd->resid = sc->aha_orig_resid;
 
 			cmd->SCp.Status = SAM_STAT_CHECK_CONDITION;
 
@@ -1583,12 +1575,22 @@ static void busfree_run(struct Scsi_Host *shpnt)
 #endif
 
 			if(!(DONE_SC->SCp.phase & not_issued)) {
+				struct aha152x_scdata *sc;
 				Scsi_Cmnd *ptr = DONE_SC;
 				DONE_SC=NULL;
 #if 0
 				DPRINTK(debug_eh, ERR_LEAD "requesting sense\n", CMDINFO(ptr));
 #endif
 
+				/* save old command */
+				sc = SCDATA(ptr);
+				/* It was allocated in aha152x_internal_queue? */
+				BUG_ON(!sc);
+				memcpy(sc->aha_orig_cmnd, ptr->cmnd,
+				                            sizeof(ptr->cmnd));
+				sc->aha_orig_cmd_len = ptr->cmd_len;
+				sc->aha_orig_resid = ptr->resid;
+
 				ptr->cmnd[0]         = REQUEST_SENSE;
 				ptr->cmnd[1]         = 0;
 				ptr->cmnd[2]         = 0;
@@ -1596,10 +1598,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 				ptr->cmnd[4]         = sizeof(ptr->sense_buffer);
 				ptr->cmnd[5]         = 0;
 				ptr->cmd_len         = 6;
-				ptr->use_sg          = 0; 
-				ptr->request_buffer  = ptr->sense_buffer;
-				ptr->request_bufflen = sizeof(ptr->sense_buffer);
-			
+
 				DO_UNLOCK(flags);
 				aha152x_internal_queue(ptr, NULL, check_condition, ptr->scsi_done);
 				DO_LOCK(flags);
-- 
1.5.2.2.249.g45fd


