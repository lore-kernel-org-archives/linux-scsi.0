From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/7] lpfc 8.3.10: Fix user interface issues
Date: Fri, 26 Feb 2010 14:13:54 -0500
Message-ID: <1267211654.3372.3.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:4822 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965792Ab0BZTOl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2010 14:14:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

- Add Logging message for critial errors.
- Remove unused variable from lpfc_nodev_tmo_show
- Update supress_link_up parameter with #define values.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    3 +++
 lpfc_attr.c |    7 ++++---
 lpfc_els.c  |   21 ++++++++++++++++++---
 lpfc_init.c |    4 ++--
 lpfc_scsi.c |   14 ++++++++++++--
 lpfc_sli.c  |   11 ++++++++++-
 6 files changed, 49 insertions(+), 11 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2010-02-25 16:33:26.000000000 -0500
@@ -1939,7 +1939,9 @@ static DEVICE_ATTR(lpfc_enable_npiv, S_I
 #            0x2  = never bring up link
 # Default value is 0.
 */
-LPFC_ATTR_R(suppress_link_up, 0, 0, 2, "Suppress Link Up at initialization");
+LPFC_ATTR_R(suppress_link_up, LPFC_INITIALIZE_LINK, LPFC_INITIALIZE_LINK,
+		LPFC_DELAY_INIT_LINK_INDEFINITELY,
+		"Suppress Link Up at initialization");
 
 /*
 # lpfc_nodev_tmo: If set, it will hold all I/O errors on devices that disappear
@@ -1966,8 +1968,7 @@ lpfc_nodev_tmo_show(struct device *dev, 
 {
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	int val = 0;
-	val = vport->cfg_devloss_tmo;
+
 	return snprintf(buf, PAGE_SIZE, "%d\n",	vport->cfg_devloss_tmo);
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-02-25 16:33:26.000000000 -0500
@@ -806,9 +806,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		}
 
 		/* FLOGI failure */
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-				 "0100 FLOGI failure Data: x%x x%x "
-				 "x%x\n",
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "0100 FLOGI failure Status:x%x/x%x TMO:x%x\n",
 				 irsp->ulpStatus, irsp->un.ulpWord[4],
 				 irsp->ulpTimeout);
 		goto flogifail;
@@ -1409,6 +1408,10 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phb
 			goto out;
 		}
 		/* PLOGI failed */
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "2753 PLOGI failure DID:%06X Status:x%x/x%x\n",
+				 ndlp->nlp_DID, irsp->ulpStatus,
+				 irsp->un.ulpWord[4]);
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (lpfc_error_lost_link(irsp))
 			rc = NLP_STE_FREED_NODE;
@@ -1577,6 +1580,10 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba
 			goto out;
 		}
 		/* PRLI failed */
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "2754 PRLI failure DID:%06X Status:x%x/x%x\n",
+				 ndlp->nlp_DID, irsp->ulpStatus,
+				 irsp->un.ulpWord[4]);
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (lpfc_error_lost_link(irsp))
 			goto out;
@@ -1860,6 +1867,10 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phb
 			goto out;
 		}
 		/* ADISC failed */
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "2755 ADISC failure DID:%06X Status:x%x/x%x\n",
+				 ndlp->nlp_DID, irsp->ulpStatus,
+				 irsp->un.ulpWord[4]);
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (!lpfc_error_lost_link(irsp))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
@@ -2009,6 +2020,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba
 			/* ELS command is being retried */
 			goto out;
 		/* LOGO failed */
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "2756 LOGO failure DID:%06X Status:x%x/x%x\n",
+				 ndlp->nlp_DID, irsp->ulpStatus,
+				 irsp->un.ulpWord[4]);
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (lpfc_error_lost_link(irsp))
 			goto out;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2010-02-25 16:33:26.000000000 -0500
@@ -623,6 +623,9 @@ struct lpfc_hba {
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_aer_support;
 	uint32_t cfg_suppress_link_up;
+#define LPFC_INITIALIZE_LINK              0	/* do normal init_link mbox */
+#define LPFC_DELAY_INIT_LINK              1	/* layered driver hold off */
+#define LPFC_DELAY_INIT_LINK_INDEFINITELY 2	/* wait, manual intervention */
 
 	lpfc_vpd_t vpd;		/* vital product data */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-02-25 16:33:09.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-02-25 16:33:26.000000000 -0500
@@ -549,7 +549,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 			mempool_free(pmb, phba->mbox_mem_pool);
 			return -EIO;
 		}
-	} else if (phba->cfg_suppress_link_up == 0) {
+	} else if (phba->cfg_suppress_link_up == LPFC_INITIALIZE_LINK) {
 		lpfc_init_link(phba, pmb, phba->cfg_topology,
 			phba->cfg_link_speed);
 		pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
@@ -667,7 +667,7 @@ lpfc_hba_init_link(struct lpfc_hba *phba
 			mempool_free(pmb, phba->mbox_mem_pool);
 		return -EIO;
 	}
-	phba->cfg_suppress_link_up = 0;
+	phba->cfg_suppress_link_up = LPFC_INITIALIZE_LINK;
 
 	return 0;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-02-25 16:33:26.000000000 -0500
@@ -2079,8 +2079,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 
 	if (resp_info & RSP_LEN_VALID) {
 		rsplen = be32_to_cpu(fcprsp->rspRspLen);
-		if ((rsplen != 0 && rsplen != 4 && rsplen != 8) ||
-		    (fcprsp->rspInfo3 != RSP_NO_FAILURE)) {
+		if (rsplen != 0 && rsplen != 4 && rsplen != 8) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "2719 Invalid response length: "
 				 "tgt x%x lun x%x cmnd x%x rsplen x%x\n",
@@ -2090,6 +2089,17 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 			host_status = DID_ERROR;
 			goto out;
 		}
+		if (fcprsp->rspInfo3 != RSP_NO_FAILURE) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+				 "2757 Protocol failure detected during "
+				 "processing of FCP I/O op: "
+				 "tgt x%x lun x%x cmnd x%x rspInfo3 x%x\n",
+				 cmnd->device->id,
+				 cmnd->device->lun, cmnd->cmnd[0],
+				 fcprsp->rspInfo3);
+			host_status = DID_ERROR;
+			goto out;
+		}
 	}
 
 	if ((resp_info & SNS_LEN_VALID) && fcprsp->rspSnsLen) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-02-25 16:33:09.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-02-25 16:33:26.000000000 -0500
@@ -3091,6 +3091,12 @@ lpfc_sli_brdready_s3(struct lpfc_hba *ph
 
 	/* Check to see if any errors occurred during init */
 	if ((status & HS_FFERM) || (i >= 20)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2751 Adapter failed to restart, "
+				"status reg x%x, FW Data: A8 x%x AC x%x\n",
+				status,
+				readl(phba->MBslimaddr + 0xa8),
+				readl(phba->MBslimaddr + 0xac));
 		phba->link_state = LPFC_HBA_ERROR;
 		retval = 1;
 	}
@@ -3278,6 +3284,9 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 	if (retval != MBX_SUCCESS) {
 		if (retval != MBX_BUSY)
 			mempool_free(pmb, phba->mbox_mem_pool);
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2752 KILL_BOARD command failed retval %d\n",
+				retval);
 		spin_lock_irq(&phba->hbalock);
 		phba->link_flag &= ~LS_IGNORE_ERATT;
 		spin_unlock_irq(&phba->hbalock);
@@ -4035,7 +4044,7 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
 
 lpfc_sli_hba_setup_error:
 	phba->link_state = LPFC_HBA_ERROR;
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"0445 Firmware initialization failed\n");
 	return rc;
 }


