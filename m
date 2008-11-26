From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/6] zfcp: eliminate race between validation and locking
Date: Wed, 26 Nov 2008 18:07:39 +0100
Message-ID: <20081126171021.068167000@de.ibm.com>
References: <20081126170734.940419000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:62145 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYKZRKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 12:10:23 -0500
Content-Disposition: inline; filename=701-zfcp-race.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The check of having a valid pointer was performed before the
processing was secured by the lock. Between those two steps the
pointer can turn invalid.  During further processing another value is
used (referenced by the pointer described above) as a function pointer
which is never verified to be valid either, resulting under some
circumstances in an invalid function call.  This patch is fixing both
issues.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-11-26 17:01:47.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-11-26 17:02:05.000000000 +0100
@@ -2116,18 +2116,21 @@ static inline void zfcp_fsf_trace_latenc
 
 static void zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *req)
 {
-	struct scsi_cmnd *scpnt = req->data;
+	struct scsi_cmnd *scpnt;
 	struct fcp_rsp_iu *fcp_rsp_iu = (struct fcp_rsp_iu *)
 	    &(req->qtcb->bottom.io.fcp_rsp);
 	u32 sns_len;
 	char *fcp_rsp_info = (unsigned char *) &fcp_rsp_iu[1];
 	unsigned long flags;
 
-	if (unlikely(!scpnt))
-		return;
-
 	read_lock_irqsave(&req->adapter->abort_lock, flags);
 
+	scpnt = req->data;
+	if (unlikely(!scpnt)) {
+		read_unlock_irqrestore(&req->adapter->abort_lock, flags);
+		return;
+	}
+
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ABORTED)) {
 		set_host_byte(scpnt, DID_SOFT_ERROR);
 		set_driver_byte(scpnt, SUGGEST_RETRY);

-- 
