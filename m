From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 13/13] zfcp: Fix tracing of request id for abort requests
Date: Mon, 13 Jul 2009 15:06:14 +0200
Message-ID: <20090713131044.406042000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:54840 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbZGMNKq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:10:46 -0400
Content-Disposition: inline; filename=720-zfcp-trace-records.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The trace record for SCSI abort requests has a field for the request
id of the request to be aborted. Put the real request id instead of
zero.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2009-07-13 10:27:03.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-07-13 10:36:07.000000000 +0200
@@ -167,20 +167,21 @@ static int zfcp_scsi_eh_abort_handler(st
 	struct zfcp_unit *unit = scpnt->device->hostdata;
 	struct zfcp_fsf_req *old_req, *abrt_req;
 	unsigned long flags;
-	unsigned long old_req_id = (unsigned long) scpnt->host_scribble;
+	unsigned long old_reqid = (unsigned long) scpnt->host_scribble;
 	int retval = SUCCESS;
 	int retry = 3;
+	char *dbf_tag;
 
 	/* avoid race condition between late normal completion and abort */
 	write_lock_irqsave(&adapter->abort_lock, flags);
 
 	spin_lock(&adapter->req_list_lock);
-	old_req = zfcp_reqlist_find(adapter, old_req_id);
+	old_req = zfcp_reqlist_find(adapter, old_reqid);
 	spin_unlock(&adapter->req_list_lock);
 	if (!old_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
 		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL,
-					  old_req_id);
+					  old_reqid);
 		return FAILED; /* completion could be in progress */
 	}
 	old_req->data = NULL;
@@ -189,7 +190,7 @@ static int zfcp_scsi_eh_abort_handler(st
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
 
 	while (retry--) {
-		abrt_req = zfcp_fsf_abort_fcp_command(old_req_id, unit);
+		abrt_req = zfcp_fsf_abort_fcp_command(old_reqid, unit);
 		if (abrt_req)
 			break;
 
@@ -197,7 +198,7 @@ static int zfcp_scsi_eh_abort_handler(st
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
 			zfcp_scsi_dbf_event_abort("nres", adapter, scpnt, NULL,
-						  old_req_id);
+						  old_reqid);
 			return SUCCESS;
 		}
 	}
@@ -208,13 +209,14 @@ static int zfcp_scsi_eh_abort_handler(st
 		   abrt_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
 	if (abrt_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED)
-		zfcp_scsi_dbf_event_abort("okay", adapter, scpnt, abrt_req, 0);
+		dbf_tag = "okay";
 	else if (abrt_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED)
-		zfcp_scsi_dbf_event_abort("lte2", adapter, scpnt, abrt_req, 0);
+		dbf_tag = "lte2";
 	else {
-		zfcp_scsi_dbf_event_abort("fail", adapter, scpnt, abrt_req, 0);
+		dbf_tag = "fail";
 		retval = FAILED;
 	}
+	zfcp_scsi_dbf_event_abort(dbf_tag, adapter, scpnt, abrt_req, old_reqid);
 	zfcp_fsf_req_free(abrt_req);
 	return retval;
 }

