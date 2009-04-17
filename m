From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 11/15] zfcp: Fix abort handler for completions in progress
Date: Fri, 17 Apr 2009 15:08:11 +0200
Message-ID: <20090417131123.260036000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:39895 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939AbZDQNML (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:12:11 -0400
Content-Disposition: inline; filename=711-zfcp-abort-handler.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When the abort handler cannot find a pending FSF request, the request
completion could just be running. This means we cannot return SUCCESS,
since this would lead to call to scsi_done after exiting the SCSI
error handler which is not allowed.

Reviewed-by: Martin Petermann <martin@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2009-04-17 15:03:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-04-17 15:03:49.000000000 +0200
@@ -171,7 +171,7 @@ static int zfcp_scsi_eh_abort_handler(st
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
 		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL,
 					  old_req_id);
-		return SUCCESS;
+		return FAILED; /* completion could be in progress */
 	}
 	old_req->data = NULL;
 

