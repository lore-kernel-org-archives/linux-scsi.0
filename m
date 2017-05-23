From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 11/15] qedf: Fixup unnecessary paratheses around test_bit operations.
Date: Tue, 23 May 2017 06:19:27 -0700
Message-ID: <20170523131931.1777-12-chad.dupuis@cavium.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0086.outbound.protection.outlook.com ([104.47.34.86]:9184
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933347AbdEWNTx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 May 2017 09:19:53 -0400
In-Reply-To: <20170523131931.1777-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_els.c | 6 +++---
 drivers/scsi/qedf/qedf_io.c  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index e197fd6..78d9f1c 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -44,7 +44,7 @@ static int qedf_initiate_els(struct qedf_rport *fcport, unsigned int op,
 		goto els_err;
 	}
 
-	if (!(test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags))) {
+	if (!test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags)) {
 		QEDF_ERR(&(qedf->dbg_ctx), "els 0x%x: fcport not ready\n", op);
 		rc = -EINVAL;
 		goto els_err;
@@ -225,7 +225,7 @@ int qedf_send_rrq(struct qedf_ioreq *aborted_io_req)
 	fcport = aborted_io_req->fcport;
 
 	/* Check that fcport is still offloaded */
-	if (!(test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags))) {
+	if (!test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags)) {
 		QEDF_ERR(NULL, "fcport is no longer offloaded.\n");
 		return -EINVAL;
 	}
@@ -550,7 +550,7 @@ static int qedf_send_srr(struct qedf_ioreq *orig_io_req, u32 offset, u8 r_ctl)
 	fcport = orig_io_req->fcport;
 
 	/* Check that fcport is still offloaded */
-	if (!(test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags))) {
+	if (!test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags)) {
 		QEDF_ERR(NULL, "fcport is no longer offloaded.\n");
 		return -EINVAL;
 	}
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index db16004..ea37c78 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1847,7 +1847,7 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, struct scsi_cmnd *sc_cmd,
 		return FAILED;
 	}
 
-	if (!(test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags))) {
+	if (!test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags)) {
 		QEDF_ERR(&(qedf->dbg_ctx), "fcport not offloaded\n");
 		rc = FAILED;
 		return FAILED;
-- 
1.8.5.6
