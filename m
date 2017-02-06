From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 07/18] lpfc: NVME Initiator: Base modifications Part E
Date: Mon, 06 Feb 2017 15:08:56 -0800
Message-ID: <58990208.nZVFaqC7RkseErlq%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33268 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751938AbdBFXJG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:09:06 -0500
Received: by mail-wm0-f67.google.com with SMTP id v77so24903925wmv.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 15:09:04 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Initiator: Base modifications

This is part E of parts A..F.

Part E is limited to lpfc_sli.c. This is the location of most of changes
for the following:
- sli3 ring vs sli4 wq splits
- io abort interfaces
- actual queuing routines and use of dma and sgl pools
- service routines to create/delete queues

This patch by itself will not result in a compilable driver. All parts
A..F must be applied to create a compilable driver.

*********

Refer to Part A for a description of base modifications

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
Modifications in V2:
Note: this was patch 6 in the V1 patches
 Address review items:
  Reverted lpfc_sli_hbq_count() spurious change. Thus more files than
     just lpfc_sli.c
  Created helper function for assigning the pring pointer
 Sync with max_hw_queues/io_channel/io_channel_irqs change
 Flipped a few do_while loops to for loops
 Some additional checkpatch cleanups

 drivers/scsi/lpfc/lpfc_crtn.h |    2 +-
 drivers/scsi/lpfc/lpfc_hw.h   |    2 +-
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 drivers/scsi/lpfc/lpfc_mbox.c |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c  | 1470 +++++++++++++++++++++++++++++------------
 5 files changed, 1063 insertions(+), 415 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 8dfa4e4..db56b73 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -322,7 +322,7 @@ uint32_t lpfc_sli_get_buffer_tag(struct lpfc_hba *);
 struct lpfc_dmabuf * lpfc_sli_ring_taggedbuf_get(struct lpfc_hba *,
 			struct lpfc_sli_ring *, uint32_t );
 
-int lpfc_sli_hbq_count(struct lpfc_hba *phba);
+int lpfc_sli_hbq_count(void);
 int lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *, uint32_t);
 void lpfc_sli_hbqbuf_free_all(struct lpfc_hba *);
 int lpfc_sli_hbq_size(struct lpfc_hba *phba);
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 5d7416c..28247c9 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -4162,7 +4162,7 @@ typedef struct _IOCB {	/* IOCB structure */
 
 /* HBQ entries are 4 words each = 4k */
 #define LPFC_TOTAL_HBQ_SIZE (sizeof(struct lpfc_hbq_entry) *  \
-			     lpfc_sli_hbq_count(phba))
+			     lpfc_sli_hbq_count())
 
 struct lpfc_sli2_slim {
 	MAILBOX_t mbx;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ea720bc..6fd5135 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6697,7 +6697,7 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *phba)
 	if (!phba->hbqslimp.virt)
 		goto out_free_slim;
 
-	hbq_count = lpfc_sli_hbq_count(phba);
+	hbq_count = lpfc_sli_hbq_count();
 	ptr = phba->hbqslimp.virt;
 	for (i = 0; i < hbq_count; ++i) {
 		phba->hbqs[i].hbq_virt = ptr;
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 8dd5a77..dc1b9a1 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1291,7 +1291,7 @@ lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			mb->un.varCfgPort.cdss = 1; /* Configure Security */
 		mb->un.varCfgPort.cerbm = 1; /* Request HBQs */
 		mb->un.varCfgPort.ccrp = 1; /* Command Ring Polling */
-		mb->un.varCfgPort.max_hbq = lpfc_sli_hbq_count(phba);
+		mb->un.varCfgPort.max_hbq = lpfc_sli_hbq_count();
 		if (phba->max_vpi && phba->cfg_enable_npiv &&
 		    phba->vpd.sli3Feat.cmv) {
 			mb->un.varCfgPort.max_vpi = LPFC_MAX_VPI;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index dbe9cb1..d114543 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -34,14 +34,17 @@
 #include <scsi/fc/fc_fs.h>
 #include <linux/aer.h>
 
+#include <linux/nvme-fc-driver.h>
+
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
-#include "lpfc_scsi.h"
 #include "lpfc.h"
+#include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc_crtn.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_compat.h"
@@ -67,14 +70,17 @@ static struct lpfc_iocbq *lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *,
 							 struct lpfc_iocbq *);
 static void lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *,
 				      struct hbq_dmabuf *);
-static int lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *, struct lpfc_queue *,
+static int lpfc_sli4_fp_handle_cqe(struct lpfc_hba *, struct lpfc_queue *,
 				    struct lpfc_cqe *);
-static int lpfc_sli4_post_els_sgl_list(struct lpfc_hba *, struct list_head *,
+static int lpfc_sli4_post_sgl_list(struct lpfc_hba *, struct list_head *,
 				       int);
 static void lpfc_sli4_hba_handle_eqe(struct lpfc_hba *, struct lpfc_eqe *,
 			uint32_t);
 static bool lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba);
 static bool lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba);
+static int lpfc_sli4_abort_nvme_io(struct lpfc_hba *phba,
+				   struct lpfc_sli_ring *pring,
+				   struct lpfc_iocbq *cmdiocb);
 
 static IOCB_t *
 lpfc_get_iocb_from_iocbq(struct lpfc_iocbq *iocbq)
@@ -271,10 +277,11 @@ lpfc_sli4_eq_get(struct lpfc_queue *q)
 	/*
 	 * insert barrier for instruction interlock : data from the hardware
 	 * must have the valid bit checked before it can be copied and acted
-	 * upon. Given what was seen in lpfc_sli4_cq_get() of speculative
-	 * instructions allowing action on content before valid bit checked,
-	 * add barrier here as well. May not be needed as "content" is a
-	 * single 32-bit entity here (vs multi word structure for cq's).
+	 * upon. Speculative instructions were allowing a bcopy at the start
+	 * of lpfc_sli4_fp_handle_wcqe(), which is called immediately
+	 * after our return, to copy data before the valid bit check above
+	 * was done. As such, some of the copied data was stale. The barrier
+	 * ensures the check is before any data is copied.
 	 */
 	mb();
 	return eqe;
@@ -386,11 +393,10 @@ lpfc_sli4_cq_get(struct lpfc_queue *q)
 	/*
 	 * insert barrier for instruction interlock : data from the hardware
 	 * must have the valid bit checked before it can be copied and acted
-	 * upon. Speculative instructions were allowing a bcopy at the start
-	 * of lpfc_sli4_fp_handle_wcqe(), which is called immediately
-	 * after our return, to copy data before the valid bit check above
-	 * was done. As such, some of the copied data was stale. The barrier
-	 * ensures the check is before any data is copied.
+	 * upon. Given what was seen in lpfc_sli4_cq_get() of speculative
+	 * instructions allowing action on content before valid bit checked,
+	 * add barrier here as well. May not be needed as "content" is a
+	 * single 32-bit entity here (vs multi word structure for cq's).
 	 */
 	mb();
 	return cqe;
@@ -456,7 +462,7 @@ lpfc_sli4_cq_release(struct lpfc_queue *q, bool arm)
  * on @q then this function will return -ENOMEM.
  * The caller is expected to hold the hbalock when calling this routine.
  **/
-static int
+int
 lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
 		 struct lpfc_rqe *hrqe, struct lpfc_rqe *drqe)
 {
@@ -602,7 +608,7 @@ __lpfc_sli_get_iocbq(struct lpfc_hba *phba)
  *
  * Returns sglq ponter = success, NULL = Failure.
  **/
-static struct lpfc_sglq *
+struct lpfc_sglq *
 __lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xritag)
 {
 	struct lpfc_sglq *sglq;
@@ -902,7 +908,7 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 }
 
 /**
- * __lpfc_sli_get_sglq - Allocates an iocb object from sgl pool
+ * __lpfc_sli_get_els_sglq - Allocates an iocb object from sgl pool
  * @phba: Pointer to HBA context object.
  * @piocb: Pointer to the iocbq.
  *
@@ -911,10 +917,10 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
  * list is not empty then it is successful, it returns pointer to the newly
  * allocated sglq object else it returns NULL.
  **/
-static struct lpfc_sglq *
-__lpfc_sli_get_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
+struct lpfc_sglq *
+__lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 {
-	struct list_head *lpfc_sgl_list = &phba->sli4_hba.lpfc_sgl_list;
+	struct list_head *lpfc_els_sgl_list = &phba->sli4_hba.lpfc_els_sgl_list;
 	struct lpfc_sglq *sglq = NULL;
 	struct lpfc_sglq *start_sglq = NULL;
 	struct lpfc_scsi_buf *lpfc_cmd;
@@ -938,18 +944,21 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 		ndlp = piocbq->context1;
 	}
 
-	list_remove_head(lpfc_sgl_list, sglq, struct lpfc_sglq, list);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	list_remove_head(lpfc_els_sgl_list, sglq, struct lpfc_sglq, list);
 	start_sglq = sglq;
 	while (!found) {
 		if (!sglq)
 			return NULL;
-		if (lpfc_test_rrq_active(phba, ndlp, sglq->sli4_lxritag)) {
+		if (ndlp && ndlp->active_rrqs_xri_bitmap &&
+		    test_bit(sglq->sli4_lxritag,
+		    ndlp->active_rrqs_xri_bitmap)) {
 			/* This xri has an rrq outstanding for this DID.
 			 * put it back in the list and get another xri.
 			 */
-			list_add_tail(&sglq->list, lpfc_sgl_list);
+			list_add_tail(&sglq->list, lpfc_els_sgl_list);
 			sglq = NULL;
-			list_remove_head(lpfc_sgl_list, sglq,
+			list_remove_head(lpfc_els_sgl_list, sglq,
 						struct lpfc_sglq, list);
 			if (sglq == start_sglq) {
 				sglq = NULL;
@@ -962,6 +971,7 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 		phba->sli4_hba.lpfc_sglq_active_list[sglq->sli4_lxritag] = sglq;
 		sglq->state = SGL_ALLOCATED;
 	}
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	return sglq;
 }
 
@@ -1002,7 +1012,7 @@ lpfc_sli_get_iocbq(struct lpfc_hba *phba)
  * this IO was aborted then the sglq entry it put on the
  * lpfc_abts_els_sgl_list until the CQ_ABORTED_XRI is received. If the
  * IO has good status or fails for any other reason then the sglq
- * entry is added to the free list (lpfc_sgl_list).
+ * entry is added to the free list (lpfc_els_sgl_list).
  **/
 static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
@@ -1010,7 +1020,7 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 	struct lpfc_sglq *sglq;
 	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
 	unsigned long iflag = 0;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 
 	lockdep_assert_held(&phba->hbalock);
 
@@ -1021,21 +1031,24 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 
 
 	if (sglq)  {
+		pring = phba->sli4_hba.els_wq->pring;
 		if ((iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) &&
 			(sglq->state != SGL_XRI_ABORTED)) {
-			spin_lock_irqsave(&phba->sli4_hba.abts_sgl_list_lock,
-					iflag);
+			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
+					  iflag);
 			list_add(&sglq->list,
-				&phba->sli4_hba.lpfc_abts_els_sgl_list);
+				 &phba->sli4_hba.lpfc_abts_els_sgl_list);
 			spin_unlock_irqrestore(
-				&phba->sli4_hba.abts_sgl_list_lock, iflag);
+				&phba->sli4_hba.sgl_list_lock, iflag);
 		} else {
-			spin_lock_irqsave(&pring->ring_lock, iflag);
+			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
+					  iflag);
 			sglq->state = SGL_FREED;
 			sglq->ndlp = NULL;
 			list_add_tail(&sglq->list,
-				&phba->sli4_hba.lpfc_sgl_list);
-			spin_unlock_irqrestore(&pring->ring_lock, iflag);
+				      &phba->sli4_hba.lpfc_els_sgl_list);
+			spin_unlock_irqrestore(
+				&phba->sli4_hba.sgl_list_lock, iflag);
 
 			/* Check if TXQ queue needs to be serviced */
 			if (!list_empty(&pring->txq))
@@ -1043,13 +1056,13 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 		}
 	}
 
-
 	/*
 	 * Clean all volatile data fields, preserve iotag and node struct.
 	 */
 	memset((char *)iocbq + start_clean, 0, sizeof(*iocbq) - start_clean);
 	iocbq->sli4_lxritag = NO_XRI;
 	iocbq->sli4_xritag = NO_XRI;
+	iocbq->iocb_flag &= ~(LPFC_IO_NVME | LPFC_IO_NVME_LS);
 	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
 }
 
@@ -1639,7 +1652,7 @@ lpfc_sli_resume_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 
 	if (lpfc_is_link_up(phba) &&
 	    (!list_empty(&pring->txq)) &&
-	    (pring->ringno != phba->sli.fcp_ring ||
+	    (pring->ringno != LPFC_FCP_RING ||
 	     phba->sli.sli_flag & LPFC_PROCESS_LA)) {
 
 		while ((iocb = lpfc_sli_next_iocb_slot(phba, pring)) &&
@@ -1718,7 +1731,6 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba *phba)
 	struct hbq_dmabuf *hbq_buf;
 	unsigned long flags;
 	int i, hbq_count;
-	uint32_t hbqno;
 
 	hbq_count = lpfc_sli_hbq_count();
 	/* Return all memory used by all HBQs */
@@ -1732,24 +1744,6 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba *phba)
 		}
 		phba->hbqs[i].buffer_count = 0;
 	}
-	/* Return all HBQ buffer that are in-fly */
-	list_for_each_entry_safe(dmabuf, next_dmabuf, &phba->rb_pend_list,
-				 list) {
-		hbq_buf = container_of(dmabuf, struct hbq_dmabuf, dbuf);
-		list_del(&hbq_buf->dbuf.list);
-		if (hbq_buf->tag == -1) {
-			(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
-				(phba, hbq_buf);
-		} else {
-			hbqno = hbq_buf->tag >> 16;
-			if (hbqno >= LPFC_MAX_HBQS)
-				(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
-					(phba, hbq_buf);
-			else
-				(phba->hbqs[hbqno].hbq_free_buffer)(phba,
-					hbq_buf);
-		}
-	}
 
 	/* Mark the HBQs not in use */
 	phba->hbq_in_use = 0;
@@ -1802,7 +1796,7 @@ lpfc_sli_hbq_to_firmware_s3(struct lpfc_hba *phba, uint32_t hbqno,
 
 		hbqe->bde.addrHigh = le32_to_cpu(putPaddrHigh(physaddr));
 		hbqe->bde.addrLow  = le32_to_cpu(putPaddrLow(physaddr));
-		hbqe->bde.tus.f.bdeSize = hbq_buf->size;
+		hbqe->bde.tus.f.bdeSize = hbq_buf->total_size;
 		hbqe->bde.tus.f.bdeFlags = 0;
 		hbqe->bde.tus.w = le32_to_cpu(hbqe->bde.tus.w);
 		hbqe->buffer_tag = le32_to_cpu(hbq_buf->tag);
@@ -1834,17 +1828,23 @@ lpfc_sli_hbq_to_firmware_s4(struct lpfc_hba *phba, uint32_t hbqno,
 	int rc;
 	struct lpfc_rqe hrqe;
 	struct lpfc_rqe drqe;
+	struct lpfc_queue *hrq;
+	struct lpfc_queue *drq;
+
+	if (hbqno != LPFC_ELS_HBQ)
+		return 1;
+	hrq = phba->sli4_hba.hdr_rq;
+	drq = phba->sli4_hba.dat_rq;
 
 	lockdep_assert_held(&phba->hbalock);
 	hrqe.address_lo = putPaddrLow(hbq_buf->hbuf.phys);
 	hrqe.address_hi = putPaddrHigh(hbq_buf->hbuf.phys);
 	drqe.address_lo = putPaddrLow(hbq_buf->dbuf.phys);
 	drqe.address_hi = putPaddrHigh(hbq_buf->dbuf.phys);
-	rc = lpfc_sli4_rq_put(phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq,
-			      &hrqe, &drqe);
+	rc = lpfc_sli4_rq_put(hrq, drq, &hrqe, &drqe);
 	if (rc < 0)
 		return rc;
-	hbq_buf->tag = rc;
+	hbq_buf->tag = (rc | (hbqno << 16));
 	list_add_tail(&hbq_buf->dbuf.list, &phba->hbqs[hbqno].hbq_buffer_list);
 	return 0;
 }
@@ -1861,22 +1861,9 @@ static struct lpfc_hbq_init lpfc_els_hbq = {
 	.add_count = 40,
 };
 
-/* HBQ for the extra ring if needed */
-static struct lpfc_hbq_init lpfc_extra_hbq = {
-	.rn = 1,
-	.entry_count = 200,
-	.mask_count = 0,
-	.profile = 0,
-	.ring_mask = (1 << LPFC_EXTRA_RING),
-	.buffer_count = 0,
-	.init_count = 0,
-	.add_count = 5,
-};
-
 /* Array of HBQs */
 struct lpfc_hbq_init *lpfc_hbq_defs[] = {
 	&lpfc_els_hbq,
-	&lpfc_extra_hbq,
 };
 
 /**
@@ -2713,7 +2700,7 @@ static struct lpfc_iocbq *
 lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 			     struct lpfc_sli_ring *pring, uint16_t iotag)
 {
-	struct lpfc_iocbq *cmd_iocb;
+	struct lpfc_iocbq *cmd_iocb = NULL;
 
 	lockdep_assert_held(&phba->hbalock);
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
@@ -2727,8 +2714,10 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 	}
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-			"0372 iotag x%x is out of range: max iotag (x%x)\n",
-			iotag, phba->sli.last_iotag);
+			"0372 iotag x%x lookup error: max iotag (x%x) "
+			"iocb_flag x%x\n",
+			iotag, phba->sli.last_iotag,
+			cmd_iocb ? cmd_iocb->iocb_flag : 0xffff);
 	return NULL;
 }
 
@@ -3598,6 +3587,33 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 }
 
 /**
+ * lpfc_sli_abort_wqe_ring - Abort all iocbs in the ring
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function aborts all iocbs in the given ring and frees all the iocb
+ * objects in txq. This function issues an abort iocb for all the iocb commands
+ * in txcmplq. The iocbs in the txcmplq is not guaranteed to complete before
+ * the return of this function. The caller is not required to hold any locks.
+ **/
+void
+lpfc_sli_abort_wqe_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
+{
+	LIST_HEAD(completions);
+	struct lpfc_iocbq *iocb, *next_iocb;
+
+	if (pring->ringno == LPFC_ELS_RING)
+		lpfc_fabric_abort_hba(phba);
+
+	spin_lock_irq(&phba->hbalock);
+	/* Next issue ABTS for everything on the txcmplq */
+	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
+		lpfc_sli4_abort_nvme_io(phba, pring, iocb);
+	spin_unlock_irq(&phba->hbalock);
+}
+
+
+/**
  * lpfc_sli_abort_fcp_rings - Abort all iocbs in all FCP rings
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
@@ -3617,15 +3633,40 @@ lpfc_sli_abort_fcp_rings(struct lpfc_hba *phba)
 	/* Look on all the FCP Rings for the iotag */
 	if (phba->sli_rev >= LPFC_SLI_REV4) {
 		for (i = 0; i < phba->cfg_fcp_io_channel; i++) {
-			pring = &psli->ring[i + MAX_SLI3_CONFIGURED_RINGS];
+			pring = phba->sli4_hba.fcp_wq[i]->pring;
 			lpfc_sli_abort_iocb_ring(phba, pring);
 		}
 	} else {
-		pring = &psli->ring[psli->fcp_ring];
+		pring = &psli->sli3_ring[LPFC_FCP_RING];
 		lpfc_sli_abort_iocb_ring(phba, pring);
 	}
 }
 
+/**
+ * lpfc_sli_abort_nvme_rings - Abort all wqes in all NVME rings
+ * @phba: Pointer to HBA context object.
+ *
+ * This function aborts all wqes in NVME rings. This function issues an
+ * abort wqe for all the outstanding IO commands in txcmplq. The iocbs in
+ * the txcmplq is not guaranteed to complete before the return of this
+ * function. The caller is not required to hold any locks.
+ **/
+void
+lpfc_sli_abort_nvme_rings(struct lpfc_hba *phba)
+{
+	struct lpfc_sli_ring  *pring;
+	uint32_t i;
+
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		return;
+
+	/* Abort all IO on each NVME ring. */
+	for (i = 0; i < phba->cfg_nvme_io_channel; i++) {
+		pring = phba->sli4_hba.nvme_wq[i]->pring;
+		lpfc_sli_abort_wqe_ring(phba, pring);
+	}
+}
+
 
 /**
  * lpfc_sli_flush_fcp_rings - flush all iocbs in the fcp ring
@@ -3654,7 +3695,7 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
 	/* Look on all the FCP Rings for the iotag */
 	if (phba->sli_rev >= LPFC_SLI_REV4) {
 		for (i = 0; i < phba->cfg_fcp_io_channel; i++) {
-			pring = &psli->ring[i + MAX_SLI3_CONFIGURED_RINGS];
+			pring = phba->sli4_hba.fcp_wq[i]->pring;
 
 			spin_lock_irq(&pring->ring_lock);
 			/* Retrieve everything on txq */
@@ -3675,7 +3716,7 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
 					      IOERR_SLI_DOWN);
 		}
 	} else {
-		pring = &psli->ring[psli->fcp_ring];
+		pring = &psli->sli3_ring[LPFC_FCP_RING];
 
 		spin_lock_irq(&phba->hbalock);
 		/* Retrieve everything on txq */
@@ -3696,6 +3737,51 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_sli_flush_nvme_rings - flush all wqes in the nvme rings
+ * @phba: Pointer to HBA context object.
+ *
+ * This function flushes all wqes in the nvme rings and frees all resources
+ * in the txcmplq. This function does not issue abort wqes for the IO
+ * commands in txcmplq, they will just be returned with
+ * IOERR_SLI_DOWN. This function is invoked with EEH when device's PCI
+ * slot has been permanently disabled.
+ **/
+void
+lpfc_sli_flush_nvme_rings(struct lpfc_hba *phba)
+{
+	LIST_HEAD(txcmplq);
+	struct lpfc_sli_ring  *pring;
+	uint32_t i;
+
+	if (phba->sli_rev < LPFC_SLI_REV4)
+		return;
+
+	/* Hint to other driver operations that a flush is in progress. */
+	spin_lock_irq(&phba->hbalock);
+	phba->hba_flag |= HBA_NVME_IOQ_FLUSH;
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Cycle through all NVME rings and complete each IO with
+	 * a local driver reason code.  This is a flush so no
+	 * abort exchange to FW.
+	 */
+	for (i = 0; i < phba->cfg_nvme_io_channel; i++) {
+		pring = phba->sli4_hba.nvme_wq[i]->pring;
+
+		/* Retrieve everything on the txcmplq */
+		spin_lock_irq(&pring->ring_lock);
+		list_splice_init(&pring->txcmplq, &txcmplq);
+		pring->txcmplq_cnt = 0;
+		spin_unlock_irq(&pring->ring_lock);
+
+		/* Flush the txcmpq &&&PAE */
+		lpfc_sli_cancel_iocbs(phba, &txcmplq,
+				      IOSTAT_LOCAL_REJECT,
+				      IOERR_SLI_DOWN);
+	}
+}
+
+/**
  * lpfc_sli_brdready_s3 - Check for sli3 host ready status
  * @phba: Pointer to HBA context object.
  * @mask: Bit mask to be checked.
@@ -4069,7 +4155,7 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
 
 	/* Initialize relevant SLI info */
 	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
+		pring = &psli->sli3_ring[i];
 		pring->flag = 0;
 		pring->sli.sli3.rspidx = 0;
 		pring->sli.sli3.next_cmdidx  = 0;
@@ -4393,7 +4479,7 @@ lpfc_sli_hbq_count(void)
  * the total count.
  **/
 static int
-lpfc_sli_hbq_entry_count(void)
+lpfc_sli_hbq_entry_count(struct lpfc_hba *phba)
 {
 	int  hbq_count = lpfc_sli_hbq_count();
 	int  count = 0;
@@ -4411,9 +4497,9 @@ lpfc_sli_hbq_entry_count(void)
  * to be configured and returns the total memory required.
  **/
 int
-lpfc_sli_hbq_size(void)
+lpfc_sli_hbq_size(struct lpfc_hba *phba)
 {
-	return lpfc_sli_hbq_entry_count() * sizeof(struct lpfc_hbq_entry);
+	return lpfc_sli_hbq_entry_count(phba) * sizeof(struct lpfc_hbq_entry);
 }
 
 /**
@@ -4498,10 +4584,11 @@ static int
 lpfc_sli4_rb_setup(struct lpfc_hba *phba)
 {
 	phba->hbq_in_use = 1;
-	phba->hbqs[0].entry_count = lpfc_hbq_defs[0]->entry_count;
+	phba->hbqs[LPFC_ELS_HBQ].entry_count =
+		lpfc_hbq_defs[LPFC_ELS_HBQ]->entry_count;
 	phba->hbq_count = 1;
+	lpfc_sli_hbqbuf_init_hbqs(phba, LPFC_ELS_HBQ);
 	/* Initially populate or replenish the HBQs */
-	lpfc_sli_hbqbuf_init_hbqs(phba, 0);
 	return 0;
 }
 
@@ -5107,27 +5194,31 @@ lpfc_sli4_retrieve_pport_name(struct lpfc_hba *phba)
 static void
 lpfc_sli4_arm_cqeq_intr(struct lpfc_hba *phba)
 {
-	int fcp_eqidx;
+	int qidx;
 
 	lpfc_sli4_cq_release(phba->sli4_hba.mbx_cq, LPFC_QUEUE_REARM);
 	lpfc_sli4_cq_release(phba->sli4_hba.els_cq, LPFC_QUEUE_REARM);
-	fcp_eqidx = 0;
-	if (phba->sli4_hba.fcp_cq) {
-		do {
-			lpfc_sli4_cq_release(phba->sli4_hba.fcp_cq[fcp_eqidx],
-					     LPFC_QUEUE_REARM);
-		} while (++fcp_eqidx < phba->cfg_fcp_io_channel);
-	}
+	if (phba->sli4_hba.nvmels_cq)
+		lpfc_sli4_cq_release(phba->sli4_hba.nvmels_cq,
+						LPFC_QUEUE_REARM);
+
+	if (phba->sli4_hba.fcp_cq)
+		for (qidx = 0; qidx < phba->cfg_fcp_io_channel; qidx++)
+			lpfc_sli4_cq_release(phba->sli4_hba.fcp_cq[qidx],
+						LPFC_QUEUE_REARM);
+
+	if (phba->sli4_hba.nvme_cq)
+		for (qidx = 0; qidx < phba->cfg_nvme_io_channel; qidx++)
+			lpfc_sli4_cq_release(phba->sli4_hba.nvme_cq[qidx],
+						LPFC_QUEUE_REARM);
 
 	if (phba->cfg_fof)
 		lpfc_sli4_cq_release(phba->sli4_hba.oas_cq, LPFC_QUEUE_REARM);
 
-	if (phba->sli4_hba.hba_eq) {
-		for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel;
-		     fcp_eqidx++)
-			lpfc_sli4_eq_release(phba->sli4_hba.hba_eq[fcp_eqidx],
-					     LPFC_QUEUE_REARM);
-	}
+	if (phba->sli4_hba.hba_eq)
+		for (qidx = 0; qidx < phba->io_channel_irqs; qidx++)
+			lpfc_sli4_eq_release(phba->sli4_hba.hba_eq[qidx],
+						LPFC_QUEUE_REARM);
 
 	if (phba->cfg_fof)
 		lpfc_sli4_eq_release(phba->sli4_hba.fof_eq, LPFC_QUEUE_REARM);
@@ -5560,9 +5651,13 @@ lpfc_sli4_alloc_extent(struct lpfc_hba *phba, uint16_t type)
 		rsrc_blks->rsrc_size = rsrc_size;
 		list_add_tail(&rsrc_blks->list, ext_blk_list);
 		rsrc_start = rsrc_id;
-		if ((type == LPFC_RSC_TYPE_FCOE_XRI) && (j == 0))
+		if ((type == LPFC_RSC_TYPE_FCOE_XRI) && (j == 0)) {
 			phba->sli4_hba.scsi_xri_start = rsrc_start +
-				lpfc_sli4_get_els_iocb_cnt(phba);
+				lpfc_sli4_get_iocb_cnt(phba);
+			phba->sli4_hba.nvme_xri_start =
+				phba->sli4_hba.scsi_xri_start +
+				phba->sli4_hba.scsi_xri_max;
+		}
 
 		while (rsrc_id < (rsrc_start + rsrc_size)) {
 			ids[j] = rsrc_id;
@@ -5578,6 +5673,8 @@ lpfc_sli4_alloc_extent(struct lpfc_hba *phba, uint16_t type)
 	return rc;
 }
 
+
+
 /**
  * lpfc_sli4_dealloc_extent - Deallocate an SLI4 resource extent.
  * @phba: Pointer to HBA context object.
@@ -6149,42 +6246,45 @@ lpfc_sli4_get_allocated_extnts(struct lpfc_hba *phba, uint16_t type,
 }
 
 /**
- * lpfc_sli4_repost_els_sgl_list - Repsot the els buffers sgl pages as block
+ * lpfc_sli4_repost_sgl_list - Repsot the buffers sgl pages as block
  * @phba: pointer to lpfc hba data structure.
+ * @pring: Pointer to driver SLI ring object.
+ * @sgl_list: linked link of sgl buffers to post
+ * @cnt: number of linked list buffers
  *
- * This routine walks the list of els buffers that have been allocated and
+ * This routine walks the list of buffers that have been allocated and
  * repost them to the port by using SGL block post. This is needed after a
  * pci_function_reset/warm_start or start. It attempts to construct blocks
- * of els buffer sgls which contains contiguous xris and uses the non-embedded
- * SGL block post mailbox commands to post them to the port. For single els
+ * of buffer sgls which contains contiguous xris and uses the non-embedded
+ * SGL block post mailbox commands to post them to the port. For single
  * buffer sgl with non-contiguous xri, if any, it shall use embedded SGL post
  * mailbox command for posting.
  *
  * Returns: 0 = success, non-zero failure.
  **/
 static int
-lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
+lpfc_sli4_repost_sgl_list(struct lpfc_hba *phba,
+			  struct list_head *sgl_list, int cnt)
 {
 	struct lpfc_sglq *sglq_entry = NULL;
 	struct lpfc_sglq *sglq_entry_next = NULL;
 	struct lpfc_sglq *sglq_entry_first = NULL;
-	int status, total_cnt, post_cnt = 0, num_posted = 0, block_cnt = 0;
+	int status, total_cnt;
+	int post_cnt = 0, num_posted = 0, block_cnt = 0;
 	int last_xritag = NO_XRI;
-	struct lpfc_sli_ring *pring;
 	LIST_HEAD(prep_sgl_list);
 	LIST_HEAD(blck_sgl_list);
 	LIST_HEAD(allc_sgl_list);
 	LIST_HEAD(post_sgl_list);
 	LIST_HEAD(free_sgl_list);
 
-	pring = &phba->sli.ring[LPFC_ELS_RING];
 	spin_lock_irq(&phba->hbalock);
-	spin_lock(&pring->ring_lock);
-	list_splice_init(&phba->sli4_hba.lpfc_sgl_list, &allc_sgl_list);
-	spin_unlock(&pring->ring_lock);
+	spin_lock(&phba->sli4_hba.sgl_list_lock);
+	list_splice_init(sgl_list, &allc_sgl_list);
+	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	spin_unlock_irq(&phba->hbalock);
 
-	total_cnt = phba->sli4_hba.els_xri_cnt;
+	total_cnt = cnt;
 	list_for_each_entry_safe(sglq_entry, sglq_entry_next,
 				 &allc_sgl_list, list) {
 		list_del_init(&sglq_entry->list);
@@ -6213,8 +6313,8 @@ lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
 		/* keep track of last sgl's xritag */
 		last_xritag = sglq_entry->sli4_xritag;
 
-		/* end of repost sgl list condition for els buffers */
-		if (num_posted == phba->sli4_hba.els_xri_cnt) {
+		/* end of repost sgl list condition for buffers */
+		if (num_posted == total_cnt) {
 			if (post_cnt == 0) {
 				list_splice_init(&prep_sgl_list,
 						 &blck_sgl_list);
@@ -6231,7 +6331,7 @@ lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
 					/* Failure, put sgl to free list */
 					lpfc_printf_log(phba, KERN_WARNING,
 						LOG_SLI,
-						"3159 Failed to post els "
+						"3159 Failed to post "
 						"sgl, xritag:x%x\n",
 						sglq_entry->sli4_xritag);
 					list_add_tail(&sglq_entry->list,
@@ -6245,9 +6345,9 @@ lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
 		if (post_cnt == 0)
 			continue;
 
-		/* post the els buffer list sgls as a block */
-		status = lpfc_sli4_post_els_sgl_list(phba, &blck_sgl_list,
-						     post_cnt);
+		/* post the buffer list sgls as a block */
+		status = lpfc_sli4_post_sgl_list(phba, &blck_sgl_list,
+						 post_cnt);
 
 		if (!status) {
 			/* success, put sgl list to posted sgl list */
@@ -6258,7 +6358,7 @@ lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
 							    struct lpfc_sglq,
 							    list);
 			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-					"3160 Failed to post els sgl-list, "
+					"3160 Failed to post sgl-list, "
 					"xritag:x%x-x%x\n",
 					sglq_entry_first->sli4_xritag,
 					(sglq_entry_first->sli4_xritag +
@@ -6271,29 +6371,28 @@ lpfc_sli4_repost_els_sgl_list(struct lpfc_hba *phba)
 		if (block_cnt == 0)
 			last_xritag = NO_XRI;
 
-		/* reset els sgl post count for next round of posting */
+		/* reset sgl post count for next round of posting */
 		post_cnt = 0;
 	}
-	/* update the number of XRIs posted for ELS */
-	phba->sli4_hba.els_xri_cnt = total_cnt;
 
-	/* free the els sgls failed to post */
+	/* free the sgls failed to post */
 	lpfc_free_sgl_list(phba, &free_sgl_list);
 
-	/* push els sgls posted to the availble list */
+	/* push sgls posted to the available list */
 	if (!list_empty(&post_sgl_list)) {
 		spin_lock_irq(&phba->hbalock);
-		spin_lock(&pring->ring_lock);
-		list_splice_init(&post_sgl_list,
-				 &phba->sli4_hba.lpfc_sgl_list);
-		spin_unlock(&pring->ring_lock);
+		spin_lock(&phba->sli4_hba.sgl_list_lock);
+		list_splice_init(&post_sgl_list, sgl_list);
+		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 		spin_unlock_irq(&phba->hbalock);
 	} else {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"3161 Failure to post els sgl to port.\n");
+				"3161 Failure to post sgl to port.\n");
 		return -EIO;
 	}
-	return 0;
+
+	/* return the number of XRIs actually posted */
+	return total_cnt;
 }
 
 void
@@ -6615,35 +6714,78 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	fc_host_node_name(shost) = wwn_to_u64(vport->fc_nodename.u.wwn);
 	fc_host_port_name(shost) = wwn_to_u64(vport->fc_portname.u.wwn);
 
-	/* update host els and scsi xri-sgl sizes and mappings */
-	rc = lpfc_sli4_xri_sgl_update(phba);
+	/* Create all the SLI4 queues */
+	rc = lpfc_sli4_queue_create(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3089 Failed to allocate queues\n");
+		rc = -ENODEV;
+		goto out_free_mbox;
+	}
+	/* Set up all the queues to the device */
+	rc = lpfc_sli4_queue_setup(phba);
+	if (unlikely(rc)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"0381 Error %d during queue setup.\n ", rc);
+		goto out_stop_timers;
+	}
+	/* Initialize the driver internal SLI layer lists. */
+	lpfc_sli4_setup(phba);
+	lpfc_sli4_queue_init(phba);
+
+	/* update host els xri-sgl sizes and mappings */
+	rc = lpfc_sli4_els_sgl_update(phba);
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 				"1400 Failed to update xri-sgl size and "
 				"mapping: %d\n", rc);
-		goto out_free_mbox;
+		goto out_destroy_queue;
 	}
 
 	/* register the els sgl pool to the port */
-	rc = lpfc_sli4_repost_els_sgl_list(phba);
-	if (unlikely(rc)) {
+	rc = lpfc_sli4_repost_sgl_list(phba, &phba->sli4_hba.lpfc_els_sgl_list,
+				       phba->sli4_hba.els_xri_cnt);
+	if (unlikely(rc < 0)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 				"0582 Error %d during els sgl post "
 				"operation\n", rc);
 		rc = -ENODEV;
-		goto out_free_mbox;
+		goto out_destroy_queue;
 	}
+	phba->sli4_hba.els_xri_cnt = rc;
 
-	/* register the allocated scsi sgl pool to the port */
-	rc = lpfc_sli4_repost_scsi_sgl_list(phba);
-	if (unlikely(rc)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"0383 Error %d during scsi sgl post "
-				"operation\n", rc);
-		/* Some Scsi buffers were moved to the abort scsi list */
-		/* A pci function reset will repost them */
-		rc = -ENODEV;
-		goto out_free_mbox;
+	if (phba->nvmet_support == 0) {
+		/* update host scsi xri-sgl sizes and mappings */
+		rc = lpfc_sli4_scsi_sgl_update(phba);
+		if (unlikely(rc)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"6309 Failed to update scsi-sgl size "
+					"and mapping: %d\n", rc);
+			goto out_destroy_queue;
+		}
+
+		/* update host nvme xri-sgl sizes and mappings */
+		rc = lpfc_sli4_nvme_sgl_update(phba);
+		if (unlikely(rc)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"6082 Failed to update nvme-sgl size "
+					"and mapping: %d\n", rc);
+			goto out_destroy_queue;
+		}
+	}
+
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
+		/* register the allocated scsi sgl pool to the port */
+		rc = lpfc_sli4_repost_scsi_sgl_list(phba);
+		if (unlikely(rc)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"0383 Error %d during scsi sgl post "
+					"operation\n", rc);
+			/* Some Scsi buffers were moved to abort scsi list */
+			/* A pci function reset will repost them */
+			rc = -ENODEV;
+			goto out_destroy_queue;
+		}
 	}
 
 	/* Post the rpi header region to the device. */
@@ -6653,24 +6795,26 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 				"0393 Error %d during rpi post operation\n",
 				rc);
 		rc = -ENODEV;
-		goto out_free_mbox;
+		goto out_destroy_queue;
 	}
 	lpfc_sli4_node_prep(phba);
 
-	/* Create all the SLI4 queues */
-	rc = lpfc_sli4_queue_create(phba);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3089 Failed to allocate queues\n");
-		rc = -ENODEV;
-		goto out_stop_timers;
-	}
-	/* Set up all the queues to the device */
-	rc = lpfc_sli4_queue_setup(phba);
-	if (unlikely(rc)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
-				"0381 Error %d during queue setup.\n ", rc);
-		goto out_destroy_queue;
+	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
+		if (phba->nvmet_support == 0) {
+			/*
+			 * The FC Port needs to register FCFI (index 0)
+			 */
+			lpfc_reg_fcfi(phba, mboxq);
+			mboxq->vport = phba->pport;
+			rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+			if (rc != MBX_SUCCESS)
+				goto out_unset_queue;
+			rc = 0;
+			phba->fcf.fcfi = bf_get(lpfc_reg_fcfi_fcfi,
+						&mboxq->u.mqe.un.reg_fcfi);
+		}
+		/* Check if the port is configured to be disabled */
+		lpfc_sli_read_link_ste(phba);
 	}
 
 	/* Arm the CQs and then EQs on device */
@@ -6724,23 +6868,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		rc = 0;
 	}
 
-	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
-		/*
-		 * The FC Port needs to register FCFI (index 0)
-		 */
-		lpfc_reg_fcfi(phba, mboxq);
-		mboxq->vport = phba->pport;
-		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-		if (rc != MBX_SUCCESS)
-			goto out_unset_queue;
-		rc = 0;
-		phba->fcf.fcfi = bf_get(lpfc_reg_fcfi_fcfi,
-					&mboxq->u.mqe.un.reg_fcfi);
-
-		/* Check if the port is configured to be disabled */
-		lpfc_sli_read_link_ste(phba);
-	}
-
 	/*
 	 * The port is ready, set the host's link state to LINK_DOWN
 	 * in preparation for link interrupts.
@@ -6877,7 +7004,7 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 	/* Find the eq associated with the mcq */
 
 	if (phba->sli4_hba.hba_eq)
-		for (eqidx = 0; eqidx < phba->cfg_fcp_io_channel; eqidx++)
+		for (eqidx = 0; eqidx < phba->io_channel_irqs; eqidx++)
 			if (phba->sli4_hba.hba_eq[eqidx]->queue_id ==
 			    phba->sli4_hba.mbx_cq->assoc_qid) {
 				fpeq = phba->sli4_hba.hba_eq[eqidx];
@@ -7236,16 +7363,15 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 				= MAILBOX_HBA_EXT_OFFSET;
 
 		/* Copy the mailbox extension data */
-		if (pmbox->in_ext_byte_len && pmbox->context2) {
+		if (pmbox->in_ext_byte_len && pmbox->context2)
 			lpfc_memcpy_to_slim(phba->MBslimaddr +
 				MAILBOX_HBA_EXT_OFFSET,
 				pmbox->context2, pmbox->in_ext_byte_len);
 
-		}
-		if (mbx->mbxCommand == MBX_CONFIG_PORT) {
+		if (mbx->mbxCommand == MBX_CONFIG_PORT)
 			/* copy command data into host mbox for cmpl */
-			lpfc_sli_pcimem_bcopy(mbx, phba->mbox, MAILBOX_CMD_SIZE);
-		}
+			lpfc_sli_pcimem_bcopy(mbx, phba->mbox,
+					      MAILBOX_CMD_SIZE);
 
 		/* First copy mbox command data to HBA SLIM, skip past first
 		   word */
@@ -7259,10 +7385,9 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 		writel(ldata, to_slim);
 		readl(to_slim); /* flush */
 
-		if (mbx->mbxCommand == MBX_CONFIG_PORT) {
+		if (mbx->mbxCommand == MBX_CONFIG_PORT)
 			/* switch over to host mailbox */
 			psli->sli_flag |= LPFC_SLI_ACTIVE;
-		}
 	}
 
 	wmb();
@@ -7361,7 +7486,8 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 
 		if (psli->sli_flag & LPFC_SLI_ACTIVE) {
 			/* copy results back to user */
-			lpfc_sli_pcimem_bcopy(phba->mbox, mbx, MAILBOX_CMD_SIZE);
+			lpfc_sli_pcimem_bcopy(phba->mbox, mbx,
+						MAILBOX_CMD_SIZE);
 			/* Copy the mailbox extension data */
 			if (pmbox->out_ext_byte_len && pmbox->context2) {
 				lpfc_sli_pcimem_bcopy(phba->mbox_ext,
@@ -7371,7 +7497,7 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 		} else {
 			/* First copy command data */
 			lpfc_memcpy_from_slim(mbx, phba->MBslimaddr,
-							MAILBOX_CMD_SIZE);
+						MAILBOX_CMD_SIZE);
 			/* Copy the mailbox extension data */
 			if (pmbox->out_ext_byte_len && pmbox->context2) {
 				lpfc_memcpy_from_slim(pmbox->context2,
@@ -8052,7 +8178,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
 {
 	struct lpfc_iocbq *nextiocb;
 	IOCB_t *iocb;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
+	struct lpfc_sli_ring *pring = &phba->sli.sli3_ring[ring_number];
 
 	lockdep_assert_held(&phba->hbalock);
 
@@ -8126,7 +8252,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
 	 * For FCP commands, we must be in a state where we can process link
 	 * attention events.
 	 */
-	} else if (unlikely(pring->ringno == phba->sli.fcp_ring &&
+	} else if (unlikely(pring->ringno == LPFC_FCP_RING &&
 			    !(phba->sli.sli_flag & LPFC_PROCESS_LA))) {
 		goto iocb_busy;
 	}
@@ -8863,9 +8989,21 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	union lpfc_wqe *wqe;
 	union lpfc_wqe128 wqe128;
 	struct lpfc_queue *wq;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
+	struct lpfc_sli_ring *pring;
 
-	lockdep_assert_held(&phba->hbalock);
+	/* Get the WQ */
+	if ((piocb->iocb_flag & LPFC_IO_FCP) ||
+	    (piocb->iocb_flag & LPFC_USE_FCPWQIDX)) {
+		if (!phba->cfg_fof || (!(piocb->iocb_flag & LPFC_IO_OAS)))
+			wq = phba->sli4_hba.fcp_wq[piocb->hba_wqidx];
+		else
+			wq = phba->sli4_hba.oas_wq;
+	} else {
+		wq = phba->sli4_hba.els_wq;
+	}
+
+	/* Get corresponding ring */
+	pring = wq->pring;
 
 	/*
 	 * The WQE can be either 64 or 128 bytes,
@@ -8873,6 +9011,8 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	 */
 	wqe = (union lpfc_wqe *)&wqe128;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	if (piocb->sli4_xritag == NO_XRI) {
 		if (piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
 		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
@@ -8887,7 +9027,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 					return IOCB_BUSY;
 				}
 			} else {
-				sglq = __lpfc_sli_get_sglq(phba, piocb);
+				sglq = __lpfc_sli_get_els_sglq(phba, piocb);
 				if (!sglq) {
 					if (!(flag & SLI_IOCB_RET_IOCB)) {
 						__lpfc_sli_ringtx_put(phba,
@@ -8899,10 +9039,10 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 				}
 			}
 		}
-	} else if (piocb->iocb_flag &  LPFC_IO_FCP) {
+	} else if (piocb->iocb_flag &  LPFC_IO_FCP)
 		/* These IO's already have an XRI and a mapped sgl. */
 		sglq = NULL;
-	} else {
+	else {
 		/*
 		 * This is a continuation of a commandi,(CX) so this
 		 * sglq is on the active list
@@ -8922,21 +9062,8 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	if (lpfc_sli4_iocb2wqe(phba, piocb, wqe))
 		return IOCB_ERROR;
 
-	if ((piocb->iocb_flag & LPFC_IO_FCP) ||
-	    (piocb->iocb_flag & LPFC_USE_FCPWQIDX)) {
-		if (!phba->cfg_fof || (!(piocb->iocb_flag & LPFC_IO_OAS))) {
-			wq = phba->sli4_hba.fcp_wq[piocb->fcp_wqidx];
-		} else {
-			wq = phba->sli4_hba.oas_wq;
-		}
-		if (lpfc_sli4_wq_put(wq, wqe))
-			return IOCB_ERROR;
-	} else {
-		if (unlikely(!phba->sli4_hba.els_wq))
-			return IOCB_ERROR;
-		if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, wqe))
-			return IOCB_ERROR;
-	}
+	if (lpfc_sli4_wq_put(wq, wqe))
+		return IOCB_ERROR;
 	lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
 
 	return 0;
@@ -8994,46 +9121,44 @@ lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 }
 
 /**
- * lpfc_sli_calc_ring - Calculates which ring to use
+ * lpfc_sli4_calc_ring - Calculates which ring to use
  * @phba: Pointer to HBA context object.
- * @ring_number: Initial ring
  * @piocb: Pointer to command iocb.
  *
- * For SLI4, FCP IO can deferred to one fo many WQs, based on
- * fcp_wqidx, thus we need to calculate the corresponding ring.
+ * For SLI4 only, FCP IO can deferred to one fo many WQs, based on
+ * hba_wqidx, thus we need to calculate the corresponding ring.
  * Since ABORTS must go on the same WQ of the command they are
- * aborting, we use command's fcp_wqidx.
+ * aborting, we use command's hba_wqidx.
  */
-static int
-lpfc_sli_calc_ring(struct lpfc_hba *phba, uint32_t ring_number,
-		    struct lpfc_iocbq *piocb)
+struct lpfc_sli_ring *
+lpfc_sli4_calc_ring(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 {
-	if (phba->sli_rev < LPFC_SLI_REV4)
-		return ring_number;
-
-	if (piocb->iocb_flag &  (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
+	if (piocb->iocb_flag & (LPFC_IO_FCP | LPFC_USE_FCPWQIDX)) {
 		if (!(phba->cfg_fof) ||
-				(!(piocb->iocb_flag & LPFC_IO_FOF))) {
+		    (!(piocb->iocb_flag & LPFC_IO_FOF))) {
 			if (unlikely(!phba->sli4_hba.fcp_wq))
-				return LPFC_HBA_ERROR;
+				return NULL;
 			/*
-			 * for abort iocb fcp_wqidx should already
+			 * for abort iocb hba_wqidx should already
 			 * be setup based on what work queue we used.
 			 */
 			if (!(piocb->iocb_flag & LPFC_USE_FCPWQIDX))
-				piocb->fcp_wqidx =
+				piocb->hba_wqidx =
 					lpfc_sli4_scmd_to_wqidx_distr(phba,
 							      piocb->context1);
-			ring_number = MAX_SLI3_CONFIGURED_RINGS +
-				piocb->fcp_wqidx;
+			return phba->sli4_hba.fcp_wq[piocb->hba_wqidx]->pring;
 		} else {
 			if (unlikely(!phba->sli4_hba.oas_wq))
-				return LPFC_HBA_ERROR;
-			piocb->fcp_wqidx = 0;
-			ring_number =  LPFC_FCP_OAS_RING;
+				return NULL;
+			piocb->hba_wqidx = 0;
+			return phba->sli4_hba.oas_wq->pring;
 		}
+	} else {
+		if (unlikely(!phba->sli4_hba.els_wq))
+			return NULL;
+		piocb->hba_wqidx = 0;
+		return phba->sli4_hba.els_wq->pring;
 	}
-	return ring_number;
 }
 
 /**
@@ -9053,7 +9178,7 @@ int
 lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 		    struct lpfc_iocbq *piocb, uint32_t flag)
 {
-	struct lpfc_fcp_eq_hdl *fcp_eq_hdl;
+	struct lpfc_hba_eq_hdl *hba_eq_hdl;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_queue *fpeq;
 	struct lpfc_eqe *eqe;
@@ -9061,21 +9186,19 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 	int rc, idx;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		ring_number = lpfc_sli_calc_ring(phba, ring_number, piocb);
-		if (unlikely(ring_number == LPFC_HBA_ERROR))
+		pring = lpfc_sli4_calc_ring(phba, piocb);
+		if (unlikely(pring == NULL))
 			return IOCB_ERROR;
-		idx = piocb->fcp_wqidx;
 
-		pring = &phba->sli.ring[ring_number];
 		spin_lock_irqsave(&pring->ring_lock, iflags);
 		rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
 		if (lpfc_fcp_look_ahead && (piocb->iocb_flag &  LPFC_IO_FCP)) {
-			fcp_eq_hdl = &phba->sli4_hba.fcp_eq_hdl[idx];
+			idx = piocb->hba_wqidx;
+			hba_eq_hdl = &phba->sli4_hba.hba_eq_hdl[idx];
 
-			if (atomic_dec_and_test(&fcp_eq_hdl->
-				fcp_eq_in_use)) {
+			if (atomic_dec_and_test(&hba_eq_hdl->hba_eq_in_use)) {
 
 				/* Get associated EQ with this index */
 				fpeq = phba->sli4_hba.hba_eq[idx];
@@ -9096,7 +9219,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 				lpfc_sli4_eq_release(fpeq,
 					LPFC_QUEUE_REARM);
 			}
-			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 		}
 	} else {
 		/* For now, SLI2/3 will still use hbalock */
@@ -9116,7 +9239,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
  * only when driver needs to support target mode functionality
  * or IP over FC functionalities.
  *
- * This function is called with no lock held.
+ * This function is called with no lock held. SLI3 only.
  **/
 static int
 lpfc_extra_ring_setup( struct lpfc_hba *phba)
@@ -9129,14 +9252,14 @@ lpfc_extra_ring_setup( struct lpfc_hba *phba)
 	/* Adjust cmd/rsp ring iocb entries more evenly */
 
 	/* Take some away from the FCP ring */
-	pring = &psli->ring[psli->fcp_ring];
+	pring = &psli->sli3_ring[LPFC_FCP_RING];
 	pring->sli.sli3.numCiocb -= SLI2_IOCB_CMD_R1XTRA_ENTRIES;
 	pring->sli.sli3.numRiocb -= SLI2_IOCB_RSP_R1XTRA_ENTRIES;
 	pring->sli.sli3.numCiocb -= SLI2_IOCB_CMD_R3XTRA_ENTRIES;
 	pring->sli.sli3.numRiocb -= SLI2_IOCB_RSP_R3XTRA_ENTRIES;
 
 	/* and give them to the extra ring */
-	pring = &psli->ring[psli->extra_ring];
+	pring = &psli->sli3_ring[LPFC_EXTRA_RING];
 
 	pring->sli.sli3.numCiocb += SLI2_IOCB_CMD_R1XTRA_ENTRIES;
 	pring->sli.sli3.numRiocb += SLI2_IOCB_RSP_R1XTRA_ENTRIES;
@@ -9321,7 +9444,7 @@ lpfc_sli_async_event_handler(struct lpfc_hba * phba,
 
 
 /**
- * lpfc_sli_setup - SLI ring setup function
+ * lpfc_sli4_setup - SLI ring setup function
  * @phba: Pointer to HBA context object.
  *
  * lpfc_sli_setup sets up rings of the SLI interface with
@@ -9332,6 +9455,51 @@ lpfc_sli_async_event_handler(struct lpfc_hba * phba,
  * This function always returns 0.
  **/
 int
+lpfc_sli4_setup(struct lpfc_hba *phba)
+{
+	struct lpfc_sli_ring *pring;
+
+	pring = phba->sli4_hba.els_wq->pring;
+	pring->num_mask = LPFC_MAX_RING_MASK;
+	pring->prt[0].profile = 0;	/* Mask 0 */
+	pring->prt[0].rctl = FC_RCTL_ELS_REQ;
+	pring->prt[0].type = FC_TYPE_ELS;
+	pring->prt[0].lpfc_sli_rcv_unsol_event =
+	    lpfc_els_unsol_event;
+	pring->prt[1].profile = 0;	/* Mask 1 */
+	pring->prt[1].rctl = FC_RCTL_ELS_REP;
+	pring->prt[1].type = FC_TYPE_ELS;
+	pring->prt[1].lpfc_sli_rcv_unsol_event =
+	    lpfc_els_unsol_event;
+	pring->prt[2].profile = 0;	/* Mask 2 */
+	/* NameServer Inquiry */
+	pring->prt[2].rctl = FC_RCTL_DD_UNSOL_CTL;
+	/* NameServer */
+	pring->prt[2].type = FC_TYPE_CT;
+	pring->prt[2].lpfc_sli_rcv_unsol_event =
+	    lpfc_ct_unsol_event;
+	pring->prt[3].profile = 0;	/* Mask 3 */
+	/* NameServer response */
+	pring->prt[3].rctl = FC_RCTL_DD_SOL_CTL;
+	/* NameServer */
+	pring->prt[3].type = FC_TYPE_CT;
+	pring->prt[3].lpfc_sli_rcv_unsol_event =
+	    lpfc_ct_unsol_event;
+	return 0;
+}
+
+/**
+ * lpfc_sli_setup - SLI ring setup function
+ * @phba: Pointer to HBA context object.
+ *
+ * lpfc_sli_setup sets up rings of the SLI interface with
+ * number of iocbs per ring and iotags. This function is
+ * called while driver attach to the HBA and before the
+ * interrupts are enabled. So there is no need for locking.
+ *
+ * This function always returns 0. SLI3 only.
+ **/
+int
 lpfc_sli_setup(struct lpfc_hba *phba)
 {
 	int i, totiocbsize = 0;
@@ -9339,19 +9507,14 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 	struct lpfc_sli_ring *pring;
 
 	psli->num_rings = MAX_SLI3_CONFIGURED_RINGS;
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		psli->num_rings += phba->cfg_fcp_io_channel;
 	psli->sli_flag = 0;
-	psli->fcp_ring = LPFC_FCP_RING;
-	psli->next_ring = LPFC_FCP_NEXT_RING;
-	psli->extra_ring = LPFC_EXTRA_RING;
 
 	psli->iocbq_lookup = NULL;
 	psli->iocbq_lookup_len = 0;
 	psli->last_iotag = 0;
 
 	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
+		pring = &psli->sli3_ring[i];
 		switch (i) {
 		case LPFC_FCP_RING:	/* ring 0 - FCP */
 			/* numCiocb and numRiocb are used in config_port */
@@ -9450,18 +9613,18 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_queue_setup - Queue initialization function
+ * lpfc_sli4_queue_init - Queue initialization function
  * @phba: Pointer to HBA context object.
  *
- * lpfc_sli_queue_setup sets up mailbox queues and iocb queues for each
+ * lpfc_sli4_queue_init sets up mailbox queues and iocb queues for each
  * ring. This function also initializes ring indices of each ring.
  * This function is called during the initialization of the SLI
  * interface of an HBA.
  * This function is called with no lock held and always returns
  * 1.
  **/
-int
-lpfc_sli_queue_setup(struct lpfc_hba *phba)
+void
+lpfc_sli4_queue_init(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
@@ -9472,22 +9635,93 @@ lpfc_sli_queue_setup(struct lpfc_hba *phba)
 	INIT_LIST_HEAD(&psli->mboxq);
 	INIT_LIST_HEAD(&psli->mboxq_cmpl);
 	/* Initialize list headers for txq and txcmplq as double linked lists */
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
-		pring->ringno = i;
-		pring->sli.sli3.next_cmdidx  = 0;
-		pring->sli.sli3.local_getidx = 0;
-		pring->sli.sli3.cmdidx = 0;
+	for (i = 0; i < phba->cfg_fcp_io_channel; i++) {
+		pring = phba->sli4_hba.fcp_wq[i]->pring;
+		pring->flag = 0;
+		pring->ringno = LPFC_FCP_RING;
+		INIT_LIST_HEAD(&pring->txq);
+		INIT_LIST_HEAD(&pring->txcmplq);
+		INIT_LIST_HEAD(&pring->iocb_continueq);
+		spin_lock_init(&pring->ring_lock);
+	}
+	for (i = 0; i < phba->cfg_nvme_io_channel; i++) {
+		pring = phba->sli4_hba.nvme_wq[i]->pring;
+		pring->flag = 0;
+		pring->ringno = LPFC_FCP_RING;
+		INIT_LIST_HEAD(&pring->txq);
+		INIT_LIST_HEAD(&pring->txcmplq);
+		INIT_LIST_HEAD(&pring->iocb_continueq);
+		spin_lock_init(&pring->ring_lock);
+	}
+	pring = phba->sli4_hba.els_wq->pring;
+	pring->flag = 0;
+	pring->ringno = LPFC_ELS_RING;
+	INIT_LIST_HEAD(&pring->txq);
+	INIT_LIST_HEAD(&pring->txcmplq);
+	INIT_LIST_HEAD(&pring->iocb_continueq);
+	spin_lock_init(&pring->ring_lock);
+
+	if (phba->cfg_nvme_io_channel) {
+		pring = phba->sli4_hba.nvmels_wq->pring;
+		pring->flag = 0;
+		pring->ringno = LPFC_ELS_RING;
+		INIT_LIST_HEAD(&pring->txq);
+		INIT_LIST_HEAD(&pring->txcmplq);
+		INIT_LIST_HEAD(&pring->iocb_continueq);
+		spin_lock_init(&pring->ring_lock);
+	}
+
+	if (phba->cfg_fof) {
+		pring = phba->sli4_hba.oas_wq->pring;
 		pring->flag = 0;
+		pring->ringno = LPFC_FCP_RING;
 		INIT_LIST_HEAD(&pring->txq);
 		INIT_LIST_HEAD(&pring->txcmplq);
 		INIT_LIST_HEAD(&pring->iocb_continueq);
+		spin_lock_init(&pring->ring_lock);
+	}
+
+	spin_unlock_irq(&phba->hbalock);
+}
+
+/**
+ * lpfc_sli_queue_init - Queue initialization function
+ * @phba: Pointer to HBA context object.
+ *
+ * lpfc_sli_queue_init sets up mailbox queues and iocb queues for each
+ * ring. This function also initializes ring indices of each ring.
+ * This function is called during the initialization of the SLI
+ * interface of an HBA.
+ * This function is called with no lock held and always returns
+ * 1.
+ **/
+void
+lpfc_sli_queue_init(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli;
+	struct lpfc_sli_ring *pring;
+	int i;
+
+	psli = &phba->sli;
+	spin_lock_irq(&phba->hbalock);
+	INIT_LIST_HEAD(&psli->mboxq);
+	INIT_LIST_HEAD(&psli->mboxq_cmpl);
+	/* Initialize list headers for txq and txcmplq as double linked lists */
+	for (i = 0; i < psli->num_rings; i++) {
+		pring = &psli->sli3_ring[i];
+		pring->ringno = i;
+		pring->sli.sli3.next_cmdidx  = 0;
+		pring->sli.sli3.local_getidx = 0;
+		pring->sli.sli3.cmdidx = 0;
+		INIT_LIST_HEAD(&pring->iocb_continueq);
 		INIT_LIST_HEAD(&pring->iocb_continue_saveq);
 		INIT_LIST_HEAD(&pring->postbufq);
+		pring->flag = 0;
+		INIT_LIST_HEAD(&pring->txq);
+		INIT_LIST_HEAD(&pring->txcmplq);
 		spin_lock_init(&pring->ring_lock);
 	}
 	spin_unlock_irq(&phba->hbalock);
-	return 1;
 }
 
 /**
@@ -9559,6 +9793,7 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 	LIST_HEAD(completions);
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_queue *qp = NULL;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *iocb, *next_iocb;
 	int i;
@@ -9568,36 +9803,64 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 	lpfc_cleanup_discovery_resources(vport);
 
 	spin_lock_irqsave(&phba->hbalock, flags);
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
-		prev_pring_flag = pring->flag;
-		/* Only slow rings */
-		if (pring->ringno == LPFC_ELS_RING) {
-			pring->flag |= LPFC_DEFERRED_RING_EVENT;
-			/* Set the lpfc data pending flag */
-			set_bit(LPFC_DATA_READY, &phba->data_flags);
-		}
-		/*
-		 * Error everything on the txq since these iocbs have not been
-		 * given to the FW yet.
-		 */
-		list_for_each_entry_safe(iocb, next_iocb, &pring->txq, list) {
-			if (iocb->vport != vport)
-				continue;
-			list_move_tail(&iocb->list, &completions);
-		}
 
-		/* Next issue ABTS for everything on the txcmplq */
-		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq,
-									list) {
-			if (iocb->vport != vport)
+	/*
+	 * Error everything on the txq since these iocbs
+	 * have not been given to the FW yet.
+	 * Also issue ABTS for everything on the txcmplq
+	 */
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		for (i = 0; i < psli->num_rings; i++) {
+			pring = &psli->sli3_ring[i];
+			prev_pring_flag = pring->flag;
+			/* Only slow rings */
+			if (pring->ringno == LPFC_ELS_RING) {
+				pring->flag |= LPFC_DEFERRED_RING_EVENT;
+				/* Set the lpfc data pending flag */
+				set_bit(LPFC_DATA_READY, &phba->data_flags);
+			}
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txq, list) {
+				if (iocb->vport != vport)
+					continue;
+				list_move_tail(&iocb->list, &completions);
+			}
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txcmplq, list) {
+				if (iocb->vport != vport)
+					continue;
+				lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+			}
+			pring->flag = prev_pring_flag;
+		}
+	} else {
+		list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+			pring = qp->pring;
+			if (!pring)
 				continue;
-			lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+			if (pring == phba->sli4_hba.els_wq->pring) {
+				pring->flag |= LPFC_DEFERRED_RING_EVENT;
+				/* Set the lpfc data pending flag */
+				set_bit(LPFC_DATA_READY, &phba->data_flags);
+			}
+			prev_pring_flag = pring->flag;
+			spin_lock_irq(&pring->ring_lock);
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txq, list) {
+				if (iocb->vport != vport)
+					continue;
+				list_move_tail(&iocb->list, &completions);
+			}
+			spin_unlock_irq(&pring->ring_lock);
+			list_for_each_entry_safe(iocb, next_iocb,
+						 &pring->txcmplq, list) {
+				if (iocb->vport != vport)
+					continue;
+				lpfc_sli_issue_abort_iotag(phba, pring, iocb);
+			}
+			pring->flag = prev_pring_flag;
 		}
-
-		pring->flag = prev_pring_flag;
 	}
-
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	/* Cancel all the IOCBs from the completions list */
@@ -9626,6 +9889,7 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);
 	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_queue *qp = NULL;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_dmabuf *buf_ptr;
 	unsigned long flags = 0;
@@ -9639,20 +9903,36 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	lpfc_fabric_abort_hba(phba);
 
 	spin_lock_irqsave(&phba->hbalock, flags);
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
-		/* Only slow rings */
-		if (pring->ringno == LPFC_ELS_RING) {
-			pring->flag |= LPFC_DEFERRED_RING_EVENT;
-			/* Set the lpfc data pending flag */
-			set_bit(LPFC_DATA_READY, &phba->data_flags);
-		}
 
-		/*
-		 * Error everything on the txq since these iocbs have not been
-		 * given to the FW yet.
-		 */
-		list_splice_init(&pring->txq, &completions);
+	/*
+	 * Error everything on the txq since these iocbs
+	 * have not been given to the FW yet.
+	 */
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		for (i = 0; i < psli->num_rings; i++) {
+			pring = &psli->sli3_ring[i];
+			/* Only slow rings */
+			if (pring->ringno == LPFC_ELS_RING) {
+				pring->flag |= LPFC_DEFERRED_RING_EVENT;
+				/* Set the lpfc data pending flag */
+				set_bit(LPFC_DATA_READY, &phba->data_flags);
+			}
+			list_splice_init(&pring->txq, &completions);
+		}
+	} else {
+		list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+			pring = qp->pring;
+			if (!pring)
+				continue;
+			spin_lock_irq(&pring->ring_lock);
+			list_splice_init(&pring->txq, &completions);
+			spin_unlock_irq(&pring->ring_lock);
+			if (pring == phba->sli4_hba.els_wq->pring) {
+				pring->flag |= LPFC_DEFERRED_RING_EVENT;
+				/* Set the lpfc data pending flag */
+				set_bit(LPFC_DATA_READY, &phba->data_flags);
+			}
+		}
 	}
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
@@ -9979,7 +10259,6 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	struct lpfc_iocbq *abtsiocbp;
 	IOCB_t *icmd = NULL;
 	IOCB_t *iabt = NULL;
-	int ring_number;
 	int retval;
 	unsigned long iflags;
 
@@ -10019,7 +10298,7 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	iabt->ulpClass = icmd->ulpClass;
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-	abtsiocbp->fcp_wqidx = cmdiocb->fcp_wqidx;
+	abtsiocbp->hba_wqidx = cmdiocb->hba_wqidx;
 	if (cmdiocb->iocb_flag & LPFC_IO_FCP)
 		abtsiocbp->iocb_flag |= LPFC_USE_FCPWQIDX;
 	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
@@ -10041,11 +10320,9 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			 abtsiocbp->iotag);
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		ring_number =
-			lpfc_sli_calc_ring(phba, pring->ringno, abtsiocbp);
-		if (unlikely(ring_number == LPFC_HBA_ERROR))
+		pring = lpfc_sli4_calc_ring(phba, abtsiocbp);
+		if (unlikely(pring == NULL))
 			return 0;
-		pring = &phba->sli.ring[ring_number];
 		/* Note: both hbalock and ring_lock need to be set here */
 		spin_lock_irqsave(&pring->ring_lock, iflags);
 		retval = __lpfc_sli_issue_iocb(phba, pring->ringno,
@@ -10127,6 +10404,111 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 }
 
 /**
+ * lpfc_sli4_abort_nvme_io - Issue abort for a command iocb
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @cmdiocb: Pointer to driver command iocb object.
+ *
+ * This function issues an abort iocb for the provided command iocb down to
+ * the port. Other than the case the outstanding command iocb is an abort
+ * request, this function issues abort out unconditionally. This function is
+ * called with hbalock held. The function returns 0 when it fails due to
+ * memory allocation failure or when the command iocb is an abort request.
+ **/
+static int
+lpfc_sli4_abort_nvme_io(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			struct lpfc_iocbq *cmdiocb)
+{
+	struct lpfc_vport *vport = cmdiocb->vport;
+	struct lpfc_iocbq *abtsiocbp;
+	union lpfc_wqe *abts_wqe;
+	int retval;
+
+	/*
+	 * There are certain command types we don't want to abort.  And we
+	 * don't want to abort commands that are already in the process of
+	 * being aborted.
+	 */
+	if (cmdiocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
+	    cmdiocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN ||
+	    (cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED) != 0)
+		return 0;
+
+	/* issue ABTS for this io based on iotag */
+	abtsiocbp = __lpfc_sli_get_iocbq(phba);
+	if (abtsiocbp == NULL)
+		return 0;
+
+	/* This signals the response to set the correct status
+	 * before calling the completion handler
+	 */
+	cmdiocb->iocb_flag |= LPFC_DRIVER_ABORTED;
+
+	/* Complete prepping the abort wqe and issue to the FW. */
+	abts_wqe = &abtsiocbp->wqe;
+	bf_set(abort_cmd_ia, &abts_wqe->abort_cmd, 0);
+	bf_set(abort_cmd_criteria, &abts_wqe->abort_cmd, T_XRI_TAG);
+
+	/* Explicitly set reserved fields to zero.*/
+	abts_wqe->abort_cmd.rsrvd4 = 0;
+	abts_wqe->abort_cmd.rsrvd5 = 0;
+
+	/* WQE Common - word 6.  Context is XRI tag.  Set 0. */
+	bf_set(wqe_xri_tag, &abts_wqe->abort_cmd.wqe_com, 0);
+	bf_set(wqe_ctxt_tag, &abts_wqe->abort_cmd.wqe_com, 0);
+
+	/* word 7 */
+	bf_set(wqe_ct, &abts_wqe->abort_cmd.wqe_com, 0);
+	bf_set(wqe_cmnd, &abts_wqe->abort_cmd.wqe_com, CMD_ABORT_XRI_CX);
+	bf_set(wqe_class, &abts_wqe->abort_cmd.wqe_com,
+	       cmdiocb->iocb.ulpClass);
+
+	/* word 8 - tell the FW to abort the IO associated with this
+	 * outstanding exchange ID.
+	 */
+	abts_wqe->abort_cmd.wqe_com.abort_tag = cmdiocb->sli4_xritag;
+
+	/* word 9 - this is the iotag for the abts_wqe completion. */
+	bf_set(wqe_reqtag, &abts_wqe->abort_cmd.wqe_com,
+	       abtsiocbp->iotag);
+
+	/* word 10 */
+	bf_set(wqe_wqid, &abts_wqe->abort_cmd.wqe_com, cmdiocb->hba_wqidx);
+	bf_set(wqe_qosd, &abts_wqe->abort_cmd.wqe_com, 1);
+	bf_set(wqe_lenloc, &abts_wqe->abort_cmd.wqe_com, LPFC_WQE_LENLOC_NONE);
+
+	/* word 11 */
+	bf_set(wqe_cmd_type, &abts_wqe->abort_cmd.wqe_com, OTHER_COMMAND);
+	bf_set(wqe_wqec, &abts_wqe->abort_cmd.wqe_com, 1);
+	bf_set(wqe_cqid, &abts_wqe->abort_cmd.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+
+	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
+	abtsiocbp->iocb_flag |= LPFC_IO_NVME;
+	abtsiocbp->vport = vport;
+	/* todo: assign wqe_cmpl to lpfc_nvme_abort_fcreq_cmpl
+	 * subsequent patch will add routine. For now, just skip assignment
+	 * as won't ever be called.
+	 */
+	retval = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, abtsiocbp);
+	if (retval == IOCB_ERROR) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+				 "6147 Failed abts issue_wqe with status x%x "
+				 "for oxid x%x\n",
+				 retval, cmdiocb->sli4_xritag);
+		lpfc_sli_release_iocbq(phba, abtsiocbp);
+		return retval;
+	}
+
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+			 "6148 Drv Abort NVME Request Issued for "
+			 "ox_id x%x on reqtag x%x\n",
+			 cmdiocb->sli4_xritag,
+			 abtsiocbp->iotag);
+
+	return retval;
+}
+
+/**
  * lpfc_sli_hba_iocb_abort - Abort all iocbs to an hba.
  * @phba: pointer to lpfc HBA data structure.
  *
@@ -10137,10 +10519,20 @@ lpfc_sli_hba_iocb_abort(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
+	struct lpfc_queue *qp = NULL;
 	int i;
 
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		for (i = 0; i < psli->num_rings; i++) {
+			pring = &psli->sli3_ring[i];
+			lpfc_sli_abort_iocb_ring(phba, pring);
+		}
+		return;
+	}
+	list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+		pring = qp->pring;
+		if (!pring)
+			continue;
 		lpfc_sli_abort_iocb_ring(phba, pring);
 	}
 }
@@ -10344,7 +10736,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		abtsiocb->vport = vport;
 
 		/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-		abtsiocb->fcp_wqidx = iocbq->fcp_wqidx;
+		abtsiocb->hba_wqidx = iocbq->hba_wqidx;
 		if (iocbq->iocb_flag & LPFC_IO_FCP)
 			abtsiocb->iocb_flag |= LPFC_USE_FCPWQIDX;
 		if (iocbq->iocb_flag & LPFC_IO_FOF)
@@ -10404,7 +10796,6 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 	int sum, i, ret_val;
 	unsigned long iflags;
 	struct lpfc_sli_ring *pring_s4;
-	uint32_t ring_number;
 
 	spin_lock_irq(&phba->hbalock);
 
@@ -10447,7 +10838,7 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		abtsiocbq->vport = vport;
 
 		/* ABTS WQE must go to the same WQ as the WQE to be aborted */
-		abtsiocbq->fcp_wqidx = iocbq->fcp_wqidx;
+		abtsiocbq->hba_wqidx = iocbq->hba_wqidx;
 		if (iocbq->iocb_flag & LPFC_IO_FCP)
 			abtsiocbq->iocb_flag |= LPFC_USE_FCPWQIDX;
 		if (iocbq->iocb_flag & LPFC_IO_FOF)
@@ -10472,9 +10863,9 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		iocbq->iocb_flag |= LPFC_DRIVER_ABORTED;
 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
-			ring_number = MAX_SLI3_CONFIGURED_RINGS +
-					 iocbq->fcp_wqidx;
-			pring_s4 = &phba->sli.ring[ring_number];
+			pring_s4 = lpfc_sli4_calc_ring(phba, iocbq);
+			if (pring_s4 == NULL)
+				continue;
 			/* Note: both hbalock and ring_lock must be set here */
 			spin_lock_irqsave(&pring_s4->ring_lock, iflags);
 			ret_val = __lpfc_sli_issue_iocb(phba, pring_s4->ringno,
@@ -10636,10 +11027,14 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 	struct lpfc_iocbq *iocb;
 	int txq_cnt = 0;
 	int txcmplq_cnt = 0;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	unsigned long iflags;
 	bool iocb_completed = true;
 
+	if (phba->sli_rev >= LPFC_SLI_REV4)
+		pring = lpfc_sli4_calc_ring(phba, piocb);
+	else
+		pring = &phba->sli.sli3_ring[ring_number];
 	/*
 	 * If the caller has provided a response iocbq buffer, then context2
 	 * is NULL or its an error.
@@ -11434,6 +11829,7 @@ lpfc_sli_fp_intr_handler(int irq, void *dev_id)
 	uint32_t ha_copy;
 	unsigned long status;
 	unsigned long iflag;
+	struct lpfc_sli_ring *pring;
 
 	/* Get the driver's phba structure from the dev_id and
 	 * assume the HBA is not interrupting.
@@ -11478,10 +11874,9 @@ lpfc_sli_fp_intr_handler(int irq, void *dev_id)
 
 	status = (ha_copy & (HA_RXMASK << (4*LPFC_FCP_RING)));
 	status >>= (4*LPFC_FCP_RING);
+	pring = &phba->sli.sli3_ring[LPFC_FCP_RING];
 	if (status & HA_RXMASK)
-		lpfc_sli_handle_fast_ring_event(phba,
-						&phba->sli.ring[LPFC_FCP_RING],
-						status);
+		lpfc_sli_handle_fast_ring_event(phba, pring, status);
 
 	if (phba->cfg_multi_ring_support == 2) {
 		/*
@@ -11492,7 +11887,7 @@ lpfc_sli_fp_intr_handler(int irq, void *dev_id)
 		status >>= (4*LPFC_EXTRA_RING);
 		if (status & HA_RXMASK) {
 			lpfc_sli_handle_fast_ring_event(phba,
-					&phba->sli.ring[LPFC_EXTRA_RING],
+					&phba->sli.sli3_ring[LPFC_EXTRA_RING],
 					status);
 		}
 	}
@@ -11805,11 +12200,13 @@ static struct lpfc_iocbq *
 lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
 			       struct lpfc_iocbq *irspiocbq)
 {
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *cmdiocbq;
 	struct lpfc_wcqe_complete *wcqe;
 	unsigned long iflags;
 
+	pring = lpfc_phba_elsring(phba);
+
 	wcqe = &irspiocbq->cq_event.cqe.wcqe_cmpl;
 	spin_lock_irqsave(&pring->ring_lock, iflags);
 	pring->stats.iocb_event++;
@@ -12045,8 +12442,6 @@ lpfc_sli4_sp_handle_els_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			txq_cnt++;
 		if (!list_empty(&pring->txcmplq))
 			txcmplq_cnt++;
-		if (!list_empty(&phba->sli.ring[LPFC_FCP_RING].txcmplq))
-			fcp_txcmplq_cnt++;
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0387 NO IOCBQ data: txq_cnt=%d iocb_cnt=%d "
 			"fcp_txcmplq_cnt=%d, els_txcmplq_cnt=%d\n",
@@ -12165,6 +12560,7 @@ static bool
 lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 {
 	bool workposted = false;
+	struct fc_frame_header *fc_hdr;
 	struct lpfc_queue *hrq = phba->sli4_hba.hdr_rq;
 	struct lpfc_queue *drq = phba->sli4_hba.dat_rq;
 	struct hbq_dmabuf *dma_buf;
@@ -12199,6 +12595,10 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 		}
 		hrq->RQ_rcv_buf++;
 		memcpy(&dma_buf->cq_event.cqe.rcqe_cmpl, rcqe, sizeof(*rcqe));
+
+		/* If a NVME LS event (type 0x28), treat it as Fast path */
+		fc_hdr = (struct fc_frame_header *)dma_buf->hbuf.virt;
+
 		/* save off the frame for the word thread to process */
 		list_add_tail(&dma_buf->cq_event.list,
 			      &phba->sli4_hba.sp_queue_event);
@@ -12317,6 +12717,9 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 		return;
 	}
 
+	/* Save EQ associated with this CQ */
+	cq->assoc_qp = speq;
+
 	/* Process all the entries to the CQ */
 	switch (cq->type) {
 	case LPFC_MCQ:
@@ -12329,8 +12732,9 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 		break;
 	case LPFC_WCQ:
 		while ((cqe = lpfc_sli4_cq_get(cq))) {
-			if (cq->subtype == LPFC_FCP)
-				workposted |= lpfc_sli4_fp_handle_wcqe(phba, cq,
+			if ((cq->subtype == LPFC_FCP) ||
+			    (cq->subtype == LPFC_NVME))
+				workposted |= lpfc_sli4_fp_handle_cqe(phba, cq,
 								       cqe);
 			else
 				workposted |= lpfc_sli4_sp_handle_cqe(phba, cq,
@@ -12417,7 +12821,23 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
 		return;
 	}
-	if (unlikely(!cmdiocbq->iocb_cmpl)) {
+
+	if (cq->assoc_qp)
+		cmdiocbq->isr_timestamp =
+			cq->assoc_qp->isr_timestamp;
+
+	if (cmdiocbq->iocb_cmpl == NULL) {
+		if (cmdiocbq->wqe_cmpl) {
+			if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED) {
+				spin_lock_irqsave(&phba->hbalock, iflags);
+				cmdiocbq->iocb_flag &= ~LPFC_DRIVER_ABORTED;
+				spin_unlock_irqrestore(&phba->hbalock, iflags);
+			}
+
+			/* Pass the cmd_iocb and the wcqe to the upper layer */
+			(cmdiocbq->wqe_cmpl)(phba, cmdiocbq, wcqe);
+			return;
+		}
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0375 FCP cmdiocb not callback function "
 				"iotag: (%d)\n",
@@ -12453,12 +12873,12 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 {
 	struct lpfc_queue *childwq;
 	bool wqid_matched = false;
-	uint16_t fcp_wqid;
+	uint16_t hba_wqid;
 
 	/* Check for fast-path FCP work queue release */
-	fcp_wqid = bf_get(lpfc_wcqe_r_wq_id, wcqe);
+	hba_wqid = bf_get(lpfc_wcqe_r_wq_id, wcqe);
 	list_for_each_entry(childwq, &cq->child_list, list) {
-		if (childwq->queue_id == fcp_wqid) {
+		if (childwq->queue_id == hba_wqid) {
 			lpfc_sli4_wq_release(childwq,
 					bf_get(lpfc_wcqe_r_wqe_index, wcqe));
 			wqid_matched = true;
@@ -12469,11 +12889,11 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	if (wqid_matched != true)
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"2580 Fast-path wqe consume event carries "
-				"miss-matched qid: wcqe-qid=x%x\n", fcp_wqid);
+				"miss-matched qid: wcqe-qid=x%x\n", hba_wqid);
 }
 
 /**
- * lpfc_sli4_fp_handle_wcqe - Process fast-path work queue completion entry
+ * lpfc_sli4_fp_handle_cqe - Process fast-path work queue completion entry
  * @cq: Pointer to the completion queue.
  * @eqe: Pointer to fast-path completion queue entry.
  *
@@ -12481,7 +12901,7 @@ lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
  * event queue for FCP command response completion.
  **/
 static int
-lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
+lpfc_sli4_fp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			 struct lpfc_cqe *cqe)
 {
 	struct lpfc_wcqe_release wcqe;
@@ -12493,10 +12913,15 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	/* Check and process for different type of WCQE and dispatch */
 	switch (bf_get(lpfc_wcqe_c_code, &wcqe)) {
 	case CQE_CODE_COMPL_WQE:
+	case CQE_CODE_NVME_ERSP:
 		cq->CQ_wq++;
 		/* Process the WQ complete event */
 		phba->last_completion_time = jiffies;
-		lpfc_sli4_fp_handle_fcp_wcqe(phba, cq,
+		if ((cq->subtype == LPFC_FCP) || (cq->subtype == LPFC_NVME))
+			lpfc_sli4_fp_handle_fcp_wcqe(phba, cq,
+				(struct lpfc_wcqe_complete *)&wcqe);
+		if (cq->subtype == LPFC_NVME_LS)
+			lpfc_sli4_fp_handle_fcp_wcqe(phba, cq,
 				(struct lpfc_wcqe_complete *)&wcqe);
 		break;
 	case CQE_CODE_RELEASE_WQE:
@@ -12512,9 +12937,13 @@ lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		workposted = lpfc_sli4_sp_handle_abort_xri_wcqe(phba, cq,
 				(struct sli4_wcqe_xri_aborted *)&wcqe);
 		break;
+	case CQE_CODE_RECEIVE_V1:
+	case CQE_CODE_RECEIVE:
+		phba->last_completion_time = jiffies;
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0144 Not a valid WCQE code: x%x\n",
+				"0144 Not a valid CQE code: x%x\n",
 				bf_get(lpfc_wcqe_c_code, &wcqe));
 		break;
 	}
@@ -12537,7 +12966,7 @@ static void
 lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 			uint32_t qidx)
 {
-	struct lpfc_queue *cq;
+	struct lpfc_queue *cq = NULL;
 	struct lpfc_cqe *cqe;
 	bool workposted = false;
 	uint16_t cqid;
@@ -12555,28 +12984,33 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	/* Get the reference to the corresponding CQ */
 	cqid = bf_get_le32(lpfc_eqe_resource_id, eqe);
 
-	/* Check if this is a Slow path event */
-	if (unlikely(cqid != phba->sli4_hba.fcp_cq_map[qidx])) {
-		lpfc_sli4_sp_handle_eqe(phba, eqe,
-			phba->sli4_hba.hba_eq[qidx]);
-		return;
+	if (phba->sli4_hba.nvme_cq_map &&
+	    (cqid == phba->sli4_hba.nvme_cq_map[qidx])) {
+		/* Process NVME command completion */
+		cq = phba->sli4_hba.nvme_cq[qidx];
+		goto  process_cq;
 	}
 
-	if (unlikely(!phba->sli4_hba.fcp_cq)) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-				"3146 Fast-path completion queues "
-				"does not exist\n");
-		return;
+	if (phba->sli4_hba.fcp_cq_map &&
+	    (cqid == phba->sli4_hba.fcp_cq_map[qidx])) {
+		/* Process FCP command completion */
+		cq = phba->sli4_hba.fcp_cq[qidx];
+		goto  process_cq;
 	}
-	cq = phba->sli4_hba.fcp_cq[qidx];
-	if (unlikely(!cq)) {
-		if (phba->sli.sli_flag & LPFC_SLI_ACTIVE)
-			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-					"0367 Fast-path completion queue "
-					"(%d) does not exist\n", qidx);
+
+	if (phba->sli4_hba.nvmels_cq &&
+	    (cqid == phba->sli4_hba.nvmels_cq->queue_id)) {
+		/* Process NVME unsol rcv */
+		cq = phba->sli4_hba.nvmels_cq;
+	}
+
+	/* Otherwise this is a Slow path event */
+	if (cq == NULL) {
+		lpfc_sli4_sp_handle_eqe(phba, eqe, phba->sli4_hba.hba_eq[qidx]);
 		return;
 	}
 
+process_cq:
 	if (unlikely(cqid != cq->queue_id)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0368 Miss-matched fast-path completion "
@@ -12585,9 +13019,12 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 		return;
 	}
 
+	/* Save EQ associated with this CQ */
+	cq->assoc_qp = phba->sli4_hba.hba_eq[qidx];
+
 	/* Process all the entries to the CQ */
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
-		workposted |= lpfc_sli4_fp_handle_wcqe(phba, cq, cqe);
+		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
 		if (!(++ecount % cq->entry_repost))
 			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 	}
@@ -12678,7 +13115,7 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
 
 	/* Process all the entries to the OAS CQ */
 	while ((cqe = lpfc_sli4_cq_get(cq))) {
-		workposted |= lpfc_sli4_fp_handle_wcqe(phba, cq, cqe);
+		workposted |= lpfc_sli4_fp_handle_cqe(phba, cq, cqe);
 		if (!(++ecount % cq->entry_repost))
 			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
 	}
@@ -12726,15 +13163,15 @@ irqreturn_t
 lpfc_sli4_fof_intr_handler(int irq, void *dev_id)
 {
 	struct lpfc_hba *phba;
-	struct lpfc_fcp_eq_hdl *fcp_eq_hdl;
+	struct lpfc_hba_eq_hdl *hba_eq_hdl;
 	struct lpfc_queue *eq;
 	struct lpfc_eqe *eqe;
 	unsigned long iflag;
 	int ecount = 0;
 
 	/* Get the driver's phba structure from the dev_id */
-	fcp_eq_hdl = (struct lpfc_fcp_eq_hdl *)dev_id;
-	phba = fcp_eq_hdl->phba;
+	hba_eq_hdl = (struct lpfc_hba_eq_hdl *)dev_id;
+	phba = hba_eq_hdl->phba;
 
 	if (unlikely(!phba))
 		return IRQ_NONE;
@@ -12820,17 +13257,17 @@ irqreturn_t
 lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 {
 	struct lpfc_hba *phba;
-	struct lpfc_fcp_eq_hdl *fcp_eq_hdl;
+	struct lpfc_hba_eq_hdl *hba_eq_hdl;
 	struct lpfc_queue *fpeq;
 	struct lpfc_eqe *eqe;
 	unsigned long iflag;
 	int ecount = 0;
-	int fcp_eqidx;
+	int hba_eqidx;
 
 	/* Get the driver's phba structure from the dev_id */
-	fcp_eq_hdl = (struct lpfc_fcp_eq_hdl *)dev_id;
-	phba = fcp_eq_hdl->phba;
-	fcp_eqidx = fcp_eq_hdl->idx;
+	hba_eq_hdl = (struct lpfc_hba_eq_hdl *)dev_id;
+	phba = hba_eq_hdl->phba;
+	hba_eqidx = hba_eq_hdl->idx;
 
 	if (unlikely(!phba))
 		return IRQ_NONE;
@@ -12838,15 +13275,15 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	/* Get to the EQ struct associated with this vector */
-	fpeq = phba->sli4_hba.hba_eq[fcp_eqidx];
+	fpeq = phba->sli4_hba.hba_eq[hba_eqidx];
 	if (unlikely(!fpeq))
 		return IRQ_NONE;
 
 	if (lpfc_fcp_look_ahead) {
-		if (atomic_dec_and_test(&fcp_eq_hdl->fcp_eq_in_use))
+		if (atomic_dec_and_test(&hba_eq_hdl->hba_eq_in_use))
 			lpfc_sli4_eq_clr_intr(fpeq);
 		else {
-			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 			return IRQ_NONE;
 		}
 	}
@@ -12861,7 +13298,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 			lpfc_sli4_eq_flush(phba, fpeq);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		if (lpfc_fcp_look_ahead)
-			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 		return IRQ_NONE;
 	}
 
@@ -12872,7 +13309,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		if (eqe == NULL)
 			break;
 
-		lpfc_sli4_hba_handle_eqe(phba, eqe, fcp_eqidx);
+		lpfc_sli4_hba_handle_eqe(phba, eqe, hba_eqidx);
 		if (!(++ecount % fpeq->entry_repost))
 			lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_NOARM);
 		fpeq->EQ_processed++;
@@ -12889,7 +13326,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		fpeq->EQ_no_entry++;
 
 		if (lpfc_fcp_look_ahead) {
-			atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+			atomic_inc(&hba_eq_hdl->hba_eq_in_use);
 			return IRQ_NONE;
 		}
 
@@ -12903,7 +13340,8 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	}
 
 	if (lpfc_fcp_look_ahead)
-		atomic_inc(&fcp_eq_hdl->fcp_eq_in_use);
+		atomic_inc(&hba_eq_hdl->hba_eq_in_use);
+
 	return IRQ_HANDLED;
 } /* lpfc_sli4_fp_intr_handler */
 
@@ -12930,7 +13368,7 @@ lpfc_sli4_intr_handler(int irq, void *dev_id)
 	struct lpfc_hba  *phba;
 	irqreturn_t hba_irq_rc;
 	bool hba_handled = false;
-	int fcp_eqidx;
+	int qidx;
 
 	/* Get the driver's phba structure from the dev_id */
 	phba = (struct lpfc_hba *)dev_id;
@@ -12941,16 +13379,16 @@ lpfc_sli4_intr_handler(int irq, void *dev_id)
 	/*
 	 * Invoke fast-path host attention interrupt handling as appropriate.
 	 */
-	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_io_channel; fcp_eqidx++) {
+	for (qidx = 0; qidx < phba->io_channel_irqs; qidx++) {
 		hba_irq_rc = lpfc_sli4_hba_intr_handler(irq,
-					&phba->sli4_hba.fcp_eq_hdl[fcp_eqidx]);
+					&phba->sli4_hba.hba_eq_hdl[qidx]);
 		if (hba_irq_rc == IRQ_HANDLED)
 			hba_handled |= true;
 	}
 
 	if (phba->cfg_fof) {
 		hba_irq_rc = lpfc_sli4_fof_intr_handler(irq,
-					&phba->sli4_hba.fcp_eq_hdl[0]);
+					&phba->sli4_hba.hba_eq_hdl[qidx]);
 		if (hba_irq_rc == IRQ_HANDLED)
 			hba_handled |= true;
 	}
@@ -12981,6 +13419,11 @@ lpfc_sli4_queue_free(struct lpfc_queue *queue)
 				  dmabuf->virt, dmabuf->phys);
 		kfree(dmabuf);
 	}
+	if (queue->rqbp) {
+		lpfc_free_rq_buffer(queue->phba, queue);
+		kfree(queue->rqbp);
+	}
+	kfree(queue->pring);
 	kfree(queue);
 	return;
 }
@@ -13014,7 +13457,13 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t entry_size,
 		return NULL;
 	queue->page_count = (ALIGN(entry_size * entry_count,
 			hw_page_size))/hw_page_size;
+
+	/* If needed, Adjust page count to match the max the adapter supports */
+	if (queue->page_count > phba->sli4_hba.pc_sli4_params.wqpcnt)
+		queue->page_count = phba->sli4_hba.pc_sli4_params.wqpcnt;
+
 	INIT_LIST_HEAD(&queue->list);
+	INIT_LIST_HEAD(&queue->wq_list);
 	INIT_LIST_HEAD(&queue->page_list);
 	INIT_LIST_HEAD(&queue->child_list);
 	for (x = 0, total_qe_count = 0; x < queue->page_count; x++) {
@@ -13086,7 +13535,7 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
 }
 
 /**
- * lpfc_modify_fcp_eq_delay - Modify Delay Multiplier on FCP EQs
+ * lpfc_modify_hba_eq_delay - Modify Delay Multiplier on FCP EQs
  * @phba: HBA structure that indicates port to create a queue on.
  * @startq: The starting FCP EQ to modify
  *
@@ -13102,7 +13551,7 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
  * fails this function will return -ENXIO.
  **/
 int
-lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint32_t startq)
+lpfc_modify_hba_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 {
 	struct lpfc_mbx_modify_eq_delay *eq_delay;
 	LPFC_MBOXQ_t *mbox;
@@ -13110,11 +13559,11 @@ lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 	int cnt, rc, length, status = 0;
 	uint32_t shdr_status, shdr_add_status;
 	uint32_t result;
-	int fcp_eqidx;
+	int qidx;
 	union lpfc_sli4_cfg_shdr *shdr;
 	uint16_t dmult;
 
-	if (startq >= phba->cfg_fcp_io_channel)
+	if (startq >= phba->io_channel_irqs)
 		return 0;
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -13128,16 +13577,15 @@ lpfc_modify_fcp_eq_delay(struct lpfc_hba *phba, uint32_t startq)
 	eq_delay = &mbox->u.mqe.un.eq_delay;
 
 	/* Calculate delay multiper from maximum interrupt per second */
-	result = phba->cfg_fcp_imax / phba->cfg_fcp_io_channel;
-	if (result > LPFC_DMULT_CONST)
+	result = phba->cfg_fcp_imax / phba->io_channel_irqs;
+	if (result > LPFC_DMULT_CONST || result == 0)
 		dmult = 0;
 	else
 		dmult = LPFC_DMULT_CONST/result - 1;
 
 	cnt = 0;
-	for (fcp_eqidx = startq; fcp_eqidx < phba->cfg_fcp_io_channel;
-	    fcp_eqidx++) {
-		eq = phba->sli4_hba.hba_eq[fcp_eqidx];
+	for (qidx = startq; qidx < phba->io_channel_irqs; qidx++) {
+		eq = phba->sli4_hba.hba_eq[qidx];
 		if (!eq)
 			continue;
 		eq_delay->u.request.eq[cnt].eq_id = eq->queue_id;
@@ -13352,8 +13800,10 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	switch (cq->entry_count) {
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0361 Unsupported CQ count. (%d)\n",
-				cq->entry_count);
+				"0361 Unsupported CQ count: "
+				"entry cnt %d sz %d pg cnt %d repost %d\n",
+				cq->entry_count, cq->entry_size,
+				cq->page_count, cq->entry_repost);
 		if (cq->entry_count < 256) {
 			status = -EINVAL;
 			goto out;
@@ -13668,7 +14118,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 		return -ENODEV;
 	if (!phba->sli4_hba.pc_sli4_params.supported)
 		hw_page_size = SLI4_PAGE_SIZE;
-
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -13819,6 +14268,11 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 		wq->db_format = LPFC_DB_LIST_FORMAT;
 		wq->db_regaddr = phba->sli4_hba.WQDBregaddr;
 	}
+	wq->pring = kzalloc(sizeof(struct lpfc_sli_ring), GFP_KERNEL);
+	if (wq->pring == NULL) {
+		status = -ENOMEM;
+		goto out;
+	}
 	wq->type = LPFC_WQ;
 	wq->assoc_qid = cq->queue_id;
 	wq->subtype = subtype;
@@ -13975,6 +14429,7 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 					putPaddrLow(dmabuf->phys);
 		rq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
 					putPaddrHigh(dmabuf->phys);
+
 	}
 	if (phba->sli4_hba.fw_func_mode & LPFC_DUA_MODE)
 		bf_set(lpfc_mbx_rq_create_dua, &rq_create->u.request, 1);
@@ -14603,7 +15058,7 @@ lpfc_sli4_next_xritag(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli4_post_els_sgl_list - post a block of ELS sgls to the port.
+ * lpfc_sli4_post_sgl_list - post a block of ELS sgls to the port.
  * @phba: pointer to lpfc hba data structure.
  * @post_sgl_list: pointer to els sgl entry list.
  * @count: number of els sgl entries on the list.
@@ -14614,7 +15069,7 @@ lpfc_sli4_next_xritag(struct lpfc_hba *phba)
  * stopped.
  **/
 static int
-lpfc_sli4_post_els_sgl_list(struct lpfc_hba *phba,
+lpfc_sli4_post_sgl_list(struct lpfc_hba *phba,
 			    struct list_head *post_sgl_list,
 			    int post_cnt)
 {
@@ -14630,14 +15085,15 @@ lpfc_sli4_post_els_sgl_list(struct lpfc_hba *phba,
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 
-	reqlen = phba->sli4_hba.els_xri_cnt * sizeof(struct sgl_page_pairs) +
+	reqlen = post_cnt * sizeof(struct sgl_page_pairs) +
 		 sizeof(union lpfc_sli4_cfg_shdr) + sizeof(uint32_t);
 	if (reqlen > SLI4_PAGE_SIZE) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2559 Block sgl registration required DMA "
 				"size (%d) great than a page\n", reqlen);
 		return -ENOMEM;
 	}
+
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
 		return -ENOMEM;
@@ -14681,8 +15137,9 @@ lpfc_sli4_post_els_sgl_list(struct lpfc_hba *phba,
 
 	/* Complete initialization and perform endian conversion. */
 	bf_set(lpfc_post_sgl_pages_xri, sgl, xritag_start);
-	bf_set(lpfc_post_sgl_pages_xricnt, sgl, phba->sli4_hba.els_xri_cnt);
+	bf_set(lpfc_post_sgl_pages_xricnt, sgl, post_cnt);
 	sgl->word0 = cpu_to_le32(sgl->word0);
+
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
@@ -14817,6 +15274,9 @@ lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *phba,
 	return rc;
 }
 
+char *lpfc_rctl_names[] = FC_RCTL_NAMES_INIT;
+char *lpfc_type_names[] = FC_TYPE_NAMES_INIT;
+
 /**
  * lpfc_fc_frame_check - Check that this frame is a valid frame to handle
  * @phba: pointer to lpfc_hba struct that the frame was received on
@@ -14827,12 +15287,10 @@ lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *phba,
  * return a zero if the frame is a valid frame or a non zero value when the
  * frame does not pass the check.
  **/
-static int
+int
 lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 {
 	/*  make rctl_names static to save stack space */
-	static char *rctl_names[] = FC_RCTL_NAMES_INIT;
-	char *type_names[] = FC_TYPE_NAMES_INIT;
 	struct fc_vft_header *fc_vft_hdr;
 	uint32_t *header = (uint32_t *) fc_hdr;
 
@@ -14877,18 +15335,18 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 	case FC_TYPE_ELS:
 	case FC_TYPE_FCP:
 	case FC_TYPE_CT:
+	case FC_TYPE_NVME:
 		break;
 	case FC_TYPE_IP:
 	case FC_TYPE_ILS:
 	default:
 		goto drop;
 	}
-
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"2538 Received frame rctl:%s (x%x), type:%s (x%x), "
 			"frame Data:%08x %08x %08x %08x %08x %08x %08x\n",
-			rctl_names[fc_hdr->fh_r_ctl], fc_hdr->fh_r_ctl,
-			type_names[fc_hdr->fh_type], fc_hdr->fh_type,
+			lpfc_rctl_names[fc_hdr->fh_r_ctl], fc_hdr->fh_r_ctl,
+			lpfc_type_names[fc_hdr->fh_type], fc_hdr->fh_type,
 			be32_to_cpu(header[0]), be32_to_cpu(header[1]),
 			be32_to_cpu(header[2]), be32_to_cpu(header[3]),
 			be32_to_cpu(header[4]), be32_to_cpu(header[5]),
@@ -14897,8 +15355,8 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 drop:
 	lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
 			"2539 Dropped frame rctl:%s type:%s\n",
-			rctl_names[fc_hdr->fh_r_ctl],
-			type_names[fc_hdr->fh_type]);
+			lpfc_rctl_names[fc_hdr->fh_r_ctl],
+			lpfc_type_names[fc_hdr->fh_type]);
 	return 1;
 }
 
@@ -14932,16 +15390,13 @@ lpfc_fc_hdr_get_vfi(struct fc_frame_header *fc_hdr)
  * returns the matching vport pointer or NULL if unable to match frame to a
  * vport.
  **/
-static struct lpfc_vport *
+struct lpfc_vport *
 lpfc_fc_frame_to_vport(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr,
-		       uint16_t fcfi)
+		       uint16_t fcfi, uint32_t did)
 {
 	struct lpfc_vport **vports;
 	struct lpfc_vport *vport = NULL;
 	int i;
-	uint32_t did = (fc_hdr->fh_d_id[0] << 16 |
-			fc_hdr->fh_d_id[1] << 8 |
-			fc_hdr->fh_d_id[2]);
 
 	if (did == Fabric_DID)
 		return phba->pport;
@@ -14950,7 +15405,7 @@ lpfc_fc_frame_to_vport(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr,
 		return phba->pport;
 
 	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL)
+	if (vports != NULL) {
 		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
 			if (phba->fcf.fcfi == fcfi &&
 			    vports[i]->vfi == lpfc_fc_hdr_get_vfi(fc_hdr) &&
@@ -14959,6 +15414,7 @@ lpfc_fc_frame_to_vport(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr,
 				break;
 			}
 		}
+	}
 	lpfc_destroy_vport_work_array(phba, vports);
 	return vport;
 }
@@ -15388,7 +15844,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 	 * a BA_RJT.
 	 */
 	if ((fctl & FC_FC_EX_CTX) &&
-	    (lxri > lpfc_sli4_get_els_iocb_cnt(phba))) {
+	    (lxri > lpfc_sli4_get_iocb_cnt(phba))) {
 		icmd->un.xseq64.w5.hcsw.Rctl = FC_RCTL_BA_RJT;
 		bf_set(lpfc_vndr_code, &icmd->un.bls_rsp, 0);
 		bf_set(lpfc_rsn_expln, &icmd->un.bls_rsp, FC_BA_RJT_INV_XID);
@@ -15565,6 +16021,7 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 		/* Initialize the first IOCB. */
 		first_iocbq->iocb.unsli3.rcvsli3.acc_len = 0;
 		first_iocbq->iocb.ulpStatus = IOSTAT_SUCCESS;
+		first_iocbq->vport = vport;
 
 		/* Check FC Header to see what TYPE of frame we are rcv'ing */
 		if (sli4_type_from_fc_hdr(fc_hdr) == FC_TYPE_ELS) {
@@ -15677,7 +16134,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
 		return;
 	}
 	if (!lpfc_complete_unsol_iocb(phba,
-				      &phba->sli.ring[LPFC_ELS_RING],
+				      phba->sli4_hba.els_wq->pring,
 				      iocbq, fc_hdr->fh_r_ctl,
 				      fc_hdr->fh_type))
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -15702,8 +16159,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
  * This function is called with no lock held. This function processes all
  * the received buffers and gives it to upper layers when a received buffer
  * indicates that it is the final frame in the sequence. The interrupt
- * service routine processes received buffers at interrupt contexts and adds
- * received dma buffers to the rb_pend_list queue and signals the worker thread.
+ * service routine processes received buffers at interrupt contexts.
  * Worker thread calls lpfc_sli4_handle_received_buffer, which will call the
  * appropriate receive function when the final frame in a sequence is received.
  **/
@@ -15719,11 +16175,13 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 
 	/* Process each received buffer */
 	fc_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
+
 	/* check to see if this a valid type of frame */
 	if (lpfc_fc_frame_check(phba, fc_hdr)) {
 		lpfc_in_buf_free(phba, &dmabuf->dbuf);
 		return;
 	}
+
 	if ((bf_get(lpfc_cqe_code,
 		    &dmabuf->cq_event.cqe.rcqe_cmpl) == CQE_CODE_RECEIVE_V1))
 		fcfi = bf_get(lpfc_rcqe_fcf_id_v1,
@@ -15732,16 +16190,16 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 		fcfi = bf_get(lpfc_rcqe_fcf_id,
 			      &dmabuf->cq_event.cqe.rcqe_cmpl);
 
-	vport = lpfc_fc_frame_to_vport(phba, fc_hdr, fcfi);
+	/* d_id this frame is directed to */
+	did = sli4_did_from_fc_hdr(fc_hdr);
+
+	vport = lpfc_fc_frame_to_vport(phba, fc_hdr, fcfi, did);
 	if (!vport) {
 		/* throw out the frame */
 		lpfc_in_buf_free(phba, &dmabuf->dbuf);
 		return;
 	}
 
-	/* d_id this frame is directed to */
-	did = sli4_did_from_fc_hdr(fc_hdr);
-
 	/* vport is registered unless we rcv a FLOGI directed to Fabric_DID */
 	if (!(vport->vpi_state & LPFC_VPI_REGISTERED) &&
 		(did != Fabric_DID)) {
@@ -17219,7 +17677,7 @@ uint32_t
 lpfc_drain_txq(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *piocbq = NULL;
 	unsigned long iflags = 0;
 	char *fail_msg = NULL;
@@ -17228,6 +17686,8 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 	union lpfc_wqe *wqe = (union lpfc_wqe *) &wqe128;
 	uint32_t txq_cnt = 0;
 
+	pring = lpfc_phba_elsring(phba);
+
 	spin_lock_irqsave(&pring->ring_lock, iflags);
 	list_for_each_entry(piocbq, &pring->txq, list) {
 		txq_cnt++;
@@ -17249,7 +17709,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 				txq_cnt);
 			break;
 		}
-		sglq = __lpfc_sli_get_sglq(phba, piocbq);
+		sglq = __lpfc_sli_get_els_sglq(phba, piocbq);
 		if (!sglq) {
 			__lpfc_sli_ringtx_put(phba, pring, piocbq);
 			spin_unlock_irqrestore(&pring->ring_lock, iflags);
@@ -17289,3 +17749,191 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 
 	return txq_cnt;
 }
+
+/**
+ * lpfc_wqe_bpl2sgl - Convert the bpl/bde to a sgl.
+ * @phba: Pointer to HBA context object.
+ * @pwqe: Pointer to command WQE.
+ * @sglq: Pointer to the scatter gather queue object.
+ *
+ * This routine converts the bpl or bde that is in the WQE
+ * to a sgl list for the sli4 hardware. The physical address
+ * of the bpl/bde is converted back to a virtual address.
+ * If the WQE contains a BPL then the list of BDE's is
+ * converted to sli4_sge's. If the WQE contains a single
+ * BDE then it is converted to a single sli_sge.
+ * The WQE is still in cpu endianness so the contents of
+ * the bpl can be used without byte swapping.
+ *
+ * Returns valid XRI = Success, NO_XRI = Failure.
+ */
+static uint16_t
+lpfc_wqe_bpl2sgl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeq,
+		 struct lpfc_sglq *sglq)
+{
+	uint16_t xritag = NO_XRI;
+	struct ulp_bde64 *bpl = NULL;
+	struct ulp_bde64 bde;
+	struct sli4_sge *sgl  = NULL;
+	struct lpfc_dmabuf *dmabuf;
+	union lpfc_wqe *wqe;
+	int numBdes = 0;
+	int i = 0;
+	uint32_t offset = 0; /* accumulated offset in the sg request list */
+	int inbound = 0; /* number of sg reply entries inbound from firmware */
+	uint32_t cmd;
+
+	if (!pwqeq || !sglq)
+		return xritag;
+
+	sgl  = (struct sli4_sge *)sglq->sgl;
+	wqe = &pwqeq->wqe;
+	pwqeq->iocb.ulpIoTag = pwqeq->iotag;
+
+	cmd = bf_get(wqe_cmnd, &wqe->generic.wqe_com);
+	if (cmd == CMD_XMIT_BLS_RSP64_WQE)
+		return sglq->sli4_xritag;
+	numBdes = pwqeq->rsvd2;
+	if (numBdes) {
+		/* The addrHigh and addrLow fields within the WQE
+		 * have not been byteswapped yet so there is no
+		 * need to swap them back.
+		 */
+		if (pwqeq->context3)
+			dmabuf = (struct lpfc_dmabuf *)pwqeq->context3;
+		else
+			return xritag;
+
+		bpl  = (struct ulp_bde64 *)dmabuf->virt;
+		if (!bpl)
+			return xritag;
+
+		for (i = 0; i < numBdes; i++) {
+			/* Should already be byte swapped. */
+			sgl->addr_hi = bpl->addrHigh;
+			sgl->addr_lo = bpl->addrLow;
+
+			sgl->word2 = le32_to_cpu(sgl->word2);
+			if ((i+1) == numBdes)
+				bf_set(lpfc_sli4_sge_last, sgl, 1);
+			else
+				bf_set(lpfc_sli4_sge_last, sgl, 0);
+			/* swap the size field back to the cpu so we
+			 * can assign it to the sgl.
+			 */
+			bde.tus.w = le32_to_cpu(bpl->tus.w);
+			sgl->sge_len = cpu_to_le32(bde.tus.f.bdeSize);
+			/* The offsets in the sgl need to be accumulated
+			 * separately for the request and reply lists.
+			 * The request is always first, the reply follows.
+			 */
+			switch (cmd) {
+			case CMD_GEN_REQUEST64_WQE:
+				/* add up the reply sg entries */
+				if (bpl->tus.f.bdeFlags == BUFF_TYPE_BDE_64I)
+					inbound++;
+				/* first inbound? reset the offset */
+				if (inbound == 1)
+					offset = 0;
+				bf_set(lpfc_sli4_sge_offset, sgl, offset);
+				bf_set(lpfc_sli4_sge_type, sgl,
+					LPFC_SGE_TYPE_DATA);
+				offset += bde.tus.f.bdeSize;
+				break;
+			case CMD_FCP_TRSP64_WQE:
+				bf_set(lpfc_sli4_sge_offset, sgl, 0);
+				bf_set(lpfc_sli4_sge_type, sgl,
+					LPFC_SGE_TYPE_DATA);
+				break;
+			case CMD_FCP_TSEND64_WQE:
+			case CMD_FCP_TRECEIVE64_WQE:
+				bf_set(lpfc_sli4_sge_type, sgl,
+					bpl->tus.f.bdeFlags);
+				if (i < 3)
+					offset = 0;
+				else
+					offset += bde.tus.f.bdeSize;
+				bf_set(lpfc_sli4_sge_offset, sgl, offset);
+				break;
+			}
+			sgl->word2 = cpu_to_le32(sgl->word2);
+			bpl++;
+			sgl++;
+		}
+	} else if (wqe->gen_req.bde.tus.f.bdeFlags == BUFF_TYPE_BDE_64) {
+		/* The addrHigh and addrLow fields of the BDE have not
+		 * been byteswapped yet so they need to be swapped
+		 * before putting them in the sgl.
+		 */
+		sgl->addr_hi = cpu_to_le32(wqe->gen_req.bde.addrHigh);
+		sgl->addr_lo = cpu_to_le32(wqe->gen_req.bde.addrLow);
+		sgl->word2 = le32_to_cpu(sgl->word2);
+		bf_set(lpfc_sli4_sge_last, sgl, 1);
+		sgl->word2 = cpu_to_le32(sgl->word2);
+		sgl->sge_len = cpu_to_le32(wqe->gen_req.bde.tus.f.bdeSize);
+	}
+	return sglq->sli4_xritag;
+}
+
+/**
+ * lpfc_sli4_issue_wqe - Issue an SLI4 Work Queue Entry (WQE)
+ * @phba: Pointer to HBA context object.
+ * @ring_number: Base sli ring number
+ * @pwqe: Pointer to command WQE.
+ **/
+int
+lpfc_sli4_issue_wqe(struct lpfc_hba *phba, uint32_t ring_number,
+		    struct lpfc_iocbq *pwqe)
+{
+	union lpfc_wqe *wqe = &pwqe->wqe;
+	struct lpfc_queue *wq;
+	struct lpfc_sglq *sglq;
+	struct lpfc_sli_ring *pring;
+	unsigned long iflags;
+
+	/* NVME_LS and NVME_LS ABTS requests. */
+	if (pwqe->iocb_flag & LPFC_IO_NVME_LS) {
+		pring =  phba->sli4_hba.nvmels_wq->pring;
+		spin_lock_irqsave(&pring->ring_lock, iflags);
+		sglq = __lpfc_sli_get_els_sglq(phba, pwqe);
+		if (!sglq) {
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
+			return WQE_BUSY;
+		}
+		pwqe->sli4_lxritag = sglq->sli4_lxritag;
+		pwqe->sli4_xritag = sglq->sli4_xritag;
+		if (lpfc_wqe_bpl2sgl(phba, pwqe, sglq) == NO_XRI) {
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
+			return WQE_ERROR;
+		}
+		bf_set(wqe_xri_tag, &pwqe->wqe.xmit_bls_rsp.wqe_com,
+		       pwqe->sli4_xritag);
+		if (lpfc_sli4_wq_put(phba->sli4_hba.nvmels_wq, wqe)) {
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
+			return WQE_ERROR;
+		}
+		lpfc_sli_ringtxcmpl_put(phba, pring, pwqe);
+		spin_unlock_irqrestore(&pring->ring_lock, iflags);
+		return 0;
+	}
+
+	/* NVME_FCREQ and NVME_ABTS requests */
+	if (pwqe->iocb_flag & LPFC_IO_NVME) {
+		/* Get the IO distribution (hba_wqidx) for WQ assignment. */
+		pring = phba->sli4_hba.nvme_wq[pwqe->hba_wqidx]->pring;
+
+		spin_lock_irqsave(&pring->ring_lock, iflags);
+		wq = phba->sli4_hba.nvme_wq[pwqe->hba_wqidx];
+		bf_set(wqe_cqid, &wqe->generic.wqe_com,
+		      phba->sli4_hba.nvme_cq[pwqe->hba_wqidx]->queue_id);
+		if (lpfc_sli4_wq_put(wq, wqe)) {
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
+			return WQE_ERROR;
+		}
+		lpfc_sli_ringtxcmpl_put(phba, pring, pwqe);
+		spin_unlock_irqrestore(&pring->ring_lock, iflags);
+		return 0;
+	}
+
+	return WQE_ERROR;
+}
-- 
2.5.0
