From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/6] zfcp: Hold queue lock when checking port/unit handle for abort command
Date: Thu, 20 Dec 2007 12:30:24 +0100
Message-ID: <20071220113233.502622000@de.ibm.com>
References: <20071220113021.955597000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:58184 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbXLTLcg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 06:32:36 -0500
Content-Disposition: inline; filename=809-zfcp-lock1.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

We need to hold the queue-lock when checking whether we still have a valid
unit/port handle for the abort command, i.e whether we can issue this request
for this unit/port. If the error recovery is about to close this unit/port,
then it competes for the queue-lock. If the close request issued by the error
recovery wins, then it is guaranteed that this unit/port has been blocked for
other requests.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2007-12-20 11:18:03.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2007-12-20 11:18:23.000000000 +0100
@@ -1116,6 +1116,10 @@ zfcp_fsf_abort_fcp_command(unsigned long
 		goto out;
 	}
 
+	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
+			&unit->status)))
+		goto unit_blocked;
+
 	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
@@ -1131,22 +1135,13 @@ zfcp_fsf_abort_fcp_command(unsigned long
 
 	zfcp_fsf_start_timer(fsf_req, ZFCP_SCSI_ER_TIMEOUT);
 	retval = zfcp_fsf_req_send(fsf_req);
-	if (retval) {
-		ZFCP_LOG_INFO("error: Failed to send abort command request "
-			      "on adapter %s, port 0x%016Lx, unit 0x%016Lx\n",
-			      zfcp_get_busid_by_adapter(adapter),
-			      unit->port->wwpn, unit->fcp_lun);
+	if (!retval)
+		goto out;
+
+ unit_blocked:
 		zfcp_fsf_req_free(fsf_req);
 		fsf_req = NULL;
-		goto out;
-	}
 
-	ZFCP_LOG_DEBUG("Abort FCP Command request initiated "
-		       "(adapter%s, port d_id=0x%06x, "
-		       "unit x%016Lx, old_req_id=0x%lx)\n",
-		       zfcp_get_busid_by_adapter(adapter),
-		       unit->port->d_id,
-		       unit->fcp_lun, old_req_id);
  out:
 	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
 	return fsf_req;

-- 
