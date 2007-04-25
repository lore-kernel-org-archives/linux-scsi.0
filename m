From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 12/16] lpfc 8.1.12 : Don't process ERATT interrupts when
	issuing KILL_BOARD mbx command
Date: Wed, 25 Apr 2007 09:53:15 -0400
Message-ID: <1177509195.23155.19.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51746 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031036AbXDYNxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:53:07 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDr6ZX006685
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:53:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Don't process ERATT interrupts when issuing KILL_BOARD mbx command

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-04-24 11:12:43.000000000 -0400
@@ -250,6 +250,7 @@ struct lpfc_hba {
 #define FC_LOOPBACK_MODE        0x40000	/* NPort is in Loopback mode */
 					/* This flag is set while issuing */
 					/* INIT_LINK mailbox command */
+#define FC_IGNORE_ERATT         0x80000	/* intr handler should ignore ERATT */
 
 	uint32_t fc_topology;	/* link topology, from LINK INIT */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:43.000000000 -0400
@@ -1584,6 +1584,7 @@ void lpfc_reset_barrier(struct lpfc_hba 
 	hc_copy = readl(phba->HCregaddr);
 	writel((hc_copy & ~HC_ERINT_ENA), phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
+	phba->fc_flag |= FC_IGNORE_ERATT;
 
 	if (readl(phba->HAregaddr) & HA_ERATT) {
 		/* Clear Chip error bit */
@@ -1626,6 +1627,7 @@ clear_errat:
 	}
 
 restore_hc:
+	phba->fc_flag &= ~FC_IGNORE_ERATT;
 	writel(hc_copy, phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
 }
@@ -1661,6 +1663,7 @@ lpfc_sli_brdkill(struct lpfc_hba * phba)
 	status &= ~HC_ERINT_ENA;
 	writel(status, phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
+	phba->fc_flag |= FC_IGNORE_ERATT;
 	spin_unlock_irq(phba->host->host_lock);
 
 	lpfc_kill_board(phba, pmb);
@@ -1670,6 +1673,9 @@ lpfc_sli_brdkill(struct lpfc_hba * phba)
 	if (retval != MBX_SUCCESS) {
 		if (retval != MBX_BUSY)
 			mempool_free(pmb, phba->mbox_mem_pool);
+		spin_lock_irq(phba->host->host_lock);
+		phba->fc_flag &= ~FC_IGNORE_ERATT;
+		spin_unlock_irq(phba->host->host_lock);
 		return 1;
 	}
 
@@ -1696,6 +1702,7 @@ lpfc_sli_brdkill(struct lpfc_hba * phba)
 	}
 	spin_lock_irq(phba->host->host_lock);
 	psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
+	phba->fc_flag &= ~FC_IGNORE_ERATT;
 	spin_unlock_irq(phba->host->host_lock);
 
 	psli->mbox_active = NULL;
@@ -3207,6 +3214,11 @@ lpfc_intr_handler(int irq, void *dev_id)
 	 */
 	spin_lock(phba->host->host_lock);
 	ha_copy = readl(phba->HAregaddr);
+	/* If somebody is waiting to handle an eratt don't process it
+	 * here.  The brdkill function will do this.
+	 */
+	if (phba->fc_flag & FC_IGNORE_ERATT)
+		ha_copy &= ~HA_ERATT;
 	writel((ha_copy & ~(HA_LATT | HA_ERATT)), phba->HAregaddr);
 	readl(phba->HAregaddr); /* flush */
 	spin_unlock(phba->host->host_lock);


