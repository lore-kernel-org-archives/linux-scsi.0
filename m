From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] fix scsi_send_eh_cmnd regression
Date: Sat, 26 Aug 2006 03:00:22 -0400
Message-ID: <1156575622.2828.4.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49594 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1422731AbWHZIAX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Aug 2006 04:00:23 -0400
Received: from [192.168.0.5] (CPE-70-92-133-61.mn.res.rr.com [70.92.133.61])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k7Q80MII024247
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 26 Aug 2006 03:00:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The callers of scsi_send_eh_cmnd are setting the cmnd buffer,
and then scsi_send_eh_cmnd is copying that updated buffer to
the old_cmnd variable. Then after the command runs, we end up
copying that old_cmnd var which has the new cmnd to the scsi
command buffer. When this command gets recent, all types of fun
things happen like getting TUR or START_STOP commands with
data and scatterlists.

This patch made against scsi-rc-fixes, has the callers of
scsi_send_eh_cmnd pass in the command so scsi_send_eh_cmnd
can do the right thing. This should go into 2.6.18 since this
fixes a regression added when we removed some of the scsi_cmnd
fields and replaced them with local variables.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6a5b731..a8ed5a2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -460,7 +460,8 @@ static void scsi_eh_done(struct scsi_cmn
  * Return value:
  *    SUCCESS or FAILED or NEEDS_RETRY
  **/
-static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, int timeout, int copy_sense)
+static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
+			     int cmnd_size, int timeout, int copy_sense)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
@@ -490,6 +491,9 @@ static int scsi_send_eh_cmnd(struct scsi
 	old_cmd_len = scmd->cmd_len;
 	old_use_sg = scmd->use_sg;
 
+	memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
+	memcpy(scmd->cmnd, cmnd, cmnd_size);
+
 	if (copy_sense) {
 		int gfp_mask = GFP_ATOMIC;
 
@@ -610,8 +614,7 @@ static int scsi_request_sense(struct scs
 	static unsigned char generic_sense[6] =
 		{REQUEST_SENSE, 0, 0, 0, 252, 0};
 
-	memcpy(scmd->cmnd, generic_sense, sizeof(generic_sense));
-	return scsi_send_eh_cmnd(scmd, SENSE_TIMEOUT, 1);
+	return scsi_send_eh_cmnd(scmd, generic_sense, 6, SENSE_TIMEOUT, 1);
 }
 
 /**
@@ -736,10 +739,7 @@ static int scsi_eh_tur(struct scsi_cmnd 
 	int retry_cnt = 1, rtn;
 
 retry_tur:
-	memcpy(scmd->cmnd, tur_command, sizeof(tur_command));
-
-
-	rtn = scsi_send_eh_cmnd(scmd, SENSE_TIMEOUT, 0);
+	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6, SENSE_TIMEOUT, 0);
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd %p rtn %x\n",
 		__FUNCTION__, scmd, rtn));
@@ -839,8 +839,8 @@ static int scsi_eh_try_stu(struct scsi_c
 	if (scmd->device->allow_restart) {
 		int rtn;
 
-		memcpy(scmd->cmnd, stu_command, sizeof(stu_command));
-		rtn = scsi_send_eh_cmnd(scmd, START_UNIT_TIMEOUT, 0);
+		rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
+					START_UNIT_TIMEOUT, 0);
 		if (rtn == SUCCESS)
 			return 0;
 	}


