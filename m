From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] aha152x: Use scsi_eh API for REQUEST_SENSE invocation
Date: Thu, 01 Nov 2007 18:54:44 +0200
Message-ID: <472A04D4.1070701@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:28764 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752611AbXKAQys (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2007 12:54:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


  - Use new scsi_eh_prep/restor_cmnd() for synchronous
    REQUEST_SENSE invocation.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
----
 drivers/scsi/aha152x.c |   38 ++++++++------------------------------
 1 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index ea8c699..6ccdc96 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -260,6 +260,7 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_spi.h>
+#include <scsi/scsi_eh.h>
 #include "aha152x.h"
 
 static LIST_HEAD(aha152x_host_list);
@@ -558,9 +559,7 @@ struct aha152x_hostdata {
 struct aha152x_scdata {
 	Scsi_Cmnd *next;	/* next sc in queue */
 	struct completion *done;/* semaphore to block on */
-	unsigned char aha_orig_cmd_len;
-	unsigned char aha_orig_cmnd[MAX_COMMAND_SIZE];
-	int aha_orig_resid;
+	struct scsi_eh_save ses;
 };
 
 /* access macros for hostdata */
@@ -1017,16 +1016,10 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
 	   SCp.buffers_residual : left buffers in list
 	   SCp.phase            : current state of the command */
 
-	if ((phase & (check_condition|resetting)) || !scsi_sglist(SCpnt)) {
-		if (phase & check_condition) {
-			SCpnt->SCp.ptr           = SCpnt->sense_buffer;
-			SCpnt->SCp.this_residual = sizeof(SCpnt->sense_buffer);
-			scsi_set_resid(SCpnt, sizeof(SCpnt->sense_buffer));
-		} else {
-			SCpnt->SCp.ptr           = NULL;
-			SCpnt->SCp.this_residual = 0;
-			scsi_set_resid(SCpnt, 0);
-		}
+	if ((phase & resetting) || !scsi_sglist(SCpnt)) {
+		SCpnt->SCp.ptr           = NULL;
+		SCpnt->SCp.this_residual = 0;
+		scsi_set_resid(SCpnt, 0);
 		SCpnt->SCp.buffer           = NULL;
 		SCpnt->SCp.buffers_residual = 0;
 	} else {
@@ -1561,10 +1554,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 			}
 #endif
 
-			/* restore old command */
-			memcpy(cmd->cmnd, sc->aha_orig_cmnd, sizeof(cmd->cmnd));
-			cmd->cmd_len = sc->aha_orig_cmd_len;
-			scsi_set_resid(cmd, sc->aha_orig_resid);
+			scsi_eh_restore_cmnd(cmd, &sc->ses);
 
 			cmd->SCp.Status = SAM_STAT_CHECK_CONDITION;
 
@@ -1587,22 +1577,10 @@ static void busfree_run(struct Scsi_Host *shpnt)
 				DPRINTK(debug_eh, ERR_LEAD "requesting sense\n", CMDINFO(ptr));
 #endif
 
-				/* save old command */
 				sc = SCDATA(ptr);
 				/* It was allocated in aha152x_internal_queue? */
 				BUG_ON(!sc);
-				memcpy(sc->aha_orig_cmnd, ptr->cmnd,
-				                            sizeof(ptr->cmnd));
-				sc->aha_orig_cmd_len = ptr->cmd_len;
-				sc->aha_orig_resid = scsi_get_resid(ptr);
-
-				ptr->cmnd[0]         = REQUEST_SENSE;
-				ptr->cmnd[1]         = 0;
-				ptr->cmnd[2]         = 0;
-				ptr->cmnd[3]         = 0;
-				ptr->cmnd[4]         = sizeof(ptr->sense_buffer);
-				ptr->cmnd[5]         = 0;
-				ptr->cmd_len         = 6;
+				scsi_eh_prep_cmnd(ptr, &sc->ses, NULL, 0, ~0);
 
 				DO_UNLOCK(flags);
 				aha152x_internal_queue(ptr, NULL, check_condition, ptr->scsi_done);
-- 
1.5.3.1

