From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH RESEND] lpfc: Add lockdep assertions
Date: Wed, 20 Jan 2016 16:22:22 +0100
Message-ID: <1453303342-11140-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933709AbcATPW2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 10:22:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>

Several functions in lpfc have comments stating that the function must be
called with the hbalock (or hostlock, or ringlock) held. Add
lockdep_assert_held() annotations to these functions, so one can actually
verify the locks are held.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |  5 +++++
 drivers/scsi/lpfc/lpfc_sli.c     | 43 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index c37d72e..25b5dcd 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
+#include <linux/lockdep.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -1314,6 +1315,8 @@ __lpfc_update_fcf_record_pri(struct lpfc_hba *phba, uint16_t fcf_index,
 {
 	struct lpfc_fcf_pri *fcf_pri;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	fcf_pri = &phba->fcf.fcf_pri[fcf_index];
 	fcf_pri->fcf_rec.fcf_index = fcf_index;
 	/* FCF record priority */
@@ -1398,6 +1401,8 @@ __lpfc_update_fcf_record(struct lpfc_hba *phba, struct lpfc_fcf_rec *fcf_rec,
 		       struct fcf_record *new_fcf_record, uint32_t addr_mode,
 		       uint16_t vlan_id, uint32_t flag)
 {
+	lockdep_assert_held(&phba->hbalock);
+
 	/* Copy the fields from the HBA's FCF record */
 	lpfc_copy_fcf_record(fcf_rec, new_fcf_record);
 	/* Update other fields of driver FCF record */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 92dfd6a..2207726 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/lockdep.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -576,6 +577,8 @@ __lpfc_sli_get_iocbq(struct lpfc_hba *phba)
 	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
 	struct lpfc_iocbq * iocbq = NULL;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	list_remove_head(lpfc_iocb_list, iocbq, struct lpfc_iocbq, list);
 	if (iocbq)
 		phba->iocb_cnt++;
@@ -797,6 +800,7 @@ int
 lpfc_test_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 			uint16_t  xritag)
 {
+	lockdep_assert_held(&phba->hbalock);
 	if (!ndlp)
 		return 0;
 	if (!ndlp->active_rrqs_xri_bitmap)
@@ -914,6 +918,8 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 	struct lpfc_nodelist *ndlp;
 	int found = 0;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	if (piocbq->iocb_flag &  LPFC_IO_FCP) {
 		lpfc_cmd = (struct lpfc_scsi_buf *) piocbq->context1;
 		ndlp = lpfc_cmd->rdata->pnode;
@@ -1003,6 +1009,8 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 	unsigned long iflag = 0;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 
+	lockdep_assert_held(&phba->hbalock);
+
 	if (iocbq->sli4_xritag == NO_XRI)
 		sglq = NULL;
 	else
@@ -1058,6 +1066,7 @@ __lpfc_sli_release_iocbq_s3(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
 
+	lockdep_assert_held(&phba->hbalock);
 
 	/*
 	 * Clean all volatile data fields, preserve iotag and node struct.
@@ -1080,6 +1089,8 @@ __lpfc_sli_release_iocbq_s3(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 static void
 __lpfc_sli_release_iocbq(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
+	lockdep_assert_held(&phba->hbalock);
+
 	phba->__lpfc_sli_release_iocbq(phba, iocbq);
 	phba->iocb_cnt--;
 }
@@ -1310,6 +1321,8 @@ static int
 lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			struct lpfc_iocbq *piocb)
 {
+	lockdep_assert_held(&phba->hbalock);
+
 	list_add_tail(&piocb->list, &pring->txcmplq);
 	piocb->iocb_flag |= LPFC_IO_ON_TXCMPLQ;
 
@@ -1344,6 +1357,8 @@ lpfc_sli_ringtx_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
 	struct lpfc_iocbq *cmd_iocb;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	list_remove_head((&pring->txq), cmd_iocb, struct lpfc_iocbq, list);
 	return cmd_iocb;
 }
@@ -1367,6 +1382,9 @@ lpfc_sli_next_iocb_slot (struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
 	struct lpfc_pgp *pgp = &phba->port_gp[pring->ringno];
 	uint32_t  max_cmd_idx = pring->sli.sli3.numCiocb;
+
+	lockdep_assert_held(&phba->hbalock);
+
 	if ((pring->sli.sli3.next_cmdidx == pring->sli.sli3.cmdidx) &&
 	   (++pring->sli.sli3.next_cmdidx >= max_cmd_idx))
 		pring->sli.sli3.next_cmdidx = 0;
@@ -1497,6 +1515,7 @@ static void
 lpfc_sli_submit_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		IOCB_t *iocb, struct lpfc_iocbq *nextiocb)
 {
+	lockdep_assert_held(&phba->hbalock);
 	/*
 	 * Set up an iotag
 	 */
@@ -1606,6 +1625,8 @@ lpfc_sli_resume_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 	IOCB_t *iocb;
 	struct lpfc_iocbq *nextiocb;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	/*
 	 * Check to see if:
 	 *  (a) there is anything on the txq to send
@@ -1647,6 +1668,8 @@ lpfc_sli_next_hbq_slot(struct lpfc_hba *phba, uint32_t hbqno)
 {
 	struct hbq_s *hbqp = &phba->hbqs[hbqno];
 
+	lockdep_assert_held(&phba->hbalock);
+
 	if (hbqp->next_hbqPutIdx == hbqp->hbqPutIdx &&
 	    ++hbqp->next_hbqPutIdx >= hbqp->entry_count)
 		hbqp->next_hbqPutIdx = 0;
@@ -1747,6 +1770,7 @@ static int
 lpfc_sli_hbq_to_firmware(struct lpfc_hba *phba, uint32_t hbqno,
 			 struct hbq_dmabuf *hbq_buf)
 {
+	lockdep_assert_held(&phba->hbalock);
 	return phba->lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buf);
 }
 
@@ -1768,6 +1792,7 @@ lpfc_sli_hbq_to_firmware_s3(struct lpfc_hba *phba, uint32_t hbqno,
 	struct lpfc_hbq_entry *hbqe;
 	dma_addr_t physaddr = hbq_buf->dbuf.phys;
 
+	lockdep_assert_held(&phba->hbalock);
 	/* Get next HBQ entry slot to use */
 	hbqe = lpfc_sli_next_hbq_slot(phba, hbqno);
 	if (hbqe) {
@@ -1808,6 +1833,7 @@ lpfc_sli_hbq_to_firmware_s4(struct lpfc_hba *phba, uint32_t hbqno,
 	struct lpfc_rqe hrqe;
 	struct lpfc_rqe drqe;
 
+	lockdep_assert_held(&phba->hbalock);
 	hrqe.address_lo = putPaddrLow(hbq_buf->hbuf.phys);
 	hrqe.address_hi = putPaddrHigh(hbq_buf->hbuf.phys);
 	drqe.address_lo = putPaddrLow(hbq_buf->dbuf.phys);
@@ -1986,6 +2012,8 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
 	struct hbq_dmabuf *hbq_buf;
 	uint32_t hbqno;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	hbqno = tag >> 16;
 	if (hbqno >= LPFC_MAX_HBQS)
 		return NULL;
@@ -2647,6 +2675,7 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
 {
 	struct lpfc_iocbq *cmd_iocb = NULL;
 	uint16_t iotag;
+	lockdep_assert_held(&phba->hbalock);
 
 	iotag = prspiocb->iocb.ulpIoTag;
 
@@ -2685,6 +2714,7 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 {
 	struct lpfc_iocbq *cmd_iocb;
 
+	lockdep_assert_held(&phba->hbalock);
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
 		if (cmd_iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ) {
@@ -3799,6 +3829,8 @@ void lpfc_reset_barrier(struct lpfc_hba *phba)
 	int  i;
 	uint8_t hdrtype;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	pci_read_config_byte(phba->pcidev, PCI_HEADER_TYPE, &hdrtype);
 	if (hdrtype != 0x80 ||
 	    (FC_JEDEC_ID(phba->vpd.rev.biuRev) != HELIOS_JEDEC_ID &&
@@ -7861,6 +7893,7 @@ void
 __lpfc_sli_ringtx_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		    struct lpfc_iocbq *piocb)
 {
+	lockdep_assert_held(&phba->hbalock);
 	/* Insert the caller's iocb in the txq tail for later processing. */
 	list_add_tail(&piocb->list, &pring->txq);
 }
@@ -7888,6 +7921,8 @@ lpfc_sli_next_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 {
 	struct lpfc_iocbq * nextiocb;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	nextiocb = lpfc_sli_ringtx_get(phba, pring);
 	if (!nextiocb) {
 		nextiocb = *piocb;
@@ -7927,6 +7962,8 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
 	IOCB_t *iocb;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
 
+	lockdep_assert_held(&phba->hbalock);
+
 	if (piocb->iocb_cmpl && (!piocb->vport) &&
 	   (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
 	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN)) {
@@ -8642,6 +8679,8 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	struct lpfc_queue *wq;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
 
+	lockdep_assert_held(&phba->hbalock);
+
 	if (piocb->sli4_xritag == NO_XRI) {
 		if (piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
 		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
@@ -9752,6 +9791,8 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	int retval;
 	unsigned long iflags;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	/*
 	 * There are certain command types we don't want to abort.  And we
 	 * don't want to abort commands that are already in the process of
@@ -9854,6 +9895,8 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	int retval = IOCB_ERROR;
 	IOCB_t *icmd = NULL;
 
+	lockdep_assert_held(&phba->hbalock);
+
 	/*
 	 * There are certain command types we don't want to abort.  And we
 	 * don't want to abort commands that are already in the process of
-- 
2.7.0

