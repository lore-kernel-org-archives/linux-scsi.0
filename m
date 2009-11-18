From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/6] lpfc 8.3.6 : Fix AER issues
Date: Wed, 18 Nov 2009 15:40:23 -0500
Message-ID: <1258576843.29086.16.camel@wookie>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50856 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbZKRUkj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 15:40:39 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id nAIKekQ7012643
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 12:40:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix AER issues.
 - Made AER sysfs entry point return "Operation not permitted" to
   OneConnect HBAs
 - Stop and abort all I/Os on HBA for AER uncorrectable non-fatal error
   handling
 

 Signed-off-by: James Smart <james.smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_attr.c    |   33 +++++++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_hbadisc.c |   10 +++++++++-
 drivers/scsi/lpfc/lpfc_init.c    |   29 ++++++++++++++++++++++++++---
 3 files changed, 60 insertions(+), 12 deletions(-)
 mode change 100644 => 100755 drivers/scsi/lpfc/lpfc_hbadisc.c

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index d55befb..7552360 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2835,6 +2835,9 @@ lpfc_aer_support_store(struct device *dev, struct device_attribute *attr,
 	struct lpfc_hba *phba = vport->phba;
 	int val = 0, rc = -EINVAL;
 
+	/* AER not supported on OC devices yet */
+	if (phba->pci_dev_grp == LPFC_PCI_DEV_OC)
+		return -EPERM;
 	if (!isdigit(buf[0]))
 		return -EINVAL;
 	if (sscanf(buf, "%i", &val) != 1)
@@ -2851,10 +2854,11 @@ lpfc_aer_support_store(struct device *dev, struct device_attribute *attr,
 				phba->cfg_aer_support = 0;
 				rc = strlen(buf);
 			} else
-				rc = -EINVAL;
-		} else
+				rc = -EPERM;
+		} else {
 			phba->cfg_aer_support = 0;
-		rc = strlen(buf);
+			rc = strlen(buf);
+		}
 		break;
 	case 1:
 		if (!(phba->hba_flag & HBA_AER_ENABLED)) {
@@ -2866,10 +2870,11 @@ lpfc_aer_support_store(struct device *dev, struct device_attribute *attr,
 				phba->cfg_aer_support = 1;
 				rc = strlen(buf);
 			} else
-				 rc = -EINVAL;
-		} else
+				 rc = -EPERM;
+		} else {
 			phba->cfg_aer_support = 1;
-		rc = strlen(buf);
+			rc = strlen(buf);
+		}
 		break;
 	default:
 		rc = -EINVAL;
@@ -2905,6 +2910,12 @@ lpfc_param_show(aer_support)
 static int
 lpfc_aer_support_init(struct lpfc_hba *phba, int val)
 {
+	/* AER not supported on OC devices yet */
+	if (phba->pci_dev_grp == LPFC_PCI_DEV_OC) {
+		phba->cfg_aer_support = 0;
+		return -EPERM;
+	}
+
 	if (val == 0 || val == 1) {
 		phba->cfg_aer_support = val;
 		return 0;
@@ -2913,6 +2924,7 @@ lpfc_aer_support_init(struct lpfc_hba *phba, int val)
 			"2712 lpfc_aer_support attribute value %d out "
 			"of range, allowed values are 0|1, setting it "
 			"to default value of 1\n", val);
+	/* By default, try to enable AER on a device */
 	phba->cfg_aer_support = 1;
 	return -EINVAL;
 }
@@ -2948,18 +2960,23 @@ lpfc_aer_cleanup_state(struct device *dev, struct device_attribute *attr,
 	struct lpfc_hba   *phba = vport->phba;
 	int val, rc = -1;
 
+	/* AER not supported on OC devices yet */
+	if (phba->pci_dev_grp == LPFC_PCI_DEV_OC)
+		return -EPERM;
 	if (!isdigit(buf[0]))
 		return -EINVAL;
 	if (sscanf(buf, "%i", &val) != 1)
 		return -EINVAL;
+	if (val != 1)
+		return -EINVAL;
 
-	if (val == 1 && phba->hba_flag & HBA_AER_ENABLED)
+	if (phba->hba_flag & HBA_AER_ENABLED)
 		rc = pci_cleanup_aer_uncorrect_error_status(phba->pcidev);
 
 	if (rc == 0)
 		return strlen(buf);
 	else
-		return -EINVAL;
+		return -EPERM;
 }
 
 static DEVICE_ATTR(lpfc_aer_state_cleanup, S_IWUSR, NULL,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
old mode 100644
new mode 100755
index 3c06aa5..4d7d884
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4369,6 +4369,14 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
 				ret = 1;
 				spin_unlock_irq(shost->host_lock);
 				goto out;
+			} else {
+				lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+					"2624 RPI %x DID %x flg %x still "
+					"logged in\n",
+					ndlp->nlp_rpi, ndlp->nlp_DID,
+					ndlp->nlp_flag);
+				if (ndlp->nlp_flag & NLP_RPI_VALID)
+					ret = 1;
 			}
 		}
 		spin_unlock_irq(shost->host_lock);
@@ -4465,7 +4473,7 @@ lpfc_unregister_unused_fcf(struct lpfc_hba *phba)
 		(phba->sli3_options & LPFC_SLI3_NPIV_ENABLED))
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			lpfc_mbx_unreg_vpi(vports[i]);
-			vports[i]->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+			vports[i]->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
 			vports[i]->vpi_state &= ~LPFC_VPI_REGISTERED;
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2b11280..33ed4b3 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7142,6 +7142,28 @@ lpfc_pci_resume_one_s3(struct pci_dev *pdev)
 }
 
 /**
+ * lpfc_sli_prep_dev_for_recover - Prepare SLI3 device for pci slot recover
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is called to prepare the SLI3 device for PCI slot recover. It
+ * aborts and stops all the on-going I/Os on the pci device.
+ **/
+static void
+lpfc_sli_prep_dev_for_recover(struct lpfc_hba *phba)
+{
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2723 PCI channel I/O abort preparing for recovery\n");
+	/* Prepare for bringing HBA offline */
+	lpfc_offline_prep(phba);
+	/* Clear sli active flag to prevent sysfs access to HBA */
+	spin_lock_irq(&phba->hbalock);
+	phba->sli.sli_flag &= ~LPFC_SLI_ACTIVE;
+	spin_unlock_irq(&phba->hbalock);
+	/* Stop and flush all I/Os and bring HBA offline */
+	lpfc_offline(phba);
+}
+
+/**
  * lpfc_sli_prep_dev_for_reset - Prepare SLI3 device for pci slot reset
  * @phba: pointer to lpfc hba data structure.
  *
@@ -7156,7 +7178,7 @@ lpfc_sli_prep_dev_for_reset(struct lpfc_hba *phba)
 	struct lpfc_sli_ring  *pring;
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"2710 PCI channel I/O frozen\n");
+			"2710 PCI channel disable preparing for reset\n");
 	/* Disable interrupt and pci device */
 	lpfc_sli_disable_intr(phba);
 	pci_disable_device(phba->pcidev);
@@ -7181,7 +7203,7 @@ static void
 lpfc_prep_dev_for_perm_failure(struct lpfc_hba *phba)
 {
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"2711 PCI channel I/O permanent failure\n");
+			"2711 PCI channel permanent disable for failure\n");
 	/* Block all SCSI devices' I/Os on the host */
 	lpfc_scsi_dev_block(phba);
 	/* Clean up all driver's outstanding SCSI I/Os */
@@ -7214,7 +7236,8 @@ lpfc_io_error_detected_s3(struct pci_dev *pdev, pci_channel_state_t state)
 
 	switch (state) {
 	case pci_channel_io_normal:
-		/* Non-fatal error, do nothing */
+		/* Non-fatal error, prepare for recovery */
+		lpfc_sli_prep_dev_for_recover(phba);
 		return PCI_ERS_RESULT_CAN_RECOVER;
 	case pci_channel_io_frozen:
 		/* Fatal error, prepare for slot reset */
-- 
1.6.0.6



