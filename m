From: giridhar.malavali@qlogic.com
Subject: [PATCH 12/17] qla2xxx: Do not allow ELS Passthru commands for ISP23xx adapters
Date: Fri, 23 Jul 2010 15:28:33 +0500
Message-ID: <1279880918-62876-13-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47961 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755708Ab0GWJ7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:43 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   37 ++++++++++++++++++++++++-------------
 1 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 04ead06..6b863f7 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -229,7 +229,7 @@ static int
 qla2x00_process_els(struct fc_bsg_job *bsg_job)
 {
 	struct fc_rport *rport;
-	fc_port_t *fcport;
+	fc_port_t *fcport = NULL;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *vha;
 	struct qla_hw_data *ha;
@@ -240,6 +240,29 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	uint16_t nextlid = 0;
 	struct srb_ctx *els;
 
+	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
+		rport = bsg_job->rport;
+		fcport = *(fc_port_t **) rport->dd_data;
+		host = rport_to_shost(rport);
+		vha = shost_priv(host);
+		ha = vha->hw;
+		type = "FC_BSG_RPT_ELS";
+	} else {
+		host = bsg_job->shost;
+		vha = shost_priv(host);
+		ha = vha->hw;
+		type = "FC_BSG_HST_ELS_NOLOGIN";
+	}
+
+	/* pass through is supported only for ISP 4Gb or higher */
+	if (!IS_FWI2_CAPABLE(ha)) {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "scsi(%ld):ELS passthru not supported for ISP23xx based "
+		    "adapters\n", vha->host_no));
+		rval = -EPERM;
+		goto done;
+	}
+
 	/*  Multiple SG's are not supported for ELS requests */
 	if (bsg_job->request_payload.sg_cnt > 1 ||
 		bsg_job->reply_payload.sg_cnt > 1) {
@@ -254,13 +277,6 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 
 	/* ELS request for rport */
 	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
-		rport = bsg_job->rport;
-		fcport = *(fc_port_t **) rport->dd_data;
-		host = rport_to_shost(rport);
-		vha = shost_priv(host);
-		ha = vha->hw;
-		type = "FC_BSG_RPT_ELS";
-
 		/* make sure the rport is logged in,
 		 * if not perform fabric login
 		 */
@@ -272,11 +288,6 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 			goto done;
 		}
 	} else {
-		host = bsg_job->shost;
-		vha = shost_priv(host);
-		ha = vha->hw;
-		type = "FC_BSG_HST_ELS_NOLOGIN";
-
 		/* Allocate a dummy fcport structure, since functions
 		 * preparing the IOCB and mailbox command retrieves port
 		 * specific information from fcport structure. For Host based
-- 
1.6.0.2

