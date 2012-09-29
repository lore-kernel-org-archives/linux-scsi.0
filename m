From: James Smart <james.smart@emulex.com>
Subject: [PATCH 06/16] lpfc 8.3.35: Fixed Linux generic firmware download on
 SLI4 devices with longer module names
Date: Sat, 29 Sep 2012 11:30:06 -0400
Message-ID: <1348932606.23909.25.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:33783 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab2I2Pfk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:35:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed Linux generic firmware download on SLI4 devices with longer module names


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    2 ++
 lpfc_init.c |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2012-09-26 21:11:37.205153927 -0400
@@ -27,6 +27,8 @@
 
 struct lpfc_sli2_slim;
 
+#define ELX_MODEL_NAME_SIZE	80
+
 #define LPFC_PCI_DEV_LP		0x1
 #define LPFC_PCI_DEV_OC		0x2
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 21:11:36.039153900 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 21:11:37.227153927 -0400
@@ -9428,7 +9428,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	int mcnt;
 	int adjusted_fcp_io_channel;
 	const struct firmware *fw;
-	uint8_t file_name[16];
+	uint8_t file_name[ELX_MODEL_NAME_SIZE];
 
 	/* Allocate memory for HBA structure */
 	phba = lpfc_hba_alloc(pdev);
@@ -9574,7 +9574,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	/* check for firmware upgrade or downgrade (if_type 2 only) */
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
 	    LPFC_SLI_INTF_IF_TYPE_2) {
-		snprintf(file_name, 16, "%s.grp", phba->ModelName);
+		snprintf(file_name, ELX_MODEL_NAME_SIZE, "%s.grp",
+			 phba->ModelName);
 		error = request_firmware(&fw, file_name, &phba->pcidev->dev);
 		if (!error) {
 			lpfc_write_firmware(phba, fw);



