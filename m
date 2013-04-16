From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH  V2 1/1] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Tue, 16 Apr 2013 15:26:26 -0500
Message-ID: <20130416203310.517593092@linux.vnet.ibm.com>
References: <20130416202625.962009312@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:25388 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S964899Ab3DPUfl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Apr 2013 16:35:41 -0400
Content-Disposition: inline; filename=scsi_error_v2
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

We discussed James's concern. We intergated James's patch and generated
this updated patch.

Fix scsi_send_eh_cmnd to check the return code of queuecommand when
sending commands and retry for a bit if the LLDD returns a busy response.
This fixes an issue seen with the ipr driver where an ipr initiated reset
immediately following an eh_host_reset caused EH initiated commands to fail,
resulting in devices being taken offline. This patch resolves the issue.


Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

Index: b/drivers/scsi/scsi_error.c
===================================================================
--- a/drivers/scsi/scsi_error.c	2013-04-16 12:56:16.617857960 -0500
+++ b/drivers/scsi/scsi_error.c	2013-04-16 12:57:00.279108838 -0500
@@ -791,18 +791,21 @@ static int scsi_send_eh_cmnd(struct scsi
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
 	DECLARE_COMPLETION_ONSTACK(done);
-	unsigned long timeleft;
+	unsigned long timeleft = timeout;
 	struct scsi_eh_save ses;
+	const int stall_for = min(HZ/10, 1);
 	int rtn;
 
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
+retry:
 	shost->eh_action = &done;
 
 	scsi_log_send(scmd);
 	scmd->scsi_done = scsi_eh_done;
-	shost->hostt->queuecommand(shost, scmd);
+	rtn = shost->hostt->queuecommand(shost, scmd);
 
-	timeleft = wait_for_completion_timeout(&done, timeout);
+	if (!rtn)
+		timeleft = wait_for_completion_timeout(&done, timeout);
 
 	shost->eh_action = NULL;
 
@@ -819,10 +822,19 @@ static int scsi_send_eh_cmnd(struct scsi
 	 * about this command.
 	 */
 	if (timeleft) {
-		rtn = scsi_eh_completed_normally(scmd);
-		SCSI_LOG_ERROR_RECOVERY(3,
-			printk("%s: scsi_eh_completed_normally %x\n",
-			       __func__, rtn));
+		switch (rtn) {
+		case 0:
+			rtn = scsi_eh_completed_normally(scmd);
+			SCSI_LOG_ERROR_RECOVERY(3,
+				printk("%s: scsi_eh_completed_normally %x\n",
+				       __func__, rtn));
+			break;
+		case FAILED:
+			break;
+		default:
+			rtn = ADD_TO_MLQUEUE;
+			break;
+		}
 
 		switch (rtn) {
 		case SUCCESS:
@@ -831,8 +843,12 @@ static int scsi_send_eh_cmnd(struct scsi
 		case TARGET_ERROR:
 			break;
 		case ADD_TO_MLQUEUE:
-			rtn = NEEDS_RETRY;
-			break;
+			if (timeleft > stall_for) {
+				timeout = timeleft - stall_for;
+				msleep(stall_for);
+				goto retry;
+			}
+			/* fall through */
 		default:
 			rtn = FAILED;
 			break;

-- 
