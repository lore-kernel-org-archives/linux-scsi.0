From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 10/17] lpfc 8.3.2 : Addition of SLI4 Interface - Queues -
	Part 1 of 2
Date: Fri, 22 May 2009 14:52:35 -0400
Message-ID: <1243018355.7729.57.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42124 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbZEVSwh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:52:37 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIqdde029846
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:52:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Addition of SLI4 Interface - Queues - Part 1 of 2

Adds support for the new queues in the SLI-4 interface.  There are :
- Work Queues - host-to-adapter for fast-path traffic
- Mailbox Queues - host-to-adapter for control (slow-path)
- Buffer Queues - host-to-adapter for posting buffers for async receive
- Completion Queues - adapter-to-host for posting async events,
       completions for fast or slow patch work, receipt of async
       receive traffic
- Event Queues - tied to MSI-X vectors, binds completion queues with
       interrupts

These patches add the all the support code to tie into command submission
and response paths, updates the interrupt handling, etc.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c | 1721 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 1653 insertions(+), 68 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 13:16:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 13:18:00.000000000 -0400
@@ -70,6 +70,350 @@ typedef enum _lpfc_iocb_type {
 	LPFC_ABORT_IOCB
 } lpfc_iocb_type;
 
+
+/* Provide function prototypes local to this module. */
+static int lpfc_sli_issue_mbox_s4(struct lpfc_hba *, LPFC_MBOXQ_t *,
+				  uint32_t);
+static int lpfc_sli4_read_rev(struct lpfc_hba *, LPFC_MBOXQ_t *,
+			    uint8_t *, uint32_t *);
+
+static IOCB_t *
+lpfc_get_iocb_from_iocbq(struct lpfc_iocbq *iocbq)
+{
+	return &iocbq->iocb;
+}
+
+/**
+ * lpfc_sli4_wq_put - Put a Work Queue Entry on an Work Queue
+ * @q: The Work Queue to operate on.
+ * @wqe: The work Queue Entry to put on the Work queue.
+ *
+ * This routine will copy the contents of @wqe to the next available entry on
+ * the @q. This function will then ring the Work Queue Doorbell to signal the
+ * HBA to start processing the Work Queue Entry. This function returns 0 if
+ * successful. If no entries are available on @q then this function will return
+ * -ENOMEM.
+ * The caller is expected to hold the hbalock when calling this routine.
+ **/
+static uint32_t
+lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe *wqe)
+{
+	union lpfc_wqe *temp_wqe = q->qe[q->host_index].wqe;
+	struct lpfc_register doorbell;
+	uint32_t host_index;
+
+	/* If the host has not yet processed the next entry then we are done */
+	if (((q->host_index + 1) % q->entry_count) == q->hba_index)
+		return -ENOMEM;
+	/* set consumption flag every once in a while */
+	if (!((q->host_index + 1) % LPFC_RELEASE_NOTIFICATION_INTERVAL))
+		bf_set(lpfc_wqe_gen_wqec, &wqe->generic, 1);
+
+	lpfc_sli_pcimem_bcopy(wqe, temp_wqe, q->entry_size);
+
+	/* Update the host index before invoking device */
+	host_index = q->host_index;
+	q->host_index = ((q->host_index + 1) % q->entry_count);
+
+	/* Ring Doorbell */
+	doorbell.word0 = 0;
+	bf_set(lpfc_wq_doorbell_num_posted, &doorbell, 1);
+	bf_set(lpfc_wq_doorbell_index, &doorbell, host_index);
+	bf_set(lpfc_wq_doorbell_id, &doorbell, q->queue_id);
+	writel(doorbell.word0, q->phba->sli4_hba.WQDBregaddr);
+	readl(q->phba->sli4_hba.WQDBregaddr); /* Flush */
+
+	return 0;
+}
+
+/**
+ * lpfc_sli4_wq_release - Updates internal hba index for WQ
+ * @q: The Work Queue to operate on.
+ * @index: The index to advance the hba index to.
+ *
+ * This routine will update the HBA index of a queue to reflect consumption of
+ * Work Queue Entries by the HBA. When the HBA indicates that it has consumed
+ * an entry the host calls this function to update the queue's internal
+ * pointers. This routine returns the number of entries that were consumed by
+ * the HBA.
+ **/
+static uint32_t
+lpfc_sli4_wq_release(struct lpfc_queue *q, uint32_t index)
+{
+	uint32_t released = 0;
+
+	if (q->hba_index == index)
+		return 0;
+	do {
+		q->hba_index = ((q->hba_index + 1) % q->entry_count);
+		released++;
+	} while (q->hba_index != index);
+	return released;
+}
+
+/**
+ * lpfc_sli4_mq_put - Put a Mailbox Queue Entry on an Mailbox Queue
+ * @q: The Mailbox Queue to operate on.
+ * @wqe: The Mailbox Queue Entry to put on the Work queue.
+ *
+ * This routine will copy the contents of @mqe to the next available entry on
+ * the @q. This function will then ring the Work Queue Doorbell to signal the
+ * HBA to start processing the Work Queue Entry. This function returns 0 if
+ * successful. If no entries are available on @q then this function will return
+ * -ENOMEM.
+ * The caller is expected to hold the hbalock when calling this routine.
+ **/
+static uint32_t
+lpfc_sli4_mq_put(struct lpfc_queue *q, struct lpfc_mqe *mqe)
+{
+	struct lpfc_mqe *temp_mqe = q->qe[q->host_index].mqe;
+	struct lpfc_register doorbell;
+	uint32_t host_index;
+
+	/* If the host has not yet processed the next entry then we are done */
+	if (((q->host_index + 1) % q->entry_count) == q->hba_index)
+		return -ENOMEM;
+	lpfc_sli_pcimem_bcopy(mqe, temp_mqe, q->entry_size);
+	/* Save off the mailbox pointer for completion */
+	q->phba->mbox = (MAILBOX_t *)temp_mqe;
+
+	/* Update the host index before invoking device */
+	host_index = q->host_index;
+	q->host_index = ((q->host_index + 1) % q->entry_count);
+
+	/* Ring Doorbell */
+	doorbell.word0 = 0;
+	bf_set(lpfc_mq_doorbell_num_posted, &doorbell, 1);
+	bf_set(lpfc_mq_doorbell_id, &doorbell, q->queue_id);
+	writel(doorbell.word0, q->phba->sli4_hba.MQDBregaddr);
+	readl(q->phba->sli4_hba.MQDBregaddr); /* Flush */
+	return 0;
+}
+
+/**
+ * lpfc_sli4_mq_release - Updates internal hba index for MQ
+ * @q: The Mailbox Queue to operate on.
+ *
+ * This routine will update the HBA index of a queue to reflect consumption of
+ * a Mailbox Queue Entry by the HBA. When the HBA indicates that it has consumed
+ * an entry the host calls this function to update the queue's internal
+ * pointers. This routine returns the number of entries that were consumed by
+ * the HBA.
+ **/
+static uint32_t
+lpfc_sli4_mq_release(struct lpfc_queue *q)
+{
+	/* Clear the mailbox pointer for completion */
+	q->phba->mbox = NULL;
+	q->hba_index = ((q->hba_index + 1) % q->entry_count);
+	return 1;
+}
+
+/**
+ * lpfc_sli4_eq_get - Gets the next valid EQE from a EQ
+ * @q: The Event Queue to get the first valid EQE from
+ *
+ * This routine will get the first valid Event Queue Entry from @q, update
+ * the queue's internal hba index, and return the EQE. If no valid EQEs are in
+ * the Queue (no more work to do), or the Queue is full of EQEs that have been
+ * processed, but not popped back to the HBA then this routine will return NULL.
+ **/
+static struct lpfc_eqe *
+lpfc_sli4_eq_get(struct lpfc_queue *q)
+{
+	struct lpfc_eqe *eqe = q->qe[q->hba_index].eqe;
+
+	/* If the next EQE is not valid then we are done */
+	if (!bf_get(lpfc_eqe_valid, eqe))
+		return NULL;
+	/* If the host has not yet processed the next entry then we are done */
+	if (((q->hba_index + 1) % q->entry_count) == q->host_index)
+		return NULL;
+
+	q->hba_index = ((q->hba_index + 1) % q->entry_count);
+	return eqe;
+}
+
+/**
+ * lpfc_sli4_eq_release - Indicates the host has finished processing an EQ
+ * @q: The Event Queue that the host has completed processing for.
+ * @arm: Indicates whether the host wants to arms this CQ.
+ *
+ * This routine will mark all Event Queue Entries on @q, from the last
+ * known completed entry to the last entry that was processed, as completed
+ * by clearing the valid bit for each completion queue entry. Then it will
+ * notify the HBA, by ringing the doorbell, that the EQEs have been processed.
+ * The internal host index in the @q will be updated by this routine to indicate
+ * that the host has finished processing the entries. The @arm parameter
+ * indicates that the queue should be rearmed when ringing the doorbell.
+ *
+ * This function will return the number of EQEs that were popped.
+ **/
+uint32_t
+lpfc_sli4_eq_release(struct lpfc_queue *q, bool arm)
+{
+	uint32_t released = 0;
+	struct lpfc_eqe *temp_eqe;
+	struct lpfc_register doorbell;
+
+	/* while there are valid entries */
+	while (q->hba_index != q->host_index) {
+		temp_eqe = q->qe[q->host_index].eqe;
+		bf_set(lpfc_eqe_valid, temp_eqe, 0);
+		released++;
+		q->host_index = ((q->host_index + 1) % q->entry_count);
+	}
+	if (unlikely(released == 0 && !arm))
+		return 0;
+
+	/* ring doorbell for number popped */
+	doorbell.word0 = 0;
+	if (arm) {
+		bf_set(lpfc_eqcq_doorbell_arm, &doorbell, 1);
+		bf_set(lpfc_eqcq_doorbell_eqci, &doorbell, 1);
+	}
+	bf_set(lpfc_eqcq_doorbell_num_released, &doorbell, released);
+	bf_set(lpfc_eqcq_doorbell_qt, &doorbell, LPFC_QUEUE_TYPE_EVENT);
+	bf_set(lpfc_eqcq_doorbell_eqid, &doorbell, q->queue_id);
+	writel(doorbell.word0, q->phba->sli4_hba.EQCQDBregaddr);
+	return released;
+}
+
+/**
+ * lpfc_sli4_cq_get - Gets the next valid CQE from a CQ
+ * @q: The Completion Queue to get the first valid CQE from
+ *
+ * This routine will get the first valid Completion Queue Entry from @q, update
+ * the queue's internal hba index, and return the CQE. If no valid CQEs are in
+ * the Queue (no more work to do), or the Queue is full of CQEs that have been
+ * processed, but not popped back to the HBA then this routine will return NULL.
+ **/
+static struct lpfc_cqe *
+lpfc_sli4_cq_get(struct lpfc_queue *q)
+{
+	struct lpfc_cqe *cqe;
+
+	/* If the next CQE is not valid then we are done */
+	if (!bf_get(lpfc_cqe_valid, q->qe[q->hba_index].cqe))
+		return NULL;
+	/* If the host has not yet processed the next entry then we are done */
+	if (((q->hba_index + 1) % q->entry_count) == q->host_index)
+		return NULL;
+
+	cqe = q->qe[q->hba_index].cqe;
+	q->hba_index = ((q->hba_index + 1) % q->entry_count);
+	return cqe;
+}
+
+/**
+ * lpfc_sli4_cq_release - Indicates the host has finished processing a CQ
+ * @q: The Completion Queue that the host has completed processing for.
+ * @arm: Indicates whether the host wants to arms this CQ.
+ *
+ * This routine will mark all Completion queue entries on @q, from the last
+ * known completed entry to the last entry that was processed, as completed
+ * by clearing the valid bit for each completion queue entry. Then it will
+ * notify the HBA, by ringing the doorbell, that the CQEs have been processed.
+ * The internal host index in the @q will be updated by this routine to indicate
+ * that the host has finished processing the entries. The @arm parameter
+ * indicates that the queue should be rearmed when ringing the doorbell.
+ *
+ * This function will return the number of CQEs that were released.
+ **/
+uint32_t
+lpfc_sli4_cq_release(struct lpfc_queue *q, bool arm)
+{
+	uint32_t released = 0;
+	struct lpfc_cqe *temp_qe;
+	struct lpfc_register doorbell;
+
+	/* while there are valid entries */
+	while (q->hba_index != q->host_index) {
+		temp_qe = q->qe[q->host_index].cqe;
+		bf_set(lpfc_cqe_valid, temp_qe, 0);
+		released++;
+		q->host_index = ((q->host_index + 1) % q->entry_count);
+	}
+	if (unlikely(released == 0 && !arm))
+		return 0;
+
+	/* ring doorbell for number popped */
+	doorbell.word0 = 0;
+	if (arm)
+		bf_set(lpfc_eqcq_doorbell_arm, &doorbell, 1);
+	bf_set(lpfc_eqcq_doorbell_num_released, &doorbell, released);
+	bf_set(lpfc_eqcq_doorbell_qt, &doorbell, LPFC_QUEUE_TYPE_COMPLETION);
+	bf_set(lpfc_eqcq_doorbell_cqid, &doorbell, q->queue_id);
+	writel(doorbell.word0, q->phba->sli4_hba.EQCQDBregaddr);
+	return released;
+}
+
+/**
+ * lpfc_sli4_rq_put - Put a Receive Buffer Queue Entry on a Receive Queue
+ * @q: The Header Receive Queue to operate on.
+ * @wqe: The Receive Queue Entry to put on the Receive queue.
+ *
+ * This routine will copy the contents of @wqe to the next available entry on
+ * the @q. This function will then ring the Receive Queue Doorbell to signal the
+ * HBA to start processing the Receive Queue Entry. This function returns the
+ * index that the rqe was copied to if successful. If no entries are available
+ * on @q then this function will return -ENOMEM.
+ * The caller is expected to hold the hbalock when calling this routine.
+ **/
+static int
+lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
+		 struct lpfc_rqe *hrqe, struct lpfc_rqe *drqe)
+{
+	struct lpfc_rqe *temp_hrqe = hq->qe[hq->host_index].rqe;
+	struct lpfc_rqe *temp_drqe = dq->qe[dq->host_index].rqe;
+	struct lpfc_register doorbell;
+	int put_index = hq->host_index;
+
+	if (hq->type != LPFC_HRQ || dq->type != LPFC_DRQ)
+		return -EINVAL;
+	if (hq->host_index != dq->host_index)
+		return -EINVAL;
+	/* If the host has not yet processed the next entry then we are done */
+	if (((hq->host_index + 1) % hq->entry_count) == hq->hba_index)
+		return -EBUSY;
+	lpfc_sli_pcimem_bcopy(hrqe, temp_hrqe, hq->entry_size);
+	lpfc_sli_pcimem_bcopy(drqe, temp_drqe, dq->entry_size);
+
+	/* Update the host index to point to the next slot */
+	hq->host_index = ((hq->host_index + 1) % hq->entry_count);
+	dq->host_index = ((dq->host_index + 1) % dq->entry_count);
+
+	/* Ring The Header Receive Queue Doorbell */
+	if (!(hq->host_index % LPFC_RQ_POST_BATCH)) {
+		doorbell.word0 = 0;
+		bf_set(lpfc_rq_doorbell_num_posted, &doorbell,
+		       LPFC_RQ_POST_BATCH);
+		bf_set(lpfc_rq_doorbell_id, &doorbell, hq->queue_id);
+		writel(doorbell.word0, hq->phba->sli4_hba.RQDBregaddr);
+	}
+	return put_index;
+}
+
+/**
+ * lpfc_sli4_rq_release - Updates internal hba index for RQ
+ * @q: The Header Receive Queue to operate on.
+ *
+ * This routine will update the HBA index of a queue to reflect consumption of
+ * one Receive Queue Entry by the HBA. When the HBA indicates that it has
+ * consumed an entry the host calls this function to update the queue's
+ * internal pointers. This routine returns the number of entries that were
+ * consumed by the HBA.
+ **/
+static uint32_t
+lpfc_sli4_rq_release(struct lpfc_queue *hq, struct lpfc_queue *dq)
+{
+	if ((hq->type != LPFC_HRQ) || (dq->type != LPFC_DRQ))
+		return 0;
+	hq->hba_index = ((hq->hba_index + 1) % hq->entry_count);
+	dq->hba_index = ((dq->hba_index + 1) % dq->entry_count);
+	return 1;
+}
+
 /**
  * lpfc_cmd_iocb - Get next command iocb entry in the ring
  * @phba: Pointer to HBA context object.
@@ -215,6 +559,59 @@ lpfc_sli_get_iocbq(struct lpfc_hba *phba
 }
 
 /**
+ * __lpfc_sli_release_iocbq_s4 - Release iocb to the iocb pool
+ * @phba: Pointer to HBA context object.
+ * @iocbq: Pointer to driver iocb object.
+ *
+ * This function is called with hbalock held to release driver
+ * iocb object to the iocb pool. The iotag in the iocb object
+ * does not change for each use of the iocb object. This function
+ * clears all other fields of the iocb object when it is freed.
+ * The sqlq structure that holds the xritag and phys and virtual
+ * mappings for the scatter gather list is retrieved from the
+ * active array of sglq. The get of the sglq pointer also clears
+ * the entry in the array. If the status of the IO indiactes that
+ * this IO was aborted then the sglq entry it put on the
+ * lpfc_abts_els_sgl_list until the CQ_ABORTED_XRI is received. If the
+ * IO has good status or fails for any other reason then the sglq
+ * entry is added to the free list (lpfc_sgl_list).
+ **/
+static void
+__lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
+{
+	struct lpfc_sglq *sglq;
+	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
+	unsigned long iflag;
+
+	if (iocbq->sli4_xritag == NO_XRI)
+		sglq = NULL;
+	else
+		sglq = __lpfc_clear_active_sglq(phba, iocbq->sli4_xritag);
+	if (sglq)  {
+		if (iocbq->iocb_flag & LPFC_DRIVER_ABORTED
+			|| ((iocbq->iocb.ulpStatus == IOSTAT_LOCAL_REJECT)
+			&& (iocbq->iocb.un.ulpWord[4]
+				== IOERR_SLI_ABORTED))) {
+			spin_lock_irqsave(&phba->sli4_hba.abts_sgl_list_lock,
+					iflag);
+			list_add(&sglq->list,
+				&phba->sli4_hba.lpfc_abts_els_sgl_list);
+			spin_unlock_irqrestore(
+				&phba->sli4_hba.abts_sgl_list_lock, iflag);
+		} else
+			list_add(&sglq->list, &phba->sli4_hba.lpfc_sgl_list);
+	}
+
+
+	/*
+	 * Clean all volatile data fields, preserve iotag and node struct.
+	 */
+	memset((char *)iocbq + start_clean, 0, sizeof(*iocbq) - start_clean);
+	iocbq->sli4_xritag = NO_XRI;
+	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
+}
+
+/**
  * __lpfc_sli_release_iocbq_s3 - Release iocb to the iocb pool
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to driver iocb object.
@@ -959,6 +1356,37 @@ lpfc_sli_hbq_to_firmware_s3(struct lpfc_
 		return -ENOMEM;
 }
 
+/**
+ * lpfc_sli_hbq_to_firmware_s4 - Post the hbq buffer to SLI4 firmware
+ * @phba: Pointer to HBA context object.
+ * @hbqno: HBQ number.
+ * @hbq_buf: Pointer to HBQ buffer.
+ *
+ * This function is called with the hbalock held to post an RQE to the SLI4
+ * firmware. If able to post the RQE to the RQ it will queue the hbq entry to
+ * the hbq_buffer_list and return zero, otherwise it will return an error.
+ **/
+static int
+lpfc_sli_hbq_to_firmware_s4(struct lpfc_hba *phba, uint32_t hbqno,
+			    struct hbq_dmabuf *hbq_buf)
+{
+	int rc;
+	struct lpfc_rqe hrqe;
+	struct lpfc_rqe drqe;
+
+	hrqe.address_lo = putPaddrLow(hbq_buf->hbuf.phys);
+	hrqe.address_hi = putPaddrHigh(hbq_buf->hbuf.phys);
+	drqe.address_lo = putPaddrLow(hbq_buf->dbuf.phys);
+	drqe.address_hi = putPaddrHigh(hbq_buf->dbuf.phys);
+	rc = lpfc_sli4_rq_put(phba->sli4_hba.hdr_rq, phba->sli4_hba.dat_rq,
+			      &hrqe, &drqe);
+	if (rc < 0)
+		return rc;
+	hbq_buf->tag = rc;
+	list_add_tail(&hbq_buf->dbuf.list, &phba->hbqs[hbqno].hbq_buffer_list);
+	return 0;
+}
+
 /* HBQ for ELS and CT traffic. */
 static struct lpfc_hbq_init lpfc_els_hbq = {
 	.rn = 1,
@@ -2575,6 +3003,36 @@ lpfc_sli_handle_slow_ring_event_s3(struc
 }
 
 /**
+ * lpfc_sli_handle_slow_ring_event_s4 - Handle SLI4 slow-path els events
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @mask: Host attention register mask for this ring.
+ *
+ * This function is called from the worker thread when there is a pending
+ * ELS response iocb on the driver internal slow-path response iocb worker
+ * queue. The caller does not hold any lock. The function will remove each
+ * response iocb from the response worker queue and calls the handle
+ * response iocb routine (lpfc_sli_sp_handle_rspiocb) to process it.
+ **/
+static void
+lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
+				   struct lpfc_sli_ring *pring, uint32_t mask)
+{
+	struct lpfc_iocbq *irspiocbq;
+	unsigned long iflag;
+
+	while (!list_empty(&phba->sli4_hba.sp_rspiocb_work_queue)) {
+		/* Get the response iocb from the head of work queue */
+		spin_lock_irqsave(&phba->hbalock, iflag);
+		list_remove_head(&phba->sli4_hba.sp_rspiocb_work_queue,
+				 irspiocbq, struct lpfc_iocbq, list);
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		/* Process the response iocb */
+		lpfc_sli_sp_handle_rspiocb(phba, pring, irspiocbq);
+	}
+}
+
+/**
  * lpfc_sli_abort_iocb_ring - Abort all iocbs in the ring
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
@@ -3376,6 +3834,26 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
 }
 
 /**
+ * lpfc_sli4_rb_setup - Initialize and post RBs to HBA
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called during the SLI initialization to configure
+ * all the HBQs and post buffers to the HBQ. The caller is not
+ * required to hold any locks. This function will return zero if successful
+ * else it will return negative error code.
+ **/
+static int
+lpfc_sli4_rb_setup(struct lpfc_hba *phba)
+{
+	phba->hbq_in_use = 1;
+	phba->hbqs[0].entry_count = lpfc_hbq_defs[0]->entry_count;
+	phba->hbq_count = 1;
+	/* Initially populate or replenish the HBQs */
+	lpfc_sli_hbqbuf_init_hbqs(phba, 0);
+	return 0;
+}
+
+/**
  * lpfc_sli_config_port - Issue config port mailbox command
  * @phba: Pointer to HBA context object.
  * @sli_mode: sli mode - 2/3
@@ -5130,99 +5608,545 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba
 }
 
 /**
- * __lpfc_sli_issue_iocb - Wrapper func of lockless version for issuing iocb
+ * lpfc_sli4_bpl2sgl - Convert the bpl/bde to a sgl.
+ * @phba: Pointer to HBA context object.
+ * @piocb: Pointer to command iocb.
+ * @sglq: Pointer to the scatter gather queue object.
  *
- * This routine wraps the actual lockless version for issusing IOCB function
- * pointer from the lpfc_hba struct.
+ * This routine converts the bpl or bde that is in the IOCB
+ * to a sgl list for the sli4 hardware. The physical address
+ * of the bpl/bde is converted back to a virtual address.
+ * If the IOCB contains a BPL then the list of BDE's is
+ * converted to sli4_sge's. If the IOCB contains a single
+ * BDE then it is converted to a single sli_sge.
+ * The IOCB is still in cpu endianess so the contents of
+ * the bpl can be used without byte swapping.
  *
- * Return codes:
- * 	IOCB_ERROR - Error
- * 	IOCB_SUCCESS - Success
- * 	IOCB_BUSY - Busy
- **/
-static inline int
-__lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
-		struct lpfc_iocbq *piocb, uint32_t flag)
-{
-	return phba->__lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
-}
+ * Returns valid XRI = Success, NO_XRI = Failure.
+**/
+static uint16_t
+lpfc_sli4_bpl2sgl(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq,
+		struct lpfc_sglq *sglq)
+{
+	uint16_t xritag = NO_XRI;
+	struct ulp_bde64 *bpl = NULL;
+	struct ulp_bde64 bde;
+	struct sli4_sge *sgl  = NULL;
+	IOCB_t *icmd;
+	int numBdes = 0;
+	int i = 0;
 
-/**
- * lpfc_sli_api_table_setup - Set up sli api fucntion jump table
- * @phba: The hba struct for which this call is being executed.
- * @dev_grp: The HBA PCI-Device group number.
- *
- * This routine sets up the SLI interface API function jump table in @phba
- * struct.
- * Returns: 0 - success, -ENODEV - failure.
- **/
-int
-lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
-{
+	if (!piocbq || !sglq)
+		return xritag;
 
-	switch (dev_grp) {
-	case LPFC_PCI_DEV_LP:
-		phba->__lpfc_sli_issue_iocb = __lpfc_sli_issue_iocb_s3;
-		phba->__lpfc_sli_release_iocbq = __lpfc_sli_release_iocbq_s3;
-		break;
-	default:
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1419 Invalid HBA PCI-device group: 0x%x\n",
-				dev_grp);
-		return -ENODEV;
-		break;
+	sgl  = (struct sli4_sge *)sglq->sgl;
+	icmd = &piocbq->iocb;
+	if (icmd->un.genreq64.bdl.bdeFlags == BUFF_TYPE_BLP_64) {
+		numBdes = icmd->un.genreq64.bdl.bdeSize /
+				sizeof(struct ulp_bde64);
+		/* The addrHigh and addrLow fields within the IOCB
+		 * have not been byteswapped yet so there is no
+		 * need to swap them back.
+		 */
+		bpl  = (struct ulp_bde64 *)
+			((struct lpfc_dmabuf *)piocbq->context3)->virt;
+
+		if (!bpl)
+			return xritag;
+
+		for (i = 0; i < numBdes; i++) {
+			/* Should already be byte swapped. */
+			sgl->addr_hi =  bpl->addrHigh;
+			sgl->addr_lo =  bpl->addrLow;
+			/* swap the size field back to the cpu so we
+			 * can assign it to the sgl.
+			 */
+			bde.tus.w  = le32_to_cpu(bpl->tus.w);
+			bf_set(lpfc_sli4_sge_len, sgl, bde.tus.f.bdeSize);
+			if ((i+1) == numBdes)
+				bf_set(lpfc_sli4_sge_last, sgl, 1);
+			else
+				bf_set(lpfc_sli4_sge_last, sgl, 0);
+			sgl->word2 = cpu_to_le32(sgl->word2);
+			sgl->word3 = cpu_to_le32(sgl->word3);
+			bpl++;
+			sgl++;
+		}
+	} else if (icmd->un.genreq64.bdl.bdeFlags == BUFF_TYPE_BDE_64) {
+			/* The addrHigh and addrLow fields of the BDE have not
+			 * been byteswapped yet so they need to be swapped
+			 * before putting them in the sgl.
+			 */
+			sgl->addr_hi =
+				cpu_to_le32(icmd->un.genreq64.bdl.addrHigh);
+			sgl->addr_lo =
+				cpu_to_le32(icmd->un.genreq64.bdl.addrLow);
+			bf_set(lpfc_sli4_sge_len, sgl,
+				icmd->un.genreq64.bdl.bdeSize);
+			bf_set(lpfc_sli4_sge_last, sgl, 1);
+			sgl->word2 = cpu_to_le32(sgl->word2);
+			sgl->word3 = cpu_to_le32(sgl->word3);
 	}
-	phba->lpfc_get_iocb_from_iocbq = lpfc_get_iocb_from_iocbq;
-	return 0;
+	return sglq->sli4_xritag;
 }
 
 /**
- * lpfc_sli_issue_iocb - Wrapper function for __lpfc_sli_issue_iocb
+ * lpfc_sli4_scmd_to_wqidx_distr - scsi command to SLI4 WQ index distribution
  * @phba: Pointer to HBA context object.
- * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to command iocb.
- * @flag: Flag indicating if this command can be put into txq.
  *
- * lpfc_sli_issue_iocb is a wrapper around __lpfc_sli_issue_iocb
- * function. This function gets the hbalock and calls
- * __lpfc_sli_issue_iocb function and will return the error returned
- * by __lpfc_sli_issue_iocb function. This wrapper is used by
- * functions which do not hold hbalock.
+ * This routine performs a round robin SCSI command to SLI4 FCP WQ index
+ * distribution.
+ *
+ * Return: index into SLI4 fast-path FCP queue index.
  **/
-int
-lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
-		    struct lpfc_iocbq *piocb, uint32_t flag)
+static uint32_t
+lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 {
-	unsigned long iflags;
-	int rc;
+	static uint32_t fcp_qidx;
 
-	spin_lock_irqsave(&phba->hbalock, iflags);
-	rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
-
-	return rc;
+	return fcp_qidx++ % phba->cfg_fcp_wq_count;
 }
 
 /**
- * lpfc_extra_ring_setup - Extra ring setup function
+ * lpfc_sli_iocb2wqe - Convert the IOCB to a work queue entry.
  * @phba: Pointer to HBA context object.
+ * @piocb: Pointer to command iocb.
+ * @wqe: Pointer to the work queue entry.
  *
- * This function is called while driver attaches with the
- * HBA to setup the extra ring. The extra ring is used
- * only when driver needs to support target mode functionality
- * or IP over FC functionalities.
+ * This routine converts the iocb command to its Work Queue Entry
+ * equivalent. The wqe pointer should not have any fields set when
+ * this routine is called because it will memcpy over them.
+ * This routine does not set the CQ_ID or the WQEC bits in the
+ * wqe.
  *
- * This function is called with no lock held.
+ * Returns: 0 = Success, IOCB_ERROR = Failure.
  **/
 static int
-lpfc_extra_ring_setup( struct lpfc_hba *phba)
+lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
+		union lpfc_wqe *wqe)
 {
-	struct lpfc_sli *psli;
-	struct lpfc_sli_ring *pring;
+	uint32_t payload_len = 0;
+	uint8_t ct = 0;
+	uint32_t fip;
+	uint32_t abort_tag;
+	uint8_t command_type = ELS_COMMAND_NON_FIP;
+	uint8_t cmnd;
+	uint16_t xritag;
+	struct ulp_bde64 *bpl = NULL;
+
+	fip = bf_get(lpfc_fip_flag, &phba->sli4_hba.sli4_flags);
+	/* The fcp commands will set command type */
+	if ((!(iocbq->iocb_flag &  LPFC_IO_FCP)) && (!fip))
+		command_type = ELS_COMMAND_NON_FIP;
+	else if (!(iocbq->iocb_flag &  LPFC_IO_FCP))
+		command_type = ELS_COMMAND_FIP;
+	else if (iocbq->iocb_flag &  LPFC_IO_FCP)
+		command_type = FCP_COMMAND;
+	else {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+			"2019 Invalid cmd 0x%x\n",
+			iocbq->iocb.ulpCommand);
+		return IOCB_ERROR;
+	}
+	/* Some of the fields are in the right position already */
+	memcpy(wqe, &iocbq->iocb, sizeof(union lpfc_wqe));
+	abort_tag = (uint32_t) iocbq->iotag;
+	xritag = iocbq->sli4_xritag;
+	wqe->words[7] = 0; /* The ct field has moved so reset */
+	/* words0-2 bpl convert bde */
+	if (iocbq->iocb.un.genreq64.bdl.bdeFlags == BUFF_TYPE_BLP_64) {
+		bpl  = (struct ulp_bde64 *)
+			((struct lpfc_dmabuf *)iocbq->context3)->virt;
+		if (!bpl)
+			return IOCB_ERROR;
 
-	psli = &phba->sli;
+		/* Should already be byte swapped. */
+		wqe->generic.bde.addrHigh =  le32_to_cpu(bpl->addrHigh);
+		wqe->generic.bde.addrLow =  le32_to_cpu(bpl->addrLow);
+		/* swap the size field back to the cpu so we
+		 * can assign it to the sgl.
+		 */
+		wqe->generic.bde.tus.w  = le32_to_cpu(bpl->tus.w);
+		payload_len = wqe->generic.bde.tus.f.bdeSize;
+	} else
+		payload_len = iocbq->iocb.un.fcpi64.bdl.bdeSize;
 
-	/* Adjust cmd/rsp ring iocb entries more evenly */
+	iocbq->iocb.ulpIoTag = iocbq->iotag;
+	cmnd = iocbq->iocb.ulpCommand;
+
+	switch (iocbq->iocb.ulpCommand) {
+	case CMD_ELS_REQUEST64_CR:
+		if (!iocbq->iocb.ulpLe) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2007 Only Limited Edition cmd Format"
+				" supported 0x%x\n",
+				iocbq->iocb.ulpCommand);
+			return IOCB_ERROR;
+		}
+		wqe->els_req.payload_len = payload_len;
+		/* Els_reguest64 has a TMO */
+		bf_set(wqe_tmo, &wqe->els_req.wqe_com,
+			iocbq->iocb.ulpTimeout);
+		/* Need a VF for word 4 set the vf bit*/
+		bf_set(els_req64_vf, &wqe->els_req, 0);
+		/* And a VFID for word 12 */
+		bf_set(els_req64_vfid, &wqe->els_req, 0);
+		/*
+		 * Set ct field to 3, indicates that the context_tag field
+		 * contains the FCFI and remote N_Port_ID is
+		 * in word 5.
+		 */
+
+		ct = ((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l);
+		bf_set(lpfc_wqe_gen_context, &wqe->generic,
+				iocbq->iocb.ulpContext);
+
+		if (iocbq->vport->fc_myDID != 0) {
+			bf_set(els_req64_sid, &wqe->els_req,
+				 iocbq->vport->fc_myDID);
+			bf_set(els_req64_sp, &wqe->els_req, 1);
+		}
+		bf_set(lpfc_wqe_gen_ct, &wqe->generic, ct);
+		bf_set(lpfc_wqe_gen_pu, &wqe->generic, 0);
+		/* CCP CCPE PV PRI in word10 were set in the memcpy */
+	break;
+	case CMD_XMIT_SEQUENCE64_CR:
+		/* word3 iocb=io_tag32 wqe=payload_offset */
+		/* payload offset used for multilpe outstanding
+		 * sequences on the same exchange
+		 */
+		wqe->words[3] = 0;
+		/* word4 relative_offset memcpy */
+		/* word5 r_ctl/df_ctl memcpy */
+		bf_set(lpfc_wqe_gen_pu, &wqe->generic, 0);
+		wqe->xmit_sequence.xmit_len = payload_len;
+	break;
+	case CMD_XMIT_BCAST64_CN:
+		/* word3 iocb=iotag32 wqe=payload_len */
+		wqe->words[3] = 0; /* no definition for this in wqe */
+		/* word4 iocb=rsvd wqe=rsvd */
+		/* word5 iocb=rctl/type/df_ctl wqe=rctl/type/df_ctl memcpy */
+		/* word6 iocb=ctxt_tag/io_tag wqe=ctxt_tag/xri */
+		bf_set(lpfc_wqe_gen_ct, &wqe->generic,
+			((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l));
+	break;
+	case CMD_FCP_IWRITE64_CR:
+		command_type = FCP_COMMAND_DATA_OUT;
+		/* The struct for wqe fcp_iwrite has 3 fields that are somewhat
+		 * confusing.
+		 * word3 is payload_len: byte offset to the sgl entry for the
+		 * fcp_command.
+		 * word4 is total xfer len, same as the IOCB->ulpParameter.
+		 * word5 is initial xfer len 0 = wait for xfer-ready
+		 */
+
+		/* Always wait for xfer-ready before sending data */
+		wqe->fcp_iwrite.initial_xfer_len = 0;
+		/* word 4 (xfer length) should have been set on the memcpy */
+
+	/* allow write to fall through to read */
+	case CMD_FCP_IREAD64_CR:
+		/* FCP_CMD is always the 1st sgl entry */
+		wqe->fcp_iread.payload_len =
+			payload_len + sizeof(struct fcp_rsp);
+
+		/* word 4 (xfer length) should have been set on the memcpy */
+
+		bf_set(lpfc_wqe_gen_erp, &wqe->generic,
+			iocbq->iocb.ulpFCP2Rcvy);
+		bf_set(lpfc_wqe_gen_lnk, &wqe->generic, iocbq->iocb.ulpXS);
+		/* The XC bit and the XS bit are similar. The driver never
+		 * tracked whether or not the exchange was previouslly open.
+		 * XC = Exchange create, 0 is create. 1 is already open.
+		 * XS = link cmd: 1 do not close the exchange after command.
+		 * XS = 0 close exchange when command completes.
+		 * The only time we would not set the XC bit is when the XS bit
+		 * is set and we are sending our 2nd or greater command on
+		 * this exchange.
+		 */
+
+	/* ALLOW read & write to fall through to ICMD64 */
+	case CMD_FCP_ICMND64_CR:
+		/* Always open the exchange */
+		bf_set(wqe_xc, &wqe->fcp_iread.wqe_com, 0);
+
+		wqe->words[10] &= 0xffff0000; /* zero out ebde count */
+		bf_set(lpfc_wqe_gen_pu, &wqe->generic, iocbq->iocb.ulpPU);
+	break;
+	case CMD_GEN_REQUEST64_CR:
+		/* word3 command length is described as byte offset to the
+		 * rsp_data. Would always be 16, sizeof(struct sli4_sge)
+		 * sgl[0] = cmnd
+		 * sgl[1] = rsp.
+		 *
+		 */
+		wqe->gen_req.command_len = payload_len;
+		/* Word4 parameter  copied in the memcpy */
+		/* Word5 [rctl, type, df_ctl, la] copied in memcpy */
+		/* word6 context tag copied in memcpy */
+		if (iocbq->iocb.ulpCt_h  || iocbq->iocb.ulpCt_l) {
+			ct = ((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l);
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2015 Invalid CT %x command 0x%x\n",
+				ct, iocbq->iocb.ulpCommand);
+			return IOCB_ERROR;
+		}
+		bf_set(lpfc_wqe_gen_ct, &wqe->generic, 0);
+		bf_set(wqe_tmo, &wqe->gen_req.wqe_com,
+			iocbq->iocb.ulpTimeout);
+
+		bf_set(lpfc_wqe_gen_pu, &wqe->generic, iocbq->iocb.ulpPU);
+		command_type = OTHER_COMMAND;
+	break;
+	case CMD_XMIT_ELS_RSP64_CX:
+		/* words0-2 BDE memcpy */
+		/* word3 iocb=iotag32 wqe=rsvd */
+		wqe->words[3] = 0;
+		/* word4 iocb=did wge=rsvd. */
+		wqe->words[4] = 0;
+		/* word5 iocb=rsvd wge=did */
+		bf_set(wqe_els_did, &wqe->xmit_els_rsp.wqe_dest,
+			 iocbq->iocb.un.elsreq64.remoteID);
+
+		bf_set(lpfc_wqe_gen_ct, &wqe->generic,
+			((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l));
+
+		bf_set(lpfc_wqe_gen_pu, &wqe->generic, iocbq->iocb.ulpPU);
+		bf_set(wqe_rcvoxid, &wqe->generic, iocbq->iocb.ulpContext);
+		if (!iocbq->iocb.ulpCt_h && iocbq->iocb.ulpCt_l)
+			bf_set(lpfc_wqe_gen_context, &wqe->generic,
+			       iocbq->vport->vpi + phba->vpi_base);
+		command_type = OTHER_COMMAND;
+	break;
+	case CMD_CLOSE_XRI_CN:
+	case CMD_ABORT_XRI_CN:
+	case CMD_ABORT_XRI_CX:
+		/* words 0-2 memcpy should be 0 rserved */
+		/* port will send abts */
+		if (iocbq->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
+			/*
+			 * The link is down so the fw does not need to send abts
+			 * on the wire.
+			 */
+			bf_set(abort_cmd_ia, &wqe->abort_cmd, 1);
+		else
+			bf_set(abort_cmd_ia, &wqe->abort_cmd, 0);
+		bf_set(abort_cmd_criteria, &wqe->abort_cmd, T_XRI_TAG);
+		abort_tag = iocbq->iocb.un.acxri.abortIoTag;
+		wqe->words[5] = 0;
+		bf_set(lpfc_wqe_gen_ct, &wqe->generic,
+			((iocbq->iocb.ulpCt_h << 1) | iocbq->iocb.ulpCt_l));
+		abort_tag = iocbq->iocb.un.acxri.abortIoTag;
+		wqe->generic.abort_tag = abort_tag;
+		/*
+		 * The abort handler will send us CMD_ABORT_XRI_CN or
+		 * CMD_CLOSE_XRI_CN and the fw only accepts CMD_ABORT_XRI_CX
+		 */
+		bf_set(lpfc_wqe_gen_command, &wqe->generic, CMD_ABORT_XRI_CX);
+		cmnd = CMD_ABORT_XRI_CX;
+		command_type = OTHER_COMMAND;
+		xritag = 0;
+	break;
+	case CMD_XRI_ABORTED_CX:
+	case CMD_CREATE_XRI_CR: /* Do we expect to use this? */
+		/* words0-2 are all 0's no bde */
+		/* word3 and word4 are rsvrd */
+		wqe->words[3] = 0;
+		wqe->words[4] = 0;
+		/* word5 iocb=rsvd wge=did */
+		/* There is no remote port id in the IOCB? */
+		/* Let this fall through and fail */
+	case CMD_IOCB_FCP_IBIDIR64_CR: /* bidirectional xfer */
+	case CMD_FCP_TSEND64_CX: /* Target mode send xfer-ready */
+	case CMD_FCP_TRSP64_CX: /* Target mode rcv */
+	case CMD_FCP_AUTO_TRSP_CX: /* Auto target rsp */
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2014 Invalid command 0x%x\n",
+				iocbq->iocb.ulpCommand);
+		return IOCB_ERROR;
+	break;
+
+	}
+	bf_set(lpfc_wqe_gen_xri, &wqe->generic, xritag);
+	bf_set(lpfc_wqe_gen_request_tag, &wqe->generic, iocbq->iotag);
+	wqe->generic.abort_tag = abort_tag;
+	bf_set(lpfc_wqe_gen_cmd_type, &wqe->generic, command_type);
+	bf_set(lpfc_wqe_gen_command, &wqe->generic, cmnd);
+	bf_set(lpfc_wqe_gen_class, &wqe->generic, iocbq->iocb.ulpClass);
+	bf_set(lpfc_wqe_gen_cq_id, &wqe->generic, LPFC_WQE_CQ_ID_DEFAULT);
+
+	return 0;
+}
+
+/**
+ * __lpfc_sli_issue_iocb_s4 - SLI4 device lockless ver of lpfc_sli_issue_iocb
+ * @phba: Pointer to HBA context object.
+ * @ring_number: SLI ring number to issue iocb on.
+ * @piocb: Pointer to command iocb.
+ * @flag: Flag indicating if this command can be put into txq.
+ *
+ * __lpfc_sli_issue_iocb_s4 is used by other functions in the driver to issue
+ * an iocb command to an HBA with SLI-4 interface spec.
+ *
+ * This function is called with hbalock held. The function will return success
+ * after it successfully submit the iocb to firmware or after adding to the
+ * txq.
+ **/
+static int
+__lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
+			 struct lpfc_iocbq *piocb, uint32_t flag)
+{
+	struct lpfc_sglq *sglq;
+	uint16_t xritag;
+	union lpfc_wqe wqe;
+	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
+	uint32_t fcp_wqidx;
+
+	if (piocb->sli4_xritag == NO_XRI) {
+		if (piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
+			piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
+			sglq = NULL;
+		else {
+			sglq = __lpfc_sli_get_sglq(phba);
+			if (!sglq)
+				return IOCB_ERROR;
+			piocb->sli4_xritag = sglq->sli4_xritag;
+		}
+	} else if (piocb->iocb_flag &  LPFC_IO_FCP) {
+		sglq = NULL; /* These IO's already have an XRI and
+			      * a mapped sgl.
+			      */
+	} else {
+		/* This is a continuation of a commandi,(CX) so this
+		 * sglq is on the active list
+		 */
+		sglq = __lpfc_get_active_sglq(phba, piocb->sli4_xritag);
+		if (!sglq)
+			return IOCB_ERROR;
+	}
+
+	if (sglq) {
+		xritag = lpfc_sli4_bpl2sgl(phba, piocb, sglq);
+		if (xritag != sglq->sli4_xritag)
+			return IOCB_ERROR;
+	}
+
+	if (lpfc_sli4_iocb2wqe(phba, piocb, &wqe))
+		return IOCB_ERROR;
+
+	if (piocb->iocb_flag &  LPFC_IO_FCP) {
+		fcp_wqidx = lpfc_sli4_scmd_to_wqidx_distr(phba, piocb);
+		if (lpfc_sli4_wq_put(phba->sli4_hba.fcp_wq[fcp_wqidx], &wqe))
+			return IOCB_ERROR;
+	} else {
+		if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, &wqe))
+			return IOCB_ERROR;
+	}
+	lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
+
+	return 0;
+}
+
+/**
+ * __lpfc_sli_issue_iocb - Wrapper func of lockless version for issuing iocb
+ *
+ * This routine wraps the actual lockless version for issusing IOCB function
+ * pointer from the lpfc_hba struct.
+ *
+ * Return codes:
+ * 	IOCB_ERROR - Error
+ * 	IOCB_SUCCESS - Success
+ * 	IOCB_BUSY - Busy
+ **/
+static inline int
+__lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
+		struct lpfc_iocbq *piocb, uint32_t flag)
+{
+	return phba->__lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
+}
+
+/**
+ * lpfc_sli_api_table_setup - Set up sli api fucntion jump table
+ * @phba: The hba struct for which this call is being executed.
+ * @dev_grp: The HBA PCI-Device group number.
+ *
+ * This routine sets up the SLI interface API function jump table in @phba
+ * struct.
+ * Returns: 0 - success, -ENODEV - failure.
+ **/
+int
+lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
+{
+
+	switch (dev_grp) {
+	case LPFC_PCI_DEV_LP:
+		phba->__lpfc_sli_issue_iocb = __lpfc_sli_issue_iocb_s3;
+		phba->__lpfc_sli_release_iocbq = __lpfc_sli_release_iocbq_s3;
+		break;
+	case LPFC_PCI_DEV_OC:
+		phba->__lpfc_sli_issue_iocb = __lpfc_sli_issue_iocb_s4;
+		phba->__lpfc_sli_release_iocbq = __lpfc_sli_release_iocbq_s4;
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1419 Invalid HBA PCI-device group: 0x%x\n",
+				dev_grp);
+		return -ENODEV;
+		break;
+	}
+	phba->lpfc_get_iocb_from_iocbq = lpfc_get_iocb_from_iocbq;
+	return 0;
+}
+
+/**
+ * lpfc_sli_issue_iocb - Wrapper function for __lpfc_sli_issue_iocb
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @piocb: Pointer to command iocb.
+ * @flag: Flag indicating if this command can be put into txq.
+ *
+ * lpfc_sli_issue_iocb is a wrapper around __lpfc_sli_issue_iocb
+ * function. This function gets the hbalock and calls
+ * __lpfc_sli_issue_iocb function and will return the error returned
+ * by __lpfc_sli_issue_iocb function. This wrapper is used by
+ * functions which do not hold hbalock.
+ **/
+int
+lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
+		    struct lpfc_iocbq *piocb, uint32_t flag)
+{
+	unsigned long iflags;
+	int rc;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	return rc;
+}
+
+/**
+ * lpfc_extra_ring_setup - Extra ring setup function
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called while driver attaches with the
+ * HBA to setup the extra ring. The extra ring is used
+ * only when driver needs to support target mode functionality
+ * or IP over FC functionalities.
+ *
+ * This function is called with no lock held.
+ **/
+static int
+lpfc_extra_ring_setup( struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli;
+	struct lpfc_sli_ring *pring;
+
+	psli = &phba->sli;
+
+	/* Adjust cmd/rsp ring iocb entries more evenly */
 
 	/* Take some away from the FCP ring */
 	pring = &psli->ring[psli->fcp_ring];
@@ -7152,3 +8076,664 @@ lpfc_sli_intr_handler(int irq, void *dev
 	/* Return device-level interrupt handling status */
 	return (sp_irq_rc == IRQ_HANDLED) ? sp_irq_rc : fp_irq_rc;
 }  /* lpfc_sli_intr_handler */
+
+/**
+ * lpfc_sli4_fcp_xri_abort_event_proc - Process fcp xri abort event
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked by the worker thread to process all the pending
+ * SLI4 FCP abort XRI events.
+ **/
+void lpfc_sli4_fcp_xri_abort_event_proc(struct lpfc_hba *phba)
+{
+	struct lpfc_cq_event *cq_event;
+
+	/* First, declare the fcp xri abort event has been handled */
+	spin_lock_irq(&phba->hbalock);
+	phba->hba_flag &= ~FCP_XRI_ABORT_EVENT;
+	spin_unlock_irq(&phba->hbalock);
+	/* Now, handle all the fcp xri abort events */
+	while (!list_empty(&phba->sli4_hba.sp_fcp_xri_aborted_work_queue)) {
+		/* Get the first event from the head of the event queue */
+		spin_lock_irq(&phba->hbalock);
+		list_remove_head(&phba->sli4_hba.sp_fcp_xri_aborted_work_queue,
+				 cq_event, struct lpfc_cq_event, list);
+		spin_unlock_irq(&phba->hbalock);
+		/* Notify aborted XRI for FCP work queue */
+		lpfc_sli4_fcp_xri_aborted(phba, &cq_event->cqe.wcqe_axri);
+		/* Free the event processed back to the free pool */
+		lpfc_sli4_cq_event_release(phba, cq_event);
+	}
+}
+
+/**
+ * lpfc_sli4_els_xri_abort_event_proc - Process els xri abort event
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked by the worker thread to process all the pending
+ * SLI4 els abort xri events.
+ **/
+void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba)
+{
+	struct lpfc_cq_event *cq_event;
+
+	/* First, declare the els xri abort event has been handled */
+	spin_lock_irq(&phba->hbalock);
+	phba->hba_flag &= ~ELS_XRI_ABORT_EVENT;
+	spin_unlock_irq(&phba->hbalock);
+	/* Now, handle all the els xri abort events */
+	while (!list_empty(&phba->sli4_hba.sp_els_xri_aborted_work_queue)) {
+		/* Get the first event from the head of the event queue */
+		spin_lock_irq(&phba->hbalock);
+		list_remove_head(&phba->sli4_hba.sp_els_xri_aborted_work_queue,
+				 cq_event, struct lpfc_cq_event, list);
+		spin_unlock_irq(&phba->hbalock);
+		/* Notify aborted XRI for ELS work queue */
+		lpfc_sli4_els_xri_aborted(phba, &cq_event->cqe.wcqe_axri);
+		/* Free the event processed back to the free pool */
+		lpfc_sli4_cq_event_release(phba, cq_event);
+	}
+}
+
+static void
+lpfc_sli4_iocb_param_transfer(struct lpfc_iocbq *pIocbIn,
+			      struct lpfc_iocbq *pIocbOut,
+			      struct lpfc_wcqe_complete *wcqe)
+{
+	size_t offset = offsetof(struct lpfc_iocbq, iocb);
+
+	memcpy((char *)pIocbIn + offset, (char *)pIocbOut + offset,
+	       sizeof(struct lpfc_iocbq) - offset);
+	memset(&pIocbIn->sli4_info, 0,
+	       sizeof(struct lpfc_sli4_rspiocb_info));
+	/* Map WCQE parameters into irspiocb parameters */
+	pIocbIn->iocb.ulpStatus = bf_get(lpfc_wcqe_c_status, wcqe);
+	if (pIocbOut->iocb_flag & LPFC_IO_FCP)
+		if (pIocbIn->iocb.ulpStatus == IOSTAT_FCP_RSP_ERROR)
+			pIocbIn->iocb.un.fcpi.fcpi_parm =
+					pIocbOut->iocb.un.fcpi.fcpi_parm -
+					wcqe->total_data_placed;
+		else
+			pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
+	else
+		pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
+	/* Load in additional WCQE parameters */
+	pIocbIn->sli4_info.hw_status = bf_get(lpfc_wcqe_c_hw_status, wcqe);
+	pIocbIn->sli4_info.bfield = 0;
+	if (bf_get(lpfc_wcqe_c_xb, wcqe))
+		pIocbIn->sli4_info.bfield |= LPFC_XB;
+	if (bf_get(lpfc_wcqe_c_pv, wcqe)) {
+		pIocbIn->sli4_info.bfield |= LPFC_PV;
+		pIocbIn->sli4_info.priority =
+					bf_get(lpfc_wcqe_c_priority, wcqe);
+	}
+}
+
+/**
+ * lpfc_sli4_sp_handle_els_wcqe - Handle els work-queue completion event
+ * @phba: Pointer to HBA context object.
+ * @wcqe: Pointer to work-queue completion queue entry.
+ *
+ * This routine handles an ELS work-queue completion event.
+ *
+ * Return: true if work posted to worker thread, otherwise false.
+ **/
+static bool
+lpfc_sli4_sp_handle_els_wcqe(struct lpfc_hba *phba,
+			     struct lpfc_wcqe_complete *wcqe)
+{
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_iocbq *cmdiocbq;
+	struct lpfc_iocbq *irspiocbq;
+	unsigned long iflags;
+	bool workposted = false;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	pring->stats.iocb_event++;
+	/* Look up the ELS command IOCB and create pseudo response IOCB */
+	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
+				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	if (unlikely(!cmdiocbq)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"0386 ELS complete with no corresponding "
+				"cmdiocb: iotag (%d)\n",
+				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+		return workposted;
+	}
+
+	/* Fake the irspiocbq and copy necessary response information */
+	irspiocbq = lpfc_sli_get_iocbq(phba);
+	if (!irspiocbq) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0387 Failed to allocate an iocbq\n");
+		return workposted;
+	}
+	lpfc_sli4_iocb_param_transfer(irspiocbq, cmdiocbq, wcqe);
+
+	/* Add the irspiocb to the response IOCB work list */
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	list_add_tail(&irspiocbq->list, &phba->sli4_hba.sp_rspiocb_work_queue);
+	/* Indicate ELS ring attention */
+	phba->work_ha |= (HA_R0ATT << (4*LPFC_ELS_RING));
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	workposted = true;
+
+	return workposted;
+}
+
+/**
+ * lpfc_sli4_sp_handle_rel_wcqe - Handle slow-path WQ entry consumed event
+ * @phba: Pointer to HBA context object.
+ * @wcqe: Pointer to work-queue completion queue entry.
+ *
+ * This routine handles slow-path WQ entry comsumed event by invoking the
+ * proper WQ release routine to the slow-path WQ.
+ **/
+static void
+lpfc_sli4_sp_handle_rel_wcqe(struct lpfc_hba *phba,
+			     struct lpfc_wcqe_release *wcqe)
+{
+	/* Check for the slow-path ELS work queue */
+	if (bf_get(lpfc_wcqe_r_wq_id, wcqe) == phba->sli4_hba.els_wq->queue_id)
+		lpfc_sli4_wq_release(phba->sli4_hba.els_wq,
+				     bf_get(lpfc_wcqe_r_wqe_index, wcqe));
+	else
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"2579 Slow-path wqe consume event carries "
+				"miss-matched qid: wcqe-qid=x%x, sp-qid=x%x\n",
+				bf_get(lpfc_wcqe_r_wqe_index, wcqe),
+				phba->sli4_hba.els_wq->queue_id);
+}
+
+/**
+ * lpfc_sli4_sp_handle_abort_xri_wcqe - Handle a xri abort event
+ * @phba: Pointer to HBA context object.
+ * @cq: Pointer to a WQ completion queue.
+ * @wcqe: Pointer to work-queue completion queue entry.
+ *
+ * This routine handles an XRI abort event.
+ *
+ * Return: true if work posted to worker thread, otherwise false.
+ **/
+static bool
+lpfc_sli4_sp_handle_abort_xri_wcqe(struct lpfc_hba *phba,
+				   struct lpfc_queue *cq,
+				   struct sli4_wcqe_xri_aborted *wcqe)
+{
+	bool workposted = false;
+	struct lpfc_cq_event *cq_event;
+	unsigned long iflags;
+
+	/* Allocate a new internal CQ_EVENT entry */
+	cq_event = lpfc_sli4_cq_event_alloc(phba);
+	if (!cq_event) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0602 Failed to allocate CQ_EVENT entry\n");
+		return false;
+	}
+
+	/* Move the CQE into the proper xri abort event list */
+	memcpy(&cq_event->cqe, wcqe, sizeof(struct sli4_wcqe_xri_aborted));
+	switch (cq->subtype) {
+	case LPFC_FCP:
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		list_add_tail(&cq_event->list,
+			      &phba->sli4_hba.sp_fcp_xri_aborted_work_queue);
+		/* Set the fcp xri abort event flag */
+		phba->hba_flag |= FCP_XRI_ABORT_EVENT;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		workposted = true;
+		break;
+	case LPFC_ELS:
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		list_add_tail(&cq_event->list,
+			      &phba->sli4_hba.sp_els_xri_aborted_work_queue);
+		/* Set the els xri abort event flag */
+		phba->hba_flag |= ELS_XRI_ABORT_EVENT;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		workposted = true;
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0603 Invalid work queue CQE subtype (x%x)\n",
+				cq->subtype);
+		workposted = false;
+		break;
+	}
+	return workposted;
+}
+
+/**
+ * lpfc_sli4_sp_handle_wcqe - Process a work-queue completion queue entry
+ * @phba: Pointer to HBA context object.
+ * @cq: Pointer to the completion queue.
+ * @wcqe: Pointer to a completion queue entry.
+ *
+ * This routine process a slow-path work-queue completion queue entry.
+ *
+ * Return: true if work posted to worker thread, otherwise false.
+ **/
+static bool
+lpfc_sli4_sp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
+			 struct lpfc_cqe *cqe)
+{
+	struct lpfc_wcqe_complete wcqe;
+	bool workposted = false;
+
+	/* Copy the work queue CQE and convert endian order if needed */
+	lpfc_sli_pcimem_bcopy(cqe, &wcqe, sizeof(struct lpfc_cqe));
+
+	/* Check and process for different type of WCQE and dispatch */
+	switch (bf_get(lpfc_wcqe_c_code, &wcqe)) {
+	case CQE_CODE_COMPL_WQE:
+		/* Process the WQ complete event */
+		workposted = lpfc_sli4_sp_handle_els_wcqe(phba,
+					(struct lpfc_wcqe_complete *)&wcqe);
+		break;
+	case CQE_CODE_RELEASE_WQE:
+		/* Process the WQ release event */
+		lpfc_sli4_sp_handle_rel_wcqe(phba,
+					(struct lpfc_wcqe_release *)&wcqe);
+		break;
+	case CQE_CODE_XRI_ABORTED:
+		/* Process the WQ XRI abort event */
+		workposted = lpfc_sli4_sp_handle_abort_xri_wcqe(phba, cq,
+					(struct sli4_wcqe_xri_aborted *)&wcqe);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0388 Not a valid WCQE code: x%x\n",
+				bf_get(lpfc_wcqe_c_code, &wcqe));
+		break;
+	}
+	return workposted;
+}
+
+/**
+ * lpfc_sli4_sp_handle_rcqe - Process a receive-queue completion queue entry
+ * @phba: Pointer to HBA context object.
+ * @rcqe: Pointer to receive-queue completion queue entry.
+ *
+ * This routine process a receive-queue completion queue entry.
+ *
+ * Return: true if work posted to worker thread, otherwise false.
+ **/
+static bool
+lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_cqe *cqe)
+{
+	struct lpfc_rcqe rcqe;
+	bool workposted = false;
+	struct lpfc_queue *hrq = phba->sli4_hba.hdr_rq;
+	struct lpfc_queue *drq = phba->sli4_hba.dat_rq;
+	struct hbq_dmabuf *dma_buf;
+	uint32_t status;
+	unsigned long iflags;
+
+	/* Copy the receive queue CQE and convert endian order if needed */
+	lpfc_sli_pcimem_bcopy(cqe, &rcqe, sizeof(struct lpfc_rcqe));
+	lpfc_sli4_rq_release(hrq, drq);
+	if (bf_get(lpfc_rcqe_code, &rcqe) != CQE_CODE_RECEIVE)
+		goto out;
+	if (bf_get(lpfc_rcqe_rq_id, &rcqe) != hrq->queue_id)
+		goto out;
+
+	status = bf_get(lpfc_rcqe_status, &rcqe);
+	switch (status) {
+	case FC_STATUS_RQ_BUF_LEN_EXCEEDED:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2537 Receive Frame Truncated!!\n");
+	case FC_STATUS_RQ_SUCCESS:
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		dma_buf = lpfc_sli_hbqbuf_get(&phba->hbqs[0].hbq_buffer_list);
+		if (!dma_buf) {
+			spin_unlock_irqrestore(&phba->hbalock, iflags);
+			goto out;
+		}
+		memcpy(&dma_buf->rcqe, &rcqe, sizeof(rcqe));
+		/* save off the frame for the word thread to process */
+		list_add_tail(&dma_buf->dbuf.list, &phba->rb_pend_list);
+		/* Frame received */
+		phba->hba_flag |= HBA_RECEIVE_BUFFER;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		workposted = true;
+		break;
+	case FC_STATUS_INSUFF_BUF_NEED_BUF:
+	case FC_STATUS_INSUFF_BUF_FRM_DISC:
+		/* Post more buffers if possible */
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		phba->hba_flag |= HBA_POST_RECEIVE_BUFFER;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		workposted = true;
+		break;
+	}
+out:
+	return workposted;
+
+}
+
+/**
+ * lpfc_sli4_sp_handle_eqe - Process a slow-path event queue entry
+ * @phba: Pointer to HBA context object.
+ * @eqe: Pointer to fast-path event queue entry.
+ *
+ * This routine process a event queue entry from the slow-path event queue.
+ * It will check the MajorCode and MinorCode to determine this is for a
+ * completion event on a completion queue, if not, an error shall be logged
+ * and just return. Otherwise, it will get to the corresponding completion
+ * queue and process all the entries on that completion queue, rearm the
+ * completion queue, and then return.
+ *
+ **/
+static void
+lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
+{
+	struct lpfc_queue *cq = NULL, *childq, *speq;
+	struct lpfc_cqe *cqe;
+	bool workposted = false;
+	int ecount = 0;
+	uint16_t cqid;
+
+	if (bf_get(lpfc_eqe_major_code, eqe) != 0 ||
+	    bf_get(lpfc_eqe_minor_code, eqe) != 0) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0359 Not a valid slow-path completion "
+				"event: majorcode=x%x, minorcode=x%x\n",
+				bf_get(lpfc_eqe_major_code, eqe),
+				bf_get(lpfc_eqe_minor_code, eqe));
+		return;
+	}
+
+	/* Get the reference to the corresponding CQ */
+	cqid = bf_get(lpfc_eqe_resource_id, eqe);
+
+	/* Search for completion queue pointer matching this cqid */
+	speq = phba->sli4_hba.sp_eq;
+	list_for_each_entry(childq, &speq->child_list, list) {
+		if (childq->queue_id == cqid) {
+			cq = childq;
+			break;
+		}
+	}
+	if (unlikely(!cq)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0365 Slow-path CQ identifier (%d) does "
+				"not exist\n", cqid);
+		return;
+	}
+
+	/* Process all the entries to the CQ */
+	switch (cq->type) {
+	case LPFC_MCQ:
+		while ((cqe = lpfc_sli4_cq_get(cq))) {
+			workposted |= lpfc_sli4_sp_handle_mcqe(phba, cqe);
+			if (!(++ecount % LPFC_GET_QE_REL_INT))
+				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+		}
+		break;
+	case LPFC_WCQ:
+		while ((cqe = lpfc_sli4_cq_get(cq))) {
+			workposted |= lpfc_sli4_sp_handle_wcqe(phba, cq, cqe);
+			if (!(++ecount % LPFC_GET_QE_REL_INT))
+				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+		}
+		break;
+	case LPFC_RCQ:
+		while ((cqe = lpfc_sli4_cq_get(cq))) {
+			workposted |= lpfc_sli4_sp_handle_rcqe(phba, cqe);
+			if (!(++ecount % LPFC_GET_QE_REL_INT))
+				lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+		}
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0370 Invalid completion queue type (%d)\n",
+				cq->type);
+		return;
+	}
+
+	/* Catch the no cq entry condition, log an error */
+	if (unlikely(ecount == 0))
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0371 No entry from the CQ: identifier "
+				"(x%x), type (%d)\n", cq->queue_id, cq->type);
+
+	/* In any case, flash and re-arm the RCQ */
+	lpfc_sli4_cq_release(cq, LPFC_QUEUE_REARM);
+
+	/* wake up worker thread if there are works to be done */
+	if (workposted)
+		lpfc_worker_wake_up(phba);
+}
+
+/**
+ * lpfc_sli4_fp_handle_fcp_wcqe - Process fast-path work queue completion entry
+ * @eqe: Pointer to fast-path completion queue entry.
+ *
+ * This routine process a fast-path work queue completion entry from fast-path
+ * event queue for FCP command response completion.
+ **/
+static void
+lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba,
+			     struct lpfc_wcqe_complete *wcqe)
+{
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_FCP_RING];
+	struct lpfc_iocbq *cmdiocbq;
+	struct lpfc_iocbq irspiocbq;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	pring->stats.iocb_event++;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	/* Check for response status */
+	if (unlikely(bf_get(lpfc_wcqe_c_status, wcqe))) {
+		/* If resource errors reported from HBA, reduce queue
+		 * depth of the SCSI device.
+		 */
+		if ((bf_get(lpfc_wcqe_c_status, wcqe) ==
+		     IOSTAT_LOCAL_REJECT) &&
+		    (wcqe->parameter == IOERR_NO_RESOURCES)) {
+			phba->lpfc_rampdown_queue_depth(phba);
+		}
+		/* Log the error status */
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"0373 FCP complete error: status=x%x, "
+				"hw_status=x%x, total_data_specified=%d, "
+				"parameter=x%x, word3=x%x\n",
+				bf_get(lpfc_wcqe_c_status, wcqe),
+				bf_get(lpfc_wcqe_c_hw_status, wcqe),
+				wcqe->total_data_placed, wcqe->parameter,
+				wcqe->word3);
+	}
+
+	/* Look up the FCP command IOCB and create pseudo response IOCB */
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
+				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	if (unlikely(!cmdiocbq)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"0374 FCP complete with no corresponding "
+				"cmdiocb: iotag (%d)\n",
+				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+		return;
+	}
+	if (unlikely(!cmdiocbq->iocb_cmpl)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"0375 FCP cmdiocb not callback function "
+				"iotag: (%d)\n",
+				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+		return;
+	}
+
+	/* Fake the irspiocb and copy necessary response information */
+	lpfc_sli4_iocb_param_transfer(&irspiocbq, cmdiocbq, wcqe);
+
+	/* Pass the cmd_iocb and the rsp state to the upper layer */
+	(cmdiocbq->iocb_cmpl)(phba, cmdiocbq, &irspiocbq);
+}
+
+/**
+ * lpfc_sli4_fp_handle_rel_wcqe - Handle fast-path WQ entry consumed event
+ * @phba: Pointer to HBA context object.
+ * @cq: Pointer to completion queue.
+ * @wcqe: Pointer to work-queue completion queue entry.
+ *
+ * This routine handles an fast-path WQ entry comsumed event by invoking the
+ * proper WQ release routine to the slow-path WQ.
+ **/
+static void
+lpfc_sli4_fp_handle_rel_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
+			     struct lpfc_wcqe_release *wcqe)
+{
+	struct lpfc_queue *childwq;
+	bool wqid_matched = false;
+	uint16_t fcp_wqid;
+
+	/* Check for fast-path FCP work queue release */
+	fcp_wqid = bf_get(lpfc_wcqe_r_wq_id, wcqe);
+	list_for_each_entry(childwq, &cq->child_list, list) {
+		if (childwq->queue_id == fcp_wqid) {
+			lpfc_sli4_wq_release(childwq,
+					bf_get(lpfc_wcqe_r_wqe_index, wcqe));
+			wqid_matched = true;
+			break;
+		}
+	}
+	/* Report warning log message if no match found */
+	if (wqid_matched != true)
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"2580 Fast-path wqe consume event carries "
+				"miss-matched qid: wcqe-qid=x%x\n", fcp_wqid);
+}
+
+/**
+ * lpfc_sli4_fp_handle_wcqe - Process fast-path work queue completion entry
+ * @cq: Pointer to the completion queue.
+ * @eqe: Pointer to fast-path completion queue entry.
+ *
+ * This routine process a fast-path work queue completion entry from fast-path
+ * event queue for FCP command response completion.
+ **/
+static int
+lpfc_sli4_fp_handle_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
+			 struct lpfc_cqe *cqe)
+{
+	struct lpfc_wcqe_release wcqe;
+	bool workposted = false;
+
+	/* Copy the work queue CQE and convert endian order if needed */
+	lpfc_sli_pcimem_bcopy(cqe, &wcqe, sizeof(struct lpfc_cqe));
+
+	/* Check and process for different type of WCQE and dispatch */
+	switch (bf_get(lpfc_wcqe_c_code, &wcqe)) {
+	case CQE_CODE_COMPL_WQE:
+		/* Process the WQ complete event */
+		lpfc_sli4_fp_handle_fcp_wcqe(phba,
+				(struct lpfc_wcqe_complete *)&wcqe);
+		break;
+	case CQE_CODE_RELEASE_WQE:
+		/* Process the WQ release event */
+		lpfc_sli4_fp_handle_rel_wcqe(phba, cq,
+				(struct lpfc_wcqe_release *)&wcqe);
+		break;
+	case CQE_CODE_XRI_ABORTED:
+		/* Process the WQ XRI abort event */
+		workposted = lpfc_sli4_sp_handle_abort_xri_wcqe(phba, cq,
+				(struct sli4_wcqe_xri_aborted *)&wcqe);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0144 Not a valid WCQE code: x%x\n",
+				bf_get(lpfc_wcqe_c_code, &wcqe));
+		break;
+	}
+	return workposted;
+}
+
+/**
+ * lpfc_sli4_fp_handle_eqe - Process a fast-path event queue entry
+ * @phba: Pointer to HBA context object.
+ * @eqe: Pointer to fast-path event queue entry.
+ *
+ * This routine process a event queue entry from the fast-path event queue.
+ * It will check the MajorCode and MinorCode to determine this is for a
+ * completion event on a completion queue, if not, an error shall be logged
+ * and just return. Otherwise, it will get to the corresponding completion
+ * queue and process all the entries on the completion queue, rearm the
+ * completion queue, and then return.
+ **/
+static void
+lpfc_sli4_fp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
+			uint32_t fcp_cqidx)
+{
+	struct lpfc_queue *cq;
+	struct lpfc_cqe *cqe;
+	bool workposted = false;
+	uint16_t cqid;
+	int ecount = 0;
+
+	if (unlikely(bf_get(lpfc_eqe_major_code, eqe) != 0) ||
+	    unlikely(bf_get(lpfc_eqe_minor_code, eqe) != 0)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0366 Not a valid fast-path completion "
+				"event: majorcode=x%x, minorcode=x%x\n",
+				bf_get(lpfc_eqe_major_code, eqe),
+				bf_get(lpfc_eqe_minor_code, eqe));
+		return;
+	}
+
+	cq = phba->sli4_hba.fcp_cq[fcp_cqidx];
+	if (unlikely(!cq)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0367 Fast-path completion queue does not "
+				"exist\n");
+		return;
+	}
+
+	/* Get the reference to the corresponding CQ */
+	cqid = bf_get(lpfc_eqe_resource_id, eqe);
+	if (unlikely(cqid != cq->queue_id)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0368 Miss-matched fast-path completion "
+				"queue identifier: eqcqid=%d, fcpcqid=%d\n",
+				cqid, cq->queue_id);
+		return;
+	}
+
+	/* Process all the entries to the CQ */
+	while ((cqe = lpfc_sli4_cq_get(cq))) {
+		workposted |= lpfc_sli4_fp_handle_wcqe(phba, cq, cqe);
+		if (!(++ecount % LPFC_GET_QE_REL_INT))
+			lpfc_sli4_cq_release(cq, LPFC_QUEUE_NOARM);
+	}
+
+	/* Catch the no cq entry condition */
+	if (unlikely(ecount == 0))
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0369 No entry from fast-path completion "
+				"queue fcpcqid=%d\n", cq->queue_id);
+
+	/* In any case, flash and re-arm the CQ */
+	lpfc_sli4_cq_release(cq, LPFC_QUEUE_REARM);
+
+	/* wake up worker thread if there are works to be done */
+	if (workposted)
+		lpfc_worker_wake_up(phba);
+}
+
+static void
+lpfc_sli4_eq_flush(struct lpfc_hba *phba, struct lpfc_queue *eq)
+{
+	struct lpfc_eqe *eqe;
+
+	/* walk all the EQ entries and drop on the floor */
+	while ((eqe = lpfc_sli4_eq_get(eq)))
+		;
+
+	/* Clear and re-arm the EQ */
+	lpfc_sli4_eq_release(eq, LPFC_QUEUE_REARM);
+}
+


