From: Brian King <brking@us.ibm.com>
Subject: [PATCH] Fix eh_abort race condition
Date: Wed, 25 Feb 2004 10:11:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <403CC931.8080309@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050304050203010600040000"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:36343 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261377AbUBYQLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 11:11:32 -0500
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e4.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i1PGBVG9866936
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2004 11:11:31 -0500
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i1PGBcwJ108596
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2004 11:11:38 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050304050203010600040000
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The following patch fixes the race condition discussed here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=107757213405773&w=2



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------050304050203010600040000
Content-Type: text/plain;
 name="patch-2.6.3-eh_abort.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-2.6.3-eh_abort.patch"


The following patch fixes a race condition in abort processing. With this
patch, the mid-layer can now guarantee to LLDs that it will only call
eh_abort for ops which returned 0 in queuecommand and have not yet had 
their ->done function called.

---


diff -puN drivers/scsi/scsi_error.c~eh_abort drivers/scsi/scsi_error.c
--- linux-2.6.3/drivers/scsi/scsi_error.c~eh_abort	Wed Feb 25 09:54:52 2004
+++ linux-2.6.3-bjking1/drivers/scsi/scsi_error.c	Wed Feb 25 09:54:52 2004
@@ -471,8 +471,9 @@ static int scsi_send_eh_cmnd(struct scsi
 		 * we should treat them differently anyways.
 		 */
 		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		if (scmd->device->host->hostt->eh_abort_handler)
-			scmd->device->host->hostt->eh_abort_handler(scmd);
+		if (scmd->serial_number != 0)
+			if (scmd->device->host->hostt->eh_abort_handler)
+				scmd->device->host->hostt->eh_abort_handler(scmd);
 		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 			
 		scmd->request->rq_status = RQ_SCSI_DONE;
@@ -687,17 +688,17 @@ static int scsi_try_to_abort_cmd(struct 
 	if (!scmd->device->host->hostt->eh_abort_handler)
 		return rtn;
 
+	spin_lock_irqsave(scmd->device->host->host_lock, flags);
 	/*
 	 * scsi_done was called just after the command timed out and before
 	 * we had a chance to process it. (db)
 	 */
-	if (scmd->serial_number == 0)
-		return SUCCESS;
-
-	scmd->owner = SCSI_OWNER_LOWLEVEL;
-
-	spin_lock_irqsave(scmd->device->host->host_lock, flags);
-	rtn = scmd->device->host->hostt->eh_abort_handler(scmd);
+	if (scmd->serial_number == 0) {
+		rtn = SUCCESS;
+	} else {
+		scmd->owner = SCSI_OWNER_LOWLEVEL;
+		rtn = scmd->device->host->hostt->eh_abort_handler(scmd);
+	}
 	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	return rtn;

_

--------------050304050203010600040000--

