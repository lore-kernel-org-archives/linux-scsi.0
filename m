From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 6/6] zfcp: Hold queue lock when checking port/unit handle for task management cmd
Date: Thu, 20 Dec 2007 12:30:27 +0100
Message-ID: <20071220113235.684212000@de.ibm.com>
References: <20071220113021.955597000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:20734 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbXLTLci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 06:32:38 -0500
Content-Disposition: inline; filename=812-zfcp-lock4.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

We need to hold the queue-lock when checking whether we still have a valid
unit/port handle for the task management command, i.e whether we can issue this
request for this unit/port. If the error recovery is about to close this
unit/port, then it competes for the queue-lock. If the close request issued by
the error recovery wins, then it is guaranteed that this unit/port has been
blocked for other requests.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2007-12-20 11:19:01.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2007-12-20 11:19:19.000000000 +0100
@@ -3774,6 +3774,10 @@ zfcp_fsf_send_fcp_command_task_managemen
 		goto out;
 	}
 
+	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
+			&unit->status)))
+		goto unit_blocked;
+
 	/*
 	 * Used to decide on proper handler in the return path,
 	 * could be either zfcp_fsf_send_fcp_command_task_handler or
@@ -3807,25 +3811,13 @@ zfcp_fsf_send_fcp_command_task_managemen
 
 	zfcp_fsf_start_timer(fsf_req, ZFCP_SCSI_ER_TIMEOUT);
 	retval = zfcp_fsf_req_send(fsf_req);
-	if (retval) {
-		ZFCP_LOG_INFO("error: Could not send an FCP-command (task "
-			      "management) on adapter %s, port 0x%016Lx for "
-			      "unit LUN 0x%016Lx\n",
-			      zfcp_get_busid_by_adapter(adapter),
-			      unit->port->wwpn,
-			      unit->fcp_lun);
-		zfcp_fsf_req_free(fsf_req);
-		fsf_req = NULL;
+	if (!retval)
 		goto out;
-	}
 
-	ZFCP_LOG_TRACE("Send FCP Command (task management function) initiated "
-		       "(adapter %s, port 0x%016Lx, unit 0x%016Lx, "
-		       "tm_flags=0x%x)\n",
-		       zfcp_get_busid_by_adapter(adapter),
-		       unit->port->wwpn,
-		       unit->fcp_lun,
-		       tm_flags);
+ unit_blocked:
+	zfcp_fsf_req_free(fsf_req);
+	fsf_req = NULL;
+
  out:
 	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
 	return fsf_req;

-- 
