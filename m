From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] expose eh_timed_out to the host template
Date: Fri, 16 Mar 2007 17:44:41 -0500
Message-ID: <1174085081.3519.63.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60925 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992440AbXCPWon (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Mar 2007 18:44:43 -0400
Received: from [172.17.6.40] (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id l2GMifx32496
	for <linux-scsi@vger.kernel.org>; Fri, 16 Mar 2007 17:44:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

It looks like megaraid_sas at least needs this to throttle its commands
as they begin to time out.  The code keeps the existing transport
template use of eh_timed_out (and allows the transport to override the
host if they both have this callback).

James

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b8edcf5..7a1a1bb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -184,10 +184,19 @@ int scsi_delete_timer(struct scsi_cmnd *scmd)
  **/
 void scsi_times_out(struct scsi_cmnd *scmd)
 {
+	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
 	if (scmd->device->host->transportt->eh_timed_out)
-		switch (scmd->device->host->transportt->eh_timed_out(scmd)) {
+		eh_timed_out = scmd->device->host->transportt->eh_timed_out;
+	else if (scmd->device->host->hostt->eh_timed_out)
+		eh_timed_out = scmd->device->host->hostt->eh_timed_out;
+	else
+		eh_timed_out = NULL;
+
+	if (eh_timed_out)
+		switch (eh_timed_out(scmd)) {
 		case EH_HANDLED:
 			__scsi_done(scmd);
 			return;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 965b6b8..68f461b 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -326,6 +326,19 @@ struct scsi_host_template {
 	int (*proc_info)(struct Scsi_Host *, char *, char **, off_t, int, int);
 
 	/*
+	 * This is an optional routine that allows the transport to become
+	 * involved when a scsi io timer fires. The return value tells the
+	 * timer routine how to finish the io timeout handling:
+	 * EH_HANDLED:		I fixed the error, please complete the command
+	 * EH_RESET_TIMER:	I need more time, reset the timer and
+	 *			begin counting again
+	 * EH_NOT_HANDLED	Begin normal error recovery
+	 *
+	 * Status: OPTIONAL
+	 */
+	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+
+	/*
 	 * suspend support
 	 */
 	int (*resume)(struct scsi_device *);


