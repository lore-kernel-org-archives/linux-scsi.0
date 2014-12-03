From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/12] advansys: Use DMA-API for carrier buffer
Date: Wed,  3 Dec 2014 12:44:57 +0100
Message-ID: <1417607105-85455-5-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbaLCLpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:12 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 238 +++++++++++++++++++++---------------------------
 1 file changed, 104 insertions(+), 134 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 4979e5a..ec8f122 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -963,8 +963,6 @@ typedef struct asc_mc_saved {
 #define ADV_MEM_WRITEW(addr, word) writew(word, addr)
 #define ADV_MEM_WRITEDW(addr, dword) writel(dword, addr)
 
-#define ADV_CARRIER_COUNT (ASC_DEF_MAX_HOST_QNG + 15)
-
 /*
  * Define total number of simultaneous maximum element scatter-gather
  * request blocks per wide adapter. ASC_DEF_MAX_HOST_QNG (253) is the
@@ -1745,16 +1743,16 @@ typedef struct adveep_38C1600_config {
  * little-endian.
  */
 typedef struct adv_carr_t {
-	ADV_VADDR carr_va;	/* Carrier Virtual Address */
-	ADV_PADDR carr_pa;	/* Carrier Physical Address */
-	ADV_VADDR areq_vpa;	/* ASC_SCSI_REQ_Q Virtual or Physical Address */
+	__le32 carr_va;	/* Carrier Virtual Address */
+	__le32 carr_pa;	/* Carrier Physical Address */
+	__le32 areq_vpa;	/* ASC_SCSI_REQ_Q Virtual or Physical Address */
 	/*
 	 * next_vpa [31:4]            Carrier Virtual or Physical Next Pointer
 	 *
 	 * next_vpa [3:1]             Reserved Bits
 	 * next_vpa [0]               Done Flag set in Response Queue.
 	 */
-	ADV_VADDR next_vpa;
+	__le32 next_vpa;
 } ADV_CARR_T;
 
 /*
@@ -1768,11 +1766,14 @@ typedef struct adv_carr_t {
 
 #define ASC_GET_CARRP(carrp) ((carrp) & ASC_NEXT_VPA_MASK)
 
-#define ADV_CARRIER_NUM_PAGE_CROSSING \
-    (((ADV_CARRIER_COUNT * sizeof(ADV_CARR_T)) + (PAGE_SIZE - 1))/PAGE_SIZE)
+/*
+ * Each carrier is 64 bytes, and we need three additional
+ * carrier for icq, irq, and the termination carrier.
+ */
+#define ADV_CARRIER_COUNT (ASC_DEF_MAX_HOST_QNG + 3)
 
 #define ADV_CARRIER_BUFSIZE \
-    ((ADV_CARRIER_COUNT + ADV_CARRIER_NUM_PAGE_CROSSING) * sizeof(ADV_CARR_T))
+    (ADV_CARRIER_COUNT * sizeof(ADV_CARR_T))
 
 /*
  * ASC_SCSI_REQ_Q 'a_flag' definitions
@@ -1844,8 +1845,8 @@ typedef struct adv_scsi_req_q {
 	uchar target_lun;	/* Device target logical unit number. */
 	ADV_PADDR data_addr;	/* Data buffer physical address. */
 	ADV_DCNT data_cnt;	/* Data count. Ucode sets to residual. */
-	ADV_PADDR sense_addr;
-	ADV_PADDR carr_pa;
+	__le32 sense_addr;
+	__le32 carr_pa;
 	uchar mflag;
 	uchar sense_len;
 	uchar cdb_len;		/* SCSI CDB length. Must <= 16 bytes. */
@@ -1856,19 +1857,18 @@ typedef struct adv_scsi_req_q {
 	uchar sg_working_ix;
 	uchar cdb[12];		/* SCSI CDB bytes 0-11. */
 	ADV_PADDR sg_real_addr;	/* SG list physical address. */
-	ADV_PADDR scsiq_rptr;
+	__le32 scsiq_rptr;
 	uchar cdb16[4];		/* SCSI CDB bytes 12-15. */
-	ADV_VADDR scsiq_ptr;
-	ADV_VADDR carr_va;
+	__le32 scsiq_ptr;
+	__le32 carr_va;
 	/*
 	 * End of microcode structure - 60 bytes. The rest of the structure
 	 * is used by the Adv Library and ignored by the microcode.
 	 */
 	__le32 srb_tag;
-	ADV_SG_BLOCK *sg_list_ptr;	/* SG list virtual address. */
-	char *vdata_addr;	/* Data buffer virtual address. */
 	uchar a_flag;
-	uchar pad[2];		/* Pad out to a word boundary. */
+	uchar pad[3];		/* Pad out to a word boundary. */
+	ADV_SG_BLOCK *sg_list_ptr;	/* SG list virtual address. */
 } ADV_SCSI_REQ_Q;
 
 /*
@@ -1935,8 +1935,9 @@ typedef struct adv_dvc_var {
 	uchar chip_scsi_id;	/* chip SCSI target ID */
 	uchar chip_type;
 	uchar bist_err_code;
-	ADV_CARR_T *carrier_buf;
+	ADV_CARR_T *carrier;
 	ADV_CARR_T *carr_freelist;	/* Carrier free list. */
+	dma_addr_t carrier_addr;
 	ADV_CARR_T *icq_sp;	/* Initiator command queue stopper pointer. */
 	ADV_CARR_T *irq_sp;	/* Initiator response queue stopper pointer. */
 	ushort carr_pending_cnt;	/* Count of pending carriers. */
@@ -2468,12 +2469,11 @@ static void asc_prt_adv_dvc_var(ADV_DVC_VAR *h)
 	printk("  start_motor 0x%x, scsi_reset_wait 0x%x\n",
 	       (unsigned)h->start_motor, (unsigned)h->scsi_reset_wait);
 
-	printk("  max_host_qng %u, max_dvc_qng %u, carr_freelist 0x%lxn\n",
+	printk("  max_host_qng %u, max_dvc_qng %u, carr_freelist 0x%p\n",
 	       (unsigned)h->max_host_qng, (unsigned)h->max_dvc_qng,
-	       (ulong)h->carr_freelist);
+	       h->carr_freelist);
 
-	printk("  icq_sp 0x%lx, irq_sp 0x%lx\n",
-	       (ulong)h->icq_sp, (ulong)h->irq_sp);
+	printk("  icq_sp 0x%p, irq_sp 0x%p\n", h->icq_sp, h->irq_sp);
 
 	printk("  no_scam 0x%x, tagqng_able 0x%x\n",
 	       (unsigned)h->no_scam, (unsigned)h->tagqng_able);
@@ -2678,8 +2678,8 @@ static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *q)
 	printk("  target_id %u, target_lun %u, srb_tag 0x%x, a_flag 0x%x\n",
 	       q->target_id, q->target_lun, q->srb_tag, q->a_flag);
 
-	printk("  cntl 0x%x, data_addr 0x%lx, vdata_addr 0x%lx\n",
-	       q->cntl, (ulong)le32_to_cpu(q->data_addr), (ulong)q->vdata_addr);
+	printk("  cntl 0x%x, data_addr 0x%lx\n",
+	       q->cntl, (ulong)le32_to_cpu(q->data_addr));
 
 	printk("  data_cnt %lu, sense_addr 0x%lx, sense_len %u,\n",
 	       (ulong)le32_to_cpu(q->data_cnt),
@@ -4345,38 +4345,61 @@ static int AdvLoadMicrocode(AdvPortAddr iop_base, const unsigned char *buf,
 	return 0;
 }
 
-static void AdvBuildCarrierFreelist(struct adv_dvc_var *asc_dvc)
+static void AdvBuildCarrierFreelist(struct adv_dvc_var *adv_dvc)
 {
-	ADV_CARR_T *carrp;
-	ADV_SDCNT buf_size;
-	ADV_PADDR carr_paddr;
+	off_t carr_offset = 0, next_offset;
+	dma_addr_t carr_paddr;
+	int carr_num = ADV_CARRIER_BUFSIZE / sizeof(ADV_CARR_T), i;
 
-	carrp = (ADV_CARR_T *) ADV_16BALIGN(asc_dvc->carrier_buf);
-	asc_dvc->carr_freelist = NULL;
-	if (carrp == asc_dvc->carrier_buf) {
-		buf_size = ADV_CARRIER_BUFSIZE;
-	} else {
-		buf_size = ADV_CARRIER_BUFSIZE - sizeof(ADV_CARR_T);
+	for (i = 0; i < carr_num; i++) {
+		carr_offset = i * sizeof(ADV_CARR_T);
+		/* Get physical address of the carrier 'carrp'. */
+		carr_paddr = adv_dvc->carrier_addr + carr_offset;
+
+		adv_dvc->carrier[i].carr_pa = cpu_to_le32(carr_paddr);
+		adv_dvc->carrier[i].carr_va = cpu_to_le32(carr_offset);
+		adv_dvc->carrier[i].areq_vpa = 0;
+		next_offset = carr_offset + sizeof(ADV_CARR_T);
+		if (i == carr_num)
+			next_offset = ~0;
+		adv_dvc->carrier[i].next_vpa = cpu_to_le32(next_offset);
 	}
+	/*
+	 * We cannot have a carrier with 'carr_va' of '0', as
+	 * a reference to this carrier would be interpreted as
+	 * list termination.
+	 * So start at carrier 1 with the freelist.
+	 */
+	adv_dvc->carr_freelist = &adv_dvc->carrier[1];
+}
 
-	do {
-		/* Get physical address of the carrier 'carrp'. */
-		carr_paddr = cpu_to_le32(virt_to_bus(carrp));
+static ADV_CARR_T *adv_get_carrier(struct adv_dvc_var *adv_dvc, u32 offset)
+{
+	int index;
 
-		buf_size -= sizeof(ADV_CARR_T);
+	BUG_ON(offset > ADV_CARRIER_BUFSIZE);
 
-		carrp->carr_pa = carr_paddr;
-		carrp->carr_va = cpu_to_le32(ADV_VADDR_TO_U32(carrp));
+	index = offset / sizeof(ADV_CARR_T);
+	return &adv_dvc->carrier[index];
+}
 
-		/*
-		 * Insert the carrier at the beginning of the freelist.
-		 */
-		carrp->next_vpa =
-			cpu_to_le32(ADV_VADDR_TO_U32(asc_dvc->carr_freelist));
-		asc_dvc->carr_freelist = carrp;
+static ADV_CARR_T *adv_get_next_carrier(struct adv_dvc_var *adv_dvc)
+{
+	ADV_CARR_T *carrp = adv_dvc->carr_freelist;
+	u32 next_vpa = le32_to_cpu(carrp->next_vpa);
+
+	if (next_vpa == 0 || next_vpa == ~0) {
+		ASC_DBG(1, "invalid vpa offset 0x%x\n", next_vpa);
+		return NULL;
+	}
 
-		carrp++;
-	} while (buf_size > 0);
+	adv_dvc->carr_freelist = adv_get_carrier(adv_dvc, next_vpa);
+	/*
+	 * insert stopper carrier to terminate list
+	 */
+	carrp->next_vpa = cpu_to_le32(ASC_CQ_STOPPER);
+
+	return carrp;
 }
 
 /*
@@ -4865,17 +4888,11 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dvc)
 	 * Set-up the Host->RISC Initiator Command Queue (ICQ).
 	 */
 
-	if ((asc_dvc->icq_sp = asc_dvc->carr_freelist) == NULL) {
+	asc_dvc->icq_sp = adv_get_next_carrier(asc_dvc);
+	if (!asc_dvc->icq_sp) {
 		asc_dvc->err_code |= ASC_IERR_NO_CARRIER;
 		return ADV_ERROR;
 	}
-	asc_dvc->carr_freelist = (ADV_CARR_T *)
-	    ADV_U32_TO_VADDR(le32_to_cpu(asc_dvc->icq_sp->next_vpa));
-
-	/*
-	 * The first command issued will be placed in the stopper carrier.
-	 */
-	asc_dvc->icq_sp->next_vpa = cpu_to_le32(ASC_CQ_STOPPER);
 
 	/*
 	 * Set RISC ICQ physical address start value.
@@ -4885,21 +4902,11 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dvc)
 	/*
 	 * Set-up the RISC->Host Initiator Response Queue (IRQ).
 	 */
-	if ((asc_dvc->irq_sp = asc_dvc->carr_freelist) == NULL) {
+	asc_dvc->irq_sp = adv_get_next_carrier(asc_dvc);
+	if (!asc_dvc->irq_sp) {
 		asc_dvc->err_code |= ASC_IERR_NO_CARRIER;
 		return ADV_ERROR;
 	}
-	asc_dvc->carr_freelist = (ADV_CARR_T *)
-	    ADV_U32_TO_VADDR(le32_to_cpu(asc_dvc->irq_sp->next_vpa));
-
-	/*
-	 * The first command completed by the RISC will be placed in
-	 * the stopper.
-	 *
-	 * Note: Set 'next_vpa' to ASC_CQ_STOPPER. When the request is
-	 * completed the RISC will set the ASC_RQ_STOPPER bit.
-	 */
-	asc_dvc->irq_sp->next_vpa = cpu_to_le32(ASC_CQ_STOPPER);
 
 	/*
 	 * Set RISC IRQ physical address start value.
@@ -5362,17 +5369,12 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	 * Set-up the Host->RISC Initiator Command Queue (ICQ).
 	 */
 
-	if ((asc_dvc->icq_sp = asc_dvc->carr_freelist) == NULL) {
+	asc_dvc->icq_sp = adv_get_next_carrier(asc_dvc);
+	if (!asc_dvc->icq_sp) {
+		ASC_DBG(0, "Failed to get ICQ carrier\n");
 		asc_dvc->err_code |= ASC_IERR_NO_CARRIER;
 		return ADV_ERROR;
 	}
-	asc_dvc->carr_freelist = (ADV_CARR_T *)
-	    ADV_U32_TO_VADDR(le32_to_cpu(asc_dvc->icq_sp->next_vpa));
-
-	/*
-	 * The first command issued will be placed in the stopper carrier.
-	 */
-	asc_dvc->icq_sp->next_vpa = cpu_to_le32(ASC_CQ_STOPPER);
 
 	/*
 	 * Set RISC ICQ physical address start value.
@@ -5383,21 +5385,12 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	/*
 	 * Set-up the RISC->Host Initiator Response Queue (IRQ).
 	 */
-	if ((asc_dvc->irq_sp = asc_dvc->carr_freelist) == NULL) {
+	asc_dvc->irq_sp = adv_get_next_carrier(asc_dvc);
+	if (!asc_dvc->irq_sp) {
+		ASC_DBG(0, "Failed to get IRQ carrier\n");
 		asc_dvc->err_code |= ASC_IERR_NO_CARRIER;
 		return ADV_ERROR;
 	}
-	asc_dvc->carr_freelist = (ADV_CARR_T *)
-	    ADV_U32_TO_VADDR(le32_to_cpu(asc_dvc->irq_sp->next_vpa));
-
-	/*
-	 * The first command completed by the RISC will be placed in
-	 * the stopper.
-	 *
-	 * Note: Set 'next_vpa' to ASC_CQ_STOPPER. When the request is
-	 * completed the RISC will set the ASC_RQ_STOPPER bit.
-	 */
-	asc_dvc->irq_sp->next_vpa = cpu_to_le32(ASC_CQ_STOPPER);
 
 	/*
 	 * Set RISC IRQ physical address start value.
@@ -5872,17 +5865,11 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 	/*
 	 * Set-up the Host->RISC Initiator Command Queue (ICQ).
 	 */
-	if ((asc_dvc->icq_sp = asc_dvc->carr_freelist) == NULL) {
+	asc_dvc->icq_sp = adv_get_next_carrier(asc_dvc);
+	if (!asc_dvc->icq_sp) {
 		asc_dvc->err_code |= ASC_IERR_NO_CARRIER;
 		return ADV_ERROR;
 	}
-	asc_dvc->carr_freelist = (ADV_CARR_T *)
-	    ADV_U32_TO_VADDR(le32_to_cpu(asc_dvc->icq_sp->next_vpa));
-
-	/*
-	 * The first command issued will be placed in the stopper carrier.
-	 */
-	asc_dvc->icq_sp->next_vpa = cpu_to_le32(ASC_CQ_STOPPER);
 
 	/*
 	 * Set RISC ICQ physical address start value. Initialize the
@@ -5896,21 +5883,11 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 	/*
 	 * Set-up the RISC->Host Initiator Response Queue (IRQ).
 	 */
-	if ((asc_dvc->irq_sp = asc_dvc->carr_freelist) == NULL) {
+	asc_dvc->irq_sp = adv_get_next_carrier(asc_dvc);
+	if (!asc_dvc->irq_sp) {
 		asc_dvc->err_code |= ASC_IERR_NO_CARRIER;
 		return ADV_ERROR;
 	}
-	asc_dvc->carr_freelist = (ADV_CARR_T *)
-	    ADV_U32_TO_VADDR(le32_to_cpu(asc_dvc->irq_sp->next_vpa));
-
-	/*
-	 * The first command completed by the RISC will be placed in
-	 * the stopper.
-	 *
-	 * Note: Set 'next_vpa' to ASC_CQ_STOPPER. When the request is
-	 * completed the RISC will set the ASC_RQ_STOPPER bit.
-	 */
-	asc_dvc->irq_sp->next_vpa = cpu_to_le32(ASC_CQ_STOPPER);
 
 	/*
 	 * Set RISC IRQ physical address start value.
@@ -6350,11 +6327,10 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 		 * stopper carrier.
 		 */
 		free_carrp = asc_dvc->irq_sp;
-		asc_dvc->irq_sp = (ADV_CARR_T *)
-		    ADV_U32_TO_VADDR(ASC_GET_CARRP(irq_next_vpa));
+		asc_dvc->irq_sp = adv_get_carrier(asc_dvc,
+						  ASC_GET_CARRP(irq_next_vpa));
 
-		free_carrp->next_vpa =
-		    cpu_to_le32(ADV_VADDR_TO_U32(asc_dvc->carr_freelist));
+		free_carrp->next_vpa = asc_dvc->carr_freelist->carr_va;
 		asc_dvc->carr_freelist = free_carrp;
 		asc_dvc->carr_pending_cnt--;
 
@@ -8119,7 +8095,6 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 		/* Zero-length transfer */
 		reqp->sgblkp = NULL;
 		scsiqp->data_cnt = 0;
-		scsiqp->vdata_addr = NULL;
 
 		scsiqp->data_addr = 0;
 		scsiqp->sg_list_ptr = NULL;
@@ -8768,19 +8743,13 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 	 * Allocate a carrier ensuring at least one carrier always
 	 * remains on the freelist and initialize fields.
 	 */
-	if ((new_carrp = asc_dvc->carr_freelist) == NULL) {
+	new_carrp = adv_get_next_carrier(asc_dvc);
+	if (!new_carrp) {
+		ASC_DBG(1, "No free carriers\n");
 		return ADV_BUSY;
 	}
-	asc_dvc->carr_freelist = (ADV_CARR_T *)
-	    ADV_U32_TO_VADDR(le32_to_cpu(new_carrp->next_vpa));
-	asc_dvc->carr_pending_cnt++;
 
-	/*
-	 * Set the carrier to be a stopper by setting 'next_vpa'
-	 * to the stopper value. The current stopper will be changed
-	 * below to point to the new stopper.
-	 */
-	new_carrp->next_vpa = cpu_to_le32(ASC_CQ_STOPPER);
+	asc_dvc->carr_pending_cnt++;
 
 	/*
 	 * Clear the ADV_SCSI_REQ_Q done flag.
@@ -8796,11 +8765,7 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 	scsiq->scsiq_ptr = cpu_to_le32(ADV_VADDR_TO_U32(scsiq));
 	scsiq->scsiq_rptr = req_paddr;
 
-	scsiq->carr_va = cpu_to_le32(ADV_VADDR_TO_U32(asc_dvc->icq_sp));
-	/*
-	 * Every ADV_CARR_T.carr_pa is byte swapped to little-endian
-	 * order during initialization.
-	 */
+	scsiq->carr_va = asc_dvc->icq_sp->carr_va;
 	scsiq->carr_pa = asc_dvc->icq_sp->carr_pa;
 
 	/*
@@ -11220,12 +11185,13 @@ static int advansys_wide_init_chip(struct Scsi_Host *shost)
 
 	/*
 	 * Allocate buffer carrier structures. The total size
-	 * is about 4 KB, so allocate all at once.
+	 * is about 8 KB, so allocate all at once.
 	 */
-	adv_dvc->carrier_buf = kmalloc(ADV_CARRIER_BUFSIZE, GFP_KERNEL);
-	ASC_DBG(1, "carrier_buf 0x%p\n", adv_dvc->carrier_buf);
+	adv_dvc->carrier = dma_alloc_coherent(board->dev,
+		ADV_CARRIER_BUFSIZE, &adv_dvc->carrier_addr, GFP_KERNEL);
+	ASC_DBG(1, "carrier 0x%p\n", adv_dvc->carrier);
 
-	if (!adv_dvc->carrier_buf)
+	if (!adv_dvc->carrier)
 		goto kmalloc_failed;
 
 	/*
@@ -11309,8 +11275,12 @@ static int advansys_wide_init_chip(struct Scsi_Host *shost)
 static void advansys_wide_free_mem(struct asc_board *board)
 {
 	struct adv_dvc_var *adv_dvc = &board->dvc_var.adv_dvc_var;
-	kfree(adv_dvc->carrier_buf);
-	adv_dvc->carrier_buf = NULL;
+
+	if (adv_dvc->carrier) {
+		dma_free_coherent(board->dev, ADV_CARRIER_BUFSIZE,
+				  adv_dvc->carrier, adv_dvc->carrier_addr);
+		adv_dvc->carrier = NULL;
+	}
 	kfree(board->adv_reqp);
 	board->adv_reqp = NULL;
 	while (board->adv_sgblkp) {
-- 
1.8.5.2

