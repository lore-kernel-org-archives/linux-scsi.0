From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] libsas: don't treat underrun as an error on SMP tasks
Date: Sat, 29 Dec 2007 11:49:53 -0600
Message-ID: <1198950594.3264.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34665 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326AbXL2Rt7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Dec 2007 12:49:59 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 0235E80F3
	for <linux-scsi@vger.kernel.org>; Sat, 29 Dec 2007 11:49:56 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.il.steeleye.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RgXDAlAe2ofy for <linux-scsi@vger.kernel.org>;
	Sat, 29 Dec 2007 11:49:55 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id D972F80E2
	for <linux-scsi@vger.kernel.org>; Sat, 29 Dec 2007 11:49:54 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

All SMP tasks sent through bsg generate messages like:

sas: smp_execute_task: task to dev 500605b000001450 response: 0x0 status 0x81

Three times (because the task gets retried).  Firstly, don't retry
either overrun or underrun (the data buffer isn't going to change size)
and secondly, just report the underrun but don't set an error for it.
This is necessary so bsg can report back the residual.

James

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 76555b1..1578059 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -109,6 +109,16 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 		    task->task_status.stat == SAM_GOOD) {
 			res = 0;
 			break;
+		} if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		      task->task_status.stat == SAS_DATA_UNDERRUN) {
+			/* no error, but return the number of bytes of
+			 * underrun */
+			res = task->task_status.residual;
+			break;
+		} if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		      task->task_status.stat == SAS_DATA_OVERRUN) {
+			res = -EMSGSIZE;
+			break;
 		} else {
 			SAS_DPRINTK("%s: task to dev %016llx response: 0x%x "
 				    "status 0x%x\n", __FUNCTION__,
@@ -1924,6 +1934,11 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	ret = smp_execute_task(dev, bio_data(req->bio), req->data_len,
 			       bio_data(rsp->bio), rsp->data_len);
+	if (ret > 0) {
+		/* positive number is the untransferred residual */
+		rsp->data_len = ret;
+		ret = 0;
+	}
 
 	return ret;
 }


