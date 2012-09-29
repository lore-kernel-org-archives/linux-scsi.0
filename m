From: James Smart <james.smart@emulex.com>
Subject: [PATCH 04/16] lpfc 8.3.35: Correct missing queue destroy on
 function reset
Date: Sat, 29 Sep 2012 11:29:29 -0400
Message-ID: <1348932569.23909.23.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:35006 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab2I2PfB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:35:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Correct missing queue destroy on function reset


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-09-26 21:11:28.318153726 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-09-26 21:11:34.543153866 -0400
@@ -3964,9 +3964,9 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba
 	pci_write_config_word(phba->pcidev, PCI_COMMAND, (cfg_value &
 			      ~(PCI_COMMAND_PARITY | PCI_COMMAND_SERR)));
 
-	/* Perform FCoE PCI function reset */
-	lpfc_sli4_queue_destroy(phba);
+	/* Perform FCoE PCI function reset before freeing queue memory */
 	rc = lpfc_pci_function_reset(phba);
+	lpfc_sli4_queue_destroy(phba);
 
 	/* Restore PCI cmd register */
 	pci_write_config_word(phba->pcidev, PCI_COMMAND, cfg_value);



