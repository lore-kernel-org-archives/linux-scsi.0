From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/11] zfcp: Move scsi result tracing decision to zfcp_dbf.h
Date: Wed, 17 Feb 2010 11:18:57 +0100
Message-ID: <20100217102019.065027000@de.ibm.com>
References: <20100217101848.662299000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:49693 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0BQKUX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 05:20:23 -0500
Content-Disposition: inline; filename=709-zfcp-result-tracing.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Move the decision which trace tag and trace level to use for the scsi
result trace to zfcp_dbf.h. zfcp_dbf_scsi_result is already an inline
function, so move the trace code there, simplifying the response
handling in zfcp_fsf.c.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.h  |   28 +++++++++++++++++++++-------
 drivers/s390/scsi/zfcp_fsf.c  |    7 +------
 drivers/s390/scsi/zfcp_scsi.c |    4 ++--
 3 files changed, 24 insertions(+), 15 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.h linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.h	2010-02-16 09:43:31.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h	2010-02-16 09:43:32.000000000 +0100
@@ -303,17 +303,31 @@ void zfcp_dbf_scsi(const char *tag, cons
 
 /**
  * zfcp_dbf_scsi_result - trace event for SCSI command completion
- * @tag: tag indicating success or failure of SCSI command
- * @level: trace level applicable for this event
- * @adapter: adapter that has been used to issue the SCSI command
+ * @dbf: adapter dbf trace
  * @scmd: SCSI command pointer
- * @fsf_req: request used to issue SCSI command (might be NULL)
+ * @req: FSF request used to issue SCSI command
  */
 static inline
-void zfcp_dbf_scsi_result(const char *tag, int level, struct zfcp_dbf *dbf,
-			  struct scsi_cmnd *scmd, struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_scsi_result(struct zfcp_dbf *dbf, struct scsi_cmnd *scmd,
+			  struct zfcp_fsf_req *req)
 {
-	zfcp_dbf_scsi("rslt", tag, level, dbf, scmd, fsf_req, 0);
+	if (scmd->result != 0)
+		zfcp_dbf_scsi("rslt", "erro", 3, dbf, scmd, req, 0);
+	else if (scmd->retries > 0)
+		zfcp_dbf_scsi("rslt", "retr", 4, dbf, scmd, req, 0);
+	else
+		zfcp_dbf_scsi("rslt", "norm", 6, dbf, scmd, req, 0);
+}
+
+/**
+ * zfcp_dbf_scsi_fail_send - trace event for failure to send SCSI command
+ * @dbf: adapter dbf trace
+ * @scmd: SCSI command pointer
+ */
+static inline
+void zfcp_dbf_scsi_fail_send(struct zfcp_dbf *dbf, struct scsi_cmnd *scmd)
+{
+	zfcp_dbf_scsi("rslt", "fail", 4, dbf, scmd, NULL, 0);
 }
 
 /**
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:32.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:32.000000000 +0100
@@ -2156,12 +2156,7 @@ static void zfcp_fsf_send_fcp_command_ta
 	zfcp_fsf_req_trace(req, scpnt);
 
 skip_fsfstatus:
-	if (scpnt->result != 0)
-		zfcp_dbf_scsi_result("erro", 3, req->adapter->dbf, scpnt, req);
-	else if (scpnt->retries > 0)
-		zfcp_dbf_scsi_result("retr", 4, req->adapter->dbf, scpnt, req);
-	else
-		zfcp_dbf_scsi_result("norm", 6, req->adapter->dbf, scpnt, req);
+	zfcp_dbf_scsi_result(req->adapter->dbf, scpnt, req);
 
 	scpnt->host_scribble = NULL;
 	(scpnt->scsi_done) (scpnt);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2010-02-16 09:43:32.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2010-02-16 09:43:32.000000000 +0100
@@ -62,7 +62,7 @@ static void zfcp_scsi_command_fail(struc
 		(struct zfcp_adapter *) scpnt->device->host->hostdata[0];
 
 	set_host_byte(scpnt, result);
-	zfcp_dbf_scsi_result("fail", 4, adapter->dbf, scpnt, NULL);
+	zfcp_dbf_scsi_fail_send(adapter->dbf, scpnt);
 	scpnt->scsi_done(scpnt);
 }
 
@@ -89,7 +89,7 @@ static int zfcp_scsi_queuecommand(struct
 	scsi_result = fc_remote_port_chkready(rport);
 	if (unlikely(scsi_result)) {
 		scpnt->result = scsi_result;
-		zfcp_dbf_scsi_result("fail", 4, adapter->dbf, scpnt, NULL);
+		zfcp_dbf_scsi_fail_send(adapter->dbf, scpnt);
 		scpnt->scsi_done(scpnt);
 		return 0;
 	}

