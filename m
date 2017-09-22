From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 18/19] lpfc: Fix oops of nvme host during driver unload.
Date: Thu, 21 Sep 2017 23:17:40 -0700
Message-ID: <20170922061741.12347-19-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36770 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbdIVGSN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:13 -0400
Received: by mail-pg0-f67.google.com with SMTP id d8so120863pgt.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:13 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

When running NVME io as a NVME host, if the driver is unloaded there
would be oops in lpfc_sli4_issue_wqe.

When unloading, controllers are torn down and the transport initiates
set_property commands to reset the controller and issues aborts to
terminate existing io.  The drivers nvme abort and fcp io submit
routines needed to recognize the driver is unloading and fail the new
requests. It didn't, resulting in the oops.

Revise the abort and fcp io submit routines to detect the unloading
state and properly handle their cleanup.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c  | 14 ++++++++++++++
 drivers/scsi/lpfc/lpfc_nvmet.c | 11 +++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index e3642c1890ea..e01e67856458 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -416,6 +416,9 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
 	lport = (struct lpfc_nvme_lport *)pnvme_lport->private;
 	vport = lport->vport;
 
+	if (vport->load_flag & FC_UNLOADING)
+		return -ENODEV;
+
 	ndlp = lpfc_findnode_did(vport, pnvme_rport->port_id);
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_IOERR,
@@ -531,6 +534,9 @@ lpfc_nvme_ls_abort(struct nvme_fc_local_port *pnvme_lport,
 	vport = lport->vport;
 	phba = vport->phba;
 
+	if (vport->load_flag & FC_UNLOADING)
+		return;
+
 	ndlp = lpfc_findnode_did(vport, pnvme_rport->port_id);
 	if (!ndlp) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
@@ -1252,6 +1258,11 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	vport = lport->vport;
 	phba = vport->phba;
 
+	if (vport->load_flag & FC_UNLOADING) {
+		ret = -ENODEV;
+		goto out_fail;
+	}
+
 	/* Validate pointers. */
 	if (!pnvme_lport || !pnvme_rport || !freqpriv) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR | LOG_NODE,
@@ -1479,6 +1490,9 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	vport = lport->vport;
 	phba = vport->phba;
 
+	if (vport->load_flag & FC_UNLOADING)
+		return;
+
 	/* Announce entry to new IO submit field. */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_ABTS,
 			 "6002 Abort Request to rport DID x%06x "
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 55badeace591..84cf1b9079f7 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -632,6 +632,9 @@ lpfc_nvmet_xmt_ls_rsp(struct nvmet_fc_target_port *tgtport,
 	struct ulp_bde64 bpl;
 	int rc;
 
+	if (phba->pport->load_flag & FC_UNLOADING)
+		return -ENODEV;
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
 			"6023 NVMET LS rsp oxid x%x\n", ctxp->oxid);
 
@@ -713,6 +716,11 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	struct lpfc_iocbq *nvmewqeq;
 	int rc;
 
+	if (phba->pport->load_flag & FC_UNLOADING) {
+		rc = -ENODEV;
+		goto aerr;
+	}
+
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (ctxp->ts_cmd_nvme) {
 		if (rsp->op == NVMET_FCOP_RSP)
@@ -812,6 +820,9 @@ lpfc_nvmet_xmt_fcp_abort(struct nvmet_fc_target_port *tgtport,
 	struct lpfc_hba *phba = ctxp->phba;
 	unsigned long flags;
 
+	if (phba->pport->load_flag & FC_UNLOADING)
+		return;
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
 			"6103 NVMET Abort op: oxri x%x flg x%x ste %d\n",
 			ctxp->oxid, ctxp->flag, ctxp->state);
-- 
2.13.1
