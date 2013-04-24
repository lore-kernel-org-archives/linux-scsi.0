From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH][v3] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Wed, 24 Apr 2013 13:32:48 +0200
Message-ID: <1366803168-79391-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab3DXLcu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 07:32:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>

scsi_send_eh_cmnd() is calling queuecommand() directly, so
it needs to check the return value here.
The only valid return codes for queuecommand() are 'busy'
states, so we need to wait for a bit to allow the LLDD
to recover.

Based on an earlier patch from Wen Xiong.

Cc: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..1fc6da94 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -791,22 +791,32 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
 	DECLARE_COMPLETION_ONSTACK(done);
-	unsigned long timeleft;
+	unsigned long timeleft = timeout;
 	struct scsi_eh_save ses;
+	const int stall_for = min(HZ/10, 1);
 	int rtn;
 
+retry:
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
 	shost->eh_action = &done;
 
 	scsi_log_send(scmd);
 	scmd->scsi_done = scsi_eh_done;
-	shost->hostt->queuecommand(shost, scmd);
-
-	timeleft = wait_for_completion_timeout(&done, timeout);
+	rtn = shost->hostt->queuecommand(shost, scmd);
+	if (rtn) {
+		if (timeleft) {
+			scsi_eh_restore_cmnd(scmd, &ses);
+			timeleft -= stall_for;
+			msleep(stall_for);
+			goto retry;
+		}
+		rtn = NEEDS_RETRY;
+	} else
+		timeleft = wait_for_completion_timeout(&done, timeout);
 
 	shost->eh_action = NULL;
 
-	scsi_log_completion(scmd, SUCCESS);
+	scsi_log_completion(scmd, rtn);
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s: scmd: %p, timeleft: %ld\n",
@@ -837,7 +847,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 			rtn = FAILED;
 			break;
 		}
-	} else {
+	} else if (!rtn) {
 		scsi_abort_eh_cmnd(scmd);
 		rtn = FAILED;
 	}
