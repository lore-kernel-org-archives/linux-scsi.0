From: James Smart <james.smart@emulex.com>
Subject: [PATCH 16/21] lpfc 8.3.33: Change Naming convention for SLI4
 Interrupt vector
Date: Fri, 3 Aug 2012 12:36:33 -0400
Message-ID: <1344011793.6110.41.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:44846 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2HCQgk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:36:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change Naming convention for SLI4 Interrupt vector


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c    |    6 +++++-
 lpfc_sli4.h    |    3 +++
 lpfc_version.h |    5 +++++
 3 files changed, 13 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-07-22 14:23:12.197282023 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-07-22 14:27:16.366273544 -0400
@@ -8105,11 +8105,15 @@ enable_msix_vectors:
 	 * Assign MSI-X vectors to interrupt handlers
 	 */
 	for (index = 0; index < vectors; index++) {
+		memset(&phba->sli4_hba.handler_name[index], 0, 16);
+		sprintf((char *)&phba->sli4_hba.handler_name[index],
+			 LPFC_DRIVER_HANDLER_NAME"%d", index);
+
 		phba->sli4_hba.fcp_eq_hdl[index].idx = index;
 		phba->sli4_hba.fcp_eq_hdl[index].phba = phba;
 		rc = request_irq(phba->sli4_hba.msix_entries[index].vector,
 				 &lpfc_sli4_hba_intr_handler, IRQF_SHARED,
-				 LPFC_FP_DRIVER_HANDLER_NAME,
+				 (char *)&phba->sli4_hba.handler_name[index],
 				 &phba->sli4_hba.fcp_eq_hdl[index]);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2012-07-22 14:22:51.296282749 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2012-07-22 14:27:16.369273544 -0400
@@ -430,6 +430,8 @@ struct lpfc_sli4_lnk_info {
 	uint8_t lnk_no;
 };
 
+#define LPFC_SLI4_HANDLER_NAME_SZ	16
+
 /* SLI4 HBA data structure entries */
 struct lpfc_sli4_hba {
 	void __iomem *conf_regs_memmap_p; /* Kernel memory mapped address for
@@ -486,6 +488,7 @@ struct lpfc_sli4_hba {
 	struct lpfc_register sli_intf;
 	struct lpfc_pc_sli4_params pc_sli4_params;
 	struct msix_entry *msix_entries;
+	uint8_t handler_name[LPFC_FCP_IO_CHAN_MAX][LPFC_SLI4_HANDLER_NAME_SZ];
 	uint32_t cfg_eqn;
 	uint32_t msix_vec_nr;
 	struct lpfc_fcp_eq_hdl *fcp_eq_hdl; /* FCP per-WQ handle */
diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2012-07-22 11:18:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2012-07-22 14:27:16.370273544 -0400
@@ -20,9 +20,14 @@
 
 #define LPFC_DRIVER_VERSION "8.3.32"
 #define LPFC_DRIVER_NAME		"lpfc"
+
+/* Used for SLI 2/3 */
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"
 
+/* Used for SLI4 */
+#define LPFC_DRIVER_HANDLER_NAME	"lpfc:"
+
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
 #define LPFC_COPYRIGHT "Copyright(c) 2004-2009 Emulex.  All rights reserved."



