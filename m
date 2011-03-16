From: David Jeffery <dhjeffery@gmail.com>
Subject: [PATCH RFC] Reduce amount of TURs sent in error recovery
Date: Wed, 16 Mar 2011 13:43:44 -0400
Message-ID: <4D80F6D0.1010404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57692 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab1CPR4E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2011 13:56:04 -0400
Received: by yia27 with SMTP id 27so769175yia.19
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2011 10:56:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In error recovery, most scsi error recovery stages will send a TUR command
for every bad command when a driver's error handler reports success.  When
several bad commands to the same device, this results in a device
being probed multiple times.

This becomes very problematic if the device or connection is in a state
where the device still doesn't respond to commands even after a recovery
function returns success.  The error handler must wait for the test
commands to time out.  The time waiting for the redundant commands can
drastically lengthen error recovery.

This patch alters the scsi mid-layer's error routines to send test commands
once per device instead of once per bad command.  This can drastically
lower error recovery time.

Signed-of-by: David Jeffery <djeffery@redhat.com>
---

As an extreme example with scsi_debug configured to drop all commands to
a device, it takes 10 commands 5.5 minutes from starting error recovery to
returning errors without the patch.  After the patch, error recovery only
takes 1 minute.  This is do to all error stages only having to wait for the
test commands to time out once per device instead of once for each bad
command.

The patch adds a helper function, scsi_eh_test_devices(), to handle a list
of commands to devices which need to be checked.  If a check for a device is
successful, all commands to a device are completed to the done queue.  If a
check to a device fails, all commands to the failing device are returned to
the work queue for additional error recovery.

scsi_eh_abort_cmds(), scsi_eh_target_reset(), scsi_eh_bus_reset(), and
scsi_eh_host_reset() were all converted to use this helper function.
scsi_eh_bus_device_reset() was not changed as it already has the behavior
of probing once per device.

One other behavior change with this patch is the probing commands occur after
all driver error handlers of a given type are called. e.g.  Instead of abort,
probe, abort, probe... it's now abort, abort, abort, probe... etc.


 drivers/scsi/scsi_error.c |   84 ++++++++++++++++++++++++++++++++++-----------
 1 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 45c7564..cea4fad 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -50,6 +50,8 @@
 #define BUS_RESET_SETTLE_TIME   (10)
 #define HOST_RESET_SETTLE_TIME  (10)
 
+static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
+
 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
@@ -934,6 +936,45 @@ retry_tur:
 }
 
 /**
+ * scsi_eh_test_devices - check if devices are responding from error recovery.
+ * @cmd_list:	scsi commands in error recovery.
+ * @work_q:     queue for commands which still need more error recovery
+ * @done_q:     queue for commands which are finished
+ * @try_stu:    boolean on if a STU command should be tried in addition to TUR.
+ *
+ * Decription:
+ *    Tests if devices are in a working state.  Commands to devices now in
+ *    a working state are sent to the done_q while commands to devices which
+ *    are still failing to respond are returned to the work_q for more
+ *    processing.
+ **/
+static int scsi_eh_test_devices(struct list_head *cmd_list, struct list_head *work_q, struct list_head *done_q, int try_stu)
+{
+	struct scsi_cmnd *scmd, *next;
+	struct scsi_device *sdev;
+	int finish_cmds;
+
+	while(!list_empty(cmd_list)){
+		scmd = list_entry(cmd_list->next, struct scsi_cmnd, eh_entry);
+		sdev = scmd->device;
+
+		finish_cmds = !scsi_device_online(scmd->device) || 
+			(try_stu && !scsi_eh_try_stu(scmd) && !scsi_eh_tur(scmd)) ||
+			!scsi_eh_tur(scmd);
+			
+		list_for_each_entry_safe(scmd, next, cmd_list, eh_entry)
+			if (scmd->device == sdev) {
+				if(finish_cmds)
+					scsi_eh_finish_cmd(scmd, done_q);
+				else
+					list_move_tail(&scmd->eh_entry, work_q);
+			}
+	}
+	return list_empty(work_q);
+}
+
+
+/**
  * scsi_eh_abort_cmds - abort pending commands.
  * @work_q:	&list_head for pending commands.
  * @done_q:	&list_head for processed commands.
@@ -949,6 +990,7 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 			      struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
+	LIST_HEAD(check_list);
 	int rtn;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
@@ -960,11 +1002,10 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 		rtn = scsi_try_to_abort_cmd(scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
-			if (!scsi_device_online(scmd->device) ||
-			    rtn == FAST_IO_FAIL ||
-			    !scsi_eh_tur(scmd)) {
+			if (rtn == FAST_IO_FAIL)
 				scsi_eh_finish_cmd(scmd, done_q);
-			}
+			else
+				list_move_tail(&scmd->eh_entry, &check_list);
 				
 		} else
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting"
@@ -974,7 +1015,7 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 							  scmd));
 	}
 
-	return list_empty(work_q);
+	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
 }
 
 /**
@@ -1125,6 +1166,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 				struct list_head *done_q)
 {
 	LIST_HEAD(tmp_list);
+	LIST_HEAD(check_list);
 
 	list_splice_init(work_q, &tmp_list);
 
@@ -1149,9 +1191,9 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 			if (scmd_id(scmd) != id)
 				continue;
 
-			if ((rtn == SUCCESS || rtn == FAST_IO_FAIL)
-			    && (!scsi_device_online(scmd->device) ||
-				 rtn == FAST_IO_FAIL || !scsi_eh_tur(scmd)))
+			if (rtn == SUCCESS)
+				list_move_tail(&scmd->eh_entry, &check_list);
+			else if (rtn == FAST_IO_FAIL)
 				scsi_eh_finish_cmd(scmd, done_q);
 			else
 				/* push back on work queue for further processing */
@@ -1159,7 +1201,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 		}
 	}
 
-	return list_empty(work_q);
+	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
 }
 
 /**
@@ -1173,6 +1215,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			     struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *chan_scmd, *next;
+	LIST_HEAD(check_list);
 	unsigned int channel;
 	int rtn;
 
@@ -1204,12 +1247,14 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 		rtn = scsi_try_bus_reset(chan_scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-				if (channel == scmd_channel(scmd))
-					if (!scsi_device_online(scmd->device) ||
-					    rtn == FAST_IO_FAIL ||
-					    !scsi_eh_tur(scmd))
+				if (channel == scmd_channel(scmd)) {
+					if (rtn == FAST_IO_FAIL)
 						scsi_eh_finish_cmd(scmd,
 								   done_q);
+					else
+						list_move_tail(&scmd->eh_entry,
+							       &check_list);
+				}
 			}
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: BRST"
@@ -1218,7 +1263,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 							  channel));
 		}
 	}
-	return list_empty(work_q);
+	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
 }
 
 /**
@@ -1230,6 +1275,7 @@ static int scsi_eh_host_reset(struct list_head *work_q,
 			      struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
+	LIST_HEAD(check_list);
 	int rtn;
 
 	if (!list_empty(work_q)) {
@@ -1240,12 +1286,10 @@ static int scsi_eh_host_reset(struct list_head *work_q,
 						  , current->comm));
 
 		rtn = scsi_try_host_reset(scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
+		if (rtn == SUCCESS) {
+			list_splice_init(work_q, &check_list);
+		} else if(rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-				if (!scsi_device_online(scmd->device) ||
-				    rtn == FAST_IO_FAIL ||
-				    (!scsi_eh_try_stu(scmd) && !scsi_eh_tur(scmd)) ||
-				    !scsi_eh_tur(scmd))
 					scsi_eh_finish_cmd(scmd, done_q);
 			}
 		} else {
@@ -1254,7 +1298,7 @@ static int scsi_eh_host_reset(struct list_head *work_q,
 							  current->comm));
 		}
 	}
-	return list_empty(work_q);
+	return scsi_eh_test_devices(&check_list, work_q, done_q, 1);
 }
 
 /**
-- 
1.7.3.4
