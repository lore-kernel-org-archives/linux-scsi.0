From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] scsi: Fix erratic device offline during EH
Date: Mon,  2 Sep 2013 13:58:36 +0200
Message-ID: <1378123118-111972-2-git-send-email-hare@suse.de>
References: <1378123118-111972-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758423Ab3IBL6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Sep 2013 07:58:43 -0400
In-Reply-To: <1378123118-111972-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

Commit 18a4d0a22ed6c54b67af7718c305cd010f09ddf8
(Handle disk devices which can not process medium access commands)
was introduced to offline any device which cannot process medium
access commands.
However, commit 3eef6257de48ff84a5d98ca533685df8a3beaeb8
(Reduce error recovery time by reducing use of TURs) reduced
the number of TURs by sending it only on the first failing
command, which might or might not be a medium access command.
So in combination this results in an erratic device offlining
during EH; if the command where the TUR was sent upon happens
to be a medium access command the device will be set offline,
if not everything proceeds as normal.

So instead of checking the EH command in the ->eh_action
callback we should rather call ->eh_action when we're
about to finish the command _and_ have sent a TUR previously.
This should then set the device offline as advertised.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Ewan Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index abf0916..c88cb7e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -941,12 +941,6 @@ retry:
 
 	scsi_eh_restore_cmnd(scmd, &ses);
 
-	if (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
-		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
-		if (sdrv->eh_action)
-			rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
-	}
-
 	return rtn;
 }
 
@@ -964,6 +958,18 @@ static int scsi_request_sense(struct scsi_cmnd *scmd)
 	return scsi_send_eh_cmnd(scmd, NULL, 0, scmd->device->eh_timeout, ~0);
 }
 
+static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
+{
+	static unsigned char tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
+
+	if (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
+		if (sdrv->eh_action)
+			rtn = sdrv->eh_action(scmd, tur_command, 6, rtn);
+	}
+	return rtn;
+}
+
 /**
  * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
  * @scmd:	Original SCSI cmd that eh has finished.
@@ -1142,7 +1148,9 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 
 		list_for_each_entry_safe(scmd, next, cmd_list, eh_entry)
 			if (scmd->device == sdev) {
-				if (finish_cmds)
+				if (finish_cmds &&
+				    (try_stu ||
+				     scsi_eh_action(scmd, SUCCESS) == SUCCESS))
 					scsi_eh_finish_cmd(scmd, done_q);
 				else
 					list_move_tail(&scmd->eh_entry, work_q);
@@ -1281,7 +1289,8 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			    !scsi_eh_tur(stu_scmd)) {
 				list_for_each_entry_safe(scmd, next,
 							  work_q, eh_entry) {
-					if (scmd->device == sdev)
+					if (scmd->device == sdev &&
+					    scsi_eh_action(scmd, SUCCESS) == SUCCESS)
 						scsi_eh_finish_cmd(scmd, done_q);
 				}
 			}
@@ -1348,7 +1357,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 			    !scsi_eh_tur(bdr_scmd)) {
 				list_for_each_entry_safe(scmd, next,
 							 work_q, eh_entry) {
-					if (scmd->device == sdev)
+					if (scmd->device == sdev &&
+					    scsi_eh_action(scmd, rtn) != FAILED)
 						scsi_eh_finish_cmd(scmd,
 								   done_q);
 				}
-- 
1.7.12.4

