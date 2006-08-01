From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/6] lpfc 8.1.7 : Fix race condition between
	lpfc_sli_issue_mbox and lpfc_online
Date: Tue, 01 Aug 2006 07:33:52 -0400
Message-ID: <1154432033.18162.14.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:65480 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932650AbWHALd4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Aug 2006 07:33:56 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k71BXtdk000885
	for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2006 04:33:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix race condition between lpfc_sli_issue_mbox and lpfc_online

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2006-08-01 07:10:11.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2006-08-01 07:10:57.000000000 -0400
@@ -1711,15 +1711,13 @@ lpfc_sli_brdreset(struct lpfc_hba * phba
 	phba->fc_myDID = 0;
 	phba->fc_prevDID = 0;
 
-	psli->sli_flag = 0;
-
 	/* Turn off parity checking and serr during the physical reset */
 	pci_read_config_word(phba->pcidev, PCI_COMMAND, &cfg_value);
 	pci_write_config_word(phba->pcidev, PCI_COMMAND,
 			      (cfg_value &
 			       ~(PCI_COMMAND_PARITY | PCI_COMMAND_SERR)));
 
-	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+	psli->sli_flag &= ~(LPFC_SLI2_ACTIVE | LPFC_PROCESS_LA);
 	/* Now toggle INITFF bit in the Host Control Register */
 	writel(HC_INITFF, phba->HCregaddr);
 	mdelay(1);
@@ -1905,6 +1903,9 @@ lpfc_sli_hba_setup(struct lpfc_hba * phb
 	}
 
 	while (resetcount < 2 && !done) {
+		spin_lock_irq(phba->host->host_lock);
+		phba->sli.sli_flag |= LPFC_SLI_MBOX_ACTIVE;
+		spin_unlock_irq(phba->host->host_lock);
 		phba->hba_state = LPFC_STATE_UNKNOWN;
 		lpfc_sli_brdrestart(phba);
 		msleep(2500);
@@ -1912,6 +1913,9 @@ lpfc_sli_hba_setup(struct lpfc_hba * phb
 		if (rc)
 			break;
 
+		spin_lock_irq(phba->host->host_lock);
+		phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+		spin_unlock_irq(phba->host->host_lock);
 		resetcount++;
 
 	/* Call pre CONFIG_PORT mailbox command initialization.  A value of 0


