From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH 1/5] scsi: rename return code FAST_IO_FAIL to FAST_IO
Date: Mon, 20 May 2013 15:14:59 +0800
Message-ID: <1369034103-31644-2-git-send-email-renmx@cn.fujitsu.com>
References: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41164 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab3ETHMY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 May 2013 03:12:24 -0400
In-Reply-To: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, james.smart@emulex.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, michaelc@cs.wisc.edu
Cc: robert.w.love@intel.com, dgilbert@interlog.com, hare@suse.de, bprakash@broadcom.com, agk@redhat.com, neilb@suse.de, gregkh@linuxfoundation.org, axboe@kernel.dk, tj@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>

The return code FAST_IO_FAIL was introduced for fast failed io
recovery. To use this code for fast timed-out io recovery as well,
we'd rename it to FAST_IO.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
 drivers/scsi/scsi_error.c           |   18 +++++++++---------
 drivers/scsi/scsi_transport_fc.c    |    4 ++--
 drivers/scsi/scsi_transport_iscsi.c |    6 +++---
 include/scsi/scsi.h                 |    2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f43de1e..9e8e37a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1067,9 +1067,9 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 						  "0x%p\n", current->comm,
 						  scmd));
 		rtn = scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
+		if (rtn == SUCCESS || rtn == FAST_IO) {
 			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
-			if (rtn == FAST_IO_FAIL)
+			if (rtn == FAST_IO)
 				scsi_eh_finish_cmd(scmd, done_q);
 			else
 				list_move_tail(&scmd->eh_entry, &check_list);
@@ -1195,9 +1195,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 						  " 0x%p\n", current->comm,
 						  sdev));
 		rtn = scsi_try_bus_device_reset(bdr_scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
+		if (rtn == SUCCESS || rtn == FAST_IO) {
 			if (!scsi_device_online(sdev) ||
-			    rtn == FAST_IO_FAIL ||
+			    rtn == FAST_IO ||
 			    !scsi_eh_tur(bdr_scmd)) {
 				list_for_each_entry_safe(scmd, next,
 							 work_q, eh_entry) {
@@ -1248,7 +1248,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 						  "to target %d\n",
 						  current->comm, id));
 		rtn = scsi_try_target_reset(scmd);
-		if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
+		if (rtn != SUCCESS && rtn != FAST_IO)
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Target reset"
 							  " failed target: "
 							  "%d\n",
@@ -1259,7 +1259,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 
 			if (rtn == SUCCESS)
 				list_move_tail(&scmd->eh_entry, &check_list);
-			else if (rtn == FAST_IO_FAIL)
+			else if (rtn == FAST_IO)
 				scsi_eh_finish_cmd(scmd, done_q);
 			else
 				/* push back on work queue for further processing */
@@ -1311,10 +1311,10 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 						  " %d\n", current->comm,
 						  channel));
 		rtn = scsi_try_bus_reset(chan_scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
+		if (rtn == SUCCESS || rtn == FAST_IO) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd_channel(scmd)) {
-					if (rtn == FAST_IO_FAIL)
+					if (rtn == FAST_IO)
 						scsi_eh_finish_cmd(scmd,
 								   done_q);
 					else
@@ -1354,7 +1354,7 @@ static int scsi_eh_host_reset(struct list_head *work_q,
 		rtn = scsi_try_host_reset(scmd);
 		if (rtn == SUCCESS) {
 			list_splice_init(work_q, &check_list);
-		} else if (rtn == FAST_IO_FAIL) {
+		} else if (rtn == FAST_IO) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 					scsi_eh_finish_cmd(scmd, done_q);
 			}
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index e106c27..7b29e00 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3301,7 +3301,7 @@ fc_scsi_scan_rport(struct work_struct *work)
  * rports which would lead to offlined SCSI devices.
  *
  * Returns: 0 if the fc_rport left the state FC_PORTSTATE_BLOCKED.
- *	    FAST_IO_FAIL if the fast_io_fail_tmo fired, this should be
+ *	    FAST_IO if the fast_io_fail_tmo fired, this should be
  *	    passed back to scsi_eh.
  */
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
@@ -3320,7 +3320,7 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
-		return FAST_IO_FAIL;
+		return FAST_IO;
 
 	return 0;
 }
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 133926b..8a88f45 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1528,8 +1528,8 @@ static void iscsi_scan_session(struct work_struct *work)
  *
  * If the session is down this function will wait for the recovery
  * timer to fire or for the session to be logged back in. If the
- * recovery timer fires then FAST_IO_FAIL is returned. The caller
- * should pass this error value to the scsi eh.
+ * recovery timer fires then FAST_IO is returned. The caller should
+ * pass this error value to the scsi eh.
  */
 int iscsi_block_scsi_eh(struct scsi_cmnd *cmd)
 {
@@ -1541,7 +1541,7 @@ int iscsi_block_scsi_eh(struct scsi_cmnd *cmd)
 	spin_lock_irqsave(&session->lock, flags);
 	while (session->state != ISCSI_SESSION_LOGGED_IN) {
 		if (session->state == ISCSI_SESSION_FREE) {
-			ret = FAST_IO_FAIL;
+			ret = FAST_IO;
 			break;
 		}
 		spin_unlock_irqrestore(&session->lock, flags);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66216c1..3e12e1e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -480,7 +480,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define ADD_TO_MLQUEUE  0x2006
 #define TIMEOUT_ERROR   0x2007
 #define SCSI_RETURN_NOT_HANDLED   0x2008
-#define FAST_IO_FAIL	0x2009
+#define FAST_IO         0x2009
 #define TARGET_ERROR    0x200A
 
 /*
-- 
1.7.1

