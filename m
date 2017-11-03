From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 14/17] lpfc: Fix crash during driver unload with running nvme traffic
Date: Fri,  3 Nov 2017 15:56:25 -0700
Message-ID: <20171103225628.24716-15-jsmart2021@gmail.com>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:43958 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756147AbdKCW4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 18:56:51 -0400
Received: by mail-qt0-f194.google.com with SMTP id j58so5084448qtj.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 15:56:51 -0700 (PDT)
In-Reply-To: <20171103225628.24716-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

When the driver is unloading, the nvme transport could be in the
process of submitting new requests, will send abort requests to
terminate associations, or may make LS-related requests.
The driver's abort and request entry points currently is ignorant
of the unloading state and is starting the requests even though
the infrastructure to complete them continues to teardown.

Change the entry points for new requests to check whether unloading
and if so, reject the requests. Abort routines check unloading, and
if so, noop the request. An abort is noop'd as the teardown paths
are already aborting/terminating the io outstanding at the time the
teardown initiated.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c  | 14 ++++++++++++++
 drivers/scsi/lpfc/lpfc_nvmet.c | 11 +++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 12d09a6a4563..ea7a0e65bbfd 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -423,6 +423,9 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
 	if (vport->load_flag & FC_UNLOADING)
 		return -ENODEV;
 
+	if (vport->load_flag & FC_UNLOADING)
+		return -ENODEV;
+
 	ndlp = lpfc_findnode_did(vport, pnvme_rport->port_id);
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_IOERR,
@@ -538,6 +541,9 @@ lpfc_nvme_ls_abort(struct nvme_fc_local_port *pnvme_lport,
 	vport = lport->vport;
 	phba = vport->phba;
 
+	if (vport->load_flag & FC_UNLOADING)
+		return;
+
 	ndlp = lpfc_findnode_did(vport, pnvme_rport->port_id);
 	if (!ndlp) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
@@ -1273,6 +1279,11 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 		goto out_fail;
 	}
 
+	if (vport->load_flag & FC_UNLOADING) {
+		ret = -ENODEV;
+		goto out_fail;
+	}
+
 	/* Validate pointers. */
 	if (!pnvme_lport || !pnvme_rport || !freqpriv) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR | LOG_NODE,
@@ -1500,6 +1511,9 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	vport = lport->vport;
 	phba = vport->phba;
 
+	if (vport->load_flag & FC_UNLOADING)
+		return;
+
 	/* Announce entry to new IO submit field. */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_ABTS,
 			 "6002 Abort Request to rport DID x%06x "
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 84cf1b9079f7..2b50aecc2722 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -635,6 +635,9 @@ lpfc_nvmet_xmt_ls_rsp(struct nvmet_fc_target_port *tgtport,
 	if (phba->pport->load_flag & FC_UNLOADING)
 		return -ENODEV;
 
+	if (phba->pport->load_flag & FC_UNLOADING)
+		return -ENODEV;
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
 			"6023 NVMET LS rsp oxid x%x\n", ctxp->oxid);
 
@@ -721,6 +724,11 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 		goto aerr;
 	}
 
+	if (phba->pport->load_flag & FC_UNLOADING) {
+		rc = -ENODEV;
+		goto aerr;
+	}
+
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (ctxp->ts_cmd_nvme) {
 		if (rsp->op == NVMET_FCOP_RSP)
@@ -823,6 +831,9 @@ lpfc_nvmet_xmt_fcp_abort(struct nvmet_fc_target_port *tgtport,
 	if (phba->pport->load_flag & FC_UNLOADING)
 		return;
 
+	if (phba->pport->load_flag & FC_UNLOADING)
+		return;
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
 			"6103 NVMET Abort op: oxri x%x flg x%x ste %d\n",
 			ctxp->oxid, ctxp->flag, ctxp->state);
-- 
2.13.1
