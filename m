From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/27] zfcp: Replace fsf_req wait_queue with completion
Date: Tue, 18 Aug 2009 15:43:14 +0200
Message-ID: <20090818135029.922611000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:56317 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759008AbZHRNuj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:39 -0400
Content-Disposition: inline; filename=710-zfcp-fsfreq-complete.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The combination wait_queue/wakeup in conjunction with the flag
ZFCP_STATUS_FSFREQ_COMPLETED to signal the completion of an fsfreq
was not race-safe and can be better solved by a completion.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h  |    3 +--
 drivers/s390/scsi/zfcp_erp.c  |    3 +--
 drivers/s390/scsi/zfcp_fsf.c  |   26 ++++++--------------------
 drivers/s390/scsi/zfcp_scsi.c |    6 ++----
 4 files changed, 10 insertions(+), 28 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2009-08-12 10:05:31.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2009-08-12 10:05:31.000000000 +0200
@@ -248,7 +248,6 @@ enum zfcp_wka_status {
 
 /* FSF request status (this does not have a common part) */
 #define ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT	0x00000002
-#define ZFCP_STATUS_FSFREQ_COMPLETED		0x00000004
 #define ZFCP_STATUS_FSFREQ_ERROR		0x00000008
 #define ZFCP_STATUS_FSFREQ_CLEANUP		0x00000010
 #define ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED	0x00000040
@@ -532,7 +531,7 @@ struct zfcp_fsf_req {
 	u8		       sbale_curr;     /* current SBALE during creation
 						  of request */
 	u8			sbal_response;	/* SBAL used in interrupt */
-	wait_queue_head_t      completion_wq;  /* can be used by a routine
+	struct completion	completion;	/* can be used by a routine
 						  to wait for completion */
 	u32			status;	       /* status of this request */
 	u32		       fsf_command;    /* FSF Command copy */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-08-12 10:05:31.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-08-12 10:05:31.000000000 +0200
@@ -485,8 +485,7 @@ static void zfcp_erp_strategy_check_fsfr
 		}
 		if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
 			zfcp_rec_dbf_event_action("erscf_2", act);
-		if (act->fsf_req->status & (ZFCP_STATUS_FSFREQ_COMPLETED |
-					    ZFCP_STATUS_FSFREQ_DISMISSED))
+		if (act->fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED)
 			act->fsf_req = NULL;
 	} else
 		act->fsf_req = NULL;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-08-12 10:05:31.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-08-12 10:05:31.000000000 +0200
@@ -444,23 +444,11 @@ static void zfcp_fsf_req_complete(struct
 
 	if (req->erp_action)
 		zfcp_erp_notify(req->erp_action, 0);
-	req->status |= ZFCP_STATUS_FSFREQ_COMPLETED;
 
 	if (likely(req->status & ZFCP_STATUS_FSFREQ_CLEANUP))
 		zfcp_fsf_req_free(req);
 	else
-	/* notify initiator waiting for the requests completion */
-	/*
-	 * FIXME: Race! We must not access fsf_req here as it might have been
-	 * cleaned up already due to the set ZFCP_STATUS_FSFREQ_COMPLETED
-	 * flag. It's an improbable case. But, we have the same paranoia for
-	 * the cleanup flag already.
-	 * Might better be handled using complete()?
-	 * (setting the flag and doing wakeup ought to be atomic
-	 *  with regard to checking the flag as long as waitqueue is
-	 *  part of the to be released structure)
-	 */
-		wake_up(&req->completion_wq);
+		complete(&req->completion);
 }
 
 /**
@@ -733,7 +721,7 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 
 	INIT_LIST_HEAD(&req->list);
 	init_timer(&req->timer);
-	init_waitqueue_head(&req->completion_wq);
+	init_completion(&req->completion);
 
 	req->adapter = adapter;
 	req->fsf_command = fsf_cmd;
@@ -1309,8 +1297,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 	retval = zfcp_fsf_req_send(req);
 	spin_unlock_bh(&adapter->req_q_lock);
 	if (!retval)
-		wait_event(req->completion_wq,
-			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+		wait_for_completion(&req->completion);
 
 	zfcp_fsf_req_free(req);
 	return retval;
@@ -1405,8 +1392,8 @@ int zfcp_fsf_exchange_port_data_sync(str
 	spin_unlock_bh(&adapter->req_q_lock);
 
 	if (!retval)
-		wait_event(req->completion_wq,
-			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+		wait_for_completion(&req->completion);
+
 	zfcp_fsf_req_free(req);
 
 	return retval;
@@ -2572,8 +2559,7 @@ out:
 	spin_unlock_bh(&adapter->req_q_lock);
 
 	if (!retval) {
-		wait_event(req->completion_wq,
-			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+		wait_for_completion(&req->completion);
 		return req;
 	}
 	return ERR_PTR(retval);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2009-08-12 10:05:28.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2009-08-12 10:05:31.000000000 +0200
@@ -206,8 +206,7 @@ static int zfcp_scsi_eh_abort_handler(st
 	if (!abrt_req)
 		return FAILED;
 
-	wait_event(abrt_req->completion_wq,
-		   abrt_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+	wait_for_completion(&abrt_req->completion);
 
 	if (abrt_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED)
 		dbf_tag = "okay";
@@ -246,8 +245,7 @@ static int zfcp_task_mgmt_function(struc
 	if (!fsf_req)
 		return FAILED;
 
-	wait_event(fsf_req->completion_wq,
-		   fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+	wait_for_completion(&fsf_req->completion);
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED) {
 		zfcp_scsi_dbf_event_devreset("fail", tm_flags, unit, scpnt);

