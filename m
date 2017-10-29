From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 4/5] lpfc: Add NVME rescan support via RSCNs
Date: Sat, 28 Oct 2017 18:14:55 -0700
Message-ID: <20171029011456.12885-5-jsmart2021@gmail.com>
References: <20171029011456.12885-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:56803 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdJ2BPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Oct 2017 21:15:08 -0400
Received: by mail-pg0-f68.google.com with SMTP id m18so8227016pgd.13
        for <linux-scsi@vger.kernel.org>; Sat, 28 Oct 2017 18:15:07 -0700 (PDT)
In-Reply-To: <20171029011456.12885-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

This patch adds NVME rescan support via RSCNs

NVME Target:
  Adds support for the new nvme_subsystem_change callback. The
  callback can be invoked by the nvmet_fc transport when it detects
  conditions that would like to have nvme discovery invoked again.
  Typically this is upon the addition of new subsystems added to
  the nvmet configuration (thus the transport tying the callback
  being invoked to port add calls).
  The callback routine will generate an RSCN to the fabric in
  order to cause RSCN events to all initiators with view of the
  nport.

NVME Host:
  Upon reception of an RSCN event for an nport which supports
  NVME initiator and which is currently logged in and PRLI'd,
  the initiator will call the nvme_fc transport
  nvme_fc_rescan_remoteport() routine to request nvme discovery
  to be performed again on the port pair.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h  |  2 ++
 drivers/scsi/lpfc/lpfc_els.c   |  4 ++++
 drivers/scsi/lpfc/lpfc_nvme.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_nvmet.c | 18 ++++++++++++++++++
 4 files changed, 66 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 6657b71d5a57..86f034fefa46 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -546,6 +546,8 @@ int lpfc_sli4_dump_page_a0(struct lpfc_hba *phba, struct lpfcMboxq *mbox);
 void lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb);
 
 /* NVME interfaces. */
+void lpfc_nvme_rescan_port(struct lpfc_vport *vport,
+			   struct lpfc_nodelist *ndlp);
 void lpfc_nvme_unregister_port(struct lpfc_vport *vport,
 			struct lpfc_nodelist *ndlp);
 int lpfc_nvme_register_port(struct lpfc_vport *vport,
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 936fc22dfcae..b02684113c75 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6071,6 +6071,10 @@ lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 		if (vport->phba->nvmet_support)
 			continue;
 
+		/* Check to see if we need to NVME rescan this remoteport. */
+		if (ndlp->nlp_fc4_type & NLP_FC4_NVME)
+			lpfc_nvme_rescan_port(vport, ndlp);
+
 		lpfc_disc_state_machine(vport, ndlp, NULL,
 					NLP_EVT_DEVICE_RECOVERY);
 		lpfc_cancel_retry_delay_tmo(vport, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 23bdb1ca106e..b372da3672eb 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2375,6 +2375,48 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 #endif
 }
 
+/* lpfc_nvme_rescan_port - Check to see if we should rescan this remoteport
+ *
+ * If the ndlp represents an NVME Target, that we are logged into,
+ * ping the NVME FC Transport layer to initiate a device rescan
+ * on this remote NPort.
+ */
+void
+lpfc_nvme_rescan_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
+{
+#if (IS_ENABLED(CONFIG_NVME_FC))
+	struct lpfc_nvme_rport *rport;
+	struct nvme_fc_remote_port *remoteport;
+
+	rport = ndlp->nrport;
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
+			 "6170 Rescan NPort DID x%06x type x%x state x%x rport %p\n",
+			 ndlp->nlp_DID, ndlp->nlp_type, ndlp->nlp_state, rport);
+	if (!rport)
+		goto input_err;
+	remoteport = rport->remoteport;
+	if (!remoteport)
+		goto input_err;
+
+	/* Only rescan if we are an NVME target in the MAPPED state */
+	if (remoteport->port_role & FC_PORT_ROLE_NVME_TARGET &&
+	    ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
+		nvme_fc_rescan_remoteport(remoteport);
+
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
+				 "6172 NVME rescanned DID x%06x "
+				 "port_state x%x\n",
+				 ndlp->nlp_DID, remoteport->port_state);
+	}
+input_err:
+	return;
+#endif
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
+			 "6169 State error: lport %p, rport%p FCID x%06x\n",
+			 vport->localport, ndlp->rport, ndlp->nlp_DID);
+}
+
 /* lpfc_nvme_unregister_port - unbind the DID and port_role from this rport.
  *
  * There is no notion of Devloss or rport recovery from the current
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 0b7c1a49e203..51888192eed7 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -866,6 +866,23 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
 	lpfc_rq_buf_free(phba, &nvmebuf->hbuf); /* repost */
 }
 
+static void
+lpfc_nvmet_subsystem_change(struct nvmet_fc_target_port *tgtport)
+{
+	struct lpfc_nvmet_tgtport *tgtp;
+	struct lpfc_hba *phba;
+	uint32_t rc;
+
+	tgtp = tgtport->private;
+	phba = tgtp->phba;
+
+	rc = lpfc_issue_els_rscn(phba->pport, 0);
+	lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
+			"6420 NVMET subsystem change: "
+			"Notification %s\n",
+			(rc) ? "Failed" : "Sent");
+}
+
 static struct nvmet_fc_target_template lpfc_tgttemplate = {
 	.targetport_delete = lpfc_nvmet_targetport_delete,
 	.xmt_ls_rsp     = lpfc_nvmet_xmt_ls_rsp,
@@ -873,6 +890,7 @@ static struct nvmet_fc_target_template lpfc_tgttemplate = {
 	.fcp_abort      = lpfc_nvmet_xmt_fcp_abort,
 	.fcp_req_release = lpfc_nvmet_xmt_fcp_release,
 	.defer_rcv	= lpfc_nvmet_defer_rcv,
+	.nvme_subsystem_change = lpfc_nvmet_subsystem_change,
 
 	.max_hw_queues  = 1,
 	.max_sgl_segments = LPFC_NVMET_DEFAULT_SEGS,
-- 
2.13.1
