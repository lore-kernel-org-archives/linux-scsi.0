From: James Smart <james.smart@emulex.com>
Subject: [PATCH 8/22] lpfc 8.3.39: Fix driver issues with SCSI Host reset
Date: Wed, 17 Apr 2013 20:16:51 -0400
Message-ID: <1366244211.1513.9.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:15663 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934827Ab3DRAQx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:16:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix driver issues with SCSI Host reset


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    7 ++++++-
 lpfc_hw4.h  |    2 +-
 lpfc_init.c |    7 ++++++-
 3 files changed, 13 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-04-15 18:26:32.478041017 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-04-15 18:26:36.982041119 -0400
@@ -674,6 +674,9 @@ lpfc_do_offline(struct lpfc_hba *phba, u
 	int i;
 	int rc;
 
+	if (phba->pport->fc_flag & FC_OFFLINE_MODE)
+		return 0;
+
 	init_completion(&online_compl);
 	rc = lpfc_workq_post_event(phba, &status, &online_compl,
 			      LPFC_EVT_OFFLINE_PREP);
@@ -741,7 +744,8 @@ lpfc_selective_reset(struct lpfc_hba *ph
 	int status = 0;
 	int rc;
 
-	if (!phba->cfg_enable_hba_reset)
+	if ((!phba->cfg_enable_hba_reset) ||
+	    (phba->pport->fc_flag & FC_OFFLINE_MODE))
 		return -EACCES;
 
 	status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
@@ -895,6 +899,7 @@ lpfc_sli4_pdev_reg_request(struct lpfc_h
 		pci_disable_sriov(pdev);
 		phba->cfg_sriov_nr_virtfn = 0;
 	}
+
 	status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
 
 	if (status != 0)
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2013-04-15 18:26:36.984041120 -0400
@@ -621,7 +621,7 @@ struct lpfc_register {
 #define lpfc_sliport_status_rdy_SHIFT	23
 #define lpfc_sliport_status_rdy_MASK	0x1
 #define lpfc_sliport_status_rdy_WORD	word0
-#define MAX_IF_TYPE_2_RESETS	1000
+#define MAX_IF_TYPE_2_RESETS		6
 
 #define LPFC_CTL_PORT_CTL_OFFSET	0x408
 #define lpfc_sliport_ctrl_end_SHIFT	30
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:32.483041017 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:36.988041120 -0400
@@ -7817,8 +7817,13 @@ lpfc_pci_function_reset(struct lpfc_hba
 
 out:
 	/* Catch the not-ready port failure after a port reset. */
-	if (num_resets >= MAX_IF_TYPE_2_RESETS)
+	if (num_resets >= MAX_IF_TYPE_2_RESETS) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3317 HBA not functional: IP Reset Failed "
+				"after (%d) retries, try: "
+				"echo fw_reset > board_mode\n", num_resets);
 		rc = -ENODEV;
+	}
 
 	return rc;
 }



