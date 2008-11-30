From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 4/7] make scsi_eh_try_stu use block timeout
Date: Sun, 30 Nov 2008 10:32:26 -0600
Message-ID: <1228062746.4115.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:32866 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbYK3Qc0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 11:32:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <Jens.Axboe@oracle.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

scsi_eh_try_stu() was still using the timeout parameter in the device
which is now not set (i.e. zero filled) meaning that it waited no time
at all for the start unit command to complete (leading the routine to
conclude failure every time).  This lead to a 2.6.27 regression:

http://bugzilla.kernel.org/show_bug.cgi?id=12120

Where firewire devices that were non spec compliant wouldn't spin up.

Fix this by using the block queue timeout value instead.

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d07bb3e..381838e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -933,8 +933,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 		int i, rtn = NEEDS_RETRY;
 
 		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
-			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
-						scmd->device->timeout, 0);
+			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->request_queue->rq_timeout, 0);
 
 		if (rtn == SUCCESS)
 			return 0;


