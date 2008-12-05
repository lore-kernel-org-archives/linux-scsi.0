From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 10/14] lpfc 8.3.0 :  Fix some memory handling issues
Date: Thu, 4 Dec 2008 22:39:40 -0500
Message-ID: <1228448380.19053.53.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45962 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYLEOnr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:47 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5EhkhZ004271
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0 : Fix some memory handling issues

- Fix mailbox buffer leak on dump mailbox completion

- Fix mbuf leak in lpfc_pci_probe_one() SLI-2 mode error path

- Don't allocate HBQs in interrupt context

- Use correct size for FCP response buffer so that all available sense
  data is copied

- Fix jiffies calculation to prevent crash when collecting statistical
  data


Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_init.c |    7 +++-
 drivers/scsi/lpfc/lpfc_scsi.c |   14 +++++---
 drivers/scsi/lpfc/lpfc_sli.c  |   76 ++++-------------------------------------
 3 files changed, 23 insertions(+), 74 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -255,8 +255,10 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	/* character array used for decoding dist type. */
 	char dist_char[] = "nabx";
 
-	if (pmboxq->mb.mbxStatus != MBX_SUCCESS)
+	if (pmboxq->mb.mbxStatus != MBX_SUCCESS) {
+		mempool_free(pmboxq, phba->mbox_mem_pool);
 		return;
+	}
 
 	prg = (struct prog_id *) &prog_id_word;
 
@@ -274,6 +276,7 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 		sprintf(phba->OptionROMVersion, "%d.%d%d%c%d",
 			prg->ver, prg->rev, prg->lev,
 			dist, prg->num);
+	mempool_free(pmboxq, phba->mbox_mem_pool);
 	return;
 }
 
@@ -2889,6 +2892,8 @@ out_remove_device:
 	lpfc_stop_phba_timers(phba);
 	phba->pport->work_port_events = 0;
 	lpfc_disable_intr(phba);
+	lpfc_sli_hba_down(phba);
+	lpfc_sli_brdrestart(phba);
 out_free_sysfs_attr:
 	lpfc_free_sysfs_attr(vport);
 out_destroy_port:
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -66,6 +66,8 @@ lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
 	if (cmd->result)
 		return;
 
+	latency = jiffies_to_msecs((long)jiffies - (long)lpfc_cmd->start_time);
+
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (!vport->stat_data_enabled ||
 		vport->stat_data_blocked ||
@@ -74,13 +76,15 @@ lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		return;
 	}
-	latency = jiffies_to_msecs(jiffies - lpfc_cmd->start_time);
 
 	if (phba->bucket_type == LPFC_LINEAR_BUCKET) {
 		i = (latency + phba->bucket_step - 1 - phba->bucket_base)/
 			phba->bucket_step;
-		if (i >= LPFC_MAX_BUCKET_COUNT)
-			i = LPFC_MAX_BUCKET_COUNT;
+		/* check array subscript bounds */
+		if (i < 0)
+			i = 0;
+		else if (i >= LPFC_MAX_BUCKET_COUNT)
+			i = LPFC_MAX_BUCKET_COUNT - 1;
 	} else {
 		for (i = 0; i < LPFC_MAX_BUCKET_COUNT-1; i++)
 			if (latency <= (phba->bucket_base +
@@ -444,14 +448,14 @@ lpfc_new_scsi_buf(struct lpfc_vport *vport)
 	bpl[0].addrLow = le32_to_cpu(putPaddrLow(pdma_phys_fcp_cmd));
 	bpl[0].tus.f.bdeSize = sizeof(struct fcp_cmnd);
 	bpl[0].tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-	bpl[0].tus.w = le32_to_cpu(bpl->tus.w);
+	bpl[0].tus.w = le32_to_cpu(bpl[0].tus.w);
 
 	/* Setup the physical region for the FCP RSP */
 	bpl[1].addrHigh = le32_to_cpu(putPaddrHigh(pdma_phys_fcp_rsp));
 	bpl[1].addrLow = le32_to_cpu(putPaddrLow(pdma_phys_fcp_rsp));
 	bpl[1].tus.f.bdeSize = sizeof(struct fcp_rsp);
 	bpl[1].tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-	bpl[1].tus.w = le32_to_cpu(bpl->tus.w);
+	bpl[1].tus.w = le32_to_cpu(bpl[1].tus.w);
 
 	/*
 	 * Since the IOCB for the FCP I/O is built into this lpfc_scsi_buf,
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1259,68 +1259,6 @@ lpfc_sli_handle_mb_event(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_replace_hbqbuff: Replace the HBQ buffer with a new buffer.
- * @phba: Pointer to HBA context object.
- * @tag: Tag for the HBQ buffer.
- *
- * This function is called from unsolicited event handler code path to get the
- * HBQ buffer associated with an unsolicited iocb. This function is called with
- * no lock held. It returns the buffer associated with the given tag and posts
- * another buffer to the firmware. Note that the new buffer must be allocated
- * before taking the hbalock and that the hba lock must be held until it is
- * finished with the hbq entry swap.
- **/
-static struct lpfc_dmabuf *
-lpfc_sli_replace_hbqbuff(struct lpfc_hba *phba, uint32_t tag)
-{
-	struct hbq_dmabuf *hbq_entry, *new_hbq_entry;
-	uint32_t hbqno;
-	void *virt;		/* virtual address ptr */
-	dma_addr_t phys;	/* mapped address */
-	unsigned long flags;
-
-	hbqno = tag >> 16;
-	new_hbq_entry = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
-	/* Check whether HBQ is still in use */
-	spin_lock_irqsave(&phba->hbalock, flags);
-	if (!phba->hbq_in_use) {
-		if (new_hbq_entry)
-			(phba->hbqs[hbqno].hbq_free_buffer)(phba,
-							    new_hbq_entry);
-		spin_unlock_irqrestore(&phba->hbalock, flags);
-		return NULL;
-	}
-
-	hbq_entry = lpfc_sli_hbqbuf_find(phba, tag);
-	if (hbq_entry == NULL) {
-		if (new_hbq_entry)
-			(phba->hbqs[hbqno].hbq_free_buffer)(phba,
-							    new_hbq_entry);
-		spin_unlock_irqrestore(&phba->hbalock, flags);
-		return NULL;
-	}
-	list_del(&hbq_entry->dbuf.list);
-
-	if (new_hbq_entry == NULL) {
-		list_add_tail(&hbq_entry->dbuf.list, &phba->hbqbuf_in_list);
-		spin_unlock_irqrestore(&phba->hbalock, flags);
-		return &hbq_entry->dbuf;
-	}
-	new_hbq_entry->tag = -1;
-	phys = new_hbq_entry->dbuf.phys;
-	virt = new_hbq_entry->dbuf.virt;
-	new_hbq_entry->dbuf.phys = hbq_entry->dbuf.phys;
-	new_hbq_entry->dbuf.virt = hbq_entry->dbuf.virt;
-	hbq_entry->dbuf.phys = phys;
-	hbq_entry->dbuf.virt = virt;
-	lpfc_sli_free_hbq(phba, hbq_entry);
-	list_add_tail(&new_hbq_entry->dbuf.list, &phba->hbqbuf_in_list);
-	spin_unlock_irqrestore(&phba->hbalock, flags);
-
-	return &new_hbq_entry->dbuf;
-}
-
-/**
  * lpfc_sli_get_buff: Get the buffer associated with the buffer tag.
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
@@ -1334,13 +1272,17 @@ lpfc_sli_replace_hbqbuff(struct lpfc_hba *phba, uint32_t tag)
  **/
 static struct lpfc_dmabuf *
 lpfc_sli_get_buff(struct lpfc_hba *phba,
-			struct lpfc_sli_ring *pring,
-			uint32_t tag)
+		  struct lpfc_sli_ring *pring,
+		  uint32_t tag)
 {
+	struct hbq_dmabuf *hbq_entry;
+
 	if (tag & QUE_BUFTAG_BIT)
 		return lpfc_sli_ring_taggedbuf_get(phba, pring, tag);
-	else
-		return lpfc_sli_replace_hbqbuff(phba, tag);
+	hbq_entry = lpfc_sli_hbqbuf_find(phba, tag);
+	if (!hbq_entry)
+		return NULL;
+	return &hbq_entry->dbuf;
 }
 

@@ -1372,8 +1314,6 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	match = 0;
 	irsp = &(saveq->iocb);
 
-	if (irsp->ulpStatus == IOSTAT_NEED_BUFFER)
-		return 1;
 	if (irsp->ulpCommand == CMD_ASYNC_STATUS) {
 		if (pring->lpfc_sli_rcv_async_status)
 			pring->lpfc_sli_rcv_async_status(phba, pring, saveq);


