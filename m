From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/6] zfcp: Hold queue lock when checking port/unit handle for FCP command
Date: Thu, 20 Dec 2007 12:30:26 +0100
Message-ID: <20071220113234.922616000@de.ibm.com>
References: <20071220113021.955597000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:27157 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbXLTLch (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 06:32:37 -0500
Content-Disposition: inline; filename=811-zfcp-lock3.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

We need to hold the queue-lock when checking whether we still have a valid
unit/port handle for the FCP command, i.e whether we can issue this request for
this unit/port. If the error recovery is about to close this unit/port, then it
competes for the queue-lock. If the close request issued by the error recovery
wins, then it is guaranteed that this unit/port has been blocked for other
requests.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c  |    7 +++++++
 drivers/s390/scsi/zfcp_scsi.c |    8 +++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2007-12-20 11:18:42.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2007-12-20 11:19:01.000000000 +0100
@@ -3593,6 +3593,12 @@ zfcp_fsf_send_fcp_command_task(struct zf
 		goto failed_req_create;
 	}
 
+	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
+			&unit->status))) {
+		retval = -EBUSY;
+		goto unit_blocked;
+	}
+
 	zfcp_unit_get(unit);
 	fsf_req->unit = unit;
 
@@ -3733,6 +3739,7 @@ zfcp_fsf_send_fcp_command_task(struct zf
  send_failed:
  no_fit:
  failed_scsi_cmnd:
+ unit_blocked:
 	zfcp_unit_put(unit);
 	zfcp_fsf_req_free(fsf_req);
 	fsf_req = NULL;
--- a/drivers/s390/scsi/zfcp_scsi.c	2007-12-20 11:15:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2007-12-20 11:19:01.000000000 +0100
@@ -258,8 +258,9 @@ zfcp_scsi_command_async(struct zfcp_adap
 		goto out;
 	}
 
-	if (unlikely(
-	     !atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &unit->status))) {
+	tmp = zfcp_fsf_send_fcp_command_task(adapter, unit, scpnt, use_timer,
+					     ZFCP_REQ_AUTO_CLEANUP);
+	if (unlikely(tmp == -EBUSY)) {
 		ZFCP_LOG_DEBUG("adapter %s not ready or unit 0x%016Lx "
 			       "on port 0x%016Lx in recovery\n",
 			       zfcp_get_busid_by_unit(unit),
@@ -268,9 +269,6 @@ zfcp_scsi_command_async(struct zfcp_adap
 		goto out;
 	}
 
-	tmp = zfcp_fsf_send_fcp_command_task(adapter, unit, scpnt, use_timer,
-					     ZFCP_REQ_AUTO_CLEANUP);
-
 	if (unlikely(tmp < 0)) {
 		ZFCP_LOG_DEBUG("error: initiation of Send FCP Cmnd failed\n");
 		retval = SCSI_MLQUEUE_HOST_BUSY;

-- 
