From: James Smart <james.smart@emulex.com>
Subject: [PATCH 05/16] lpfc 8.3.35: Expand I/O channel support for large
 systems
Date: Sat, 29 Sep 2012 11:29:50 -0400
Message-ID: <1348932590.23909.24.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:35008 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab2I2PfW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:35:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Expand I/O channel support for large systems


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   40 +++++++++++++++++++++-------------------
 lpfc_sli4.h |    4 +---
 2 files changed, 22 insertions(+), 22 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 21:11:36.039153900 -0400
@@ -4947,7 +4947,7 @@ lpfc_sli4_driver_resource_setup(struct l
 	}
 
 	phba->sli4_hba.msix_entries = kzalloc((sizeof(struct msix_entry) *
-				      phba->sli4_hba.cfg_eqn), GFP_KERNEL);
+				      phba->cfg_fcp_io_channel), GFP_KERNEL);
 	if (!phba->sli4_hba.msix_entries) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2573 Failed allocate memory for msi-x "
@@ -6559,7 +6559,8 @@ lpfc_sli4_queue_verify(struct lpfc_hba *
 		i++;
 	}
 	if (i < cfg_fcp_io_channel) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+		lpfc_printf_log(phba,
+				KERN_ERR, LOG_INIT,
 				"3188 Reducing IO channels to match number of "
 				"CPUs: from %d to %d\n", cfg_fcp_io_channel, i);
 		cfg_fcp_io_channel = i;
@@ -6567,8 +6568,8 @@ lpfc_sli4_queue_verify(struct lpfc_hba *
 
 	if (cfg_fcp_io_channel >
 	    phba->sli4_hba.max_cfg_param.max_eq) {
-		cfg_fcp_io_channel = phba->sli4_hba.max_cfg_param.max_eq;
-		if (cfg_fcp_io_channel < LPFC_FCP_IO_CHAN_MIN) {
+		if (phba->sli4_hba.max_cfg_param.max_eq <
+		    LPFC_FCP_IO_CHAN_MIN) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"2574 Not enough EQs (%d) from the "
 					"pci function for supporting FCP "
@@ -6577,13 +6578,12 @@ lpfc_sli4_queue_verify(struct lpfc_hba *
 					phba->cfg_fcp_io_channel);
 			goto out_error;
 		}
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
-				"2575 Not enough EQs (%d) from the pci "
-				"function for supporting the requested "
-				"FCP EQs (%d), the actual FCP EQs can "
-				"be supported: %d\n",
-				phba->sli4_hba.max_cfg_param.max_eq,
-				phba->cfg_fcp_io_channel, cfg_fcp_io_channel);
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2575 Reducing IO channels to match number of "
+				"available EQs: from %d to %d\n",
+				cfg_fcp_io_channel,
+				phba->sli4_hba.max_cfg_param.max_eq);
+		cfg_fcp_io_channel = phba->sli4_hba.max_cfg_param.max_eq;
 	}
 
 	/* Eventually cfg_fcp_eq_count / cfg_fcp_wq_count will be depricated */
@@ -6592,7 +6592,6 @@ lpfc_sli4_queue_verify(struct lpfc_hba *
 	phba->cfg_fcp_eq_count = cfg_fcp_io_channel;
 	phba->cfg_fcp_wq_count = cfg_fcp_io_channel;
 	phba->cfg_fcp_io_channel = cfg_fcp_io_channel;
-	phba->sli4_hba.cfg_eqn = cfg_fcp_io_channel;
 
 	/* Get EQ depth from module parameter, fake the default for now */
 	phba->sli4_hba.eq_esize = LPFC_EQE_SIZE_4B;
@@ -8095,11 +8094,11 @@ lpfc_sli4_enable_msix(struct lpfc_hba *p
 	int vectors, rc, index;
 
 	/* Set up MSI-X multi-message vectors */
-	for (index = 0; index < phba->sli4_hba.cfg_eqn; index++)
+	for (index = 0; index < phba->cfg_fcp_io_channel; index++)
 		phba->sli4_hba.msix_entries[index].entry = index;
 
 	/* Configure MSI-X capability structure */
-	vectors = phba->sli4_hba.cfg_eqn;
+	vectors = phba->cfg_fcp_io_channel;
 enable_msix_vectors:
 	rc = pci_enable_msix(phba->pcidev, phba->sli4_hba.msix_entries,
 			     vectors);
@@ -8142,8 +8141,14 @@ enable_msix_vectors:
 			goto cfg_fail_out;
 		}
 	}
-	phba->sli4_hba.msix_vec_nr = vectors;
 
+	if (vectors != phba->cfg_fcp_io_channel) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3238 Reducing IO channels to match number of "
+				"MSI-X vectors, requested %d got %d\n",
+				phba->cfg_fcp_io_channel, vectors);
+		phba->cfg_fcp_io_channel = vectors;
+	}
 	return rc;
 
 cfg_fail_out:
@@ -8171,7 +8176,7 @@ lpfc_sli4_disable_msix(struct lpfc_hba *
 	int index;
 
 	/* Free up MSI-X multi-message vectors */
-	for (index = 0; index < phba->sli4_hba.msix_vec_nr; index++)
+	for (index = 0; index < phba->cfg_fcp_io_channel; index++)
 		free_irq(phba->sli4_hba.msix_entries[index].vector,
 			 &phba->sli4_hba.fcp_eq_hdl[index]);
 
@@ -9525,9 +9530,6 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 		/* Default to single EQ for non-MSI-X */
 		if (phba->intr_type != MSIX)
 			adjusted_fcp_io_channel = 1;
-		else if (phba->sli4_hba.msix_vec_nr <
-					phba->cfg_fcp_io_channel)
-			adjusted_fcp_io_channel = phba->sli4_hba.msix_vec_nr;
 		else
 			adjusted_fcp_io_channel = phba->cfg_fcp_io_channel;
 		phba->cfg_fcp_io_channel = adjusted_fcp_io_channel;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2012-09-26 21:11:18.456153500 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2012-09-26 21:11:36.040153900 -0400
@@ -37,7 +37,7 @@
 /* Multi-queue arrangement for FCP EQ/CQ/WQ tuples */
 #define LPFC_FCP_IO_CHAN_DEF       4
 #define LPFC_FCP_IO_CHAN_MIN       1
-#define LPFC_FCP_IO_CHAN_MAX       8
+#define LPFC_FCP_IO_CHAN_MAX       16
 
 /*
  * Provide the default FCF Record attributes used by the driver
@@ -490,8 +490,6 @@ struct lpfc_sli4_hba {
 	struct lpfc_pc_sli4_params pc_sli4_params;
 	struct msix_entry *msix_entries;
 	uint8_t handler_name[LPFC_FCP_IO_CHAN_MAX][LPFC_SLI4_HANDLER_NAME_SZ];
-	uint32_t cfg_eqn;
-	uint32_t msix_vec_nr;
 	struct lpfc_fcp_eq_hdl *fcp_eq_hdl; /* FCP per-WQ handle */
 
 	/* Pointers to the constructed SLI4 queues */



