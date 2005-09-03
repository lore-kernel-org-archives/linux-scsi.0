From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 4/7] zfcp: remove function zfcp_fsf_req_wait_and_cleanup
Date: Sat, 3 Sep 2005 14:32:56 +0200
Message-ID: <20050903123256.GA7923@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:2198 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751405AbVICMfM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 08:35:12 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j83CZBOI144888
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 12:35:11 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j83CZBih169514
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:35:11 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j83CZAF6014988
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:35:11 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: remove function zfcp_fsf_req_wait_and_cleanup

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

 zfcp_ext.h  |    1 -
 zfcp_fsf.c  |   46 ----------------------------------------------
 zfcp_scsi.c |   21 +++++++++------------
 3 files changed, 9 insertions(+), 59 deletions(-)

diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_ext.h linux-2.6.13/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_ext.h	2005-09-03 12:17:16.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_ext.h	2005-09-03 12:21:24.000000000 +0200
@@ -109,7 +109,6 @@ extern int zfcp_fsf_req_create(struct zf
 extern int zfcp_fsf_send_ct(struct zfcp_send_ct *, mempool_t *,
 			    struct zfcp_erp_action *);
 extern int zfcp_fsf_send_els(struct zfcp_send_els *);
-extern int  zfcp_fsf_req_wait_and_cleanup(struct zfcp_fsf_req *, int, u32 *);
 extern int  zfcp_fsf_send_fcp_command_task(struct zfcp_adapter *,
 					   struct zfcp_unit *,
 					   struct scsi_cmnd *,
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_fsf.c linux-2.6.13/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_fsf.c	2005-09-03 12:21:07.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_fsf.c	2005-09-03 12:21:24.000000000 +0200
@@ -4548,52 +4548,6 @@ skip_fsfstatus:
 	return retval;
 }
 
-
-/*
- * function:    zfcp_fsf_req_wait_and_cleanup
- *
- * purpose:
- *
- * FIXME(design): signal seems to be <0 !!!
- * returns:	0	- request completed (*status is valid), cleanup succ.
- *		<0	- request completed (*status is valid), cleanup failed
- *		>0	- signal which interrupted waiting (*status invalid),
- *			  request not completed, no cleanup
- *
- *		*status is a copy of status of completed fsf_req
- */
-int
-zfcp_fsf_req_wait_and_cleanup(struct zfcp_fsf_req *fsf_req,
-			      int interruptible, u32 * status)
-{
-	int retval = 0;
-	int signal = 0;
-
-	if (interruptible) {
-		__wait_event_interruptible(fsf_req->completion_wq,
-					   fsf_req->status &
-					   ZFCP_STATUS_FSFREQ_COMPLETED,
-					   signal);
-		if (signal) {
-			ZFCP_LOG_DEBUG("Caught signal %i while waiting for the "
-				       "completion of the request at %p\n",
-				       signal, fsf_req);
-			retval = signal;
-			goto out;
-		}
-	} else {
-		__wait_event(fsf_req->completion_wq,
-			     fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
-	}
-
-	*status = fsf_req->status;
-
-	/* cleanup request */
-	zfcp_fsf_req_free(fsf_req);
- out:
-	return retval;
-}
-
 static inline int
 zfcp_fsf_req_sbal_check(unsigned long *flags,
 			struct zfcp_qdio_queue *queue, int needed)
diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_scsi.c linux-2.6.13/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_scsi.c	2005-09-03 12:21:07.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_scsi.c	2005-09-03 12:21:24.000000000 +0200
@@ -614,9 +614,8 @@ static int
 zfcp_task_management_function(struct zfcp_unit *unit, u8 tm_flags)
 {
 	struct zfcp_adapter *adapter = unit->port->adapter;
-	int retval;
-	int status;
 	struct zfcp_fsf_req *fsf_req;
+	int retval = 0;
 
 	/* issue task management function */
 	fsf_req = zfcp_fsf_send_fcp_command_task_management
@@ -630,18 +629,16 @@ zfcp_task_management_function(struct zfc
 		goto out;
 	}
 
-	retval = zfcp_fsf_req_wait_and_cleanup(fsf_req,
-					       ZFCP_UNINTERRUPTIBLE, &status);
-	/*
-	 * check completion status of task management function
-	 * (status should always be valid since no signals permitted)
-	 */
-	if (status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED)
+	__wait_event(fsf_req->completion_wq,
+		     fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+
+	/* check completion status of task management function */
+	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED)
 		retval = -EIO;
-	else if (status & ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP)
+	else if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP)
 		retval = -ENOTSUPP;
-	else
-		retval = 0;
+
+	zfcp_fsf_req_free(fsf_req);
  out:
 	return retval;
 }
