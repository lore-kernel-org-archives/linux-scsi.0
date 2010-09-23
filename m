From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 3/7] scsi error: rename FAST_IO_FAIL to TRANSPORT_FAILED
Date: Thu, 23 Sep 2010 00:17:21 -0500
Message-ID: <1285219045-14645-4-git-send-email-michaelc@cs.wisc.edu>
References: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab0IWFLq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 01:11:46 -0400
In-Reply-To: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This renames FAST_IO_FAIL to TRANSPORT_FAILED to indicate
that in the next patches transport classes can return the
error because their fast io fail timer expired, or because
the transport decided the port/target/session/connection
is dead and is going to be cleaning up the mess.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c           |   20 ++++++++++----------
 drivers/scsi/scsi_transport_fc.c    |    4 ++--
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 include/scsi/scsi.h                 |    2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1de30eb..7e80547 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -990,10 +990,10 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 						  "0x%p\n", current->comm,
 						  scmd));
 		rtn = scsi_try_to_abort_cmd(scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
+		if (rtn == SUCCESS || rtn == TRANSPORT_FAILED) {
 			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
 			if (!scsi_device_online(scmd->device) ||
-			    rtn == FAST_IO_FAIL ||
+			    rtn == TRANSPORT_FAILED ||
 			    !scsi_eh_tur(scmd)) {
 				scsi_eh_finish_cmd(scmd, done_q);
 			}
@@ -1120,9 +1120,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 						  " 0x%p\n", current->comm,
 						  sdev));
 		rtn = scsi_try_bus_device_reset(bdr_scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
+		if (rtn == SUCCESS || rtn == TRANSPORT_FAILED) {
 			if (!scsi_device_online(sdev) ||
-			    rtn == FAST_IO_FAIL ||
+			    rtn == TRANSPORT_FAILED ||
 			    !scsi_eh_tur(bdr_scmd)) {
 				list_for_each_entry_safe(scmd, next,
 							 work_q, eh_entry) {
@@ -1185,11 +1185,11 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 						  "to target %d\n",
 						  current->comm, id));
 		rtn = scsi_try_target_reset(tgtr_scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
+		if (rtn == SUCCESS || rtn == TRANSPORT_FAILED) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (id == scmd_id(scmd))
 					if (!scsi_device_online(scmd->device) ||
-					    rtn == FAST_IO_FAIL ||
+					    rtn == TRANSPORT_FAILED ||
 					    !scsi_eh_tur(tgtr_scmd))
 						scsi_eh_finish_cmd(scmd,
 								   done_q);
@@ -1245,11 +1245,11 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 						  " %d\n", current->comm,
 						  channel));
 		rtn = scsi_try_bus_reset(chan_scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
+		if (rtn == SUCCESS || rtn == TRANSPORT_FAILED) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd_channel(scmd))
 					if (!scsi_device_online(scmd->device) ||
-					    rtn == FAST_IO_FAIL ||
+					    rtn == TRANSPORT_FAILED ||
 					    !scsi_eh_tur(scmd))
 						scsi_eh_finish_cmd(scmd,
 								   done_q);
@@ -1283,10 +1283,10 @@ static int scsi_eh_host_reset(struct list_head *work_q,
 						  , current->comm));
 
 		rtn = scsi_try_host_reset(scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
+		if (rtn == SUCCESS || rtn == TRANSPORT_FAILED) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (!scsi_device_online(scmd->device) ||
-				    rtn == FAST_IO_FAIL ||
+				    rtn == TRANSPORT_FAILED ||
 				    (!scsi_eh_try_stu(scmd) && !scsi_eh_tur(scmd)) ||
 				    !scsi_eh_tur(scmd))
 					scsi_eh_finish_cmd(scmd, done_q);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3982a2b..a15e815 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3181,7 +3181,7 @@ fc_scsi_scan_rport(struct work_struct *work)
  * rports which would lead to offlined SCSI devices.
  *
  * Returns: 0 if the fc_rport left the state FC_PORTSTATE_BLOCKED.
- *	    FAST_IO_FAIL if the fast_io_fail_tmo fired, this should be
+ *	    TRANSPORT_FAILED if the fast_io_fail_tmo fired, this should be
  *	    passed back to scsi_eh.
  */
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
@@ -3200,7 +3200,7 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
-		return FAST_IO_FAIL;
+		return TRANSPORT_FAILED;
 
 	return 0;
 }
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 332387a..ddb87be 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -554,7 +554,7 @@ int iscsi_block_scsi_eh(struct scsi_cmnd *cmd)
 	spin_lock_irqsave(&session->lock, flags);
 	while (session->state != ISCSI_SESSION_LOGGED_IN) {
 		if (session->state == ISCSI_SESSION_FREE) {
-			ret = FAST_IO_FAIL;
+			ret = TRANSPORT_FAILED;
 			break;
 		}
 		spin_unlock_irqrestore(&session->lock, flags);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8fcb6e0..0683db8 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -425,7 +425,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define ADD_TO_MLQUEUE  0x2006
 #define TIMEOUT_ERROR   0x2007
 #define SCSI_RETURN_NOT_HANDLED   0x2008
-#define FAST_IO_FAIL	0x2009
+#define TRANSPORT_FAILED	0x2009
 
 /*
  * Midlevel queue return values.
-- 
1.7.2.2

