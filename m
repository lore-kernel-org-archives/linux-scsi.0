From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] scsi: Fix erratic device offline during EH
Date: Thu, 31 Oct 2013 14:02:51 +0100
Message-ID: <1383224573-113346-2-git-send-email-hare@suse.de>
References: <1383224573-113346-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab3JaNC6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Oct 2013 09:02:58 -0400
In-Reply-To: <1383224573-113346-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Hannes Reinecke <hare@suse.de>

From: James Bottomley <jbottomley@parallels.com>

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

This patch moves the check to the final test, eliminating
this problem.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <jbottomley@parallels.com>
---
 drivers/scsi/scsi_error.c  | 26 +++++++++++++++++---------
 drivers/scsi/sd.c          | 26 ++++++++++++--------------
 include/scsi/scsi_driver.h |  2 +-
 3 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index e8bee9f..67c0014 100644
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
 
@@ -964,6 +958,16 @@ static int scsi_request_sense(struct scsi_cmnd *scmd)
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
@@ -1142,7 +1146,9 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 
 		list_for_each_entry_safe(scmd, next, cmd_list, eh_entry)
 			if (scmd->device == sdev) {
-				if (finish_cmds)
+				if (finish_cmds &&
+				    (try_stu ||
+				     scsi_eh_action(scmd, SUCCESS) == SUCCESS))
 					scsi_eh_finish_cmd(scmd, done_q);
 				else
 					list_move_tail(&scmd->eh_entry, work_q);
@@ -1283,7 +1289,8 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			    !scsi_eh_tur(stu_scmd)) {
 				list_for_each_entry_safe(scmd, next,
 							  work_q, eh_entry) {
-					if (scmd->device == sdev)
+					if (scmd->device == sdev &&
+					    scsi_eh_action(scmd, SUCCESS) == SUCCESS)
 						scsi_eh_finish_cmd(scmd, done_q);
 				}
 			}
@@ -1350,7 +1357,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
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
index fd874b8..1929838 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -110,7 +110,7 @@ static int sd_suspend_runtime(struct device *);
 static int sd_resume(struct device *);
 static void sd_rescan(struct device *);
 static int sd_done(struct scsi_cmnd *);
-static int sd_eh_action(struct scsi_cmnd *, unsigned char *, int, int);
+static int sd_eh_action(struct scsi_cmnd *, int);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
@@ -1551,23 +1551,23 @@ static const struct block_device_operations sd_fops = {
 /**
  *	sd_eh_action - error handling callback
  *	@scmd:		sd-issued command that has failed
- *	@eh_cmnd:	The command that was sent during error handling
- *	@eh_cmnd_len:	Length of eh_cmnd in bytes
  *	@eh_disp:	The recovery disposition suggested by the midlayer
  *
- *	This function is called by the SCSI midlayer upon completion of
- *	an error handling command (TEST UNIT READY, START STOP UNIT,
- *	etc.) The command sent to the device by the error handler is
- *	stored in eh_cmnd. The result of sending the eh command is
- *	passed in eh_disp.
+ *	This function is called by the SCSI midlayer upon completion of an
+ *	error test command (currently TEST UNIT READY). The result of sending
+ *	the eh command is passed in eh_disp.  We're looking for devices that
+ *	fail medium access commands but are OK with non access commands like
+ *	test unit ready (so wrongly see the device as having a successful
+ *	recovery)
  **/
-static int sd_eh_action(struct scsi_cmnd *scmd, unsigned char *eh_cmnd,
-			int eh_cmnd_len, int eh_disp)
+static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 {
 	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
 
 	if (!scsi_device_online(scmd->device) ||
-	    !scsi_medium_access_command(scmd))
+	    !scsi_medium_access_command(scmd) ||
+	    host_byte(scmd->result) != DID_TIME_OUT ||
+	    eh_disp != SUCCESS)
 		return eh_disp;
 
 	/*
@@ -1577,9 +1577,7 @@ static int sd_eh_action(struct scsi_cmnd *scmd, unsigned char *eh_cmnd,
 	 * process of recovering or has it suffered an internal failure
 	 * that prevents access to the storage medium.
 	 */
-	if (host_byte(scmd->result) == DID_TIME_OUT && eh_disp == SUCCESS &&
-	    eh_cmnd_len && eh_cmnd[0] == TEST_UNIT_READY)
-		sdkp->medium_access_timed_out++;
+	sdkp->medium_access_timed_out++;
 
 	/*
 	 * If the device keeps failing read/write commands but TEST UNIT
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
1.8.1.4

