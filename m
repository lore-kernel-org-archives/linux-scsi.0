From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 5/6] aha152x.c - Fix check_condition code-path
Date: Sun, 29 Jul 2007 22:27:06 +0300
Message-ID: <46ACEA0A.5040101@panasas.com>
References: <46ACE62F.4070108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:7995 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933154AbXG2T1R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 15:27:17 -0400
In-Reply-To: <46ACE62F.4070108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, =?ISO-8859-1?Q?=22J=FC?= =?ISO-8859-1?Q?rgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>


  check_condition code-path was similar but more
  complicated to Reset. It went like this:
  1. extra space was allocated at aha152x_scdata for mirroring
    scsi_cmnd members.
  2. At aha152x_internal_queue() every not check_condition
    (REQUEST_SENSE) command was copied to above members in
    case of error.
  3. At busfree_run() in the DONE_CS phase if a Status of
    SAM_STAT_CHECK_CONDITION was detected. The command was
    re-queued Internally using aha152x_internal_queue(,,check_condition,)
    The old command members are over written with the
    REQUEST_SENSE info.
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
    execute the command.
  4. At busfree_run() in the DONE_CS phase again. restore needed
     members.

  While at it. This patch fixes a BUG. Old code when sending
  a REQUEST_SENSE for a failed command. Would than return with
  cmd->resid == 0 which was the status of the REQUEST_SENSE.
  The failing command resid was lost. And when would resid
  be interesting if not on a failing command?

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

---
 drivers/scsi/aha152x.c |   55 +++++++++++++++++++++++------------------------
 1 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index d7ca86f..cf49ed5 100644
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
@@ -1568,11 +1562,9 @@ static void busfree_run(struct Scsi_Host *shpnt)
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
 
@@ -1588,12 +1580,22 @@ static void busfree_run(struct Scsi_Host *shpnt)
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
@@ -1601,10 +1603,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
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


