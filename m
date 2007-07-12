From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patch 1/4] aha152x.c - Preliminary fixes and some comments
Date: Thu, 12 Jul 2007 12:49:04 +0300
Message-ID: <4695F910.8080506@panasas.com>
References: <4695F76F.5000305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12227 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753957AbXGLJtW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 05:49:22 -0400
In-Reply-To: <4695F76F.5000305@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, =?ISO-8859-1?Q?=22J=FCrgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


  hunk by hunk:
  - CHECK_CONDITION is what happens to cmnd->status >> 1
    or after status_byte() macro. But here it is used
    directly on status which means 0x1 which is an undefined
    bit in the standard. And is a status that will never
    return from a target.

  - in busfree_run at the DONE_SC phase we have 3 distinct
    operation:
	1-if(DONE_SC->SCp.phase & check_condition)
          The REQUEST_SENSE command return.
          - Restore original command
	  - Than continue to operation 3.
	2-if(DONE_SC->SCp.Status==SAM_STAT_CHECK_CONDITION)
          A regular command returned with a status.
	  - Internally re-Q a REQUEST_SENSE.
	  - Do not do operation 3.
	3-
	  - Complete the command and return it to scsi-ml
     So the 0x2 in both these operations (1,2) means the scsi
     check-condition status, hence SAM_STAT_CHECK_CONDITION

  - Here the code asks about !(DONE_SC->SCp.Status & not_issued)
    but "not_issued" is an enum belonging to the "phase" member
    and not to the Status returned from target. The reason this
    works is because not_issued==1 and Also CHECK_CONDITION==1
    (remember from hunk 1). So actually the code was asking
    !(DONE_SC->SCp.Status & CHECK_CONDITION). Which means
    "Has the status been read from target yet?"
    Staus is read at status_run(). "not_issued" is
    cleared in seldo_run() which is usually earlier than
    status_run().

  So this patch does nothing as far as assembly is concerned
  but it does let the reader understand what is going on.
---
 drivers/scsi/aha152x.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 85f2394..29253f9 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -986,7 +986,7 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
 	SCpnt->scsi_done	= done;
 	SCpnt->resid 		= SCpnt->request_bufflen;
 	SCpnt->SCp.phase	= not_issued | phase;
-	SCpnt->SCp.Status	= CHECK_CONDITION;
+	SCpnt->SCp.Status	= 0x1; /* Ilegal status by SCSI standard */
 	SCpnt->SCp.Message	= 0;
 	SCpnt->SCp.have_data_in	= 0;
 	SCpnt->SCp.sent_command	= 0;
@@ -1574,12 +1574,12 @@ static void busfree_run(struct Scsi_Host *shpnt)
 			cmd->use_sg          = sc->use_sg;
 			cmd->cmd_len         = sc->cmd_len;
 
-			cmd->SCp.Status = 0x02;
+			cmd->SCp.Status = SAM_STAT_CHECK_CONDITION;
 
 			HOSTDATA(shpnt)->commands--;
 			if (!HOSTDATA(shpnt)->commands)
 				SETPORT(PORTA, 0);	/* turn led off */
-		} else if(DONE_SC->SCp.Status==0x02) {
+		} else if(DONE_SC->SCp.Status==SAM_STAT_CHECK_CONDITION) {
 #if defined(AHA152X_STAT)
 			HOSTDATA(shpnt)->busfree_with_check_condition++;
 #endif
@@ -1587,7 +1587,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 			DPRINTK(debug_eh, ERR_LEAD "CHECK CONDITION found\n", CMDINFO(DONE_SC));
 #endif
 
-			if(!(DONE_SC->SCp.Status & not_issued)) {
+			if(!(DONE_SC->SCp.phase & not_issued)) {
 				Scsi_Cmnd *ptr = DONE_SC;
 				DONE_SC=NULL;
 #if 0
-- 
1.5.2.2.249.g45fd


