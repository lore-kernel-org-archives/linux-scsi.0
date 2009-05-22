From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 11/17] lpfc 8.3.2 : Addition of SLI4 Interface - Queues -
	Part 2 of 2
Date: Fri, 22 May 2009 14:52:46 -0400
Message-ID: <1243018366.7729.59.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42173 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbZEVSwv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:52:51 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIqqle029895
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:52:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Addition of SLI4 Interface - Queues - Part 2 of 2

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

 lpfc_sli.c | 1797 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 1797 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 13:18:00.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 13:18:16.000000000 -0400
@@ -8737,3 +8737,1800 @@ lpfc_sli4_eq_flush(struct lpfc_hba *phba
 	lpfc_sli4_eq_release(eq, LPFC_QUEUE_REARM);
 }
 
+/**
+ * lpfc_sli4_sp_intr_handler - Slow-path interrupt handler to SLI-4 device
+ * @irq: Interrupt number.
+ * @dev_id: The device context pointer.
+ *
+ * This function is directly called from the PCI layer as an interrupt
+ * service routine when device with SLI-4 interface spec is enabled with
+ * MSI-X multi-message interrupt mode and there are slow-path events in
+ * the HBA. However, when the device is enabled with either MSI or Pin-IRQ
+ * interrupt mode, this function is called as part of the device-level
+ * interrupt handler. When the PCI slot is in error recovery or the HBA is
+ * undergoing initialization, the interrupt handler will not process the
+ * interrupt. The link attention and ELS ring attention events are handled
+ * by the worker thread. The interrupt handler signals the worker thread
+ * and returns for these events. This function is called without any lock
+ * held. It gets the hbalock to access and update SLI data structures.
+ *
+ * This function returns IRQ_HANDLED when interrupt is handled else it
+ * returns IRQ_NONE.
+ **/
+irqreturn_t
+lpfc_sli4_sp_intr_handler(int irq, void *dev_id)
+{
+	struct lpfc_hba *phba;
+	struct lpfc_queue *speq;
+	struct lpfc_eqe *eqe;
+	unsigned long iflag;
+	int ecount = 0;
+
+	/*
+	 * Get the driver's phba structure from the dev_id
+	 */
+	phba = (struct lpfc_hba *)dev_id;
+
+	if (unlikely(!phba))
+		return IRQ_NONE;
+
+	/* Get to the EQ struct associated with this vector */
+	speq = phba->sli4_hba.sp_eq;
+
+	/* Check device state for handling interrupt */
+	if (unlikely(lpfc_intr_state_check(phba))) {
+		/* Check again for link_state with lock held */
+		spin_lock_irqsave(&phba->hbalock, iflag);
+		if (phba->link_state < LPFC_LINK_DOWN)
+			/* Flush, clear interrupt, and rearm the EQ */
+			lpfc_sli4_eq_flush(phba, speq);
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		return IRQ_NONE;
+	}
+
+	/*
+	 * Process all the event on FCP slow-path EQ
+	 */
+	while ((eqe = lpfc_sli4_eq_get(speq))) {
+		lpfc_sli4_sp_handle_eqe(phba, eqe);
+		if (!(++ecount % LPFC_GET_QE_REL_INT))
+			lpfc_sli4_eq_release(speq, LPFC_QUEUE_NOARM);
+	}
+
+	/* Always clear and re-arm the slow-path EQ */
+	lpfc_sli4_eq_release(speq, LPFC_QUEUE_REARM);
+
+	/* Catch the no cq entry condition */
+	if (unlikely(ecount == 0)) {
+		if (phba->intr_type == MSIX)
+			/* MSI-X treated interrupt served as no EQ share INT */
+			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+					"0357 MSI-X interrupt with no EQE\n");
+		else
+			/* Non MSI-X treated on interrupt as EQ share INT */
+			return IRQ_NONE;
+	}
+
+	return IRQ_HANDLED;
+} /* lpfc_sli4_sp_intr_handler */
+
+/**
+ * lpfc_sli4_fp_intr_handler - Fast-path interrupt handler to SLI-4 device
+ * @irq: Interrupt number.
+ * @dev_id: The device context pointer.
+ *
+ * This function is directly called from the PCI layer as an interrupt
+ * service routine when device with SLI-4 interface spec is enabled with
+ * MSI-X multi-message interrupt mode and there is a fast-path FCP IOCB
+ * ring event in the HBA. However, when the device is enabled with either
+ * MSI or Pin-IRQ interrupt mode, this function is called as part of the
+ * device-level interrupt handler. When the PCI slot is in error recovery
+ * or the HBA is undergoing initialization, the interrupt handler will not
+ * process the interrupt. The SCSI FCP fast-path ring event are handled in
+ * the intrrupt context. This function is called without any lock held.
+ * It gets the hbalock to access and update SLI data structures. Note that,
+ * the FCP EQ to FCP CQ are one-to-one map such that the FCP EQ index is
+ * equal to that of FCP CQ index.
+ *
+ * This function returns IRQ_HANDLED when interrupt is handled else it
+ * returns IRQ_NONE.
+ **/
+irqreturn_t
+lpfc_sli4_fp_intr_handler(int irq, void *dev_id)
+{
+	struct lpfc_hba *phba;
+	struct lpfc_fcp_eq_hdl *fcp_eq_hdl;
+	struct lpfc_queue *fpeq;
+	struct lpfc_eqe *eqe;
+	unsigned long iflag;
+	int ecount = 0;
+	uint32_t fcp_eqidx;
+
+	/* Get the driver's phba structure from the dev_id */
+	fcp_eq_hdl = (struct lpfc_fcp_eq_hdl *)dev_id;
+	phba = fcp_eq_hdl->phba;
+	fcp_eqidx = fcp_eq_hdl->idx;
+
+	if (unlikely(!phba))
+		return IRQ_NONE;
+
+	/* Get to the EQ struct associated with this vector */
+	fpeq = phba->sli4_hba.fp_eq[fcp_eqidx];
+
+	/* Check device state for handling interrupt */
+	if (unlikely(lpfc_intr_state_check(phba))) {
+		/* Check again for link_state with lock held */
+		spin_lock_irqsave(&phba->hbalock, iflag);
+		if (phba->link_state < LPFC_LINK_DOWN)
+			/* Flush, clear interrupt, and rearm the EQ */
+			lpfc_sli4_eq_flush(phba, fpeq);
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		return IRQ_NONE;
+	}
+
+	/*
+	 * Process all the event on FCP fast-path EQ
+	 */
+	while ((eqe = lpfc_sli4_eq_get(fpeq))) {
+		lpfc_sli4_fp_handle_eqe(phba, eqe, fcp_eqidx);
+		if (!(++ecount % LPFC_GET_QE_REL_INT))
+			lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_NOARM);
+	}
+
+	/* Always clear and re-arm the fast-path EQ */
+	lpfc_sli4_eq_release(fpeq, LPFC_QUEUE_REARM);
+
+	if (unlikely(ecount == 0)) {
+		if (phba->intr_type == MSIX)
+			/* MSI-X treated interrupt served as no EQ share INT */
+			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+					"0358 MSI-X interrupt with no EQE\n");
+		else
+			/* Non MSI-X treated on interrupt as EQ share INT */
+			return IRQ_NONE;
+	}
+
+	return IRQ_HANDLED;
+} /* lpfc_sli4_fp_intr_handler */
+
+/**
+ * lpfc_sli4_intr_handler - Device-level interrupt handler for SLI-4 device
+ * @irq: Interrupt number.
+ * @dev_id: The device context pointer.
+ *
+ * This function is the device-level interrupt handler to device with SLI-4
+ * interface spec, called from the PCI layer when either MSI or Pin-IRQ
+ * interrupt mode is enabled and there is an event in the HBA which requires
+ * driver attention. This function invokes the slow-path interrupt attention
+ * handling function and fast-path interrupt attention handling function in
+ * turn to process the relevant HBA attention events. This function is called
+ * without any lock held. It gets the hbalock to access and update SLI data
+ * structures.
+ *
+ * This function returns IRQ_HANDLED when interrupt is handled, else it
+ * returns IRQ_NONE.
+ **/
+irqreturn_t
+lpfc_sli4_intr_handler(int irq, void *dev_id)
+{
+	struct lpfc_hba  *phba;
+	irqreturn_t sp_irq_rc, fp_irq_rc;
+	bool fp_handled = false;
+	uint32_t fcp_eqidx;
+
+	/* Get the driver's phba structure from the dev_id */
+	phba = (struct lpfc_hba *)dev_id;
+
+	if (unlikely(!phba))
+		return IRQ_NONE;
+
+	/*
+	 * Invokes slow-path host attention interrupt handling as appropriate.
+	 */
+	sp_irq_rc = lpfc_sli4_sp_intr_handler(irq, dev_id);
+
+	/*
+	 * Invoke fast-path host attention interrupt handling as appropriate.
+	 */
+	for (fcp_eqidx = 0; fcp_eqidx < phba->cfg_fcp_eq_count; fcp_eqidx++) {
+		fp_irq_rc = lpfc_sli4_fp_intr_handler(irq,
+					&phba->sli4_hba.fcp_eq_hdl[fcp_eqidx]);
+		if (fp_irq_rc == IRQ_HANDLED)
+			fp_handled |= true;
+	}
+
+	return (fp_handled == true) ? IRQ_HANDLED : sp_irq_rc;
+} /* lpfc_sli4_intr_handler */
+
+/**
+ * lpfc_sli4_queue_free - free a queue structure and associated memory
+ * @queue: The queue structure to free.
+ *
+ * This function frees a queue structure and the DMAable memeory used for
+ * the host resident queue. This function must be called after destroying the
+ * queue on the HBA.
+ **/
+void
+lpfc_sli4_queue_free(struct lpfc_queue *queue)
+{
+	struct lpfc_dmabuf *dmabuf;
+
+	if (!queue)
+		return;
+
+	while (!list_empty(&queue->page_list)) {
+		list_remove_head(&queue->page_list, dmabuf, struct lpfc_dmabuf,
+				 list);
+		dma_free_coherent(&queue->phba->pcidev->dev, PAGE_SIZE,
+				  dmabuf->virt, dmabuf->phys);
+		kfree(dmabuf);
+	}
+	kfree(queue);
+	return;
+}
+
+/**
+ * lpfc_sli4_queue_alloc - Allocate and initialize a queue structure
+ * @phba: The HBA that this queue is being created on.
+ * @entry_size: The size of each queue entry for this queue.
+ * @entry count: The number of entries that this queue will handle.
+ *
+ * This function allocates a queue structure and the DMAable memory used for
+ * the host resident queue. This function must be called before creating the
+ * queue on the HBA.
+ **/
+struct lpfc_queue *
+lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t entry_size,
+		      uint32_t entry_count)
+{
+	struct lpfc_queue *queue;
+	struct lpfc_dmabuf *dmabuf;
+	int x, total_qe_count;
+	void *dma_pointer;
+
+
+	queue = kzalloc(sizeof(struct lpfc_queue) +
+			(sizeof(union sli4_qe) * entry_count), GFP_KERNEL);
+	if (!queue)
+		return NULL;
+	queue->page_count = (PAGE_ALIGN(entry_size * entry_count))/PAGE_SIZE;
+	INIT_LIST_HEAD(&queue->list);
+	INIT_LIST_HEAD(&queue->page_list);
+	INIT_LIST_HEAD(&queue->child_list);
+	for (x = 0, total_qe_count = 0; x < queue->page_count; x++) {
+		dmabuf = kzalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+		if (!dmabuf)
+			goto out_fail;
+		dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
+						  PAGE_SIZE, &dmabuf->phys,
+						  GFP_KERNEL);
+		if (!dmabuf->virt) {
+			kfree(dmabuf);
+			goto out_fail;
+		}
+		dmabuf->buffer_tag = x;
+		list_add_tail(&dmabuf->list, &queue->page_list);
+		/* initialize queue's entry array */
+		dma_pointer = dmabuf->virt;
+		for (; total_qe_count < entry_count &&
+		     dma_pointer < (PAGE_SIZE + dmabuf->virt);
+		     total_qe_count++, dma_pointer += entry_size) {
+			queue->qe[total_qe_count].address = dma_pointer;
+		}
+	}
+	queue->entry_size = entry_size;
+	queue->entry_count = entry_count;
+	queue->phba = phba;
+
+	return queue;
+out_fail:
+	lpfc_sli4_queue_free(queue);
+	return NULL;
+}
+
+/**
+ * lpfc_eq_create - Create an Event Queue on the HBA
+ * @phba: HBA structure that indicates port to create a queue on.
+ * @eq: The queue structure to use to create the event queue.
+ * @imax: The maximum interrupt per second limit.
+ *
+ * This function creates an event queue, as detailed in @eq, on a port,
+ * described by @phba by sending an EQ_CREATE mailbox command to the HBA.
+ *
+ * The @phba struct is used to send mailbox command to HBA. The @eq struct
+ * is used to get the entry count and entry size that are necessary to
+ * determine the number of pages to allocate and use for this queue. This
+ * function will send the EQ_CREATE mailbox command to the HBA to setup the
+ * event queue. This function is asynchronous and will wait for the mailbox
+ * command to finish before continuing.
+ *
+ * On success this function will return a zero. If unable to allocate enough
+ * memory this function will return ENOMEM. If the queue create mailbox command
+ * fails this function will return ENXIO.
+ **/
+uint32_t
+lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint16_t imax)
+{
+	struct lpfc_mbx_eq_create *eq_create;
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, status = 0;
+	struct lpfc_dmabuf *dmabuf;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+	uint16_t dmult;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	length = (sizeof(struct lpfc_mbx_eq_create) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_EQ_CREATE,
+			 length, LPFC_SLI4_MBX_EMBED);
+	eq_create = &mbox->u.mqe.un.eq_create;
+	bf_set(lpfc_mbx_eq_create_num_pages, &eq_create->u.request,
+	       eq->page_count);
+	bf_set(lpfc_eq_context_size, &eq_create->u.request.context,
+	       LPFC_EQE_SIZE);
+	bf_set(lpfc_eq_context_valid, &eq_create->u.request.context, 1);
+	/* Calculate delay multiper from maximum interrupt per second */
+	dmult = LPFC_DMULT_CONST/imax - 1;
+	bf_set(lpfc_eq_context_delay_multi, &eq_create->u.request.context,
+	       dmult);
+	switch (eq->entry_count) {
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0360 Unsupported EQ count. (%d)\n",
+				eq->entry_count);
+		if (eq->entry_count < 256)
+			return -EINVAL;
+		/* otherwise default to smallest count (drop through) */
+	case 256:
+		bf_set(lpfc_eq_context_count, &eq_create->u.request.context,
+		       LPFC_EQ_CNT_256);
+		break;
+	case 512:
+		bf_set(lpfc_eq_context_count, &eq_create->u.request.context,
+		       LPFC_EQ_CNT_512);
+		break;
+	case 1024:
+		bf_set(lpfc_eq_context_count, &eq_create->u.request.context,
+		       LPFC_EQ_CNT_1024);
+		break;
+	case 2048:
+		bf_set(lpfc_eq_context_count, &eq_create->u.request.context,
+		       LPFC_EQ_CNT_2048);
+		break;
+	case 4096:
+		bf_set(lpfc_eq_context_count, &eq_create->u.request.context,
+		       LPFC_EQ_CNT_4096);
+		break;
+	}
+	list_for_each_entry(dmabuf, &eq->page_list, list) {
+		eq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
+					putPaddrLow(dmabuf->phys);
+		eq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
+					putPaddrHigh(dmabuf->phys);
+	}
+	mbox->vport = phba->pport;
+	mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	mbox->context1 = NULL;
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	shdr = (union lpfc_sli4_cfg_shdr *) &eq_create->header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2500 EQ_CREATE mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+	}
+	eq->type = LPFC_EQ;
+	eq->subtype = LPFC_NONE;
+	eq->queue_id = bf_get(lpfc_mbx_eq_create_q_id, &eq_create->u.response);
+	if (eq->queue_id == 0xFFFF)
+		status = -ENXIO;
+	eq->host_index = 0;
+	eq->hba_index = 0;
+
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	return status;
+}
+
+/**
+ * lpfc_cq_create - Create a Completion Queue on the HBA
+ * @phba: HBA structure that indicates port to create a queue on.
+ * @cq: The queue structure to use to create the completion queue.
+ * @eq: The event queue to bind this completion queue to.
+ *
+ * This function creates a completion queue, as detailed in @wq, on a port,
+ * described by @phba by sending a CQ_CREATE mailbox command to the HBA.
+ *
+ * The @phba struct is used to send mailbox command to HBA. The @cq struct
+ * is used to get the entry count and entry size that are necessary to
+ * determine the number of pages to allocate and use for this queue. The @eq
+ * is used to indicate which event queue to bind this completion queue to. This
+ * function will send the CQ_CREATE mailbox command to the HBA to setup the
+ * completion queue. This function is asynchronous and will wait for the mailbox
+ * command to finish before continuing.
+ *
+ * On success this function will return a zero. If unable to allocate enough
+ * memory this function will return ENOMEM. If the queue create mailbox command
+ * fails this function will return ENXIO.
+ **/
+uint32_t
+lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
+	       struct lpfc_queue *eq, uint32_t type, uint32_t subtype)
+{
+	struct lpfc_mbx_cq_create *cq_create;
+	struct lpfc_dmabuf *dmabuf;
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, status = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	length = (sizeof(struct lpfc_mbx_cq_create) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_CQ_CREATE,
+			 length, LPFC_SLI4_MBX_EMBED);
+	cq_create = &mbox->u.mqe.un.cq_create;
+	bf_set(lpfc_mbx_cq_create_num_pages, &cq_create->u.request,
+		    cq->page_count);
+	bf_set(lpfc_cq_context_event, &cq_create->u.request.context, 1);
+	bf_set(lpfc_cq_context_valid, &cq_create->u.request.context, 1);
+	bf_set(lpfc_cq_eq_id, &cq_create->u.request.context, eq->queue_id);
+	switch (cq->entry_count) {
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0361 Unsupported CQ count. (%d)\n",
+				cq->entry_count);
+		if (cq->entry_count < 256)
+			return -EINVAL;
+		/* otherwise default to smallest count (drop through) */
+	case 256:
+		bf_set(lpfc_cq_context_count, &cq_create->u.request.context,
+		       LPFC_CQ_CNT_256);
+		break;
+	case 512:
+		bf_set(lpfc_cq_context_count, &cq_create->u.request.context,
+		       LPFC_CQ_CNT_512);
+		break;
+	case 1024:
+		bf_set(lpfc_cq_context_count, &cq_create->u.request.context,
+		       LPFC_CQ_CNT_1024);
+		break;
+	}
+	list_for_each_entry(dmabuf, &cq->page_list, list) {
+		cq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
+					putPaddrLow(dmabuf->phys);
+		cq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
+					putPaddrHigh(dmabuf->phys);
+	}
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *) &cq_create->header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2501 CQ_CREATE mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+		goto out;
+	}
+	cq->queue_id = bf_get(lpfc_mbx_cq_create_q_id, &cq_create->u.response);
+	if (cq->queue_id == 0xFFFF) {
+		status = -ENXIO;
+		goto out;
+	}
+	/* link the cq onto the parent eq child list */
+	list_add_tail(&cq->list, &eq->child_list);
+	/* Set up completion queue's type and subtype */
+	cq->type = type;
+	cq->subtype = subtype;
+	cq->queue_id = bf_get(lpfc_mbx_cq_create_q_id, &cq_create->u.response);
+	cq->host_index = 0;
+	cq->hba_index = 0;
+out:
+
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	return status;
+}
+
+/**
+ * lpfc_wq_create - Create a Work Queue on the HBA
+ * @phba: HBA structure that indicates port to create a queue on.
+ * @wq: The queue structure to use to create the work queue.
+ * @cq: The completion queue to bind this work queue to.
+ * @subtype: The subtype of the work queue indicating its functionality.
+ *
+ * This function creates a work queue, as detailed in @wq, on a port, described
+ * by @phba by sending a WQ_CREATE mailbox command to the HBA.
+ *
+ * The @phba struct is used to send mailbox command to HBA. The @wq struct
+ * is used to get the entry count and entry size that are necessary to
+ * determine the number of pages to allocate and use for this queue. The @cq
+ * is used to indicate which completion queue to bind this work queue to. This
+ * function will send the WQ_CREATE mailbox command to the HBA to setup the
+ * work queue. This function is asynchronous and will wait for the mailbox
+ * command to finish before continuing.
+ *
+ * On success this function will return a zero. If unable to allocate enough
+ * memory this function will return ENOMEM. If the queue create mailbox command
+ * fails this function will return ENXIO.
+ **/
+uint32_t
+lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
+	       struct lpfc_queue *cq, uint32_t subtype)
+{
+	struct lpfc_mbx_wq_create *wq_create;
+	struct lpfc_dmabuf *dmabuf;
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, status = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	length = (sizeof(struct lpfc_mbx_wq_create) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+			 LPFC_MBOX_OPCODE_FCOE_WQ_CREATE,
+			 length, LPFC_SLI4_MBX_EMBED);
+	wq_create = &mbox->u.mqe.un.wq_create;
+	bf_set(lpfc_mbx_wq_create_num_pages, &wq_create->u.request,
+		    wq->page_count);
+	bf_set(lpfc_mbx_wq_create_cq_id, &wq_create->u.request,
+		    cq->queue_id);
+	list_for_each_entry(dmabuf, &wq->page_list, list) {
+		wq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
+					putPaddrLow(dmabuf->phys);
+		wq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
+					putPaddrHigh(dmabuf->phys);
+	}
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *) &wq_create->header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2503 WQ_CREATE mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+		goto out;
+	}
+	wq->queue_id = bf_get(lpfc_mbx_wq_create_q_id, &wq_create->u.response);
+	if (wq->queue_id == 0xFFFF) {
+		status = -ENXIO;
+		goto out;
+	}
+	wq->type = LPFC_WQ;
+	wq->subtype = subtype;
+	wq->host_index = 0;
+	wq->hba_index = 0;
+
+	/* link the wq onto the parent cq child list */
+	list_add_tail(&wq->list, &cq->child_list);
+out:
+	if (rc == MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	return status;
+}
+
+/**
+ * lpfc_rq_create - Create a Receive Queue on the HBA
+ * @phba: HBA structure that indicates port to create a queue on.
+ * @hrq: The queue structure to use to create the header receive queue.
+ * @drq: The queue structure to use to create the data receive queue.
+ * @cq: The completion queue to bind this work queue to.
+ *
+ * This function creates a receive buffer queue pair , as detailed in @hrq and
+ * @drq, on a port, described by @phba by sending a RQ_CREATE mailbox command
+ * to the HBA.
+ *
+ * The @phba struct is used to send mailbox command to HBA. The @drq and @hrq
+ * struct is used to get the entry count that is necessary to determine the
+ * number of pages to use for this queue. The @cq is used to indicate which
+ * completion queue to bind received buffers that are posted to these queues to.
+ * This function will send the RQ_CREATE mailbox command to the HBA to setup the
+ * receive queue pair. This function is asynchronous and will wait for the
+ * mailbox command to finish before continuing.
+ *
+ * On success this function will return a zero. If unable to allocate enough
+ * memory this function will return ENOMEM. If the queue create mailbox command
+ * fails this function will return ENXIO.
+ **/
+uint32_t
+lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
+	       struct lpfc_queue *drq, struct lpfc_queue *cq, uint32_t subtype)
+{
+	struct lpfc_mbx_rq_create *rq_create;
+	struct lpfc_dmabuf *dmabuf;
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, status = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	if (hrq->entry_count != drq->entry_count)
+		return -EINVAL;
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	length = (sizeof(struct lpfc_mbx_rq_create) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+			 LPFC_MBOX_OPCODE_FCOE_RQ_CREATE,
+			 length, LPFC_SLI4_MBX_EMBED);
+	rq_create = &mbox->u.mqe.un.rq_create;
+	switch (hrq->entry_count) {
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2535 Unsupported RQ count. (%d)\n",
+				hrq->entry_count);
+		if (hrq->entry_count < 512)
+			return -EINVAL;
+		/* otherwise default to smallest count (drop through) */
+	case 512:
+		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
+		       LPFC_RQ_RING_SIZE_512);
+		break;
+	case 1024:
+		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
+		       LPFC_RQ_RING_SIZE_1024);
+		break;
+	case 2048:
+		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
+		       LPFC_RQ_RING_SIZE_2048);
+		break;
+	case 4096:
+		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
+		       LPFC_RQ_RING_SIZE_4096);
+		break;
+	}
+	bf_set(lpfc_rq_context_cq_id, &rq_create->u.request.context,
+	       cq->queue_id);
+	bf_set(lpfc_mbx_rq_create_num_pages, &rq_create->u.request,
+	       hrq->page_count);
+	bf_set(lpfc_rq_context_buf_size, &rq_create->u.request.context,
+	       LPFC_HDR_BUF_SIZE);
+	list_for_each_entry(dmabuf, &hrq->page_list, list) {
+		rq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
+					putPaddrLow(dmabuf->phys);
+		rq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
+					putPaddrHigh(dmabuf->phys);
+	}
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *) &rq_create->header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2504 RQ_CREATE mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+		goto out;
+	}
+	hrq->queue_id = bf_get(lpfc_mbx_rq_create_q_id, &rq_create->u.response);
+	if (hrq->queue_id == 0xFFFF) {
+		status = -ENXIO;
+		goto out;
+	}
+	hrq->type = LPFC_HRQ;
+	hrq->subtype = subtype;
+	hrq->host_index = 0;
+	hrq->hba_index = 0;
+
+	/* now create the data queue */
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+			 LPFC_MBOX_OPCODE_FCOE_RQ_CREATE,
+			 length, LPFC_SLI4_MBX_EMBED);
+	switch (drq->entry_count) {
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2536 Unsupported RQ count. (%d)\n",
+				drq->entry_count);
+		if (drq->entry_count < 512)
+			return -EINVAL;
+		/* otherwise default to smallest count (drop through) */
+	case 512:
+		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
+		       LPFC_RQ_RING_SIZE_512);
+		break;
+	case 1024:
+		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
+		       LPFC_RQ_RING_SIZE_1024);
+		break;
+	case 2048:
+		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
+		       LPFC_RQ_RING_SIZE_2048);
+		break;
+	case 4096:
+		bf_set(lpfc_rq_context_rq_size, &rq_create->u.request.context,
+		       LPFC_RQ_RING_SIZE_4096);
+		break;
+	}
+	bf_set(lpfc_rq_context_cq_id, &rq_create->u.request.context,
+	       cq->queue_id);
+	bf_set(lpfc_mbx_rq_create_num_pages, &rq_create->u.request,
+	       drq->page_count);
+	bf_set(lpfc_rq_context_buf_size, &rq_create->u.request.context,
+	       LPFC_DATA_BUF_SIZE);
+	list_for_each_entry(dmabuf, &drq->page_list, list) {
+		rq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
+					putPaddrLow(dmabuf->phys);
+		rq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
+					putPaddrHigh(dmabuf->phys);
+	}
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *) &rq_create->header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		status = -ENXIO;
+		goto out;
+	}
+	drq->queue_id = bf_get(lpfc_mbx_rq_create_q_id, &rq_create->u.response);
+	if (drq->queue_id == 0xFFFF) {
+		status = -ENXIO;
+		goto out;
+	}
+	drq->type = LPFC_DRQ;
+	drq->subtype = subtype;
+	drq->host_index = 0;
+	drq->hba_index = 0;
+
+	/* link the header and data RQs onto the parent cq child list */
+	list_add_tail(&hrq->list, &cq->child_list);
+	list_add_tail(&drq->list, &cq->child_list);
+
+out:
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	return status;
+}
+
+/**
+ * lpfc_eq_destroy - Destroy an event Queue on the HBA
+ * @eq: The queue structure associated with the queue to destroy.
+ *
+ * This function destroys a queue, as detailed in @eq by sending an mailbox
+ * command, specific to the type of queue, to the HBA.
+ *
+ * The @eq struct is used to get the queue ID of the queue to destroy.
+ *
+ * On success this function will return a zero. If the queue destroy mailbox
+ * command fails this function will return ENXIO.
+ **/
+uint32_t
+lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
+{
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, status = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	if (!eq)
+		return -ENODEV;
+	mbox = mempool_alloc(eq->phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	length = (sizeof(struct lpfc_mbx_eq_destroy) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_EQ_DESTROY,
+			 length, LPFC_SLI4_MBX_EMBED);
+	bf_set(lpfc_mbx_eq_destroy_q_id, &mbox->u.mqe.un.eq_destroy.u.request,
+	       eq->queue_id);
+	mbox->vport = eq->phba->pport;
+	mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+
+	rc = lpfc_sli_issue_mbox(eq->phba, mbox, MBX_POLL);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *)
+		&mbox->u.mqe.un.eq_destroy.header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2505 EQ_DESTROY mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+	}
+
+	/* Remove eq from any list */
+	list_del_init(&eq->list);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, eq->phba->mbox_mem_pool);
+	return status;
+}
+
+/**
+ * lpfc_cq_destroy - Destroy a Completion Queue on the HBA
+ * @cq: The queue structure associated with the queue to destroy.
+ *
+ * This function destroys a queue, as detailed in @cq by sending an mailbox
+ * command, specific to the type of queue, to the HBA.
+ *
+ * The @cq struct is used to get the queue ID of the queue to destroy.
+ *
+ * On success this function will return a zero. If the queue destroy mailbox
+ * command fails this function will return ENXIO.
+ **/
+uint32_t
+lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
+{
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, status = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	if (!cq)
+		return -ENODEV;
+	mbox = mempool_alloc(cq->phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	length = (sizeof(struct lpfc_mbx_cq_destroy) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_CQ_DESTROY,
+			 length, LPFC_SLI4_MBX_EMBED);
+	bf_set(lpfc_mbx_cq_destroy_q_id, &mbox->u.mqe.un.cq_destroy.u.request,
+	       cq->queue_id);
+	mbox->vport = cq->phba->pport;
+	mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	rc = lpfc_sli_issue_mbox(cq->phba, mbox, MBX_POLL);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *)
+		&mbox->u.mqe.un.wq_create.header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2506 CQ_DESTROY mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+	}
+	/* Remove cq from any list */
+	list_del_init(&cq->list);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, cq->phba->mbox_mem_pool);
+	return status;
+}
+
+/**
+ * lpfc_wq_destroy - Destroy a Work Queue on the HBA
+ * @wq: The queue structure associated with the queue to destroy.
+ *
+ * This function destroys a queue, as detailed in @wq by sending an mailbox
+ * command, specific to the type of queue, to the HBA.
+ *
+ * The @wq struct is used to get the queue ID of the queue to destroy.
+ *
+ * On success this function will return a zero. If the queue destroy mailbox
+ * command fails this function will return ENXIO.
+ **/
+uint32_t
+lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
+{
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, status = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	if (!wq)
+		return -ENODEV;
+	mbox = mempool_alloc(wq->phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	length = (sizeof(struct lpfc_mbx_wq_destroy) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+			 LPFC_MBOX_OPCODE_FCOE_WQ_DESTROY,
+			 length, LPFC_SLI4_MBX_EMBED);
+	bf_set(lpfc_mbx_wq_destroy_q_id, &mbox->u.mqe.un.wq_destroy.u.request,
+	       wq->queue_id);
+	mbox->vport = wq->phba->pport;
+	mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	rc = lpfc_sli_issue_mbox(wq->phba, mbox, MBX_POLL);
+	shdr = (union lpfc_sli4_cfg_shdr *)
+		&mbox->u.mqe.un.wq_destroy.header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2508 WQ_DESTROY mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+	}
+	/* Remove wq from any list */
+	list_del_init(&wq->list);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, wq->phba->mbox_mem_pool);
+	return status;
+}
+
+/**
+ * lpfc_rq_destroy - Destroy a Receive Queue on the HBA
+ * @rq: The queue structure associated with the queue to destroy.
+ *
+ * This function destroys a queue, as detailed in @rq by sending an mailbox
+ * command, specific to the type of queue, to the HBA.
+ *
+ * The @rq struct is used to get the queue ID of the queue to destroy.
+ *
+ * On success this function will return a zero. If the queue destroy mailbox
+ * command fails this function will return ENXIO.
+ **/
+uint32_t
+lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
+		struct lpfc_queue *drq)
+{
+	LPFC_MBOXQ_t *mbox;
+	int rc, length, status = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	if (!hrq || !drq)
+		return -ENODEV;
+	mbox = mempool_alloc(hrq->phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+	length = (sizeof(struct lpfc_mbx_rq_destroy) -
+		  sizeof(struct mbox_header));
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+			 LPFC_MBOX_OPCODE_FCOE_RQ_DESTROY,
+			 length, LPFC_SLI4_MBX_EMBED);
+	bf_set(lpfc_mbx_rq_destroy_q_id, &mbox->u.mqe.un.rq_destroy.u.request,
+	       hrq->queue_id);
+	mbox->vport = hrq->phba->pport;
+	mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	rc = lpfc_sli_issue_mbox(hrq->phba, mbox, MBX_POLL);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *)
+		&mbox->u.mqe.un.rq_destroy.header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2509 RQ_DESTROY mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		if (rc != MBX_TIMEOUT)
+			mempool_free(mbox, hrq->phba->mbox_mem_pool);
+		return -ENXIO;
+	}
+	bf_set(lpfc_mbx_rq_destroy_q_id, &mbox->u.mqe.un.rq_destroy.u.request,
+	       drq->queue_id);
+	rc = lpfc_sli_issue_mbox(drq->phba, mbox, MBX_POLL);
+	shdr = (union lpfc_sli4_cfg_shdr *)
+		&mbox->u.mqe.un.rq_destroy.header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2510 RQ_DESTROY mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		status = -ENXIO;
+	}
+	list_del_init(&hrq->list);
+	list_del_init(&drq->list);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, hrq->phba->mbox_mem_pool);
+	return status;
+}
+
+/**
+ * lpfc_sli4_post_sgl - Post scatter gather list for an XRI to HBA
+ * @phba: The virtual port for which this call being executed.
+ * @pdma_phys_addr0: Physical address of the 1st SGL page.
+ * @pdma_phys_addr1: Physical address of the 2nd SGL page.
+ * @xritag: the xritag that ties this io to the SGL pages.
+ *
+ * This routine will post the sgl pages for the IO that has the xritag
+ * that is in the iocbq structure. The xritag is assigned during iocbq
+ * creation and persists for as long as the driver is loaded.
+ * if the caller has fewer than 256 scatter gather segments to map then
+ * pdma_phys_addr1 should be 0.
+ * If the caller needs to map more than 256 scatter gather segment then
+ * pdma_phys_addr1 should be a valid physical address.
+ * physical address for SGLs must be 64 byte aligned.
+ * If you are going to map 2 SGL's then the first one must have 256 entries
+ * the second sgl can have between 1 and 256 entries.
+ *
+ * Return codes:
+ * 	0 - Success
+ * 	-ENXIO, -ENOMEM - Failure
+ **/
+int
+lpfc_sli4_post_sgl(struct lpfc_hba *phba,
+		dma_addr_t pdma_phys_addr0,
+		dma_addr_t pdma_phys_addr1,
+		uint16_t xritag)
+{
+	struct lpfc_mbx_post_sgl_pages *post_sgl_pages;
+	LPFC_MBOXQ_t *mbox;
+	int rc;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	if (xritag == NO_XRI) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"0364 Invalid param:\n");
+		return -EINVAL;
+	}
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+			LPFC_MBOX_OPCODE_FCOE_POST_SGL_PAGES,
+			sizeof(struct lpfc_mbx_post_sgl_pages) -
+			sizeof(struct mbox_header), LPFC_SLI4_MBX_EMBED);
+
+	post_sgl_pages = (struct lpfc_mbx_post_sgl_pages *)
+				&mbox->u.mqe.un.post_sgl_pages;
+	bf_set(lpfc_post_sgl_pages_xri, post_sgl_pages, xritag);
+	bf_set(lpfc_post_sgl_pages_xricnt, post_sgl_pages, 1);
+
+	post_sgl_pages->sgl_pg_pairs[0].sgl_pg0_addr_lo	=
+				cpu_to_le32(putPaddrLow(pdma_phys_addr0));
+	post_sgl_pages->sgl_pg_pairs[0].sgl_pg0_addr_hi =
+				cpu_to_le32(putPaddrHigh(pdma_phys_addr0));
+
+	post_sgl_pages->sgl_pg_pairs[0].sgl_pg1_addr_lo	=
+				cpu_to_le32(putPaddrLow(pdma_phys_addr1));
+	post_sgl_pages->sgl_pg_pairs[0].sgl_pg1_addr_hi =
+				cpu_to_le32(putPaddrHigh(pdma_phys_addr1));
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	else
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *) &post_sgl_pages->header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2511 POST_SGL mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		rc = -ENXIO;
+	}
+	return 0;
+}
+/**
+ * lpfc_sli4_remove_all_sgl_pages - Post scatter gather list for an XRI to HBA
+ * @phba: The virtual port for which this call being executed.
+ *
+ * This routine will remove all of the sgl pages registered with the hba.
+ *
+ * Return codes:
+ * 	0 - Success
+ * 	-ENXIO, -ENOMEM - Failure
+ **/
+int
+lpfc_sli4_remove_all_sgl_pages(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *mbox;
+	int rc;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+			LPFC_MBOX_OPCODE_FCOE_REMOVE_SGL_PAGES, 0,
+			LPFC_SLI4_MBX_EMBED);
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	else
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *)
+		&mbox->u.mqe.un.sli4_config.header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2512 REMOVE_ALL_SGL_PAGES mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		rc = -ENXIO;
+	}
+	return rc;
+}
+
+/**
+ * lpfc_sli4_next_xritag - Get an xritag for the io
+ * @phba: Pointer to HBA context object.
+ *
+ * This function gets an xritag for the iocb. If there is no unused xritag
+ * it will return 0xffff.
+ * The function returns the allocated xritag if successful, else returns zero.
+ * Zero is not a valid xritag.
+ * The caller is not required to hold any lock.
+ **/
+uint16_t
+lpfc_sli4_next_xritag(struct lpfc_hba *phba)
+{
+	uint16_t xritag;
+
+	spin_lock_irq(&phba->hbalock);
+	xritag = phba->sli4_hba.next_xri;
+	if ((xritag != (uint16_t) -1) && xritag <
+		(phba->sli4_hba.max_cfg_param.max_xri
+			+ phba->sli4_hba.max_cfg_param.xri_base)) {
+		phba->sli4_hba.next_xri++;
+		phba->sli4_hba.max_cfg_param.xri_used++;
+		spin_unlock_irq(&phba->hbalock);
+		return xritag;
+	}
+	spin_unlock_irq(&phba->hbalock);
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+			"2004 Failed to allocate XRI.last XRITAG is %d"
+			" Max XRI is %d, Used XRI is %d\n",
+			phba->sli4_hba.next_xri,
+			phba->sli4_hba.max_cfg_param.max_xri,
+			phba->sli4_hba.max_cfg_param.xri_used);
+	return -1;
+}
+
+/**
+ * lpfc_sli4_post_sgl_list - post a block of sgl list to the firmware.
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to post a block of driver's sgl pages to the
+ * HBA using non-embedded mailbox command. No Lock is held. This routine
+ * is only called when the driver is loading and after all IO has been
+ * stopped.
+ **/
+int
+lpfc_sli4_post_sgl_list(struct lpfc_hba *phba)
+{
+	struct lpfc_sglq *sglq_entry;
+	struct lpfc_mbx_post_uembed_sgl_page1 *sgl;
+	struct sgl_page_pairs *sgl_pg_pairs;
+	void *viraddr;
+	LPFC_MBOXQ_t *mbox;
+	uint32_t reqlen, alloclen, pg_pairs;
+	uint32_t mbox_tmo;
+	uint16_t xritag_start = 0;
+	int els_xri_cnt, rc = 0;
+	uint32_t shdr_status, shdr_add_status;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	/* The number of sgls to be posted */
+	els_xri_cnt = lpfc_sli4_get_els_iocb_cnt(phba);
+
+	reqlen = els_xri_cnt * sizeof(struct sgl_page_pairs) +
+		 sizeof(union lpfc_sli4_cfg_shdr) + sizeof(uint32_t);
+	if (reqlen > PAGE_SIZE) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"2559 Block sgl registration required DMA "
+				"size (%d) great than a page\n", reqlen);
+		return -ENOMEM;
+	}
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2560 Failed to allocate mbox cmd memory\n");
+		return -ENOMEM;
+	}
+
+	/* Allocate DMA memory and set up the non-embedded mailbox command */
+	alloclen = lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+			 LPFC_MBOX_OPCODE_FCOE_POST_SGL_PAGES, reqlen,
+			 LPFC_SLI4_MBX_NEMBED);
+
+	if (alloclen < reqlen) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0285 Allocated DMA memory size (%d) is "
+				"less than the requested DMA memory "
+				"size (%d)\n", alloclen, reqlen);
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
+		return -ENOMEM;
+	}
+
+	/* Get the first SGE entry from the non-embedded DMA memory */
+	if (unlikely(!mbox->sge_array)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+				"2525 Failed to get the non-embedded SGE "
+				"virtual address\n");
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
+		return -ENOMEM;
+	}
+	viraddr = mbox->sge_array->addr[0];
+
+	/* Set up the SGL pages in the non-embedded DMA pages */
+	sgl = (struct lpfc_mbx_post_uembed_sgl_page1 *)viraddr;
+	sgl_pg_pairs = &sgl->sgl_pg_pairs;
+
+	for (pg_pairs = 0; pg_pairs < els_xri_cnt; pg_pairs++) {
+		sglq_entry = phba->sli4_hba.lpfc_els_sgl_array[pg_pairs];
+		/* Set up the sge entry */
+		sgl_pg_pairs->sgl_pg0_addr_lo =
+				cpu_to_le32(putPaddrLow(sglq_entry->phys));
+		sgl_pg_pairs->sgl_pg0_addr_hi =
+				cpu_to_le32(putPaddrHigh(sglq_entry->phys));
+		sgl_pg_pairs->sgl_pg1_addr_lo =
+				cpu_to_le32(putPaddrLow(0));
+		sgl_pg_pairs->sgl_pg1_addr_hi =
+				cpu_to_le32(putPaddrHigh(0));
+		/* Keep the first xritag on the list */
+		if (pg_pairs == 0)
+			xritag_start = sglq_entry->sli4_xritag;
+		sgl_pg_pairs++;
+	}
+	bf_set(lpfc_post_sgl_pages_xri, sgl, xritag_start);
+	pg_pairs = (pg_pairs > 0) ? (pg_pairs - 1) : pg_pairs;
+	bf_set(lpfc_post_sgl_pages_xricnt, sgl, pg_pairs);
+	/* Perform endian conversion if necessary */
+	sgl->word0 = cpu_to_le32(sgl->word0);
+
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+	}
+	shdr = (union lpfc_sli4_cfg_shdr *) &sgl->cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (rc != MBX_TIMEOUT)
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2513 POST_SGL_BLOCK mailbox command failed "
+				"status x%x add_status x%x mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		rc = -ENXIO;
+	}
+	return rc;
+}
+
+/**
+ * lpfc_sli4_post_scsi_sgl_block - post a block of scsi sgl list to firmware
+ * @phba: pointer to lpfc hba data structure.
+ * @sblist: pointer to scsi buffer list.
+ * @count: number of scsi buffers on the list.
+ *
+ * This routine is invoked to post a block of @count scsi sgl pages from a
+ * SCSI buffer list @sblist to the HBA using non-embedded mailbox command.
+ * No Lock is held.
+ *
+ **/
+int
+lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *phba, struct list_head *sblist,
+			      int cnt)
+{
+	struct lpfc_scsi_buf *psb;
+	struct lpfc_mbx_post_uembed_sgl_page1 *sgl;
+	struct sgl_page_pairs *sgl_pg_pairs;
+	void *viraddr;
+	LPFC_MBOXQ_t *mbox;
+	uint32_t reqlen, alloclen, pg_pairs;
+	uint32_t mbox_tmo;
+	uint16_t xritag_start = 0;
+	int rc = 0;
+	uint32_t shdr_status, shdr_add_status;
+	dma_addr_t pdma_phys_bpl1;
+	union lpfc_sli4_cfg_shdr *shdr;
+
+	/* Calculate the requested length of the dma memory */
+	reqlen = cnt * sizeof(struct sgl_page_pairs) +
+		 sizeof(union lpfc_sli4_cfg_shdr) + sizeof(uint32_t);
+	if (reqlen > PAGE_SIZE) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+				"0217 Block sgl registration required DMA "
+				"size (%d) great than a page\n", reqlen);
+		return -ENOMEM;
+	}
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0283 Failed to allocate mbox cmd memory\n");
+		return -ENOMEM;
+	}
+
+	/* Allocate DMA memory and set up the non-embedded mailbox command */
+	alloclen = lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
+				LPFC_MBOX_OPCODE_FCOE_POST_SGL_PAGES, reqlen,
+				LPFC_SLI4_MBX_NEMBED);
+
+	if (alloclen < reqlen) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"2561 Allocated DMA memory size (%d) is "
+				"less than the requested DMA memory "
+				"size (%d)\n", alloclen, reqlen);
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
+		return -ENOMEM;
+	}
+
+	/* Get the first SGE entry from the non-embedded DMA memory */
+	if (unlikely(!mbox->sge_array)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+				"2565 Failed to get the non-embedded SGE "
+				"virtual address\n");
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
+		return -ENOMEM;
+	}
+	viraddr = mbox->sge_array->addr[0];
+
+	/* Set up the SGL pages in the non-embedded DMA pages */
+	sgl = (struct lpfc_mbx_post_uembed_sgl_page1 *)viraddr;
+	sgl_pg_pairs = &sgl->sgl_pg_pairs;
+
+	pg_pairs = 0;
+	list_for_each_entry(psb, sblist, list) {
+		/* Set up the sge entry */
+		sgl_pg_pairs->sgl_pg0_addr_lo =
+			cpu_to_le32(putPaddrLow(psb->dma_phys_bpl));
+		sgl_pg_pairs->sgl_pg0_addr_hi =
+			cpu_to_le32(putPaddrHigh(psb->dma_phys_bpl));
+		if (phba->cfg_sg_dma_buf_size > SGL_PAGE_SIZE)
+			pdma_phys_bpl1 = psb->dma_phys_bpl + SGL_PAGE_SIZE;
+		else
+			pdma_phys_bpl1 = 0;
+		sgl_pg_pairs->sgl_pg1_addr_lo =
+			cpu_to_le32(putPaddrLow(pdma_phys_bpl1));
+		sgl_pg_pairs->sgl_pg1_addr_hi =
+			cpu_to_le32(putPaddrHigh(pdma_phys_bpl1));
+		/* Keep the first xritag on the list */
+		if (pg_pairs == 0)
+			xritag_start = psb->cur_iocbq.sli4_xritag;
+		sgl_pg_pairs++;
+		pg_pairs++;
+	}
+	bf_set(lpfc_post_sgl_pages_xri, sgl, xritag_start);
+	bf_set(lpfc_post_sgl_pages_xricnt, sgl, pg_pairs);
+	/* Perform endian conversion if necessary */
+	sgl->word0 = cpu_to_le32(sgl->word0);
+
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+	}
+	shdr = (union lpfc_sli4_cfg_shdr *) &sgl->cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (rc != MBX_TIMEOUT)
+		lpfc_sli4_mbox_cmd_free(phba, mbox);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2564 POST_SGL_BLOCK mailbox command failed "
+				"status x%x add_status x%x mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		rc = -ENXIO;
+	}
+	return rc;
+}
+
+/**
+ * lpfc_fc_frame_check - Check that this frame is a valid frame to handle
+ * @phba: pointer to lpfc_hba struct that the frame was received on
+ * @fc_hdr: A pointer to the FC Header data (In Big Endian Format)
+ *
+ * This function checks the fields in the @fc_hdr to see if the FC frame is a
+ * valid type of frame that the LPFC driver will handle. This function will
+ * return a zero if the frame is a valid frame or a non zero value when the
+ * frame does not pass the check.
+ **/
+static int
+lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
+{
+	char *rctl_names[] = FC_RCTL_NAMES_INIT;
+	char *type_names[] = FC_TYPE_NAMES_INIT;
+	struct fc_vft_header *fc_vft_hdr;
+
+	switch (fc_hdr->fh_r_ctl) {
+	case FC_RCTL_DD_UNCAT:		/* uncategorized information */
+	case FC_RCTL_DD_SOL_DATA:	/* solicited data */
+	case FC_RCTL_DD_UNSOL_CTL:	/* unsolicited control */
+	case FC_RCTL_DD_SOL_CTL:	/* solicited control or reply */
+	case FC_RCTL_DD_UNSOL_DATA:	/* unsolicited data */
+	case FC_RCTL_DD_DATA_DESC:	/* data descriptor */
+	case FC_RCTL_DD_UNSOL_CMD:	/* unsolicited command */
+	case FC_RCTL_DD_CMD_STATUS:	/* command status */
+	case FC_RCTL_ELS_REQ:	/* extended link services request */
+	case FC_RCTL_ELS_REP:	/* extended link services reply */
+	case FC_RCTL_ELS4_REQ:	/* FC-4 ELS request */
+	case FC_RCTL_ELS4_REP:	/* FC-4 ELS reply */
+	case FC_RCTL_BA_NOP:  	/* basic link service NOP */
+	case FC_RCTL_BA_ABTS: 	/* basic link service abort */
+	case FC_RCTL_BA_RMC: 	/* remove connection */
+	case FC_RCTL_BA_ACC:	/* basic accept */
+	case FC_RCTL_BA_RJT:	/* basic reject */
+	case FC_RCTL_BA_PRMT:
+	case FC_RCTL_ACK_1:	/* acknowledge_1 */
+	case FC_RCTL_ACK_0:	/* acknowledge_0 */
+	case FC_RCTL_P_RJT:	/* port reject */
+	case FC_RCTL_F_RJT:	/* fabric reject */
+	case FC_RCTL_P_BSY:	/* port busy */
+	case FC_RCTL_F_BSY:	/* fabric busy to data frame */
+	case FC_RCTL_F_BSYL:	/* fabric busy to link control frame */
+	case FC_RCTL_LCR:	/* link credit reset */
+	case FC_RCTL_END:	/* end */
+		break;
+	case FC_RCTL_VFTH:	/* Virtual Fabric tagging Header */
+		fc_vft_hdr = (struct fc_vft_header *)fc_hdr;
+		fc_hdr = &((struct fc_frame_header *)fc_vft_hdr)[1];
+		return lpfc_fc_frame_check(phba, fc_hdr);
+	default:
+		goto drop;
+	}
+	switch (fc_hdr->fh_type) {
+	case FC_TYPE_BLS:
+	case FC_TYPE_ELS:
+	case FC_TYPE_FCP:
+	case FC_TYPE_CT:
+		break;
+	case FC_TYPE_IP:
+	case FC_TYPE_ILS:
+	default:
+		goto drop;
+	}
+	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+			"2538 Received frame rctl:%s type:%s\n",
+			rctl_names[fc_hdr->fh_r_ctl],
+			type_names[fc_hdr->fh_type]);
+	return 0;
+drop:
+	lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
+			"2539 Dropped frame rctl:%s type:%s\n",
+			rctl_names[fc_hdr->fh_r_ctl],
+			type_names[fc_hdr->fh_type]);
+	return 1;
+}
+
+/**
+ * lpfc_fc_hdr_get_vfi - Get the VFI from an FC frame
+ * @fc_hdr: A pointer to the FC Header data (In Big Endian Format)
+ *
+ * This function processes the FC header to retrieve the VFI from the VF
+ * header, if one exists. This function will return the VFI if one exists
+ * or 0 if no VSAN Header exists.
+ **/
+static uint32_t
+lpfc_fc_hdr_get_vfi(struct fc_frame_header *fc_hdr)
+{
+	struct fc_vft_header *fc_vft_hdr = (struct fc_vft_header *)fc_hdr;
+
+	if (fc_hdr->fh_r_ctl != FC_RCTL_VFTH)
+		return 0;
+	return bf_get(fc_vft_hdr_vf_id, fc_vft_hdr);
+}
+
+/**
+ * lpfc_fc_frame_to_vport - Finds the vport that a frame is destined to
+ * @phba: Pointer to the HBA structure to search for the vport on
+ * @fc_hdr: A pointer to the FC Header data (In Big Endian Format)
+ * @fcfi: The FC Fabric ID that the frame came from
+ *
+ * This function searches the @phba for a vport that matches the content of the
+ * @fc_hdr passed in and the @fcfi. This function uses the @fc_hdr to fetch the
+ * VFI, if the Virtual Fabric Tagging Header exists, and the DID. This function
+ * returns the matching vport pointer or NULL if unable to match frame to a
+ * vport.
+ **/
+static struct lpfc_vport *
+lpfc_fc_frame_to_vport(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr,
+		       uint16_t fcfi)
+{
+	struct lpfc_vport **vports;
+	struct lpfc_vport *vport = NULL;
+	int i;
+	uint32_t did = (fc_hdr->fh_d_id[0] << 16 |
+			fc_hdr->fh_d_id[1] << 8 |
+			fc_hdr->fh_d_id[2]);
+
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+			if (phba->fcf.fcfi == fcfi &&
+			    vports[i]->vfi == lpfc_fc_hdr_get_vfi(fc_hdr) &&
+			    vports[i]->fc_myDID == did) {
+				vport = vports[i];
+				break;
+			}
+		}
+	lpfc_destroy_vport_work_array(phba, vports);
+	return vport;
+}
+
+/**
+ * lpfc_fc_frame_add - Adds a frame to the vport's list of received sequences
+ * @dmabuf: pointer to a dmabuf that describes the hdr and data of the FC frame
+ *
+ * This function searches through the existing incomplete sequences that have
+ * been sent to this @vport. If the frame matches one of the incomplete
+ * sequences then the dbuf in the @dmabuf is added to the list of frames that
+ * make up that sequence. If no sequence is found that matches this frame then
+ * the function will add the hbuf in the @dmabuf to the @vport's rcv_buffer_list
+ * This function returns a pointer to the first dmabuf in the sequence list that
+ * the frame was linked to.
+ **/
+static struct hbq_dmabuf *
+lpfc_fc_frame_add(struct lpfc_vport *vport, struct hbq_dmabuf *dmabuf)
+{
+	struct fc_frame_header *new_hdr;
+	struct fc_frame_header *temp_hdr;
+	struct lpfc_dmabuf *d_buf;
+	struct lpfc_dmabuf *h_buf;
+	struct hbq_dmabuf *seq_dmabuf = NULL;
+	struct hbq_dmabuf *temp_dmabuf = NULL;
+
+	new_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
+	/* Use the hdr_buf to find the sequence that this frame belongs to */
+	list_for_each_entry(h_buf, &vport->rcv_buffer_list, list) {
+		temp_hdr = (struct fc_frame_header *)h_buf->virt;
+		if ((temp_hdr->fh_seq_id != new_hdr->fh_seq_id) ||
+		    (temp_hdr->fh_ox_id != new_hdr->fh_ox_id) ||
+		    (memcmp(&temp_hdr->fh_s_id, &new_hdr->fh_s_id, 3)))
+			continue;
+		/* found a pending sequence that matches this frame */
+		seq_dmabuf = container_of(h_buf, struct hbq_dmabuf, hbuf);
+		break;
+	}
+	if (!seq_dmabuf) {
+		/*
+		 * This indicates first frame received for this sequence.
+		 * Queue the buffer on the vport's rcv_buffer_list.
+		 */
+		list_add_tail(&dmabuf->hbuf.list, &vport->rcv_buffer_list);
+		return dmabuf;
+	}
+	temp_hdr = seq_dmabuf->hbuf.virt;
+	if (new_hdr->fh_seq_cnt < temp_hdr->fh_seq_cnt) {
+		list_add(&seq_dmabuf->dbuf.list, &dmabuf->dbuf.list);
+		return dmabuf;
+	}
+	/* find the correct place in the sequence to insert this frame */
+	list_for_each_entry_reverse(d_buf, &seq_dmabuf->dbuf.list, list) {
+		temp_dmabuf = container_of(d_buf, struct hbq_dmabuf, dbuf);
+		temp_hdr = (struct fc_frame_header *)temp_dmabuf->hbuf.virt;
+		/*
+		 * If the frame's sequence count is greater than the frame on
+		 * the list then insert the frame right after this frame
+		 */
+		if (new_hdr->fh_seq_cnt > temp_hdr->fh_seq_cnt) {
+			list_add(&dmabuf->dbuf.list, &temp_dmabuf->dbuf.list);
+			return seq_dmabuf;
+		}
+	}
+	return NULL;
+}
+
+/**
+ * lpfc_seq_complete - Indicates if a sequence is complete
+ * @dmabuf: pointer to a dmabuf that describes the FC sequence
+ *
+ * This function checks the sequence, starting with the frame described by
+ * @dmabuf, to see if all the frames associated with this sequence are present.
+ * the frames associated with this sequence are linked to the @dmabuf using the
+ * dbuf list. This function looks for two major things. 1) That the first frame
+ * has a sequence count of zero. 2) There is a frame with last frame of sequence
+ * set. 3) That there are no holes in the sequence count. The function will
+ * return 1 when the sequence is complete, otherwise it will return 0.
+ **/
+static int
+lpfc_seq_complete(struct hbq_dmabuf *dmabuf)
+{
+	struct fc_frame_header *hdr;
+	struct lpfc_dmabuf *d_buf;
+	struct hbq_dmabuf *seq_dmabuf;
+	uint32_t fctl;
+	int seq_count = 0;
+
+	hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
+	/* make sure first fame of sequence has a sequence count of zero */
+	if (hdr->fh_seq_cnt != seq_count)
+		return 0;
+	fctl = (hdr->fh_f_ctl[0] << 16 |
+		hdr->fh_f_ctl[1] << 8 |
+		hdr->fh_f_ctl[2]);
+	/* If last frame of sequence we can return success. */
+	if (fctl & FC_FC_END_SEQ)
+		return 1;
+	list_for_each_entry(d_buf, &dmabuf->dbuf.list, list) {
+		seq_dmabuf = container_of(d_buf, struct hbq_dmabuf, dbuf);
+		hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
+		/* If there is a hole in the sequence count then fail. */
+		if (++seq_count != hdr->fh_seq_cnt)
+			return 0;
+		fctl = (hdr->fh_f_ctl[0] << 16 |
+			hdr->fh_f_ctl[1] << 8 |
+			hdr->fh_f_ctl[2]);
+		/* If last frame of sequence we can return success. */
+		if (fctl & FC_FC_END_SEQ)
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ * lpfc_prep_seq - Prep sequence for ULP processing
+ * @vport: Pointer to the vport on which this sequence was received
+ * @dmabuf: pointer to a dmabuf that describes the FC sequence
+ *
+ * This function takes a sequence, described by a list of frames, and creates
+ * a list of iocbq structures to describe the sequence. This iocbq list will be
+ * used to issue to the generic unsolicited sequence handler. This routine
+ * returns a pointer to the first iocbq in the list. If the function is unable
+ * to allocate an iocbq then it throw out the received frames that were not
+ * able to be described and return a pointer to the first iocbq. If unable to
+ * allocate any iocbqs (including the first) this function will return NULL.
+ **/
+static struct lpfc_iocbq *
+lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
+{
+	struct lpfc_dmabuf *d_buf, *n_buf;
+	struct lpfc_iocbq *first_iocbq, *iocbq;
+	struct fc_frame_header *fc_hdr;
+	uint32_t sid;
+
+	fc_hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
+	/* remove from receive buffer list */
+	list_del_init(&seq_dmabuf->hbuf.list);
+	/* get the Remote Port's SID */
+	sid = (fc_hdr->fh_s_id[0] << 16 |
+	       fc_hdr->fh_s_id[1] << 8 |
+	       fc_hdr->fh_s_id[2]);
+	/* Get an iocbq struct to fill in. */
+	first_iocbq = lpfc_sli_get_iocbq(vport->phba);
+	if (first_iocbq) {
+		/* Initialize the first IOCB. */
+		first_iocbq->iocb.ulpStatus = IOSTAT_SUCCESS;
+		first_iocbq->iocb.ulpCommand = CMD_IOCB_RCV_SEQ64_CX;
+		first_iocbq->iocb.ulpContext = be16_to_cpu(fc_hdr->fh_ox_id);
+		first_iocbq->iocb.unsli3.rcvsli3.vpi =
+					vport->vpi + vport->phba->vpi_base;
+		/* put the first buffer into the first IOCBq */
+		first_iocbq->context2 = &seq_dmabuf->dbuf;
+		first_iocbq->context3 = NULL;
+		first_iocbq->iocb.ulpBdeCount = 1;
+		first_iocbq->iocb.un.cont64[0].tus.f.bdeSize =
+							LPFC_DATA_BUF_SIZE;
+		first_iocbq->iocb.un.rcvels.remoteID = sid;
+	}
+	iocbq = first_iocbq;
+	/*
+	 * Each IOCBq can have two Buffers assigned, so go through the list
+	 * of buffers for this sequence and save two buffers in each IOCBq
+	 */
+	list_for_each_entry_safe(d_buf, n_buf, &seq_dmabuf->dbuf.list, list) {
+		if (!iocbq) {
+			lpfc_in_buf_free(vport->phba, d_buf);
+			continue;
+		}
+		if (!iocbq->context3) {
+			iocbq->context3 = d_buf;
+			iocbq->iocb.ulpBdeCount++;
+			iocbq->iocb.unsli3.rcvsli3.bde2.tus.f.bdeSize =
+							LPFC_DATA_BUF_SIZE;
+		} else {
+			iocbq = lpfc_sli_get_iocbq(vport->phba);
+			if (!iocbq) {
+				if (first_iocbq) {
+					first_iocbq->iocb.ulpStatus =
+							IOSTAT_FCP_RSP_ERROR;
+					first_iocbq->iocb.un.ulpWord[4] =
+							IOERR_NO_RESOURCES;
+				}
+				lpfc_in_buf_free(vport->phba, d_buf);
+				continue;
+			}
+			iocbq->context2 = d_buf;
+			iocbq->context3 = NULL;
+			iocbq->iocb.ulpBdeCount = 1;
+			iocbq->iocb.un.cont64[0].tus.f.bdeSize =
+							LPFC_DATA_BUF_SIZE;
+			iocbq->iocb.un.rcvels.remoteID = sid;
+			list_add_tail(&iocbq->list, &first_iocbq->list);
+		}
+	}
+	return first_iocbq;
+}
+
+/**
+ * lpfc_sli4_handle_received_buffer - Handle received buffers from firmware
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called with no lock held. This function processes all
+ * the received buffers and gives it to upper layers when a received buffer
+ * indicates that it is the final frame in the sequence. The interrupt
+ * service routine processes received buffers at interrupt contexts and adds
+ * received dma buffers to the rb_pend_list queue and signals the worker thread.
+ * Worker thread calls lpfc_sli4_handle_received_buffer, which will call the
+ * appropriate receive function when the final frame in a sequence is received.
+ **/
+int
+lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba)
+{
+	LIST_HEAD(cmplq);
+	struct hbq_dmabuf *dmabuf, *seq_dmabuf;
+	struct fc_frame_header *fc_hdr;
+	struct lpfc_vport *vport;
+	uint32_t fcfi;
+	struct lpfc_iocbq *iocbq;
+
+	/* Clear hba flag and get all received buffers into the cmplq */
+	spin_lock_irq(&phba->hbalock);
+	phba->hba_flag &= ~HBA_RECEIVE_BUFFER;
+	list_splice_init(&phba->rb_pend_list, &cmplq);
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Process each received buffer */
+	while ((dmabuf = lpfc_sli_hbqbuf_get(&cmplq)) != NULL) {
+		fc_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
+		/* check to see if this a valid type of frame */
+		if (lpfc_fc_frame_check(phba, fc_hdr)) {
+			lpfc_in_buf_free(phba, &dmabuf->dbuf);
+			continue;
+		}
+		fcfi = bf_get(lpfc_rcqe_fcf_id, &dmabuf->rcqe);
+		vport = lpfc_fc_frame_to_vport(phba, fc_hdr, fcfi);
+		if (!vport) {
+			/* throw out the frame */
+			lpfc_in_buf_free(phba, &dmabuf->dbuf);
+			continue;
+		}
+		/* Link this frame */
+		seq_dmabuf = lpfc_fc_frame_add(vport, dmabuf);
+		if (!seq_dmabuf) {
+			/* unable to add frame to vport - throw it out */
+			lpfc_in_buf_free(phba, &dmabuf->dbuf);
+			continue;
+		}
+		/* If not last frame in sequence continue processing frames. */
+		if (!lpfc_seq_complete(seq_dmabuf)) {
+			/*
+			 * When saving off frames post a new one and mark this
+			 * frame to be freed when it is finished.
+			 **/
+			lpfc_sli_hbqbuf_fill_hbqs(phba, LPFC_ELS_HBQ, 1);
+			dmabuf->tag = -1;
+			continue;
+		}
+		fc_hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
+		iocbq = lpfc_prep_seq(vport, seq_dmabuf);
+		if (!lpfc_complete_unsol_iocb(phba,
+					      &phba->sli.ring[LPFC_ELS_RING],
+					      iocbq, fc_hdr->fh_r_ctl,
+					      fc_hdr->fh_type))
+			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+					"2540 Ring %d handler: unexpected Rctl "
+					"x%x Type x%x received\n",
+					LPFC_ELS_RING,
+					fc_hdr->fh_r_ctl, fc_hdr->fh_type);
+	};
+	return 0;
+}


