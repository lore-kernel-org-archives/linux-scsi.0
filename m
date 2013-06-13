From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Fix erratic device offline during EH
Date: Thu, 13 Jun 2013 10:09:13 +0200
Message-ID: <1371110953-99904-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab3FMIJQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jun 2013 04:09:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>

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
 drivers/scsi/scsi_error.c  | 26 +++++++++++++++++---------
 drivers/scsi/sd.c          |  8 +++-----
 include/scsi/scsi_driver.h |  2 +-
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ea056e0..49bdc00 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -877,12 +877,6 @@ retry:
 
 	scsi_eh_restore_cmnd(scmd, &ses);
 
-	if (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
-		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
-		if (sdrv->eh_action)
-			rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
-	}
-
 	return rtn;
 }
 
@@ -900,6 +894,16 @@ static int scsi_request_sense(struct scsi_cmnd *scmd)
 	return scsi_send_eh_cmnd(scmd, NULL, 0, scmd->device->eh_timeout, ~0);
 }
 
+static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
+{
+	if (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
+		if (sdrv->eh_action)
+			rtn = sdrv->eh_action(scmd, rtn);
+	}
+	return rtn;
+}
+
 /**
  * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
  * @scmd:	Original SCSI cmd that eh has finished.
@@ -1071,7 +1075,9 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 
 		list_for_each_entry_safe(scmd, next, cmd_list, eh_entry)
 			if (scmd->device == sdev) {
-				if (finish_cmds)
+				if (finish_cmds &&
+				    (try_stu ||
+				     scsi_eh_action(scmd, SUCCESS) == SUCCESS))
 					scsi_eh_finish_cmd(scmd, done_q);
 				else
 					list_move_tail(&scmd->eh_entry, work_q);
@@ -1208,7 +1214,8 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			    !scsi_eh_tur(stu_scmd)) {
 				list_for_each_entry_safe(scmd, next,
 							  work_q, eh_entry) {
-					if (scmd->device == sdev)
+					if (scmd->device == sdev &&
+					    scsi_eh_action(scmd, SUCCESS) == SUCCESS)
 						scsi_eh_finish_cmd(scmd, done_q);
 				}
 			}
@@ -1274,7 +1281,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 			    !scsi_eh_tur(bdr_scmd)) {
 				list_for_each_entry_safe(scmd, next,
 							 work_q, eh_entry) {
-					if (scmd->device == sdev)
+					if (scmd->device == sdev &&
+					    scsi_eh_action(scmd, rtn) != FAILED)
 						scsi_eh_finish_cmd(scmd,
 								   done_q);
 				}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c1c5552..c4c16e3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -109,7 +109,7 @@ static int sd_suspend(struct device *);
 static int sd_resume(struct device *);
 static void sd_rescan(struct device *);
 static int sd_done(struct scsi_cmnd *);
-static int sd_eh_action(struct scsi_cmnd *, unsigned char *, int, int);
+static int sd_eh_action(struct scsi_cmnd *, int);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
@@ -1519,8 +1519,7 @@ static const struct block_device_operations sd_fops = {
  *	stored in eh_cmnd. The result of sending the eh command is
  *	passed in eh_disp.
  **/
-static int sd_eh_action(struct scsi_cmnd *scmd, unsigned char *eh_cmnd,
-			int eh_cmnd_len, int eh_disp)
+static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 {
 	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
 
@@ -1535,8 +1534,7 @@ static int sd_eh_action(struct scsi_cmnd *scmd, unsigned char *eh_cmnd,
 	 * process of recovering or has it suffered an internal failure
 	 * that prevents access to the storage medium.
 	 */
-	if (host_byte(scmd->result) == DID_TIME_OUT && eh_disp == SUCCESS &&
-	    eh_cmnd_len && eh_cmnd[0] == TEST_UNIT_READY)
+	if (host_byte(scmd->result) == DID_TIME_OUT && eh_disp == SUCCESS)
 		sdkp->medium_access_timed_out++;
 
 	/*
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index d443aa0..20fdfc2 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -16,7 +16,7 @@ struct scsi_driver {
 
 	void (*rescan)(struct device *);
 	int (*done)(struct scsi_cmnd *);
-	int (*eh_action)(struct scsi_cmnd *, unsigned char *, int, int);
+	int (*eh_action)(struct scsi_cmnd *, int);
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
-- 
1.7.12.4

