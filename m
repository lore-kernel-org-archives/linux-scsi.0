From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/15] lpfc 8.1.7 : Fix memory leak and cleanup code related
	to per ring lookup array
Date: Thu, 06 Jul 2006 15:49:34 -0400
Message-ID: <1152215374.23158.20.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:18828 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750771AbWGFTtf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:49:35 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66JnHmQ006924
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:49:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix memory leak and cleanup code related to per ring lookup array.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2006-07-05 14:49:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2006-07-06 14:46:13.000000000 -0400
@@ -133,6 +133,11 @@ lpfc_mem_free(struct lpfc_hba * phba)
 
 	pci_pool_destroy(phba->lpfc_scsi_dma_buf_pool);
 	pci_pool_destroy(phba->lpfc_mbuf_pool);
+
+	/* Free the iocb lookup array */
+	kfree(psli->iocbq_lookup);
+	psli->iocbq_lookup = NULL;
+
 }
 
 void *
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2006-07-05 14:49:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2006-07-06 14:46:13.000000000 -0400
@@ -191,35 +191,12 @@ static int
 lpfc_sli_ringtxcmpl_put(struct lpfc_hba * phba,
 			struct lpfc_sli_ring * pring, struct lpfc_iocbq * piocb)
 {
-	uint16_t iotag;
-
 	list_add_tail(&piocb->list, &pring->txcmplq);
 	pring->txcmplq_cnt++;
 	if (unlikely(pring->ringno == LPFC_ELS_RING))
 		mod_timer(&phba->els_tmofunc,
 					jiffies + HZ * (phba->fc_ratov << 1));
 
-	if (pring->fast_lookup) {
-		/* Setup fast lookup based on iotag for completion */
-		iotag = piocb->iocb.ulpIoTag;
-		if (iotag && (iotag < pring->fast_iotag))
-			*(pring->fast_lookup + iotag) = piocb;
-		else {
-
-			/* Cmd ring <ringno> put: iotag <iotag> greater then
-			   configured max <fast_iotag> wd0 <icmd> */
-			lpfc_printf_log(phba,
-					KERN_ERR,
-					LOG_SLI,
-					"%d:0316 Cmd ring %d put: iotag x%x "
-					"greater then configured max x%x "
-					"wd0 x%x\n",
-					phba->brd_no,
-					pring->ringno, iotag,
-					pring->fast_iotag,
-					*(((uint32_t *)(&piocb->iocb)) + 7));
-		}
-	}
 	return (0);
 }
 
@@ -2659,8 +2636,6 @@ lpfc_sli_hba_down(struct lpfc_hba * phba
 
 		INIT_LIST_HEAD(&(pring->txq));
 
-		kfree(pring->fast_lookup);
-		pring->fast_lookup = NULL;
 	}
 
 	spin_unlock_irqrestore(phba->host->host_lock, flags);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2006-07-05 14:49:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2006-07-06 14:46:13.000000000 -0400
@@ -135,8 +135,6 @@ struct lpfc_sli_ring {
 	uint32_t fast_iotag;	/* max fastlookup based iotag           */
 	uint32_t iotag_ctr;	/* keeps track of the next iotag to use */
 	uint32_t iotag_max;	/* max iotag value to use               */
-	struct lpfc_iocbq ** fast_lookup; /* array of IOCB ptrs indexed by
-					   iotag */
 	struct list_head txq;
 	uint16_t txq_cnt;	/* current length of queue */
 	uint16_t txq_max;	/* max length */


