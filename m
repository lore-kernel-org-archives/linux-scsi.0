From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Mon, 15 Apr 2013 13:39:50 -0500
Message-ID: <20130415184142.788994252@linux.vnet.ibm.com>
References: <20130415183949.678757952@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:56836 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S934872Ab3DOSoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Apr 2013 14:44:13 -0400
Content-Disposition: inline; filename=check_return_of_queuecommand
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Fix scsi_send_eh_cmnd to check the return code of queuecommand when
sending commands and retry for a bit if the LLDD returns a busy response.
This fixes an issue seen with the ipr driver where an ipr initiated reset
immediately following an eh_host_reset caused EH initiated commands to fail,
resulting in devices being taken offline. This patch resolves the issue.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

---
 drivers/scsi/scsi_error.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: b/drivers/scsi/scsi_error.c
===================================================================
--- a/drivers/scsi/scsi_error.c	2013-04-10 12:55:57.000000000 -0500
+++ b/drivers/scsi/scsi_error.c	2013-04-10 13:04:12.467858487 -0500
@@ -793,6 +793,7 @@ static int scsi_send_eh_cmnd(struct scsi
 	DECLARE_COMPLETION_ONSTACK(done);
 	unsigned long timeleft;
 	struct scsi_eh_save ses;
+	int attempts = 30;
 	int rtn;
 
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
@@ -800,7 +801,14 @@ static int scsi_send_eh_cmnd(struct scsi
 
 	scsi_log_send(scmd);
 	scmd->scsi_done = scsi_eh_done;
-	shost->hostt->queuecommand(shost, scmd);
+
+	while ((rtn = shost->hostt->queuecommand(shost, scmd)) && attempts) {
+		if (rtn == SCSI_MLQUEUE_DEVICE_BUSY ||
+		    rtn == SCSI_MLQUEUE_TARGET_BUSY ||
+		    rtn == SCSI_MLQUEUE_HOST_BUSY)
+			attempts--;
+		ssleep(1);
+	}
 
 	timeleft = wait_for_completion_timeout(&done, timeout);
 

-- 
