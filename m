From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/6] lpfc 8.1.4 : Introduce lpfc_reset_barrier() function
	for resets on dual channel adapters
Date: Tue, 07 Mar 2006 15:04:13 -0500
Message-ID: <1141761853.25430.18.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39116 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932332AbWCGUER
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 15:04:17 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k27K4Grf021512
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 12:04:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Introduce lpfc_reset_barrier() function for resets on dual channel adapters

Workaround for a hardware errata on dual channel asics. There is a
potential for the chip to lock up on a reset if a shared dma engine is in
use. The (ugly) work around requires a reset process which uses a mailbox
command to synchronize the independent channels prior to the reset to
avoid the issue. Unfortunately, the timing windows required to ensure this
workaround succeeds are very specific, meaning we can't release the cpu
during the barrier.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -155,6 +155,7 @@ lpfc_work_list_done(struct lpfc_hba * ph
 		case LPFC_EVT_WARM_START:
 			if (phba->hba_state >= LPFC_LINK_DOWN)
 				lpfc_offline(phba);
+			lpfc_reset_barrier(phba);
 			lpfc_sli_brdreset(phba);
 			lpfc_hba_down_post(phba);
 			*(int *)(evtp->evt_arg1) =
@@ -164,7 +165,8 @@ lpfc_work_list_done(struct lpfc_hba * ph
 		case LPFC_EVT_KILL:
 			if (phba->hba_state >= LPFC_LINK_DOWN)
 				lpfc_offline(phba);
-			*(int *)(evtp->evt_arg1)  = lpfc_sli_brdkill(phba);
+			*(int *)(evtp->evt_arg1)
+				= (phba->stopped) ? 0 : lpfc_sli_brdkill(phba);
 			complete((struct completion *)(evtp->evt_arg2));
 			break;
 		}
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -464,8 +464,6 @@ lpfc_hba_down_prep(struct lpfc_hba * phb
 	lpfc_els_flush_cmd(phba);
 	lpfc_disc_flush_list(phba);
 
-	/* Disable SLI2 since we disabled interrupts */
-	phba->sli.sli_flag &= ~LPFC_SLI2_ACTIVE;
 	return (0);
 }
 
@@ -526,6 +524,7 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 				phba->work_status[0], phba->work_status[1]);
 		spin_lock_irq(phba->host->host_lock);
 		phba->fc_flag |= FC_ESTABLISH_LINK;
+		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 		spin_unlock_irq(phba->host->host_lock);
 
 		/*
@@ -559,6 +558,7 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 				phba->brd_no, phba->work_hs,
 				phba->work_status[0], phba->work_status[1]);
 
+		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 		lpfc_offline(phba);
 		phba->hba_state = LPFC_HBA_ERROR;
 		lpfc_hba_down_post(phba);
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -139,6 +139,7 @@ struct lpfc_iocbq * lpfc_sli_get_iocbq(s
 void lpfc_sli_release_iocbq(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
 uint16_t lpfc_sli_next_iotag(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
 
+void lpfc_reset_barrier(struct lpfc_hba * phba);
 int lpfc_sli_brdready(struct lpfc_hba *, uint32_t);
 int lpfc_sli_brdkill(struct lpfc_hba *);
 int lpfc_sli_brdreset(struct lpfc_hba *);
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -197,6 +197,7 @@ struct lpfc_hba {
 #define LPFC_HBA_READY            32
 #define LPFC_HBA_ERROR            -1
 
+	int32_t stopped;   /* HBA has not been restarted since last ERATT */
 	uint8_t fc_linkspeed;	/* Link speed after last READ_LA */
 
 	uint32_t fc_eventTag;	/* event tag for link attention */
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1566,6 +1566,79 @@ lpfc_sli_brdready(struct lpfc_hba * phba
 	return retval;
 }
 
+#define BARRIER_TEST_PATTERN (0xdeadbeef)
+
+void lpfc_reset_barrier(struct lpfc_hba * phba)
+{
+	uint32_t * resp_buf;
+	uint32_t * mbox_buf;
+	volatile uint32_t mbox;
+	uint32_t hc_copy;
+	int  i;
+	uint8_t hdrtype;
+
+	pci_read_config_byte(phba->pcidev, PCI_HEADER_TYPE, &hdrtype);
+	if (hdrtype != 0x80 ||
+	    (FC_JEDEC_ID(phba->vpd.rev.biuRev) != HELIOS_JEDEC_ID &&
+	     FC_JEDEC_ID(phba->vpd.rev.biuRev) != THOR_JEDEC_ID))
+		return;
+
+	/*
+	 * Tell the other part of the chip to suspend temporarily all
+	 * its DMA activity.
+	 */
+	resp_buf =  (uint32_t *)phba->MBslimaddr;
+
+	/* Disable the error attention */
+	hc_copy = readl(phba->HCregaddr);
+	writel((hc_copy & ~HC_ERINT_ENA), phba->HCregaddr);
+	readl(phba->HCregaddr); /* flush */
+
+	if (readl(phba->HAregaddr) & HA_ERATT) {
+		/* Clear Chip error bit */
+		writel(HA_ERATT, phba->HAregaddr);
+		phba->stopped = 1;
+	}
+
+	mbox = 0;
+	((MAILBOX_t *)&mbox)->mbxCommand = MBX_KILL_BOARD;
+	((MAILBOX_t *)&mbox)->mbxOwner = OWN_CHIP;
+
+	writel(BARRIER_TEST_PATTERN, (resp_buf + 1));
+	mbox_buf = (uint32_t *)phba->MBslimaddr;
+	writel(mbox, mbox_buf);
+
+	for (i = 0;
+	     readl(resp_buf + 1) != ~(BARRIER_TEST_PATTERN) && i < 50; i++)
+		mdelay(1);
+
+	if (readl(resp_buf + 1) != ~(BARRIER_TEST_PATTERN)) {
+		if (phba->sli.sli_flag & LPFC_SLI2_ACTIVE ||
+		    phba->stopped)
+			goto restore_hc;
+		else
+			goto clear_errat;
+	}
+
+	((MAILBOX_t *)&mbox)->mbxOwner = OWN_HOST;
+	for (i = 0; readl(resp_buf) != mbox &&  i < 500; i++)
+		mdelay(1);
+
+clear_errat:
+
+	while (!(readl(phba->HAregaddr) & HA_ERATT) && ++i < 500)
+		mdelay(1);
+
+	if (readl(phba->HAregaddr) & HA_ERATT) {
+		writel(HA_ERATT, phba->HAregaddr);
+		phba->stopped = 1;
+	}
+
+restore_hc:
+	writel(hc_copy, phba->HCregaddr);
+	readl(phba->HCregaddr); /* flush */
+}
+
 int
 lpfc_sli_brdkill(struct lpfc_hba * phba)
 {
@@ -1588,9 +1661,8 @@ lpfc_sli_brdkill(struct lpfc_hba * phba)
 		psli->sli_flag);
 
 	if ((pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
-						  GFP_ATOMIC)) == 0) {
+						  GFP_KERNEL)) == 0)
 		return 1;
-	}
 
 	/* Disable the error attention */
 	spin_lock_irq(phba->host->host_lock);
@@ -1610,6 +1682,8 @@ lpfc_sli_brdkill(struct lpfc_hba * phba)
 		return 1;
 	}
 
+	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	/* There is no completion for a KILL_BOARD mbox cmd. Check for an error
@@ -1625,7 +1699,10 @@ lpfc_sli_brdkill(struct lpfc_hba * phba)
 	}
 
 	del_timer_sync(&psli->mbox_tmo);
-
+	if (ha_copy & HA_ERATT) {
+		writel(HA_ERATT, phba->HAregaddr);
+		phba->stopped = 1;
+	}
 	spin_lock_irq(phba->host->host_lock);
 	psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 	spin_unlock_irq(phba->host->host_lock);
@@ -1665,6 +1742,7 @@ lpfc_sli_brdreset(struct lpfc_hba * phba
 			      (cfg_value &
 			       ~(PCI_COMMAND_PARITY | PCI_COMMAND_SERR)));
 
+	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 	/* Now toggle INITFF bit in the Host Control Register */
 	writel(HC_INITFF, phba->HCregaddr);
 	mdelay(1);
@@ -1713,6 +1791,8 @@ lpfc_sli_brdrestart(struct lpfc_hba * ph
 	mb->mbxCommand = MBX_RESTART;
 	mb->mbxHc = 1;
 
+	lpfc_reset_barrier(phba);
+
 	to_slim = phba->MBslimaddr;
 	writel(*(uint32_t *) mb, to_slim);
 	readl(to_slim); /* flush */
@@ -1730,7 +1810,7 @@ lpfc_sli_brdrestart(struct lpfc_hba * ph
 	readl(to_slim); /* flush */
 
 	lpfc_sli_brdreset(phba);
-
+	phba->stopped = 0;
 	phba->hba_state = LPFC_INIT_START;
 
 	spin_unlock_irq(phba->host->host_lock);
@@ -2038,6 +2118,13 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 		return (MBX_NOT_FINISHED);
 	}
 
+	if (mb->mbxCommand != MBX_KILL_BOARD && flag & MBX_NOWAIT &&
+	    !(readl(phba->HCregaddr) & HC_MBINT_ENA)) {
+		spin_unlock_irqrestore(phba->host->host_lock, drvr_flag);
+		LOG_MBOX_CANNOT_ISSUE_DATA( phba, mb, psli, flag)
+		return (MBX_NOT_FINISHED);
+	}
+
 	if (psli->sli_flag & LPFC_SLI_MBOX_ACTIVE) {
 		/* Polling for a mbox command when another one is already active
 		 * is not allowed in SLI. Also, the driver must have established
@@ -2154,8 +2241,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 		/* First copy command data to host SLIM area */
 		lpfc_sli_pcimem_bcopy(mb, &phba->slim2p->mbx, MAILBOX_CMD_SIZE);
 	} else {
-		if (mb->mbxCommand == MBX_CONFIG_PORT ||
-		    mb->mbxCommand == MBX_KILL_BOARD) {
+		if (mb->mbxCommand == MBX_CONFIG_PORT) {
 			/* copy command data into host mbox for cmpl */
 			lpfc_sli_pcimem_bcopy(mb, &phba->slim2p->mbx,
 					MAILBOX_CMD_SIZE);
@@ -3121,6 +3207,7 @@ lpfc_intr_handler(int irq, void *dev_id,
 			/* Clear Chip error bit */
 			writel(HA_ERATT, phba->HAregaddr);
 			readl(phba->HAregaddr); /* flush */
+			phba->stopped = 1;
 		}
 
 		spin_lock(phba->host->host_lock);


