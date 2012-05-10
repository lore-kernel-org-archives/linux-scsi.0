From: James Smart <james.smart@emulex.com>
Subject: [PATCH 19/20] lpfc 8.3.31: Fixed system crash due to not providing
 SCSI error-handling host reset handler
Date: Wed, 9 May 2012 21:19:44 -0400
Message-ID: <1336612785.1996.48.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27901 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757301Ab2EJBTr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:19:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed system crash due to not providing SCSI error-handling host reset handler


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |   38 ++++++++++++++++++++++++++++++++++++++
 lpfc_sli.c  |   10 ++++++----
 2 files changed, 44 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:01:26.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:07:01.000000000 -0400
@@ -4959,6 +4959,43 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 }
 
 /**
+ * lpfc_host_reset_handler - scsi_host_template eh_host_reset_handler entry pt
+ * @cmnd: Pointer to scsi_cmnd data structure.
+ *
+ * This routine does host reset to the adaptor port. It brings the HBA
+ * offline, performs a board restart, and then brings the board back online.
+ * The lpfc_offline calls lpfc_sli_hba_down which will abort and local
+ * reject all outstanding SCSI commands to the host and error returned
+ * back to SCSI mid-level. As this will be SCSI mid-level's last resort
+ * of error handling, it will only return error if resetting of the adapter
+ * is not successful; in all other cases, will return success.
+ *
+ * Return code :
+ *  0x2003 - Error
+ *  0x2002 - Success
+ **/
+static int
+lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
+{
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+	int rc, ret = SUCCESS;
+
+	lpfc_offline_prep(phba);
+	lpfc_offline(phba);
+	rc = lpfc_sli_brdrestart(phba);
+	if (rc)
+		ret = FAILED;
+	lpfc_online(phba);
+	lpfc_unblock_mgmt_io(phba);
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
+			"3172 SCSI layer issued Host Reset Data: x%x\n", ret);
+	return ret;
+}
+
+/**
  * lpfc_slave_alloc - scsi_host_template slave_alloc entry point
  * @sdev: Pointer to scsi_device.
  *
@@ -5090,6 +5127,7 @@ struct scsi_host_template lpfc_template 
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
 	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
+	.eh_host_reset_handler  = lpfc_host_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:06:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:07:01.000000000 -0400
@@ -3885,6 +3885,7 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba
 {
 	struct lpfc_sli *psli = &phba->sli;
 	uint16_t cfg_value;
+	int rc;
 
 	/* Reset HBA */
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
@@ -3913,12 +3914,12 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba
 
 	/* Perform FCoE PCI function reset */
 	lpfc_sli4_queue_destroy(phba);
-	lpfc_pci_function_reset(phba);
+	rc = lpfc_pci_function_reset(phba);
 
 	/* Restore PCI cmd register */
 	pci_write_config_word(phba->pcidev, PCI_COMMAND, cfg_value);
 
-	return 0;
+	return rc;
 }
 
 /**
@@ -4010,6 +4011,7 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *
 {
 	struct lpfc_sli *psli = &phba->sli;
 	uint32_t hba_aer_enabled;
+	int rc;
 
 	/* Restart HBA */
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
@@ -4019,7 +4021,7 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *
 	/* Take PCIe device Advanced Error Reporting (AER) state */
 	hba_aer_enabled = phba->hba_flag & HBA_AER_ENABLED;
 
-	lpfc_sli4_brdreset(phba);
+	rc = lpfc_sli4_brdreset(phba);
 
 	spin_lock_irq(&phba->hbalock);
 	phba->pport->stopped = 0;
@@ -4036,7 +4038,7 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *
 
 	lpfc_hba_down_post(phba);
 
-	return 0;
+	return rc;
 }
 
 /**



