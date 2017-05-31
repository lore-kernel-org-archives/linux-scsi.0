From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH V2 08/15] qedf: Use same logic for SCSI host reset and FC lip_reset.
Date: Wed, 31 May 2017 06:33:55 -0700
Message-ID: <20170531133402.16629-9-chad.dupuis@cavium.com>
References: <20170531133402.16629-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0089.outbound.protection.outlook.com ([104.47.32.89]:42902
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751146AbdEaNec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 09:34:32 -0400
In-Reply-To: <20170531133402.16629-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

We should be using the same logic to do a soft reset of the FCoE function
whether it is initiated via sg_reset or the fc_host issue_lip attribute.
Refactor the host reset and fcoe reset handlers to use the preferred logic
which is currently contained in qedf_eh_host_reset().

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index d08793e..99d8822 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -640,27 +640,17 @@ void qedf_wait_for_upload(struct qedf_ctx *qedf)
 	}
 }
 
-/* Reset the host by gracefully logging out and then logging back in */
-static int qedf_eh_host_reset(struct scsi_cmnd *sc_cmd)
+/* Performs soft reset of qedf_ctx by simulating a link down/up */
+static void qedf_ctx_soft_reset(struct fc_lport *lport)
 {
-	struct fc_lport *lport;
 	struct qedf_ctx *qedf;
 
-	lport = shost_priv(sc_cmd->device->host);
-
 	if (lport->vport) {
 		QEDF_ERR(NULL, "Cannot issue host reset on NPIV port.\n");
-		return SUCCESS;
+		return;
 	}
 
-	qedf = (struct qedf_ctx *)lport_priv(lport);
-
-	if (atomic_read(&qedf->link_state) == QEDF_LINK_DOWN ||
-	    test_bit(QEDF_UNLOADING, &qedf->flags) ||
-	    test_bit(QEDF_DBG_STOP_IO, &qedf->flags))
-		return FAILED;
-
-	QEDF_ERR(&(qedf->dbg_ctx), "HOST RESET Issued...");
+	qedf = lport_priv(lport);
 
 	/* For host reset, essentially do a soft link up/down */
 	atomic_set(&qedf->link_state, QEDF_LINK_DOWN);
@@ -672,6 +662,24 @@ static int qedf_eh_host_reset(struct scsi_cmnd *sc_cmd)
 	qedf->vlan_id  = 0;
 	queue_delayed_work(qedf->link_update_wq, &qedf->link_update,
 	    0);
+}
+
+/* Reset the host by gracefully logging out and then logging back in */
+static int qedf_eh_host_reset(struct scsi_cmnd *sc_cmd)
+{
+	struct fc_lport *lport;
+	struct qedf_ctx *qedf;
+
+	lport = shost_priv(sc_cmd->device->host);
+	qedf = lport_priv(lport);
+
+	if (atomic_read(&qedf->link_state) == QEDF_LINK_DOWN ||
+	    test_bit(QEDF_UNLOADING, &qedf->flags))
+		return FAILED;
+
+	QEDF_ERR(&(qedf->dbg_ctx), "HOST RESET Issued...");
+
+	qedf_ctx_soft_reset(lport);
 
 	return SUCCESS;
 }
@@ -1669,8 +1677,7 @@ static int qedf_fcoe_reset(struct Scsi_Host *shost)
 {
 	struct fc_lport *lport = shost_priv(shost);
 
-	fc_fabric_logoff(lport);
-	fc_fabric_login(lport);
+	qedf_ctx_soft_reset(lport);
 	return 0;
 }
 
-- 
1.8.5.6
