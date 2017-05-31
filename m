From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH V2 05/15] qedf: Check that fcport is offloaded before dereferencing pointers in initiate_abts|cleanup.
Date: Wed, 31 May 2017 06:33:52 -0700
Message-ID: <20170531133402.16629-6-chad.dupuis@cavium.com>
References: <20170531133402.16629-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0089.outbound.protection.outlook.com ([104.47.37.89]:41385
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751164AbdEaNem (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 09:34:42 -0400
In-Reply-To: <20170531133402.16629-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

If an fcport is not offloaded then the members of the qedf_rport struct
are undefined which may cause a system crash.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_io.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index ca9097b..db16004 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1476,8 +1476,8 @@ int qedf_initiate_abts(struct qedf_ioreq *io_req, bool return_scsi_cmd_on_abts)
 {
 	struct fc_lport *lport;
 	struct qedf_rport *fcport = io_req->fcport;
-	struct fc_rport_priv *rdata = fcport->rdata;
-	struct qedf_ctx *qedf = fcport->qedf;
+	struct fc_rport_priv *rdata;
+	struct qedf_ctx *qedf;
 	u16 xid;
 	u32 r_a_tov = 0;
 	int rc = 0;
@@ -1485,15 +1485,18 @@ int qedf_initiate_abts(struct qedf_ioreq *io_req, bool return_scsi_cmd_on_abts)
 	struct fcoe_wqe *sqe;
 	u16 sqe_idx;
 
-	r_a_tov = rdata->r_a_tov;
-	lport = qedf->lport;
-
+	/* Sanity check qedf_rport before dereferencing any pointers */
 	if (!test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags)) {
-		QEDF_ERR(&(qedf->dbg_ctx), "tgt not offloaded\n");
+		QEDF_ERR(NULL, "tgt not offloaded\n");
 		rc = 1;
 		goto abts_err;
 	}
 
+	rdata = fcport->rdata;
+	r_a_tov = rdata->r_a_tov;
+	qedf = fcport->qedf;
+	lport = qedf->lport;
+
 	if (lport->state != LPORT_ST_READY || !(lport->link_up)) {
 		QEDF_ERR(&(qedf->dbg_ctx), "link is not ready\n");
 		rc = 1;
@@ -1729,6 +1732,13 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 		return SUCCESS;
 	}
 
+	/* Sanity check qedf_rport before dereferencing any pointers */
+	if (!test_bit(QEDF_RPORT_SESSION_READY, &fcport->flags)) {
+		QEDF_ERR(NULL, "tgt not offloaded\n");
+		rc = 1;
+		return SUCCESS;
+	}
+
 	qedf = fcport->qedf;
 	if (!qedf) {
 		QEDF_ERR(NULL, "qedf is NULL.\n");
-- 
1.8.5.6
