From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 04/17] lpfc: NVME Initiator: Base modifications Part C
Date: Tue, 17 Jan 2017 17:20:47 -0800
Message-ID: <587ec2ef.Y/y2qvlPHm64sAst%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33931 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdARBUy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 20:20:54 -0500
Received: by mail-wm0-f66.google.com with SMTP id c85so271458wmi.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 17:20:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Initiator: Base modifications

This is part C of parts A..F.

Part C is the 1st half of the mods to lpfc_init.c. This is the location
of most of changes for the following:
- sli3 ring vs sli4 wq splits
- buffer pools are allocated/freed
- sgl pools allocated/freed
- adapter resources split up
- queue config decided and enacted
- receive buffer management

*********

Refer to Part A for a description of base modifications

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 1086 +++++++++++++++++++++++++++--------------
 1 file changed, 724 insertions(+), 362 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7a17bd0..ca54beb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -34,6 +34,7 @@
 #include <linux/firmware.h>
 #include <linux/miscdevice.h>
 #include <linux/percpu.h>
+#include <linux/msi.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -46,8 +47,9 @@
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
-#include "lpfc_scsi.h"
 #include "lpfc.h"
+#include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
@@ -87,6 +89,7 @@ static struct scsi_transport_template *lpfc_transport_template = NULL;
 static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
 static DEFINE_IDR(lpfc_hba_index);
 
+
 /**
  * lpfc_config_port_prep - Perform lpfc initialization prior to config port
  * @phba: pointer to lpfc hba data structure.
@@ -499,12 +502,10 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	phba->link_state = LPFC_LINK_DOWN;
 
 	/* Only process IOCBs on ELS ring till hba_state is READY */
-	if (psli->ring[psli->extra_ring].sli.sli3.cmdringaddr)
-		psli->ring[psli->extra_ring].flag |= LPFC_STOP_IOCB_EVENT;
-	if (psli->ring[psli->fcp_ring].sli.sli3.cmdringaddr)
-		psli->ring[psli->fcp_ring].flag |= LPFC_STOP_IOCB_EVENT;
-	if (psli->ring[psli->next_ring].sli.sli3.cmdringaddr)
-		psli->ring[psli->next_ring].flag |= LPFC_STOP_IOCB_EVENT;
+	if (psli->sli3_ring[LPFC_EXTRA_RING].sli.sli3.cmdringaddr)
+		psli->sli3_ring[LPFC_EXTRA_RING].flag |= LPFC_STOP_IOCB_EVENT;
+	if (psli->sli3_ring[LPFC_FCP_RING].sli.sli3.cmdringaddr)
+		psli->sli3_ring[LPFC_FCP_RING].flag |= LPFC_STOP_IOCB_EVENT;
 
 	/* Post receive buffers for desired rings */
 	if (phba->sli_rev != 3)
@@ -892,7 +893,7 @@ lpfc_hba_free_post_buf(struct lpfc_hba *phba)
 		lpfc_sli_hbqbuf_free_all(phba);
 	else {
 		/* Cleanup preposted buffers on the ELS ring */
-		pring = &psli->ring[LPFC_ELS_RING];
+		pring = &psli->sli3_ring[LPFC_ELS_RING];
 		spin_lock_irq(&phba->hbalock);
 		list_splice_init(&pring->postbufq, &buflist);
 		spin_unlock_irq(&phba->hbalock);
@@ -925,32 +926,43 @@ static void
 lpfc_hba_clean_txcmplq(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_queue *qp = NULL;
 	struct lpfc_sli_ring *pring;
 	LIST_HEAD(completions);
 	int i;
 
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
-		if (phba->sli_rev >= LPFC_SLI_REV4)
-			spin_lock_irq(&pring->ring_lock);
-		else
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		for (i = 0; i < psli->num_rings; i++) {
+			pring = &psli->sli3_ring[i];
 			spin_lock_irq(&phba->hbalock);
-		/* At this point in time the HBA is either reset or DOA. Either
-		 * way, nothing should be on txcmplq as it will NEVER complete.
-		 */
-		list_splice_init(&pring->txcmplq, &completions);
-		pring->txcmplq_cnt = 0;
-
-		if (phba->sli_rev >= LPFC_SLI_REV4)
-			spin_unlock_irq(&pring->ring_lock);
-		else
+			/* At this point in time the HBA is either reset or DOA
+			 * Nothing should be on txcmplq as it will
+			 * NEVER complete.
+			 */
+			list_splice_init(&pring->txcmplq, &completions);
+			pring->txcmplq_cnt = 0;
 			spin_unlock_irq(&phba->hbalock);
 
+			lpfc_sli_abort_iocb_ring(phba, pring);
+		}
 		/* Cancel all the IOCBs from the completions list */
-		lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
-				      IOERR_SLI_ABORTED);
+		lpfc_sli_cancel_iocbs(phba, &completions,
+				      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
+		return;
+	}
+	list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+		pring = qp->pring;
+		if (!pring)
+			continue;
+		spin_lock_irq(&pring->ring_lock);
+		list_splice_init(&pring->txcmplq, &completions);
+		pring->txcmplq_cnt = 0;
+		spin_unlock_irq(&pring->ring_lock);
 		lpfc_sli_abort_iocb_ring(phba, pring);
 	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions,
+			      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
 }
 
 /**
@@ -989,43 +1001,51 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 {
 	struct lpfc_scsi_buf *psb, *psb_next;
 	LIST_HEAD(aborts);
+	LIST_HEAD(nvme_aborts);
 	unsigned long iflag = 0;
 	struct lpfc_sglq *sglq_entry = NULL;
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *pring;
 
-	lpfc_hba_free_post_buf(phba);
+
+	lpfc_sli_hbqbuf_free_all(phba);
 	lpfc_hba_clean_txcmplq(phba);
-	pring = &psli->ring[LPFC_ELS_RING];
 
 	/* At this point in time the HBA is either reset or DOA. Either
 	 * way, nothing should be on lpfc_abts_els_sgl_list, it needs to be
-	 * on the lpfc_sgl_list so that it can either be freed if the
+	 * on the lpfc_els_sgl_list so that it can either be freed if the
 	 * driver is unloading or reposted if the driver is restarting
 	 * the port.
 	 */
-	spin_lock_irq(&phba->hbalock);  /* required for lpfc_sgl_list and */
+	spin_lock_irq(&phba->hbalock);  /* required for lpfc_els_sgl_list and */
 					/* scsl_buf_list */
-	/* abts_sgl_list_lock required because worker thread uses this
+	/* sgl_list_lock required because worker thread uses this
 	 * list.
 	 */
-	spin_lock(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
 	list_for_each_entry(sglq_entry,
 		&phba->sli4_hba.lpfc_abts_els_sgl_list, list)
 		sglq_entry->state = SGL_FREED;
 
-	spin_lock(&pring->ring_lock);
 	list_splice_init(&phba->sli4_hba.lpfc_abts_els_sgl_list,
-			&phba->sli4_hba.lpfc_sgl_list);
-	spin_unlock(&pring->ring_lock);
-	spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
+			&phba->sli4_hba.lpfc_els_sgl_list);
+
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	/* abts_scsi_buf_list_lock required because worker thread uses this
 	 * list.
 	 */
-	spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
-	list_splice_init(&phba->sli4_hba.lpfc_abts_scsi_buf_list,
-			&aborts);
-	spin_unlock(&phba->sli4_hba.abts_scsi_buf_list_lock);
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+		spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
+		list_splice_init(&phba->sli4_hba.lpfc_abts_scsi_buf_list,
+				 &aborts);
+		spin_unlock(&phba->sli4_hba.abts_scsi_buf_list_lock);
+	}
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		list_splice_init(&phba->sli4_hba.lpfc_abts_nvme_buf_list,
+				 &nvme_aborts);
+		spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+	}
+
 	spin_unlock_irq(&phba->hbalock);
 
 	list_for_each_entry_safe(psb, psb_next, &aborts, list) {
@@ -1036,6 +1056,14 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 	list_splice(&aborts, &phba->lpfc_scsi_buf_list_put);
 	spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
 
+	list_for_each_entry_safe(psb, psb_next, &nvme_aborts, list) {
+		psb->pCmd = NULL;
+		psb->status = IOSTAT_SUCCESS;
+	}
+	spin_lock_irqsave(&phba->nvme_buf_list_put_lock, iflag);
+	list_splice(&nvme_aborts, &phba->lpfc_nvme_buf_list_put);
+	spin_unlock_irqrestore(&phba->nvme_buf_list_put_lock, iflag);
+
 	lpfc_sli4_free_sp_events(phba);
 	return 0;
 }
@@ -1829,7 +1857,7 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked from the worker thread to handle a HBA host
- * attention link event.
+ * attention link event. SLI3 only.
  **/
 void
 lpfc_handle_latt(struct lpfc_hba *phba)
@@ -1867,7 +1895,7 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_topology;
 	pmb->vport = vport;
 	/* Block ELS IOCBs until we have processed this mbox command */
-	phba->sli.ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
+	phba->sli.sli3_ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
 	rc = lpfc_sli_issue_mbox (phba, pmb, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {
 		rc = 4;
@@ -1883,7 +1911,7 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	return;
 
 lpfc_handle_latt_free_mbuf:
-	phba->sli.ring[LPFC_ELS_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
+	phba->sli.sli3_ring[LPFC_ELS_RING].flag &= ~LPFC_STOP_IOCB_EVENT;
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 lpfc_handle_latt_free_mp:
 	kfree(mp);
@@ -2441,7 +2469,7 @@ lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt)
  *
  * This routine posts initial receive IOCB buffers to the ELS ring. The
  * current number of initial IOCB buffers specified by LPFC_BUF_RING0 is
- * set to 64 IOCBs.
+ * set to 64 IOCBs. SLI3 only.
  *
  * Return codes
  *   0 - success (currently always success)
@@ -2452,7 +2480,7 @@ lpfc_post_rcv_buf(struct lpfc_hba *phba)
 	struct lpfc_sli *psli = &phba->sli;
 
 	/* Ring 0, ELS / CT buffers */
-	lpfc_post_buffer(phba, &psli->ring[LPFC_ELS_RING], LPFC_BUF_RING0);
+	lpfc_post_buffer(phba, &psli->sli3_ring[LPFC_ELS_RING], LPFC_BUF_RING0);
 	/* Ring 2 - FCP no buffers needed */
 
 	return 0;
@@ -2895,11 +2923,6 @@ lpfc_online(struct lpfc_hba *phba)
 
 	lpfc_block_mgmt_io(phba, LPFC_MBX_WAIT);
 
-	if (!lpfc_sli_queue_setup(phba)) {
-		lpfc_unblock_mgmt_io(phba);
-		return 1;
-	}
-
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		if (lpfc_sli4_hba_setup(phba)) { /* Initialize SLI4 HBA */
 			lpfc_unblock_mgmt_io(phba);
@@ -2910,6 +2933,7 @@ lpfc_online(struct lpfc_hba *phba)
 			vpis_cleared = true;
 		spin_unlock_irq(&phba->hbalock);
 	} else {
+		lpfc_sli_queue_init(phba);
 		if (lpfc_sli_hba_setup(phba)) {	/* Initialize SLI2/SLI3 HBA */
 			lpfc_unblock_mgmt_io(phba);
 			return 1;
@@ -3101,6 +3125,9 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 	struct lpfc_scsi_buf *sb, *sb_next;
 	struct lpfc_iocbq *io, *io_next;
 
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
+		return;
+
 	spin_lock_irq(&phba->hbalock);
 
 	/* Release all the lpfc_scsi_bufs maintained by this host. */
@@ -3109,7 +3136,7 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 	list_for_each_entry_safe(sb, sb_next, &phba->lpfc_scsi_buf_list_put,
 				 list) {
 		list_del(&sb->list);
-		pci_pool_free(phba->lpfc_scsi_dma_buf_pool, sb->data,
+		pci_pool_free(phba->lpfc_sg_dma_buf_pool, sb->data,
 			      sb->dma_handle);
 		kfree(sb);
 		phba->total_scsi_bufs--;
@@ -3120,7 +3147,7 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 	list_for_each_entry_safe(sb, sb_next, &phba->lpfc_scsi_buf_list_get,
 				 list) {
 		list_del(&sb->list);
-		pci_pool_free(phba->lpfc_scsi_dma_buf_pool, sb->data,
+		pci_pool_free(phba->lpfc_sg_dma_buf_pool, sb->data,
 			      sb->dma_handle);
 		kfree(sb);
 		phba->total_scsi_bufs--;
@@ -3136,9 +3163,59 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 
 	spin_unlock_irq(&phba->hbalock);
 }
+/**
+ * lpfc_nvme_free - Free all the NVME buffers and IOCBs from driver lists
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is to free all the NVME buffers and IOCBs from the driver
+ * list back to kernel. It is called from lpfc_pci_remove_one to free
+ * the internal resources before the device is removed from the system.
+ **/
+static void
+lpfc_nvme_free(struct lpfc_hba *phba)
+{
+	struct lpfc_nvme_buf *lpfc_ncmd, *lpfc_ncmd_next;
+	struct lpfc_iocbq *io, *io_next;
+
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
+		return;
+
+	spin_lock_irq(&phba->hbalock);
+
+	/* Release all the lpfc_nvme_bufs maintained by this host. */
+	spin_lock(&phba->nvme_buf_list_put_lock);
+	list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
+				 &phba->lpfc_nvme_buf_list_put, list) {
+		list_del(&lpfc_ncmd->list);
+		pci_pool_free(phba->lpfc_sg_dma_buf_pool, lpfc_ncmd->data,
+			      lpfc_ncmd->dma_handle);
+		kfree(lpfc_ncmd);
+		phba->total_nvme_bufs--;
+	}
+	spin_unlock(&phba->nvme_buf_list_put_lock);
+
+	spin_lock(&phba->nvme_buf_list_get_lock);
+	list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
+				 &phba->lpfc_nvme_buf_list_get, list) {
+		list_del(&lpfc_ncmd->list);
+		pci_pool_free(phba->lpfc_sg_dma_buf_pool, lpfc_ncmd->data,
+			      lpfc_ncmd->dma_handle);
+		kfree(lpfc_ncmd);
+		phba->total_nvme_bufs--;
+	}
+	spin_unlock(&phba->nvme_buf_list_get_lock);
+
+	/* Release all the lpfc_iocbq entries maintained by this host. */
+	list_for_each_entry_safe(io, io_next, &phba->lpfc_iocb_list, list) {
+		list_del(&io->list);
+		kfree(io);
+		phba->total_iocbq_bufs--;
+	}
 
+	spin_unlock_irq(&phba->hbalock);
+}
 /**
- * lpfc_sli4_xri_sgl_update - update xri-sgl sizing and mapping
+ * lpfc_sli4_els_sgl_update - update ELS xri-sgl sizing and mapping
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine first calculates the sizes of the current els and allocated
@@ -3150,20 +3227,18 @@ lpfc_scsi_free(struct lpfc_hba *phba)
  *   0 - successful (for now, it always returns 0)
  **/
 int
-lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
+lpfc_sli4_els_sgl_update(struct lpfc_hba *phba)
 {
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_entry_next = NULL;
-	struct lpfc_scsi_buf *psb = NULL, *psb_next = NULL;
-	uint16_t i, lxri, xri_cnt, els_xri_cnt, scsi_xri_cnt;
+	uint16_t i, lxri, xri_cnt, els_xri_cnt;
 	LIST_HEAD(els_sgl_list);
-	LIST_HEAD(scsi_sgl_list);
 	int rc;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 
 	/*
 	 * update on pci function's els xri-sgl list
 	 */
 	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
+
 	if (els_xri_cnt > phba->sli4_hba.els_xri_cnt) {
 		/* els xri-sgl expanded */
 		xri_cnt = els_xri_cnt - phba->sli4_hba.els_xri_cnt;
@@ -3199,9 +3274,10 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 			list_add_tail(&sglq_entry->list, &els_sgl_list);
 		}
 		spin_lock_irq(&phba->hbalock);
-		spin_lock(&pring->ring_lock);
-		list_splice_init(&els_sgl_list, &phba->sli4_hba.lpfc_sgl_list);
-		spin_unlock(&pring->ring_lock);
+		spin_lock(&phba->sli4_hba.sgl_list_lock);
+		list_splice_init(&els_sgl_list,
+				 &phba->sli4_hba.lpfc_els_sgl_list);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 		spin_unlock_irq(&phba->hbalock);
 	} else if (els_xri_cnt < phba->sli4_hba.els_xri_cnt) {
 		/* els xri-sgl shrinked */
@@ -3211,24 +3287,22 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 				"%d to %d\n", phba->sli4_hba.els_xri_cnt,
 				els_xri_cnt);
 		spin_lock_irq(&phba->hbalock);
-		spin_lock(&pring->ring_lock);
-		list_splice_init(&phba->sli4_hba.lpfc_sgl_list, &els_sgl_list);
-		spin_unlock(&pring->ring_lock);
-		spin_unlock_irq(&phba->hbalock);
+		spin_lock(&phba->sli4_hba.sgl_list_lock);
+		list_splice_init(&phba->sli4_hba.lpfc_els_sgl_list,
+				 &els_sgl_list);
 		/* release extra els sgls from list */
 		for (i = 0; i < xri_cnt; i++) {
 			list_remove_head(&els_sgl_list,
 					 sglq_entry, struct lpfc_sglq, list);
 			if (sglq_entry) {
-				lpfc_mbuf_free(phba, sglq_entry->virt,
-					       sglq_entry->phys);
+				__lpfc_mbuf_free(phba, sglq_entry->virt,
+						 sglq_entry->phys);
 				kfree(sglq_entry);
 			}
 		}
-		spin_lock_irq(&phba->hbalock);
-		spin_lock(&pring->ring_lock);
-		list_splice_init(&els_sgl_list, &phba->sli4_hba.lpfc_sgl_list);
-		spin_unlock(&pring->ring_lock);
+		list_splice_init(&els_sgl_list,
+				 &phba->sli4_hba.lpfc_els_sgl_list);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 		spin_unlock_irq(&phba->hbalock);
 	} else
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
@@ -3240,7 +3314,7 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 	sglq_entry = NULL;
 	sglq_entry_next = NULL;
 	list_for_each_entry_safe(sglq_entry, sglq_entry_next,
-				 &phba->sli4_hba.lpfc_sgl_list, list) {
+				 &phba->sli4_hba.lpfc_els_sgl_list, list) {
 		lxri = lpfc_sli4_next_xritag(phba);
 		if (lxri == NO_XRI) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -3252,21 +3326,53 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 		sglq_entry->sli4_lxritag = lxri;
 		sglq_entry->sli4_xritag = phba->sli4_hba.xri_ids[lxri];
 	}
+	return 0;
+
+out_free_mem:
+	lpfc_free_els_sgl_list(phba);
+	return rc;
+}
+
+/**
+ * lpfc_sli4_scsi_sgl_update - update xri-sgl sizing and mapping
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine first calculates the sizes of the current els and allocated
+ * scsi sgl lists, and then goes through all sgls to updates the physical
+ * XRIs assigned due to port function reset. During port initialization, the
+ * current els and allocated scsi sgl lists are 0s.
+ *
+ * Return codes
+ *   0 - successful (for now, it always returns 0)
+ **/
+int
+lpfc_sli4_scsi_sgl_update(struct lpfc_hba *phba)
+{
+	struct lpfc_scsi_buf *psb, *psb_next;
+	uint16_t i, lxri, els_xri_cnt, scsi_xri_cnt;
+	LIST_HEAD(scsi_sgl_list);
+	int rc;
 
 	/*
-	 * update on pci function's allocated scsi xri-sgl list
+	 * update on pci function's els xri-sgl list
 	 */
+	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
 	phba->total_scsi_bufs = 0;
 
+	/*
+	 * update on pci function's allocated scsi xri-sgl list
+	 */
 	/* maximum number of xris available for scsi buffers */
 	phba->sli4_hba.scsi_xri_max = phba->sli4_hba.max_cfg_param.max_xri -
 				      els_xri_cnt;
 
-	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-			"2401 Current allocated SCSI xri-sgl count:%d, "
-			"maximum  SCSI xri count:%d\n",
-			phba->sli4_hba.scsi_xri_cnt,
-			phba->sli4_hba.scsi_xri_max);
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
+		return 0;
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+		phba->sli4_hba.scsi_xri_max =  /* Split them up */
+			(phba->sli4_hba.scsi_xri_max *
+			 phba->cfg_xri_split) / 100;
 
 	spin_lock_irq(&phba->scsi_buf_list_get_lock);
 	spin_lock(&phba->scsi_buf_list_put_lock);
@@ -3284,7 +3390,7 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 			list_remove_head(&scsi_sgl_list, psb,
 					 struct lpfc_scsi_buf, list);
 			if (psb) {
-				pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
+				pci_pool_free(phba->lpfc_sg_dma_buf_pool,
 					      psb->data, psb->dma_handle);
 				kfree(psb);
 			}
@@ -3315,16 +3421,121 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
 	spin_unlock(&phba->scsi_buf_list_put_lock);
 	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
-
 	return 0;
 
 out_free_mem:
-	lpfc_free_els_sgl_list(phba);
 	lpfc_scsi_free(phba);
 	return rc;
 }
 
 /**
+ * lpfc_sli4_nvme_sgl_update - update xri-sgl sizing and mapping
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine first calculates the sizes of the current els and allocated
+ * scsi sgl lists, and then goes through all sgls to updates the physical
+ * XRIs assigned due to port function reset. During port initialization, the
+ * current els and allocated scsi sgl lists are 0s.
+ *
+ * Return codes
+ *   0 - successful (for now, it always returns 0)
+ **/
+int
+lpfc_sli4_nvme_sgl_update(struct lpfc_hba *phba)
+{
+	struct lpfc_nvme_buf *lpfc_ncmd = NULL, *lpfc_ncmd_next = NULL;
+	uint16_t i, lxri, els_xri_cnt;
+	uint16_t nvme_xri_cnt;
+	LIST_HEAD(nvme_sgl_list);
+	int rc;
+
+	phba->total_nvme_bufs = 0;
+
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
+		return 0;
+	/*
+	 * update on pci function's allocated nvme xri-sgl list
+	 */
+
+	/* maximum number of xris available for nvme buffers */
+	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
+	phba->sli4_hba.nvme_xri_max = phba->sli4_hba.max_cfg_param.max_xri -
+				      els_xri_cnt;
+	phba->sli4_hba.nvme_xri_max -= phba->sli4_hba.scsi_xri_max;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"6074 Current allocated NVME xri-sgl count:%d, "
+			"maximum  NVME xri count:%d\n",
+			phba->sli4_hba.nvme_xri_cnt,
+			phba->sli4_hba.nvme_xri_max);
+
+	if (phba->cfg_nvme_posted_buf > phba->sli4_hba.nvme_xri_max) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3363 NVME posted buffer count "
+				"changed from %d to %d: total %d\n",
+				phba->cfg_nvme_posted_buf,
+				phba->sli4_hba.nvme_xri_max,
+				phba->sli4_hba.max_cfg_param.max_xri);
+		phba->cfg_nvme_posted_buf = phba->sli4_hba.nvme_xri_max;
+	}
+
+	spin_lock_irq(&phba->nvme_buf_list_get_lock);
+	spin_lock(&phba->nvme_buf_list_put_lock);
+	list_splice_init(&phba->lpfc_nvme_buf_list_get, &nvme_sgl_list);
+	list_splice(&phba->lpfc_nvme_buf_list_put, &nvme_sgl_list);
+	spin_unlock(&phba->nvme_buf_list_put_lock);
+	spin_unlock_irq(&phba->nvme_buf_list_get_lock);
+
+	if (phba->sli4_hba.nvme_xri_cnt > phba->sli4_hba.nvme_xri_max) {
+		/* max nvme xri shrunk below the allocated nvme buffers */
+		nvme_xri_cnt = phba->sli4_hba.nvme_xri_cnt -
+					phba->sli4_hba.nvme_xri_max;
+		/* release the extra allocated nvme buffers */
+		for (i = 0; i < nvme_xri_cnt; i++) {
+			list_remove_head(&nvme_sgl_list, lpfc_ncmd,
+					 struct lpfc_nvme_buf, list);
+			if (lpfc_ncmd) {
+				pci_pool_free(phba->lpfc_sg_dma_buf_pool,
+					      lpfc_ncmd->data,
+					      lpfc_ncmd->dma_handle);
+				kfree(lpfc_ncmd);
+			}
+		}
+		spin_lock_irq(&phba->nvme_buf_list_get_lock);
+		phba->sli4_hba.nvme_xri_cnt -= nvme_xri_cnt;
+		spin_unlock_irq(&phba->nvme_buf_list_get_lock);
+	}
+
+	/* update xris associated to remaining allocated nvme buffers */
+	lpfc_ncmd = NULL;
+	lpfc_ncmd_next = NULL;
+	list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
+				 &nvme_sgl_list, list) {
+		lxri = lpfc_sli4_next_xritag(phba);
+		if (lxri == NO_XRI) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"6075 Failed to allocate xri for "
+					"nvme buffer\n");
+			rc = -ENOMEM;
+			goto out_free_mem;
+		}
+		lpfc_ncmd->cur_iocbq.sli4_lxritag = lxri;
+		lpfc_ncmd->cur_iocbq.sli4_xritag = phba->sli4_hba.xri_ids[lxri];
+	}
+	spin_lock_irq(&phba->nvme_buf_list_get_lock);
+	spin_lock(&phba->nvme_buf_list_put_lock);
+	list_splice_init(&nvme_sgl_list, &phba->lpfc_nvme_buf_list_get);
+	INIT_LIST_HEAD(&phba->lpfc_nvme_buf_list_put);
+	spin_unlock(&phba->nvme_buf_list_put_lock);
+	spin_unlock_irq(&phba->nvme_buf_list_get_lock);
+	return 0;
+
+out_free_mem:
+	lpfc_nvme_free(phba);
+	return rc;
+}
+
+/**
  * lpfc_create_port - Create an FC port
  * @phba: pointer to lpfc hba data structure.
  * @instance: a unique integer ID to this FC port.
@@ -3344,18 +3555,23 @@ struct lpfc_vport *
 lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 {
 	struct lpfc_vport *vport;
-	struct Scsi_Host  *shost;
+	struct Scsi_Host  *shost = NULL;
 	int error = 0;
 
-	if (dev != &phba->pcidev->dev) {
-		shost = scsi_host_alloc(&lpfc_vport_template,
-					sizeof(struct lpfc_vport));
-	} else {
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			shost = scsi_host_alloc(&lpfc_template,
-					sizeof(struct lpfc_vport));
-		else
-			shost = scsi_host_alloc(&lpfc_template_s3,
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+		if (dev != &phba->pcidev->dev) {
+			shost = scsi_host_alloc(&lpfc_vport_template,
+						sizeof(struct lpfc_vport));
+		} else {
+			if (phba->sli_rev == LPFC_SLI_REV4)
+				shost = scsi_host_alloc(&lpfc_template,
+						sizeof(struct lpfc_vport));
+			else
+				shost = scsi_host_alloc(&lpfc_template_s3,
+						sizeof(struct lpfc_vport));
+		}
+	} else if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		shost = scsi_host_alloc(&lpfc_template_nvme,
 					sizeof(struct lpfc_vport));
 	}
 	if (!shost)
@@ -3366,8 +3582,8 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	vport->load_flag |= FC_LOADING;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 	vport->fc_rscn_flush = 0;
-
 	lpfc_get_vport_cfgparam(vport);
+
 	shost->unique_id = instance;
 	shost->max_id = LPFC_MAX_TARGET;
 	shost->max_lun = vport->cfg_max_luns;
@@ -3945,7 +4161,7 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 	lpfc_els_flush_all_cmd(phba);
 
 	/* Block ELS IOCBs until we have done process link event */
-	phba->sli.ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
+	phba->sli4_hba.els_wq->pring->flag |= LPFC_STOP_IOCB_EVENT;
 
 	/* Update link event statistics */
 	phba->sli.slistat.link_event++;
@@ -4104,7 +4320,7 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 	lpfc_els_flush_all_cmd(phba);
 
 	/* Block ELS IOCBs until we have done process link event */
-	phba->sli.ring[LPFC_ELS_RING].flag |= LPFC_STOP_IOCB_EVENT;
+	phba->sli4_hba.els_wq->pring->flag |= LPFC_STOP_IOCB_EVENT;
 
 	/* Update link event statistics */
 	phba->sli.slistat.link_event++;
@@ -4240,9 +4456,9 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 			break;
 		default:
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-					"3296 "
-					"LPFC_SLI_EVENT_TYPE_MISCONFIGURED "
-					"event: Invalid link %d",
+					"3296 LPFC_SLI_EVENT_TYPE_"
+					"MISCONFIGURED  event: "
+					"Invalid link %d\n",
 					phba->sli4_hba.lnk_info.lnk_no);
 			return;
 		}
@@ -4273,13 +4489,13 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 			sprintf(message, "Unqualified optics - Replace with "
 				"Avago optics for Warranty and Technical "
 				"Support - Link is%s operational",
-				(operational) ? "" : " not");
+				(operational) ? " not" : "");
 			break;
 		case LPFC_SLI_EVENT_STATUS_UNCERTIFIED:
 			sprintf(message, "Uncertified optics - Replace with "
 				"Avago-certified optics to enable link "
 				"operation - Link is%s operational",
-				(operational) ? "" : " not");
+				(operational) ? " not" : "");
 			break;
 		default:
 			/* firmware is reporting a status we don't know about */
@@ -4854,17 +5070,20 @@ static int
 lpfc_enable_pci_dev(struct lpfc_hba *phba)
 {
 	struct pci_dev *pdev;
+	int bars = 0;
 
 	/* Obtain PCI device reference */
 	if (!phba->pcidev)
 		goto out_error;
 	else
 		pdev = phba->pcidev;
+	/* Select PCI BARs */
+	bars = pci_select_bars(pdev, IORESOURCE_MEM);
 	/* Enable PCI device */
 	if (pci_enable_device_mem(pdev))
 		goto out_error;
 	/* Request PCI resource for the device */
-	if (pci_request_mem_regions(pdev, LPFC_DRIVER_NAME))
+	if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
 		goto out_disable_device;
 	/* Set up device as PCI master and save state for EEH */
 	pci_set_master(pdev);
@@ -4881,7 +5100,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
 	pci_disable_device(pdev);
 out_error:
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"1401 Failed to enable pci device\n");
+			"1401 Failed to enable pci device, bars:x%x\n", bars);
 	return -ENODEV;
 }
 
@@ -4896,14 +5115,17 @@ static void
 lpfc_disable_pci_dev(struct lpfc_hba *phba)
 {
 	struct pci_dev *pdev;
+	int bars;
 
 	/* Obtain PCI device reference */
 	if (!phba->pcidev)
 		return;
 	else
 		pdev = phba->pcidev;
+	/* Select PCI BARs */
+	bars = pci_select_bars(pdev, IORESOURCE_MEM);
 	/* Release PCI resource and disable PCI device */
-	pci_release_mem_regions(pdev);
+	pci_release_selected_regions(pdev, bars);
 	pci_disable_device(pdev);
 
 	return;
@@ -5001,40 +5223,78 @@ lpfc_sli_probe_sriov_nr_virtfn(struct lpfc_hba *phba, int nr_vfn)
 }
 
 /**
- * lpfc_sli_driver_resource_setup - Setup driver internal resources for SLI3 dev.
+ * lpfc_setup_driver_resource_phase1 - Phase1 etup driver internal resources.
  * @phba: pointer to lpfc hba data structure.
  *
- * This routine is invoked to set up the driver internal resources specific to
- * support the SLI-3 HBA device it attached to.
+ * This routine is invoked to set up the driver internal resources before the
+ * device specific resource setup to support the HBA device it attached to.
  *
  * Return codes
- * 	0 - successful
- * 	other values - error
+ *	0 - successful
+ *	other values - error
  **/
 static int
-lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
+lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
 {
-	struct lpfc_sli *psli;
-	int rc;
+	struct lpfc_sli *psli = &phba->sli;
 
 	/*
-	 * Initialize timers used by driver
+	 * Driver resources common to all SLI revisions
 	 */
+	atomic_set(&phba->fast_event_count, 0);
+	spin_lock_init(&phba->hbalock);
 
-	/* Heartbeat timer */
-	init_timer(&phba->hb_tmofunc);
-	phba->hb_tmofunc.function = lpfc_hb_timeout;
-	phba->hb_tmofunc.data = (unsigned long)phba;
+	/* Initialize ndlp management spinlock */
+	spin_lock_init(&phba->ndlp_lock);
+
+	INIT_LIST_HEAD(&phba->port_list);
+	INIT_LIST_HEAD(&phba->work_list);
+	init_waitqueue_head(&phba->wait_4_mlo_m_q);
+
+	/* Initialize the wait queue head for the kernel thread */
+	init_waitqueue_head(&phba->work_waitq);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"1403 Protocols supported %s %s\n",
+			((phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) ?
+				"SCSI" : " "),
+			((phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) ?
+				"NVME" : " "));
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+		/* Initialize the scsi buffer list used by driver for scsi IO */
+		spin_lock_init(&phba->scsi_buf_list_get_lock);
+		INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_get);
+		spin_lock_init(&phba->scsi_buf_list_put_lock);
+		INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
+	}
+
+	if ((phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) &&
+		(phba->nvmet_support == 0)) {
+		/* Initialize the NVME buffer list used by driver for NVME IO */
+		spin_lock_init(&phba->nvme_buf_list_get_lock);
+		INIT_LIST_HEAD(&phba->lpfc_nvme_buf_list_get);
+		spin_lock_init(&phba->nvme_buf_list_put_lock);
+		INIT_LIST_HEAD(&phba->lpfc_nvme_buf_list_put);
+	}
+
+	/* Initialize the fabric iocb list */
+	INIT_LIST_HEAD(&phba->fabric_iocb_list);
+
+	/* Initialize list to save ELS buffers */
+	INIT_LIST_HEAD(&phba->elsbuf);
+
+	/* Initialize FCF connection rec list */
+	INIT_LIST_HEAD(&phba->fcf_conn_rec_list);
+
+	/* Initialize OAS configuration list */
+	spin_lock_init(&phba->devicelock);
+	INIT_LIST_HEAD(&phba->luns);
 
-	psli = &phba->sli;
 	/* MBOX heartbeat timer */
 	init_timer(&psli->mbox_tmo);
 	psli->mbox_tmo.function = lpfc_mbox_timeout;
 	psli->mbox_tmo.data = (unsigned long) phba;
-	/* FCP polling mode timer */
-	init_timer(&phba->fcp_poll_timer);
-	phba->fcp_poll_timer.function = lpfc_poll_timeout;
-	phba->fcp_poll_timer.data = (unsigned long) phba;
 	/* Fabric block timer */
 	init_timer(&phba->fabric_block_timer);
 	phba->fabric_block_timer.function = lpfc_fabric_block_timeout;
@@ -5043,6 +5303,38 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	init_timer(&phba->eratt_poll);
 	phba->eratt_poll.function = lpfc_poll_eratt;
 	phba->eratt_poll.data = (unsigned long) phba;
+	/* Heartbeat timer */
+	init_timer(&phba->hb_tmofunc);
+	phba->hb_tmofunc.function = lpfc_hb_timeout;
+	phba->hb_tmofunc.data = (unsigned long)phba;
+
+	return 0;
+}
+
+/**
+ * lpfc_sli_driver_resource_setup - Setup driver internal resources for SLI3 dev
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to set up the driver internal resources specific to
+ * support the SLI-3 HBA device it attached to.
+ *
+ * Return codes
+ * 0 - successful
+ * other values - error
+ **/
+static int
+lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
+{
+	int rc;
+
+	/*
+	 * Initialize timers used by driver
+	 */
+
+	/* FCP polling mode timer */
+	init_timer(&phba->fcp_poll_timer);
+	phba->fcp_poll_timer.function = lpfc_poll_timeout;
+	phba->fcp_poll_timer.data = (unsigned long) phba;
 
 	/* Host attention work mask setup */
 	phba->work_ha_mask = (HA_ERATT | HA_MBATT | HA_LATT);
@@ -5050,6 +5342,12 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 
 	/* Get all the module params for configuring this host */
 	lpfc_get_cfgparam(phba);
+	/* Set up phase-1 common device driver resources */
+
+	rc = lpfc_setup_driver_resource_phase1(phba);
+	if (rc)
+		return -ENODEV;
+
 	if (phba->pcidev->device == PCI_DEVICE_ID_HORNET) {
 		phba->menlo_flag |= HBA_MENLO_SUPPORT;
 		/* check for menlo minimum sg count */
@@ -5057,10 +5355,10 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 			phba->cfg_sg_seg_cnt = LPFC_DEFAULT_MENLO_SG_SEG_CNT;
 	}
 
-	if (!phba->sli.ring)
-		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
+	if (!phba->sli.sli3_ring)
+		phba->sli.sli3_ring = kzalloc(LPFC_SLI3_MAX_RING *
 			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
-	if (!phba->sli.ring)
+	if (!phba->sli.sli3_ring)
 		return -ENOMEM;
 
 	/*
@@ -5119,7 +5417,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	 * Initialize the SLI Layer to run with lpfc HBAs.
 	 */
 	lpfc_sli_setup(phba);
-	lpfc_sli_queue_setup(phba);
+	lpfc_sli_queue_init(phba);
 
 	/* Allocate device driver memory */
 	if (lpfc_mem_alloc(phba, BPL_ALIGN_SZ))
@@ -5175,18 +5473,34 @@ lpfc_sli_driver_resource_unset(struct lpfc_hba *phba)
 static int
 lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 {
-	struct lpfc_vector_map_info *cpup;
-	struct lpfc_sli *psli;
 	LPFC_MBOXQ_t *mboxq;
-	int rc, i, hbq_count, max_buf_size;
+	int rc, i, max_buf_size;
 	uint8_t pn_page[LPFC_MAX_SUPPORTED_PAGES] = {0};
 	struct lpfc_mqe *mqe;
 	int longs;
 	int fof_vectors = 0;
+	uint32_t cpu = 0;
+
+	/* Get the current online cpu count and the number of present
+	 * cpus.
+	 */
+	i = 0;
+	for_each_present_cpu(cpu) {
+		if (cpu_online(cpu))
+			i++;
+	}
+	phba->sli4_hba.num_online_cpu = i;
+	phba->sli4_hba.num_present_cpu = lpfc_present_cpu;
+	phba->sli4_hba.curr_disp_cpu = 0;
 
 	/* Get all the module params for configuring this host */
 	lpfc_get_cfgparam(phba);
 
+	/* Set up phase-1 common device driver resources */
+	rc = lpfc_setup_driver_resource_phase1(phba);
+	if (rc)
+		return -ENODEV;
+
 	/* Before proceed, wait for POST done and device ready */
 	rc = lpfc_sli4_post_status_check(phba);
 	if (rc)
@@ -5196,27 +5510,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	 * Initialize timers used by driver
 	 */
 
-	/* Heartbeat timer */
-	init_timer(&phba->hb_tmofunc);
-	phba->hb_tmofunc.function = lpfc_hb_timeout;
-	phba->hb_tmofunc.data = (unsigned long)phba;
 	init_timer(&phba->rrq_tmr);
 	phba->rrq_tmr.function = lpfc_rrq_timeout;
 	phba->rrq_tmr.data = (unsigned long)phba;
 
-	psli = &phba->sli;
-	/* MBOX heartbeat timer */
-	init_timer(&psli->mbox_tmo);
-	psli->mbox_tmo.function = lpfc_mbox_timeout;
-	psli->mbox_tmo.data = (unsigned long) phba;
-	/* Fabric block timer */
-	init_timer(&phba->fabric_block_timer);
-	phba->fabric_block_timer.function = lpfc_fabric_block_timeout;
-	phba->fabric_block_timer.data = (unsigned long) phba;
-	/* EA polling mode timer */
-	init_timer(&phba->eratt_poll);
-	phba->eratt_poll.function = lpfc_poll_eratt;
-	phba->eratt_poll.data = (unsigned long) phba;
 	/* FCF rediscover timer */
 	init_timer(&phba->fcf.redisc_wait);
 	phba->fcf.redisc_wait.function = lpfc_sli4_fcf_redisc_wait_tmo;
@@ -5243,14 +5540,9 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 	/*
 	 * For SLI4, instead of using ring 0 (LPFC_FCP_RING) for FCP commands
-	 * we will associate a new ring, for each FCP fastpath EQ/CQ/WQ tuple.
+	 * we will associate a new ring, for each EQ/CQ/WQ tuple.
+	 * The WQ create will allocate the ring.
 	 */
-	if (!phba->sli.ring)
-		phba->sli.ring = kzalloc(
-			(LPFC_SLI3_MAX_RING + phba->cfg_fcp_io_channel) *
-			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
-	if (!phba->sli.ring)
-		return -ENOMEM;
 
 	/*
 	 * It doesn't matter what family our adapter is in, we are
@@ -5262,43 +5554,45 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		phba->cfg_sg_seg_cnt = LPFC_MAX_SGL_SEG_CNT - 2;
 
 	/*
-	 * Since lpfc_sg_seg_cnt is module parameter, the sg_dma_buf_size
-	 * used to create the sg_dma_buf_pool must be dynamically calculated.
+	 * Since lpfc_sg_seg_cnt is module param, the sg_dma_buf_size
+	 * used to create the sg_dma_buf_pool must be calculated.
 	 */
-
 	if (phba->cfg_enable_bg) {
 		/*
-		 * The scsi_buf for a T10-DIF I/O will hold the FCP cmnd,
-		 * the FCP rsp, and a SGE for each. Sice we have no control
-		 * over how many protection data segments the SCSI Layer
+		 * The scsi_buf for a T10-DIF I/O holds the FCP cmnd,
+		 * the FCP rsp, and a SGE. Sice we have no control
+		 * over how many protection segments the SCSI Layer
 		 * will hand us (ie: there could be one for every block
-		 * in the IO), we just allocate enough SGEs to accomidate
-		 * our max amount and we need to limit lpfc_sg_seg_cnt to
-		 * minimize the risk of running out.
+		 * in the IO), just allocate enough SGEs to accomidate
+		 * our max amount and we need to limit lpfc_sg_seg_cnt
+		 * to minimize the risk of running out.
 		 */
 		phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd) +
-			sizeof(struct fcp_rsp) + max_buf_size;
+				sizeof(struct fcp_rsp) + max_buf_size;
 
 		/* Total SGEs for scsi_sg_list and scsi_sg_prot_list */
 		phba->cfg_total_seg_cnt = LPFC_MAX_SGL_SEG_CNT;
 
 		if (phba->cfg_sg_seg_cnt > LPFC_MAX_SG_SLI4_SEG_CNT_DIF)
-			phba->cfg_sg_seg_cnt = LPFC_MAX_SG_SLI4_SEG_CNT_DIF;
+			phba->cfg_sg_seg_cnt =
+				LPFC_MAX_SG_SLI4_SEG_CNT_DIF;
 	} else {
 		/*
-		 * The scsi_buf for a regular I/O will hold the FCP cmnd,
+		 * The scsi_buf for a regular I/O holds the FCP cmnd,
 		 * the FCP rsp, a SGE for each, and a SGE for up to
 		 * cfg_sg_seg_cnt data segments.
 		 */
 		phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd) +
-			sizeof(struct fcp_rsp) +
-			((phba->cfg_sg_seg_cnt + 2) * sizeof(struct sli4_sge));
+				sizeof(struct fcp_rsp) +
+				((phba->cfg_sg_seg_cnt + 2) *
+				sizeof(struct sli4_sge));
 
 		/* Total SGEs for scsi_sg_list */
 		phba->cfg_total_seg_cnt = phba->cfg_sg_seg_cnt + 2;
+
 		/*
-		 * NOTE: if (phba->cfg_sg_seg_cnt + 2) <= 256 we only need
-		 * to post 1 page for the SGL.
+		 * NOTE: if (phba->cfg_sg_seg_cnt + 2) <= 256 we only
+		 * need to post 1 page for the SGL.
 		 */
 	}
 
@@ -5318,21 +5612,27 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			phba->cfg_total_seg_cnt);
 
 	/* Initialize buffer queue management fields */
-	hbq_count = lpfc_sli_hbq_count();
-	for (i = 0; i < hbq_count; ++i)
-		INIT_LIST_HEAD(&phba->hbqs[i].hbq_buffer_list);
-	INIT_LIST_HEAD(&phba->rb_pend_list);
+	INIT_LIST_HEAD(&phba->hbqs[LPFC_ELS_HBQ].hbq_buffer_list);
 	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_sli4_rb_alloc;
 	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer = lpfc_sli4_rb_free;
 
 	/*
 	 * Initialize the SLI Layer to run with lpfc SLI4 HBAs.
 	 */
-	/* Initialize the Abort scsi buffer list used by driver */
-	spin_lock_init(&phba->sli4_hba.abts_scsi_buf_list_lock);
-	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+		/* Initialize the Abort scsi buffer list used by driver */
+		spin_lock_init(&phba->sli4_hba.abts_scsi_buf_list_lock);
+		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+	}
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		/* Initialize the Abort nvme buffer list used by driver */
+		spin_lock_init(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
+	}
+
 	/* This abort list used by worker thread */
-	spin_lock_init(&phba->sli4_hba.abts_sgl_list_lock);
+	spin_lock_init(&phba->sli4_hba.sgl_list_lock);
 
 	/*
 	 * Initialize driver internal slow-path work queues
@@ -5360,10 +5660,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	/* initialize optic_state to 0xFF */
 	phba->sli4_hba.lnk_info.optic_state = 0xff;
 
-	/* Initialize the driver internal SLI layer lists. */
-	lpfc_sli_setup(phba);
-	lpfc_sli_queue_setup(phba);
-
 	/* Allocate device driver memory */
 	rc = lpfc_mem_alloc(phba, SGL_ALIGN_SZ);
 	if (rc)
@@ -5373,8 +5669,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
 	    LPFC_SLI_INTF_IF_TYPE_2) {
 		rc = lpfc_pci_function_reset(phba);
-		if (unlikely(rc))
-			return -ENODEV;
+		if (unlikely(rc)) {
+			rc = -ENODEV;
+			goto out_free_mem;
+		}
 		phba->temp_sensor_support = 1;
 	}
 
@@ -5411,6 +5709,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		goto out_free_bsmbx;
 	}
 
+	phba->nvmet_support = 0;
+
+	lpfc_nvme_mod_param_dep(phba);
+
 	/* Get the Supported Pages if PORT_CAPABILITIES is supported by port. */
 	lpfc_supported_pages(mboxq);
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
@@ -5449,9 +5751,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2999 Unsupported SLI4 Parameters "
 				"Extents and RPI headers enabled.\n");
-			goto out_free_bsmbx;
 		}
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		goto out_free_bsmbx;
 	}
+
 	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/* Verify OAS is supported */
@@ -5498,11 +5802,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		goto out_remove_rpi_hdrs;
 	}
 
-	phba->sli4_hba.fcp_eq_hdl =
-			kzalloc((sizeof(struct lpfc_fcp_eq_hdl) *
-			    (fof_vectors + phba->cfg_fcp_io_channel)),
-			    GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_eq_hdl) {
+	phba->sli4_hba.hba_eq_hdl =
+			kzalloc((sizeof(struct lpfc_hba_eq_hdl) *
+			    (fof_vectors + phba->io_channel)), GFP_KERNEL);
+	if (!phba->sli4_hba.hba_eq_hdl) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2572 Failed allocate memory for "
 				"fast-path per-EQ handle array\n");
@@ -5511,14 +5814,14 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	phba->sli4_hba.msix_entries = kzalloc((sizeof(struct msix_entry) *
-				  (fof_vectors +
-				   phba->cfg_fcp_io_channel)), GFP_KERNEL);
+				  (fof_vectors + phba->io_channel)),
+					      GFP_KERNEL);
 	if (!phba->sli4_hba.msix_entries) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2573 Failed allocate memory for msi-x "
 				"interrupt vector entries\n");
 		rc = -ENOMEM;
-		goto out_free_fcp_eq_hdl;
+		goto out_free_hba_eq_hdl;
 	}
 
 	phba->sli4_hba.cpu_map = kzalloc((sizeof(struct lpfc_vector_map_info) *
@@ -5546,16 +5849,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			lpfc_used_cpu[i] = LPFC_VECTOR_MAP_EMPTY;
 	}
 
-	/* Initialize io channels for round robin */
-	cpup = phba->sli4_hba.cpu_map;
-	rc = 0;
-	for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
-		cpup->channel_id = rc;
-		rc++;
-		if (rc >= phba->cfg_fcp_io_channel)
-			rc = 0;
-	}
-
 	/*
 	 * Enable sr-iov virtual functions if supported and configured
 	 * through the module parameter.
@@ -5577,8 +5870,8 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 out_free_msix:
 	kfree(phba->sli4_hba.msix_entries);
-out_free_fcp_eq_hdl:
-	kfree(phba->sli4_hba.fcp_eq_hdl);
+out_free_hba_eq_hdl:
+	kfree(phba->sli4_hba.hba_eq_hdl);
 out_free_fcf_rr_bmask:
 	kfree(phba->fcf.fcf_rr_bmask);
 out_remove_rpi_hdrs:
@@ -5616,7 +5909,7 @@ lpfc_sli4_driver_resource_unset(struct lpfc_hba *phba)
 	kfree(phba->sli4_hba.msix_entries);
 
 	/* Free memory allocated for fast-path work queue handles */
-	kfree(phba->sli4_hba.fcp_eq_hdl);
+	kfree(phba->sli4_hba.hba_eq_hdl);
 
 	/* Free the allocated rpi headers. */
 	lpfc_sli4_remove_rpi_hdrs(phba);
@@ -5690,58 +5983,6 @@ lpfc_init_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 }
 
 /**
- * lpfc_setup_driver_resource_phase1 - Phase1 etup driver internal resources.
- * @phba: pointer to lpfc hba data structure.
- *
- * This routine is invoked to set up the driver internal resources before the
- * device specific resource setup to support the HBA device it attached to.
- *
- * Return codes
- *	0 - successful
- *	other values - error
- **/
-static int
-lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
-{
-	/*
-	 * Driver resources common to all SLI revisions
-	 */
-	atomic_set(&phba->fast_event_count, 0);
-	spin_lock_init(&phba->hbalock);
-
-	/* Initialize ndlp management spinlock */
-	spin_lock_init(&phba->ndlp_lock);
-
-	INIT_LIST_HEAD(&phba->port_list);
-	INIT_LIST_HEAD(&phba->work_list);
-	init_waitqueue_head(&phba->wait_4_mlo_m_q);
-
-	/* Initialize the wait queue head for the kernel thread */
-	init_waitqueue_head(&phba->work_waitq);
-
-	/* Initialize the scsi buffer list used by driver for scsi IO */
-	spin_lock_init(&phba->scsi_buf_list_get_lock);
-	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_get);
-	spin_lock_init(&phba->scsi_buf_list_put_lock);
-	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
-
-	/* Initialize the fabric iocb list */
-	INIT_LIST_HEAD(&phba->fabric_iocb_list);
-
-	/* Initialize list to save ELS buffers */
-	INIT_LIST_HEAD(&phba->elsbuf);
-
-	/* Initialize FCF connection rec list */
-	INIT_LIST_HEAD(&phba->fcf_conn_rec_list);
-
-	/* Initialize OAS configuration list */
-	spin_lock_init(&phba->devicelock);
-	INIT_LIST_HEAD(&phba->luns);
-
-	return 0;
-}
-
-/**
  * lpfc_setup_driver_resource_phase2 - Phase2 setup driver internal resources.
  * @phba: pointer to lpfc hba data structure.
  *
@@ -5888,13 +6129,12 @@ static void
 lpfc_free_els_sgl_list(struct lpfc_hba *phba)
 {
 	LIST_HEAD(sglq_list);
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 
 	/* Retrieve all els sgls from driver list */
 	spin_lock_irq(&phba->hbalock);
-	spin_lock(&pring->ring_lock);
-	list_splice_init(&phba->sli4_hba.lpfc_sgl_list, &sglq_list);
-	spin_unlock(&pring->ring_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	list_splice_init(&phba->sli4_hba.lpfc_els_sgl_list, &sglq_list);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Now free the sgl list */
@@ -5948,7 +6188,7 @@ static void
 lpfc_init_sgl_list(struct lpfc_hba *phba)
 {
 	/* Initialize and populate the sglq list per host/VF. */
-	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_sgl_list);
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_els_sgl_list);
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_els_sgl_list);
 
 	/* els xri-sgl book keeping */
@@ -5956,6 +6196,9 @@ lpfc_init_sgl_list(struct lpfc_hba *phba)
 
 	/* scsi xri-buffer book keeping */
 	phba->sli4_hba.scsi_xri_cnt = 0;
+
+	/* nvme xri-buffer book keeping */
+	phba->sli4_hba.nvme_xri_cnt = 0;
 }
 
 /**
@@ -6186,9 +6429,9 @@ lpfc_hba_free(struct lpfc_hba *phba)
 	/* Release the driver assigned board number */
 	idr_remove(&lpfc_hba_index, phba->brd_no);
 
-	/* Free memory allocated with sli rings */
-	kfree(phba->sli.ring);
-	phba->sli.ring = NULL;
+	/* Free memory allocated with sli3 rings */
+	kfree(phba->sli.sli3_ring);
+	phba->sli.sli3_ring = NULL;
 
 	kfree(phba);
 	return;
@@ -6224,6 +6467,7 @@ lpfc_create_shost(struct lpfc_hba *phba)
 
 	shost = lpfc_shost_from_vport(vport);
 	phba->pport = vport;
+
 	lpfc_debugfs_initialize(vport);
 	/* Put reference to SCSI host to driver's device private data */
 	pci_set_drvdata(phba->pcidev, shost);
@@ -6486,13 +6730,13 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 		       offsetof(struct lpfc_sli2_slim, IOCBs));
 
 	phba->hbqslimp.virt = dma_alloc_coherent(&pdev->dev,
-						 lpfc_sli_hbq_size(),
+						 lpfc_sli_hbq_size(phba),
 						 &phba->hbqslimp.phys,
 						 GFP_KERNEL);
 	if (!phba->hbqslimp.virt)
 		goto out_free_slim;
 
-	hbq_count = lpfc_sli_hbq_count();
+	hbq_count = lpfc_sli_hbq_count(phba);
 	ptr = phba->hbqslimp.virt;
 	for (i = 0; i < hbq_count; ++i) {
 		phba->hbqs[i].hbq_virt = ptr;
@@ -6503,9 +6747,7 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_els_hbq_alloc;
 	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer = lpfc_els_hbq_free;
 
-	memset(phba->hbqslimp.virt, 0, lpfc_sli_hbq_size());
-
-	INIT_LIST_HEAD(&phba->rb_pend_list);
+	memset(phba->hbqslimp.virt, 0, lpfc_sli_hbq_size(phba));
 
 	phba->MBslimaddr = phba->slim_memmap_p;
 	phba->HAregaddr = phba->ctrl_regs_memmap_p + HA_REG_OFFSET;
@@ -6545,7 +6787,7 @@ lpfc_sli_pci_mem_unset(struct lpfc_hba *phba)
 		pdev = phba->pcidev;
 
 	/* Free coherent DMA memory allocated */
-	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
+	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(phba),
 			  phba->hbqslimp.virt, phba->hbqslimp.phys);
 	dma_free_coherent(&pdev->dev, SLI2_SLIM_SIZE,
 			  phba->slim2p.virt, phba->slim2p.phys);
@@ -7010,7 +7252,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 				"VPI(B:%d M:%d) "
 				"VFI(B:%d M:%d) "
 				"RPI(B:%d M:%d) "
-				"FCFI(Count:%d)\n",
+				"FCFI:%d EQ:%d CQ:%d WQ:%d RQ:%d\n",
 				phba->sli4_hba.extents_in_use,
 				phba->sli4_hba.max_cfg_param.xri_base,
 				phba->sli4_hba.max_cfg_param.max_xri,
@@ -7020,7 +7262,12 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 				phba->sli4_hba.max_cfg_param.max_vfi,
 				phba->sli4_hba.max_cfg_param.rpi_base,
 				phba->sli4_hba.max_cfg_param.max_rpi,
-				phba->sli4_hba.max_cfg_param.max_fcfi);
+				phba->sli4_hba.max_cfg_param.max_fcfi,
+				phba->sli4_hba.max_cfg_param.max_eq,
+				phba->sli4_hba.max_cfg_param.max_cq,
+				phba->sli4_hba.max_cfg_param.max_wq,
+				phba->sli4_hba.max_cfg_param.max_rq);
+
 	}
 
 	if (rc)
@@ -7069,9 +7316,8 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 				break;
 			default:
 				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-						"0047 Unrecognized link "
-						"speed : %d\n",
-						forced_link_speed);
+						"0047 Unrecognized link speed"
+						" : %d\n", forced_link_speed);
 				phba->cfg_link_speed =
 					LPFC_USER_LINK_SPEED_AUTO;
 			}
@@ -7226,9 +7472,7 @@ lpfc_setup_endian_order(struct lpfc_hba *phba)
 static int
 lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 {
-	int cfg_fcp_io_channel;
-	uint32_t cpu;
-	uint32_t i = 0;
+	int io_channel;
 	int fof_vectors = phba->cfg_fof ? 1 : 0;
 
 	/*
@@ -7237,49 +7481,39 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 	 */
 
 	/* Sanity check on HBA EQ parameters */
-	cfg_fcp_io_channel = phba->cfg_fcp_io_channel;
+	io_channel = phba->io_channel;
 
-	/* It doesn't make sense to have more io channels then online CPUs */
-	for_each_present_cpu(cpu) {
-		if (cpu_online(cpu))
-			i++;
-	}
-	phba->sli4_hba.num_online_cpu = i;
-	phba->sli4_hba.num_present_cpu = lpfc_present_cpu;
-	phba->sli4_hba.curr_disp_cpu = 0;
-
-	if (i < cfg_fcp_io_channel) {
+	if (phba->sli4_hba.num_online_cpu < io_channel) {
 		lpfc_printf_log(phba,
 				KERN_ERR, LOG_INIT,
 				"3188 Reducing IO channels to match number of "
 				"online CPUs: from %d to %d\n",
-				cfg_fcp_io_channel, i);
-		cfg_fcp_io_channel = i;
+				io_channel, phba->sli4_hba.num_online_cpu);
+		io_channel = phba->sli4_hba.num_online_cpu;
 	}
 
-	if (cfg_fcp_io_channel + fof_vectors >
+	if (io_channel + fof_vectors >
 	    phba->sli4_hba.max_cfg_param.max_eq) {
-		if (phba->sli4_hba.max_cfg_param.max_eq <
-		    LPFC_FCP_IO_CHAN_MIN) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"2574 Not enough EQs (%d) from the "
-					"pci function for supporting FCP "
-					"EQs (%d)\n",
-					phba->sli4_hba.max_cfg_param.max_eq,
-					phba->cfg_fcp_io_channel);
-			goto out_error;
-		}
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2575 Reducing IO channels to match number of "
 				"available EQs: from %d to %d\n",
-				cfg_fcp_io_channel,
+				io_channel,
 				phba->sli4_hba.max_cfg_param.max_eq);
-		cfg_fcp_io_channel = phba->sli4_hba.max_cfg_param.max_eq -
-			fof_vectors;
+		io_channel = phba->sli4_hba.max_cfg_param.max_eq - fof_vectors;
 	}
 
-	/* The actual number of FCP event queues adopted */
-	phba->cfg_fcp_io_channel = cfg_fcp_io_channel;
+	/* The actual number of FCP / NVME event queues adopted */
+	if (io_channel != phba->io_channel)
+		phba->io_channel = io_channel;
+	if (phba->cfg_fcp_io_channel > io_channel)
+		phba->cfg_fcp_io_channel = io_channel;
+	if (phba->cfg_nvme_io_channel > io_channel)
+		phba->cfg_nvme_io_channel = io_channel;
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2574 IO chann: %d fcp %d nvme %d hwQ: nvme %d\n",
+			phba->io_channel, phba->cfg_fcp_io_channel,
+			phba->cfg_nvme_io_channel, phba->cfg_nvme_max_hw_queue);
 
 	/* Get EQ depth from module parameter, fake the default for now */
 	phba->sli4_hba.eq_esize = LPFC_EQE_SIZE_4B;
@@ -7288,10 +7522,7 @@ lpfc_sli4_queue_verify(struct lpfc_hba *phba)
 	/* Get CQ depth from module parameter, fake the default for now */
 	phba->sli4_hba.cq_esize = LPFC_CQE_SIZE;
 	phba->sli4_hba.cq_ecount = LPFC_CQE_DEF_COUNT;
-
 	return 0;
-out_error:
-	return -ENOMEM;
 }
 
 /**
@@ -7312,13 +7543,14 @@ int
 lpfc_sli4_queue_create(struct lpfc_hba *phba)
 {
 	struct lpfc_queue *qdesc;
-	uint32_t wqesize;
-	int idx;
+	int idx, io_channel, numwq, cnt;
 
 	/*
 	 * Create HBA Record arrays.
+	 * Both NVME and FCP will share that same vectors / EQs
 	 */
-	if (!phba->cfg_fcp_io_channel)
+	io_channel = phba->io_channel;
+	if (!io_channel)
 		return -ERANGE;
 
 	phba->sli4_hba.mq_esize = LPFC_MQE_SIZE;
@@ -7327,9 +7559,13 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	phba->sli4_hba.wq_ecount = LPFC_WQE_DEF_COUNT;
 	phba->sli4_hba.rq_esize = LPFC_RQE_SIZE;
 	phba->sli4_hba.rq_ecount = LPFC_RQE_DEF_COUNT;
+	phba->sli4_hba.eq_esize = LPFC_EQE_SIZE_4B;
+	phba->sli4_hba.eq_ecount = LPFC_EQE_DEF_COUNT;
+	phba->sli4_hba.cq_esize = LPFC_CQE_SIZE;
+	phba->sli4_hba.cq_ecount = LPFC_CQE_DEF_COUNT;
 
 	phba->sli4_hba.hba_eq =  kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_io_channel), GFP_KERNEL);
+				io_channel), GFP_KERNEL);
 	if (!phba->sli4_hba.hba_eq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"2576 Failed allocate memory for "
@@ -7337,44 +7573,86 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		goto out_error;
 	}
 
-	phba->sli4_hba.fcp_cq = kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_io_channel), GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_cq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2577 Failed allocate memory for fast-path "
-				"CQ record array\n");
-		goto out_error;
+	if (phba->cfg_fcp_io_channel) {
+		phba->sli4_hba.fcp_cq = kzalloc((sizeof(struct lpfc_queue *) *
+						 phba->cfg_fcp_io_channel),
+						 GFP_KERNEL);
+		if (!phba->sli4_hba.fcp_cq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2577 Failed allocate memory for "
+					"fast-path CQ record array\n");
+			goto out_error;
+		}
+		phba->sli4_hba.fcp_wq =
+			kzalloc((sizeof(struct lpfc_queue *)*
+				phba->cfg_fcp_max_hw_queue), GFP_KERNEL);
+		if (!phba->sli4_hba.fcp_wq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2578 Failed allocate memory for "
+					"fast-path FCP WQ record array\n");
+			goto out_error;
+		}
+		/*
+		 * Since the first EQ can have multiple CQs associated with it,
+		 * this array is used to quickly see if we have a FCP fast-path
+		 * CQ match.
+		 */
+		phba->sli4_hba.fcp_cq_map = kzalloc((sizeof(uint16_t) *
+						     phba->cfg_fcp_io_channel),
+						    GFP_KERNEL);
+		if (!phba->sli4_hba.fcp_cq_map) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2545 Failed allocate memory for "
+					"fast-path CQ map\n");
+			goto out_error;
+		}
 	}
 
-	phba->sli4_hba.fcp_wq = kzalloc((sizeof(struct lpfc_queue *) *
-				phba->cfg_fcp_io_channel), GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_wq) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2578 Failed allocate memory for fast-path "
-				"WQ record array\n");
-		goto out_error;
-	}
+	numwq = 0;
+	if (phba->cfg_nvme_io_channel) {
+		phba->sli4_hba.nvme_cq = kzalloc((sizeof(struct lpfc_queue *) *
+					phba->cfg_nvme_io_channel), GFP_KERNEL);
+		if (!phba->sli4_hba.nvme_cq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6077 Failed allocate memory for "
+					"fast-path CQ record array\n");
+			goto out_error;
+		}
 
-	/*
-	 * Since the first EQ can have multiple CQs associated with it,
-	 * this array is used to quickly see if we have a FCP fast-path
-	 * CQ match.
-	 */
-	phba->sli4_hba.fcp_cq_map = kzalloc((sizeof(uint16_t) *
-					 phba->cfg_fcp_io_channel), GFP_KERNEL);
-	if (!phba->sli4_hba.fcp_cq_map) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"2545 Failed allocate memory for fast-path "
-				"CQ map\n");
-		goto out_error;
+		numwq = phba->cfg_nvme_max_hw_queue;
+
+		phba->sli4_hba.nvme_wq =
+			kzalloc((numwq * sizeof(struct lpfc_queue *)),
+				GFP_KERNEL);
+		if (!phba->sli4_hba.nvme_wq) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"2581 Failed allocate memory for "
+					"fast-path NVME WQ record array\n");
+			goto out_error;
+		}
+
+		/*
+		 * Since the first EQ can have multiple CQs associated with it,
+		 * this array is used to quickly see if we have a NVME fast-path
+		 * CQ match.
+		 */
+		phba->sli4_hba.nvme_cq_map = kzalloc(
+				(sizeof(uint16_t) * phba->cfg_nvme_io_channel),
+				GFP_KERNEL);
+		if (!phba->sli4_hba.nvme_cq_map) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6078 Failed allocate memory for "
+					"fast-path CQ map\n");
+			goto out_error;
+		}
 	}
 
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_wq_list);
 	/*
-	 * Create HBA Event Queues (EQs).  The cfg_fcp_io_channel specifies
+	 * Create HBA Event Queues (EQs).  The io_channel specifies
 	 * how many EQs to create.
 	 */
-	for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
-
+	for (idx = 0; idx < io_channel; idx++) {
 		/* Create EQs */
 		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.eq_esize,
 					      phba->sli4_hba.eq_ecount);
@@ -7385,32 +7663,92 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		}
 		phba->sli4_hba.hba_eq[idx] = qdesc;
 
+		/* FCP and NVME channels are not required to be balanced. */
 		/* Create Fast Path FCP CQs */
-		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
-					      phba->sli4_hba.cq_ecount);
-		if (!qdesc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0499 Failed allocate fast-path FCP "
-					"CQ (%d)\n", idx);
-			goto out_error;
+		if (idx < phba->cfg_fcp_io_channel) {
+			qdesc = lpfc_sli4_queue_alloc(phba,
+						      phba->sli4_hba.cq_esize,
+						      phba->sli4_hba.cq_ecount);
+			if (!qdesc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0499 Failed allocate "
+						"fast-path FCP CQ (%d)\n",
+						idx);
+				goto out_error;
+			}
+			phba->sli4_hba.fcp_cq[idx] = qdesc;
+
 		}
-		phba->sli4_hba.fcp_cq[idx] = qdesc;
 
-		/* Create Fast Path FCP WQs */
-		wqesize = (phba->fcp_embed_io) ?
-				LPFC_WQE128_SIZE : phba->sli4_hba.wq_esize;
-		qdesc = lpfc_sli4_queue_alloc(phba, wqesize,
-						phba->sli4_hba.wq_ecount);
-		if (!qdesc) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"0503 Failed allocate fast-path FCP "
-					"WQ (%d)\n", idx);
-			goto out_error;
+		/* Create Fast Path NVME CQs */
+		if (idx < phba->cfg_nvme_io_channel) {
+			qdesc = lpfc_sli4_queue_alloc(phba,
+						      phba->sli4_hba.cq_esize,
+						      phba->sli4_hba.cq_ecount);
+			if (!qdesc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0508 Failed allocate "
+						"fast-path NVME CQ (%d)\n",
+						idx);
+				goto out_error;
+			}
+			phba->sli4_hba.nvme_cq[idx] = qdesc;
 		}
-		phba->sli4_hba.fcp_wq[idx] = qdesc;
 	}
 
+	for (idx = 0; idx < phba->sli4_hba.num_present_cpu; idx++) {
+		if (phba->cfg_nvme_io_channel && (idx < numwq)) {
+			/* Create Fast Path NVME WQs. */
 
+			/* For NVME, every posted buffer potentially
+			 * represents 1 IO and IOs are spread across
+			 * cfg_nvme_max_hw_queue NVME hardware queues.
+			 *
+			 * Thus we need to ensure we have
+			 * enough WQE slots in the WQs to address all IOs.
+			 */
+			cnt = phba->cfg_nvme_posted_buf /
+				phba->cfg_nvme_max_hw_queue;
+			if (cnt < LPFC_WQE128_DEF_COUNT)
+				cnt = LPFC_WQE128_DEF_COUNT;
+			qdesc = lpfc_sli4_queue_alloc(phba,
+						      LPFC_WQE128_SIZE,
+						      cnt);
+			if (!qdesc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0509 Failed allocate "
+						"fast-path NVME WQ (%d)\n",
+						idx);
+				goto out_error;
+			}
+			phba->sli4_hba.nvme_wq[idx] = qdesc;
+			list_add_tail(&qdesc->wq_list,
+				      &phba->sli4_hba.lpfc_wq_list);
+		}
+		if ((phba->cfg_fcp_io_channel) &&
+		    (idx < phba->cfg_fcp_max_hw_queue)) {
+			/* Create Fast Path FCP WQs */
+			if (phba->fcp_embed_io) {
+				qdesc = lpfc_sli4_queue_alloc(phba,
+							LPFC_WQE128_SIZE,
+							LPFC_WQE128_DEF_COUNT);
+			} else {
+				qdesc = lpfc_sli4_queue_alloc(phba,
+						phba->sli4_hba.wq_esize,
+						phba->sli4_hba.wq_ecount);
+			}
+			if (!qdesc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"0503 Failed allocate "
+						"fast-path FCP WQ (%d)\n",
+						idx);
+				goto out_error;
+			}
+			phba->sli4_hba.fcp_wq[idx] = qdesc;
+			list_add_tail(&qdesc->wq_list,
+				      &phba->sli4_hba.lpfc_wq_list);
+		}
+	}
 	/*
 	 * Create Slow Path Completion Queues (CQs)
 	 */
@@ -7464,6 +7802,30 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		goto out_error;
 	}
 	phba->sli4_hba.els_wq = qdesc;
+	list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		/* Create NVME LS Complete Queue */
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.cq_esize,
+					      phba->sli4_hba.cq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6079 Failed allocate NVME LS CQ\n");
+			goto out_error;
+		}
+		phba->sli4_hba.nvmels_cq = qdesc;
+
+		/* Create NVME LS Work Queue */
+		qdesc = lpfc_sli4_queue_alloc(phba, phba->sli4_hba.wq_esize,
+					      phba->sli4_hba.wq_ecount);
+		if (!qdesc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6080 Failed allocate NVME LS WQ\n");
+			goto out_error;
+		}
+		phba->sli4_hba.nvmels_wq = qdesc;
+		list_add_tail(&qdesc->wq_list, &phba->sli4_hba.lpfc_wq_list);
+	}
 
 	/*
 	 * Create Receive Queue (RQ)
-- 
2.5.0

