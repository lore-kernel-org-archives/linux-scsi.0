From: jsmart2021@gmail.com
Subject: [PATCH 13/20] lpfc: Rework lpfc Kconfig for NVME options
Date: Sat,  4 Mar 2017 09:30:33 -0800
Message-ID: <1488648640-5170-14-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33246 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752383AbdCDRbF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:31:05 -0500
Received: by mail-qk0-f195.google.com with SMTP id j127so16586744qke.0
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:31:05 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Reworked Kconfig so that lfpc only requires the scsi stack.
NVME Initiator and NVME Target support can be enabled if
the other NVMe subsystems have been enabled.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/Kconfig           | 19 ++++++++++++++++---
 drivers/scsi/lpfc/lpfc_nvme.c  | 18 +++++++++++++++---
 drivers/scsi/lpfc/lpfc_nvmet.c | 10 ++++++++++
 3 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 230043c..4bf55b5 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1241,19 +1241,32 @@ config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
 	depends on PCI && SCSI
 	depends on SCSI_FC_ATTRS
-	depends on NVME_FC && NVME_TARGET_FC
 	select CRC_T10DIF
-	help
+	---help---
           This lpfc driver supports the Emulex LightPulse
           Family of Fibre Channel PCI host adapters.
 
 config SCSI_LPFC_DEBUG_FS
 	bool "Emulex LightPulse Fibre Channel debugfs Support"
 	depends on SCSI_LPFC && DEBUG_FS
-	help
+	---help---
 	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
+config LPFC_NVME_INITIATOR
+	bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
+	depends on SCSI_LPFC && NVME_FC
+	---help---
+	  This enables NVME Initiator support in the Emulex lpfc driver.
+
+config LPFC_NVME_TARGET
+	bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
+	depends on SCSI_LPFC && NVME_TARGET_FC
+	---help---
+	  This enables NVME Target support in the Emulex lpfc driver.
+	  Target enablement must still be enabled on a per adapter
+	  basis by module parameters.
+
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on (EISA || MCA) && SCSI
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index b9012fe..0a4c190 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2127,11 +2127,12 @@ lpfc_release_nvme_buf(struct lpfc_hba *phba, struct lpfc_nvme_buf *lpfc_ncmd)
 int
 lpfc_nvme_create_localport(struct lpfc_vport *vport)
 {
+	int ret = 0;
 	struct lpfc_hba  *phba = vport->phba;
 	struct nvme_fc_port_info nfcp_info;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
-	int len, ret = 0;
+	int len;
 
 	/* Initialize this localport instance.  The vport wwn usage ensures
 	 * that NPIV is accounted for.
@@ -2148,8 +2149,12 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 	/* localport is allocated from the stack, but the registration
 	 * call allocates heap memory as well as the private area.
 	 */
+#ifdef CONFIG_LPFC_NVME_INITIATOR
 	ret = nvme_fc_register_localport(&nfcp_info, &lpfc_nvme_template,
 					 &vport->phba->pcidev->dev, &localport);
+#else
+	ret = -ENOMEM;
+#endif
 	if (!ret) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME | LOG_NVME_DISC,
 				 "6005 Successfully registered local "
@@ -2185,6 +2190,7 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 void
 lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 {
+#ifdef CONFIG_LPFC_NVME_INITIATOR
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
 	struct lpfc_nvme_rport *rport = NULL, *rport_next = NULL;
@@ -2200,7 +2206,6 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
 			 "6011 Destroying NVME localport %p\n",
 			 localport);
-
 	list_for_each_entry_safe(rport, rport_next, &lport->rport_list, list) {
 		/* The last node ref has to get released now before the rport
 		 * private memory area is released by the transport.
@@ -2214,6 +2219,7 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 					 "6008 rport fail destroy %x\n", ret);
 		wait_for_completion_timeout(&rport->rport_unreg_done, 5);
 	}
+
 	/* lport's rport list is clear.  Unregister
 	 * lport and release resources.
 	 */
@@ -2237,6 +2243,7 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 				 "Failed, status x%x\n",
 				 ret);
 	}
+#endif
 }
 
 void
@@ -2267,6 +2274,7 @@ lpfc_nvme_update_localport(struct lpfc_vport *vport)
 int
 lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
+#ifdef CONFIG_LPFC_NVME_INITIATOR
 	int ret = 0;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
@@ -2340,7 +2348,6 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			rpinfo.port_role |= FC_PORT_ROLE_NVME_INITIATOR;
 		rpinfo.port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
 		rpinfo.node_name = wwn_to_u64(ndlp->nlp_nodename.u.wwn);
-
 		ret = nvme_fc_register_remoteport(localport, &rpinfo,
 						  &remote_port);
 		if (!ret) {
@@ -2376,6 +2383,9 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				 ndlp->nlp_type, ndlp->nlp_DID, ndlp);
 	}
 	return ret;
+#else
+	return 0;
+#endif
 }
 
 /* lpfc_nvme_unregister_port - unbind the DID and port_role from this rport.
@@ -2393,6 +2403,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 void
 lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
+#ifdef CONFIG_LPFC_NVME_INITIATOR
 	int ret;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
@@ -2450,6 +2461,7 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	return;
 
  input_err:
+#endif
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
 			 "6168: State error: lport %p, rport%p FCID x%06x\n",
 			 vport->localport, ndlp->rport, ndlp->nlp_DID);
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 48ce985..a69ca6e 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -671,9 +671,13 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 	lpfc_tgttemplate.target_features = NVMET_FCTGTFEAT_READDATA_RSP |
 					   NVMET_FCTGTFEAT_NEEDS_CMD_CPUSCHED;
 
+#ifdef CONFIG_LPFC_NVME_TARGET
 	error = nvmet_fc_register_targetport(&pinfo, &lpfc_tgttemplate,
 					     &phba->pcidev->dev,
 					     &phba->targetport);
+#else
+	error = -ENOMEM;
+#endif
 	if (error) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_DISC,
 				"6025 Cannot register NVME targetport "
@@ -752,6 +756,7 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 void
 lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 {
+#ifdef CONFIG_LPFC_NVME_TARGET
 	struct lpfc_nvmet_tgtport *tgtp;
 
 	if (phba->nvmet_support == 0)
@@ -763,6 +768,7 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 		wait_for_completion_timeout(&tgtp->tport_unreg_done, 5);
 	}
 	phba->targetport = NULL;
+#endif
 }
 
 /**
@@ -782,6 +788,7 @@ static void
 lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			   struct hbq_dmabuf *nvmebuf)
 {
+#ifdef CONFIG_LPFC_NVME_TARGET
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
 	struct lpfc_nvmet_rcv_ctx *ctxp;
@@ -862,6 +869,7 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	atomic_inc(&tgtp->xmt_ls_abort);
 	lpfc_nvmet_unsol_ls_issue_abort(phba, ctxp, sid, oxid);
+#endif
 }
 
 /**
@@ -883,6 +891,7 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 			    struct rqb_dmabuf *nvmebuf,
 			    uint64_t isr_timestamp)
 {
+#ifdef CONFIG_LPFC_NVME_TARGET
 	struct lpfc_nvmet_rcv_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
@@ -988,6 +997,7 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 		/* We assume a rcv'ed cmd ALWAYs fits into 1 buffer */
 		lpfc_nvmet_rq_post(phba, NULL, &nvmebuf->hbuf);
 	}
+#endif
 }
 
 /**
-- 
2.5.0
