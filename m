From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 12/15] lpfc 8.1.7 : Correct the wait in attachment that
	delays for topology discovery
Date: Thu, 06 Jul 2006 15:50:36 -0400
Message-ID: <1152215436.23158.29.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:30604 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750782AbWGFTuU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:50:20 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66JoJLD006981
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:50:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Correct the wait in attachment that delays for topology discovery

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-07-06 14:50:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-07-06 15:01:03.000000000 -0400
@@ -405,19 +405,26 @@ lpfc_config_port_post(struct lpfc_hba * 
 	}
 	/* MBOX buffer will be freed in mbox compl */
 
-	i = 0;
+	return (0);
+}
+
+static int
+lpfc_discovery_wait(struct lpfc_hba *phba)
+{
+	int i = 0;
+
 	while ((phba->hba_state != LPFC_HBA_READY) ||
 	       (phba->num_disc_nodes) || (phba->fc_prli_sent) ||
 	       ((phba->fc_map_cnt == 0) && (i<2)) ||
-	       (psli->sli_flag & LPFC_SLI_MBOX_ACTIVE)) {
+	       (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE)) {
 		/* Check every second for 30 retries. */
 		i++;
 		if (i > 30) {
-			break;
+			return -ETIMEDOUT;
 		}
 		if ((i >= 15) && (phba->hba_state <= LPFC_LINK_DOWN)) {
 			/* The link is down.  Set linkdown timeout */
-			break;
+			return -ETIMEDOUT;
 		}
 
 		/* Delay for 1 second to give discovery time to complete. */
@@ -425,12 +432,7 @@ lpfc_config_port_post(struct lpfc_hba * 
 
 	}
 
-	/* Since num_disc_nodes keys off of PLOGI, delay a bit to let
-	 * any potential PRLIs to flush thru the SLI sub-system.
-	 */
-	msleep(50);
-
-	return (0);
+	return 0;
 }
 
 /************************************************************************/
@@ -1649,6 +1651,8 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		goto out_free_irq;
 	}
 
+	lpfc_discovery_wait(phba);
+
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
 		spin_lock_irq(phba->host->host_lock);
 		lpfc_poll_start_timer(phba);


