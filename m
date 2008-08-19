From: michaelc@cs.wisc.edu
Subject: [PATCH 9/9] scsi: modify scsi to handle new fail fast flags.
Date: Tue, 19 Aug 2008 18:45:31 -0500
Message-ID: <1219189531-5243-10-git-send-email-michaelc@cs.wisc.edu>
References: <1219189531-5243-1-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-2-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-3-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-4-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-5-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-6-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-7-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-8-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-9-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbYHSXqF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2008 19:46:05 -0400
In-Reply-To: <1219189531-5243-9-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This checks the errors the scsi-ml determined were retryable
and returns if we should fast fail it based on the request
fail fast flags.

Without the patch, drivers like lpfc, qla2xxx and fcoe would return
DID_ERROR for what it determines is a temporary communication problem.
There is no loss of connectivity at that time and the driver thinks
that it would be fast to retry at the driver level. SCSI-ml will however
sees fast fail on the request and DID_ERROR and will fast fail the io.
This will then cause dm-multipath to fail the path and possibley switch
target controllers when we should be retrying at the scsi layer.

We also were fast failing device errors to dm multiapth when
unless the scsi_dh modules think otherwis we want to retry at
the scsi layer because multipath can only retry the IO like scsi
should have done. multipath is a little dumber though because it
does not what the error was for and assumes that it should fail
the paths.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi_error.c |   38 ++++++++++++++++++++++++++++++++++++--
 drivers/scsi/scsi_lib.c   |    2 +-
 drivers/scsi/scsi_priv.h  |    1 +
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4e30343..d02ebc0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1280,6 +1280,40 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
 }
 
 /**
+ * scsi_noretry_cmd - determinte if command should be failed fast
+ * @scmd:	SCSI cmd to examine.
+ */
+int scsi_noretry_cmd(struct scsi_cmnd *scmd)
+{
+	switch (host_byte(scmd->result)) {
+	case DID_OK:
+		break;
+	case DID_BUS_BUSY:
+		return blk_failfast_transport(scmd->request);
+	case DID_PARITY:
+		return blk_failfast_dev(scmd->request);
+	case DID_ERROR:
+		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
+		    status_byte(scmd->result) == RESERVATION_CONFLICT)
+			return 0;
+		/* fall through */
+	case DID_SOFT_ERROR:
+		return blk_failfast_driver(scmd->request);
+	}
+
+	switch (status_byte(scmd->result)) {
+	case CHECK_CONDITION:
+		/*
+		 * assume caller has checked sense and determinted
+		 * the check condition was retryable.
+		 */
+		return blk_failfast_dev(scmd->request);
+	}
+
+	return 0;
+}
+
+/**
  * scsi_decide_disposition - Disposition a cmd on return from LLD.
  * @scmd:	SCSI cmd to examine.
  *
@@ -1457,7 +1491,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * even if the request is marked fast fail, we still requeue
 	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
 	if ((++scmd->retries) <= scmd->allowed
-	    && !blk_noretry_request(scmd->request)) {
+	    && !scsi_noretry_cmd(scmd)) {
 		return NEEDS_RETRY;
 	} else {
 		/*
@@ -1582,7 +1616,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
-		    !blk_noretry_request(scmd->request) &&
+		    !scsi_noretry_cmd(scmd) &&
 		    (++scmd->retries <= scmd->allowed)) {
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
 							  " retry cmd: %p\n",
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ff5d56b..4c95086 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -681,7 +681,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 			leftover = req->data_len;
 
 		/* kill remainder if no retrys */
-		if (error && blk_noretry_request(req))
+		if (error && scsi_noretry_cmd(cmd))
 			blk_end_request(req, error, leftover);
 		else {
 			if (requeue) {
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 79f0f75..cfbd8a5 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -62,6 +62,7 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *done_q);
 int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
+int scsi_noretry_cmd(struct scsi_cmnd *scmd);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
-- 
1.5.4.1

