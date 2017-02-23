From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH] qedf: fixup compilation warning about atomic_t usage
Date: Thu, 23 Feb 2017 07:01:03 -0800
Message-ID: <1487862063-28158-1-git-send-email-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0072.outbound.protection.outlook.com ([104.47.37.72]:6626
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751099AbdBWPBY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Feb 2017 10:01:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, hare@suse.de, QLogic-Storage-Upstream@cavium.com

From: "Dupuis, Chad" <chad.dupuis@cavium.com>

Based on an original patch by Hannes Reinecke.

The driver didn't follow the atomic_t vs refcount_t change, and
anyway one should be using kref_read() instead of accessing the
counter inside an kref.

Fixes: 61d8658b4a435e ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.)
Cc: Hannes Reinecke <hare@suse.de>
Cc: Nilesh Javali <nilesh.javali@cavium.com>
Signed-off-by: Dupuis, Chad <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_els.c | 6 +++---
 drivers/scsi/qedf/qedf_io.c  | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index 78f1c25..59f3e5c 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -183,7 +183,7 @@ static void qedf_rrq_compl(struct qedf_els_cb_arg *cb_arg)
 	    rrq_req->event != QEDF_IOREQ_EV_ELS_ERR_DETECT)
 		cancel_delayed_work_sync(&orig_io_req->timeout_work);
 
-	refcount = atomic_read(&orig_io_req->refcount.refcount);
+	refcount = kref_read(&orig_io_req->refcount);
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "rrq_compl: orig io = %p,"
 		   " orig xid = 0x%x, rrq_xid = 0x%x, refcount=%d\n",
 		   orig_io_req, orig_io_req->xid, rrq_req->xid, refcount);
@@ -474,7 +474,7 @@ static void qedf_srr_compl(struct qedf_els_cb_arg *cb_arg)
 	    srr_req->event != QEDF_IOREQ_EV_ELS_ERR_DETECT)
 		cancel_delayed_work_sync(&orig_io_req->timeout_work);
 
-	refcount = atomic_read(&orig_io_req->refcount.refcount);
+	refcount = kref_read(&orig_io_req->refcount);
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Entered: orig_io=%p,"
 		   " orig_io_xid=0x%x, rec_xid=0x%x, refcount=%d\n",
 		   orig_io_req, orig_io_req->xid, srr_req->xid, refcount);
@@ -758,7 +758,7 @@ static void qedf_rec_compl(struct qedf_els_cb_arg *cb_arg)
 	    rec_req->event != QEDF_IOREQ_EV_ELS_ERR_DETECT)
 		cancel_delayed_work_sync(&orig_io_req->timeout_work);
 
-	refcount = atomic_read(&orig_io_req->refcount.refcount);
+	refcount = kref_read(&orig_io_req->refcount);
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Entered: orig_io=%p,"
 		   " orig_io_xid=0x%x, rec_xid=0x%x, refcount=%d\n",
 		   orig_io_req, orig_io_req->xid, rec_req->xid, refcount);
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 486c045..ee0dcf9 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -998,7 +998,7 @@ static void qedf_trace_io(struct qedf_rport *fcport, struct qedf_ioreq *io_req,
 	io_log->sg_count = scsi_sg_count(sc_cmd);
 	io_log->result = sc_cmd->result;
 	io_log->jiffies = jiffies;
-	io_log->refcount = atomic_read(&io_req->refcount.refcount);
+	io_log->refcount = kref_read(&io_req->refcount);
 
 	if (direction == QEDF_IO_TRACE_REQ) {
 		/* For requests we only care abot the submission CPU */
@@ -1340,7 +1340,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 			/* Good I/O completion */
 			sc_cmd->result = DID_OK << 16;
 		} else {
-			refcount = atomic_read(&io_req->refcount.refcount);
+			refcount = kref_read(&io_req->refcount);
 			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO,
 			    "%d:0:%d:%d xid=0x%0x op=0x%02x "
 			    "lba=%02x%02x%02x%02x cdb_status=%d "
@@ -1425,7 +1425,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 	qedf_unmap_sg_list(qedf, io_req);
 
 	sc_cmd->result = result << 16;
-	refcount = atomic_read(&io_req->refcount.refcount);
+	refcount = kref_read(&io_req->refcount);
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO, "%d:0:%d:%d: Completing "
 	    "sc_cmd=%p result=0x%08x op=0x%02x lba=0x%02x%02x%02x%02x, "
 	    "allowed=%d retries=%d refcount=%d.\n",
@@ -1556,7 +1556,7 @@ static void qedf_flush_els_req(struct qedf_ctx *qedf,
 {
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO,
 	    "Flushing ELS request xid=0x%x refcount=%d.\n", els_req->xid,
-	    atomic_read(&els_req->refcount.refcount));
+	    kref_read(&els_req->refcount));
 
 	/*
 	 * Need to distinguish this from a timeout when calling the
-- 
1.8.5.6
