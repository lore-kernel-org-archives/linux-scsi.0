From: jsmart2021@gmail.com
Subject: [PATCH v2] lpfc: Finalize Kconfig options for nvme
Date: Wed,  8 Mar 2017 14:36:01 -0800
Message-ID: <1489012561-27977-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35628 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbdCHWgr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 17:36:47 -0500
Received: by mail-qk0-f193.google.com with SMTP id o135so15494507qke.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Mar 2017 14:36:22 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Reviewing the result of what was just added for Kconfig, we made
a poor choice. It worked well for full kernel builds, but not so
much for how it would be deployed on a distro.

Here's the final result:
- lpfc will compile in NVME initiator and/or NVME target support
  based on whether the kernel has the corresponding subsystem support.
  Kconfig is not used to drive this specifically for lpfc.
- There is a module parameter, lpfc_enable_fc4_type, that indicates
  whether the ports will do FCP-only or FCP & NVME (NVME-only not yet
  possible due to dependency on fc transport). As FCP & NVME divvys
  up exchange resources, and given NVME will not be often initially,
  the default is changed to FCP only.

-- james

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/Kconfig           | 14 --------------
 drivers/scsi/lpfc/lpfc_attr.c  |  4 ++--
 drivers/scsi/lpfc/lpfc_init.c  |  7 +++++++
 drivers/scsi/lpfc/lpfc_nvme.c  |  8 ++++----
 drivers/scsi/lpfc/lpfc_nvmet.c |  8 ++++----
 5 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4bf55b5..3c52867 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1253,20 +1253,6 @@ config SCSI_LPFC_DEBUG_FS
 	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
-config LPFC_NVME_INITIATOR
-	bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
-	depends on SCSI_LPFC && NVME_FC
-	---help---
-	  This enables NVME Initiator support in the Emulex lpfc driver.
-
-config LPFC_NVME_TARGET
-	bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
-	depends on SCSI_LPFC && NVME_TARGET_FC
-	---help---
-	  This enables NVME Target support in the Emulex lpfc driver.
-	  Target enablement must still be enabled on a per adapter
-	  basis by module parameters.
-
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on (EISA || MCA) && SCSI
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index fbd3a56..84aa62f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3315,9 +3315,9 @@ LPFC_ATTR_R(nvmet_mrq_post, LPFC_DEF_MRQ_POST,
  * lpfc_enable_fc4_type: Defines what FC4 types are supported.
  * Supported Values:  1 - register just FCP
  *                    3 - register both FCP and NVME
- * Supported values are [1,3]. Default value is 3
+ * Supported values are [1,3]. Default value is 1
  */
-LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_BOTH,
+LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_FCP,
 	    LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
 	    "Define fc4 type to register with fabric.");
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 77d8840..a58194c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5904,10 +5904,17 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		/* Check to see if it matches any module parameter */
 		for (i = 0; i < lpfc_enable_nvmet_cnt; i++) {
 			if (wwn == lpfc_enable_nvmet[i]) {
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 						"6017 NVME Target %016llx\n",
 						wwn);
 				phba->nvmet_support = 1; /* a match */
+#else
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6021 Can't enable NVME Target."
+						" NVME_TARGET_FC infrastructure"
+						" is not in kernel\n");
+#endif
 			}
 		}
 	}
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 0a4c190..0024de1 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2149,7 +2149,7 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 	/* localport is allocated from the stack, but the registration
 	 * call allocates heap memory as well as the private area.
 	 */
-#ifdef CONFIG_LPFC_NVME_INITIATOR
+#if (IS_ENABLED(CONFIG_NVME_FC))
 	ret = nvme_fc_register_localport(&nfcp_info, &lpfc_nvme_template,
 					 &vport->phba->pcidev->dev, &localport);
 #else
@@ -2190,7 +2190,7 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 void
 lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 {
-#ifdef CONFIG_LPFC_NVME_INITIATOR
+#if (IS_ENABLED(CONFIG_NVME_FC))
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
 	struct lpfc_nvme_rport *rport = NULL, *rport_next = NULL;
@@ -2274,7 +2274,7 @@ lpfc_nvme_update_localport(struct lpfc_vport *vport)
 int
 lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
-#ifdef CONFIG_LPFC_NVME_INITIATOR
+#if (IS_ENABLED(CONFIG_NVME_FC))
 	int ret = 0;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
@@ -2403,7 +2403,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 void
 lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
-#ifdef CONFIG_LPFC_NVME_INITIATOR
+#if (IS_ENABLED(CONFIG_NVME_FC))
 	int ret;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index b7739a5..7ca868f 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -671,7 +671,7 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 	lpfc_tgttemplate.target_features = NVMET_FCTGTFEAT_READDATA_RSP |
 					   NVMET_FCTGTFEAT_NEEDS_CMD_CPUSCHED;
 
-#ifdef CONFIG_LPFC_NVME_TARGET
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	error = nvmet_fc_register_targetport(&pinfo, &lpfc_tgttemplate,
 					     &phba->pcidev->dev,
 					     &phba->targetport);
@@ -756,7 +756,7 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 void
 lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 {
-#ifdef CONFIG_LPFC_NVME_TARGET
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	struct lpfc_nvmet_tgtport *tgtp;
 
 	if (phba->nvmet_support == 0)
@@ -788,7 +788,7 @@ static void
 lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			   struct hbq_dmabuf *nvmebuf)
 {
-#ifdef CONFIG_LPFC_NVME_TARGET
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
 	struct lpfc_nvmet_rcv_ctx *ctxp;
@@ -891,7 +891,7 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 			    struct rqb_dmabuf *nvmebuf,
 			    uint64_t isr_timestamp)
 {
-#ifdef CONFIG_LPFC_NVME_TARGET
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	struct lpfc_nvmet_rcv_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
-- 
2.5.0
