From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/17] lpfc 8.3.2 : Reorganization for SLI4 - Part 2 of 3
Date: Fri, 22 May 2009 14:51:21 -0400
Message-ID: <1243018281.7729.41.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41929 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbZEVSvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:51:24 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIpPsS029645
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:51:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Reorganization for SLI4 - Part 2 of 3

Preps the organization of the driver so that the bottom half, which
interacts with the hardware, can share common code sequences for
attachment, detachment, initialization, teardown, etc with new hardware.

For very common code sections, which become specific to the interface
type, the driver uses an indirect function call. The function is set at
initialization. For less common sections, such as initialization, the
driver looks at the interface type and calls the routines relative to
the interface.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |  435 +++++++++++++++++--------
 lpfc_sli.c  | 1008 ++++++++++++++++++++++++++++++++++++++----------------------
 2 files changed, 932 insertions(+), 511 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-05-22 13:14:55.000000000 -0400
@@ -438,22 +438,23 @@ lpfc_scsi_dev_block(struct lpfc_hba *phb
 }
 
 /**
- * lpfc_new_scsi_buf - Scsi buffer allocator
+ * lpfc_new_scsi_buf_s3 - Scsi buffer allocator for HBA with SLI3 IF spec
  * @vport: The virtual port for which this call being executed.
+ * @num_to_allocate: The requested number of buffers to allocate.
  *
- * This routine allocates a scsi buffer, which contains all the necessary
- * information needed to initiate a SCSI I/O.  The non-DMAable buffer region
- * contains information to build the IOCB.  The DMAable region contains
- * memory for the FCP CMND, FCP RSP, and the initial BPL.  In addition to
- * allocating memory, the FCP CMND and FCP RSP BDEs are setup in the BPL
- * and the BPL BDE is setup in the IOCB.
+ * This routine allocates a scsi buffer for device with SLI-3 interface spec,
+ * the scsi buffer contains all the necessary information needed to initiate
+ * a SCSI I/O. The non-DMAable buffer region contains information to build
+ * the IOCB. The DMAable region contains memory for the FCP CMND, FCP RSP,
+ * and the initial BPL. In addition to allocating memory, the FCP CMND and
+ * FCP RSP BDEs are setup in the BPL and the BPL BDE is setup in the IOCB.
  *
  * Return codes:
- *   NULL - Error
- *   Pointer to lpfc_scsi_buf data structure - Success
+ *   int - number of scsi buffers that were allocated.
+ *   0 = failure, less than num_to_alloc is a partial failure.
  **/
-static struct lpfc_scsi_buf *
-lpfc_new_scsi_buf(struct lpfc_vport *vport)
+static int
+lpfc_new_scsi_buf_s3(struct lpfc_vport *vport, int num_to_alloc)
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_scsi_buf *psb;
@@ -463,107 +464,134 @@ lpfc_new_scsi_buf(struct lpfc_vport *vpo
 	dma_addr_t pdma_phys_fcp_rsp;
 	dma_addr_t pdma_phys_bpl;
 	uint16_t iotag;
+	int bcnt;
+
+	for (bcnt = 0; bcnt < num_to_alloc; bcnt++) {
+		psb = kzalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
+		if (!psb)
+			break;
+
+		/*
+		 * Get memory from the pci pool to map the virt space to pci
+		 * bus space for an I/O.  The DMA buffer includes space for the
+		 * struct fcp_cmnd, struct fcp_rsp and the number of bde's
+		 * necessary to support the sg_tablesize.
+		 */
+		psb->data = pci_pool_alloc(phba->lpfc_scsi_dma_buf_pool,
+					GFP_KERNEL, &psb->dma_handle);
+		if (!psb->data) {
+			kfree(psb);
+			break;
+		}
+
+		/* Initialize virtual ptrs to dma_buf region. */
+		memset(psb->data, 0, phba->cfg_sg_dma_buf_size);
+
+		/* Allocate iotag for psb->cur_iocbq. */
+		iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
+		if (iotag == 0) {
+			pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
+					psb->data, psb->dma_handle);
+			kfree(psb);
+			break;
+		}
+		psb->cur_iocbq.iocb_flag |= LPFC_IO_FCP;
 
-	psb = kzalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
-	if (!psb)
-		return NULL;
-
-	/*
-	 * Get memory from the pci pool to map the virt space to pci bus space
-	 * for an I/O.  The DMA buffer includes space for the struct fcp_cmnd,
-	 * struct fcp_rsp and the number of bde's necessary to support the
-	 * sg_tablesize.
-	 */
-	psb->data = pci_pool_alloc(phba->lpfc_scsi_dma_buf_pool, GFP_KERNEL,
-							&psb->dma_handle);
-	if (!psb->data) {
-		kfree(psb);
-		return NULL;
-	}
-
-	/* Initialize virtual ptrs to dma_buf region. */
-	memset(psb->data, 0, phba->cfg_sg_dma_buf_size);
-
-	/* Allocate iotag for psb->cur_iocbq. */
-	iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
-	if (iotag == 0) {
-		pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
-			      psb->data, psb->dma_handle);
-		kfree (psb);
-		return NULL;
-	}
-	psb->cur_iocbq.iocb_flag |= LPFC_IO_FCP;
-
-	psb->fcp_cmnd = psb->data;
-	psb->fcp_rsp = psb->data + sizeof(struct fcp_cmnd);
-	psb->fcp_bpl = psb->data + sizeof(struct fcp_cmnd) +
-							sizeof(struct fcp_rsp);
-
-	/* Initialize local short-hand pointers. */
-	bpl = psb->fcp_bpl;
-	pdma_phys_fcp_cmd = psb->dma_handle;
-	pdma_phys_fcp_rsp = psb->dma_handle + sizeof(struct fcp_cmnd);
-	pdma_phys_bpl = psb->dma_handle + sizeof(struct fcp_cmnd) +
+		psb->fcp_cmnd = psb->data;
+		psb->fcp_rsp = psb->data + sizeof(struct fcp_cmnd);
+		psb->fcp_bpl = psb->data + sizeof(struct fcp_cmnd) +
 			sizeof(struct fcp_rsp);
 
-	/*
-	 * The first two bdes are the FCP_CMD and FCP_RSP.  The balance are sg
-	 * list bdes.  Initialize the first two and leave the rest for
-	 * queuecommand.
-	 */
-	bpl[0].addrHigh = le32_to_cpu(putPaddrHigh(pdma_phys_fcp_cmd));
-	bpl[0].addrLow = le32_to_cpu(putPaddrLow(pdma_phys_fcp_cmd));
-	bpl[0].tus.f.bdeSize = sizeof(struct fcp_cmnd);
-	bpl[0].tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-	bpl[0].tus.w = le32_to_cpu(bpl[0].tus.w);
-
-	/* Setup the physical region for the FCP RSP */
-	bpl[1].addrHigh = le32_to_cpu(putPaddrHigh(pdma_phys_fcp_rsp));
-	bpl[1].addrLow = le32_to_cpu(putPaddrLow(pdma_phys_fcp_rsp));
-	bpl[1].tus.f.bdeSize = sizeof(struct fcp_rsp);
-	bpl[1].tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-	bpl[1].tus.w = le32_to_cpu(bpl[1].tus.w);
-
-	/*
-	 * Since the IOCB for the FCP I/O is built into this lpfc_scsi_buf,
-	 * initialize it with all known data now.
-	 */
-	iocb = &psb->cur_iocbq.iocb;
-	iocb->un.fcpi64.bdl.ulpIoTag32 = 0;
-	if ((phba->sli_rev == 3) &&
-	    !(phba->sli3_options & LPFC_SLI3_BG_ENABLED)) {
-		/* fill in immediate fcp command BDE */
-		iocb->un.fcpi64.bdl.bdeFlags = BUFF_TYPE_BDE_IMMED;
-		iocb->un.fcpi64.bdl.bdeSize = sizeof(struct fcp_cmnd);
-		iocb->un.fcpi64.bdl.addrLow = offsetof(IOCB_t,
-						       unsli3.fcp_ext.icd);
-		iocb->un.fcpi64.bdl.addrHigh = 0;
-		iocb->ulpBdeCount = 0;
-		iocb->ulpLe = 0;
-		/* fill in responce BDE */
-		iocb->unsli3.fcp_ext.rbde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
-		iocb->unsli3.fcp_ext.rbde.tus.f.bdeSize =
-						sizeof(struct fcp_rsp);
-		iocb->unsli3.fcp_ext.rbde.addrLow =
-						putPaddrLow(pdma_phys_fcp_rsp);
-		iocb->unsli3.fcp_ext.rbde.addrHigh =
-						putPaddrHigh(pdma_phys_fcp_rsp);
-	} else {
-		iocb->un.fcpi64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
-		iocb->un.fcpi64.bdl.bdeSize = (2 * sizeof(struct ulp_bde64));
-		iocb->un.fcpi64.bdl.addrLow = putPaddrLow(pdma_phys_bpl);
-		iocb->un.fcpi64.bdl.addrHigh = putPaddrHigh(pdma_phys_bpl);
-		iocb->ulpBdeCount = 1;
-		iocb->ulpLe = 1;
+		/* Initialize local short-hand pointers. */
+		bpl = psb->fcp_bpl;
+		pdma_phys_fcp_cmd = psb->dma_handle;
+		pdma_phys_fcp_rsp = psb->dma_handle + sizeof(struct fcp_cmnd);
+		pdma_phys_bpl = psb->dma_handle + sizeof(struct fcp_cmnd) +
+			sizeof(struct fcp_rsp);
+
+		/*
+		 * The first two bdes are the FCP_CMD and FCP_RSP. The balance
+		 * are sg list bdes.  Initialize the first two and leave the
+		 * rest for queuecommand.
+		 */
+		bpl[0].addrHigh = le32_to_cpu(putPaddrHigh(pdma_phys_fcp_cmd));
+		bpl[0].addrLow = le32_to_cpu(putPaddrLow(pdma_phys_fcp_cmd));
+		bpl[0].tus.f.bdeSize = sizeof(struct fcp_cmnd);
+		bpl[0].tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		bpl[0].tus.w = le32_to_cpu(bpl[0].tus.w);
+
+		/* Setup the physical region for the FCP RSP */
+		bpl[1].addrHigh = le32_to_cpu(putPaddrHigh(pdma_phys_fcp_rsp));
+		bpl[1].addrLow = le32_to_cpu(putPaddrLow(pdma_phys_fcp_rsp));
+		bpl[1].tus.f.bdeSize = sizeof(struct fcp_rsp);
+		bpl[1].tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		bpl[1].tus.w = le32_to_cpu(bpl[1].tus.w);
+
+		/*
+		 * Since the IOCB for the FCP I/O is built into this
+		 * lpfc_scsi_buf, initialize it with all known data now.
+		 */
+		iocb = &psb->cur_iocbq.iocb;
+		iocb->un.fcpi64.bdl.ulpIoTag32 = 0;
+		if ((phba->sli_rev == 3) &&
+				!(phba->sli3_options & LPFC_SLI3_BG_ENABLED)) {
+			/* fill in immediate fcp command BDE */
+			iocb->un.fcpi64.bdl.bdeFlags = BUFF_TYPE_BDE_IMMED;
+			iocb->un.fcpi64.bdl.bdeSize = sizeof(struct fcp_cmnd);
+			iocb->un.fcpi64.bdl.addrLow = offsetof(IOCB_t,
+					unsli3.fcp_ext.icd);
+			iocb->un.fcpi64.bdl.addrHigh = 0;
+			iocb->ulpBdeCount = 0;
+			iocb->ulpLe = 0;
+			/* fill in responce BDE */
+			iocb->unsli3.fcp_ext.rbde.tus.f.bdeFlags =
+							BUFF_TYPE_BDE_64;
+			iocb->unsli3.fcp_ext.rbde.tus.f.bdeSize =
+				sizeof(struct fcp_rsp);
+			iocb->unsli3.fcp_ext.rbde.addrLow =
+				putPaddrLow(pdma_phys_fcp_rsp);
+			iocb->unsli3.fcp_ext.rbde.addrHigh =
+				putPaddrHigh(pdma_phys_fcp_rsp);
+		} else {
+			iocb->un.fcpi64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
+			iocb->un.fcpi64.bdl.bdeSize =
+					(2 * sizeof(struct ulp_bde64));
+			iocb->un.fcpi64.bdl.addrLow =
+					putPaddrLow(pdma_phys_bpl);
+			iocb->un.fcpi64.bdl.addrHigh =
+					putPaddrHigh(pdma_phys_bpl);
+			iocb->ulpBdeCount = 1;
+			iocb->ulpLe = 1;
+		}
+		iocb->ulpClass = CLASS3;
+		psb->status = IOSTAT_SUCCESS;
+
 	}
-	iocb->ulpClass = CLASS3;
 
-	return psb;
+	return bcnt;
 }
 
 /**
- * lpfc_get_scsi_buf - Get a scsi buffer from lpfc_scsi_buf_list list of Hba
- * @phba: The Hba for which this call is being executed.
+ * lpfc_new_scsi_buf - Wrapper funciton for scsi buffer allocator
+ * @vport: The virtual port for which this call being executed.
+ * @num_to_allocate: The requested number of buffers to allocate.
+ *
+ * This routine wraps the actual SCSI buffer allocator function pointer from
+ * the lpfc_hba struct.
+ *
+ * Return codes:
+ *   int - number of scsi buffers that were allocated.
+ *   0 = failure, less than num_to_alloc is a partial failure.
+ **/
+static inline int
+lpfc_new_scsi_buf(struct lpfc_vport *vport, int num_to_alloc)
+{
+	return vport->phba->lpfc_new_scsi_buf(vport, num_to_alloc);
+}
+
+/**
+ * lpfc_get_scsi_buf - Get a scsi buffer from lpfc_scsi_buf_list of the HBA
+ * @phba: The HBA for which this call is being executed.
  *
  * This routine removes a scsi buffer from head of @phba lpfc_scsi_buf_list list
  * and returns to caller.
@@ -591,7 +619,7 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba
 }
 
 /**
- * lpfc_release_scsi_buf - Return a scsi buffer back to hba's lpfc_scsi_buf_list
+ * lpfc_release_scsi_buf - Return a scsi buffer back to hba scsi buf list
  * @phba: The Hba for which this call is being executed.
  * @psb: The scsi buffer which is being released.
  *
@@ -599,7 +627,7 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba
  * lpfc_scsi_buf_list list.
  **/
 static void
-lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
+lpfc_release_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 {
 	unsigned long iflag = 0;
 
@@ -610,21 +638,36 @@ lpfc_release_scsi_buf(struct lpfc_hba *p
 }
 
 /**
- * lpfc_scsi_prep_dma_buf - Routine to do DMA mapping for scsi buffer
+ * lpfc_release_scsi_buf: Return a scsi buffer back to hba scsi buf list.
+ * @phba: The Hba for which this call is being executed.
+ * @psb: The scsi buffer which is being released.
+ *
+ * This routine releases @psb scsi buffer by adding it to tail of @phba
+ * lpfc_scsi_buf_list list.
+ **/
+static void
+lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
+{
+
+	phba->lpfc_release_scsi_buf(phba, psb);
+}
+
+/**
+ * lpfc_scsi_prep_dma_buf_s3 - DMA mapping for scsi buffer to SLI3 IF spec
  * @phba: The Hba for which this call is being executed.
  * @lpfc_cmd: The scsi buffer which is going to be mapped.
  *
  * This routine does the pci dma mapping for scatter-gather list of scsi cmnd
- * field of @lpfc_cmd. This routine scans through sg elements and format the
- * bdea. This routine also initializes all IOCB fields which are dependent on
- * scsi command request buffer.
+ * field of @lpfc_cmd for device with SLI-3 interface spec. This routine scans
+ * through sg elements and format the bdea. This routine also initializes all
+ * IOCB fields which are dependent on scsi command request buffer.
  *
  * Return codes:
  *   1 - Error
  *   0 - Success
  **/
 static int
-lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
+lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 {
 	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
 	struct scatterlist *sgel = NULL;
@@ -1412,6 +1455,24 @@ out:
 }
 
 /**
+ * lpfc_scsi_prep_dma_buf - Wrapper function for DMA mapping of scsi buffer
+ * @phba: The Hba for which this call is being executed.
+ * @lpfc_cmd: The scsi buffer which is going to be mapped.
+ *
+ * This routine wraps the actual DMA mapping function pointer from the
+ * lpfc_hba struct.
+ *
+ * Return codes:
+ * 	1 - Error
+ * 	0 - Success
+ **/
+static inline int
+lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
+{
+	return phba->lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
+}
+
+/**
  * lpfc_send_scsi_error_event - Posts an event when there is SCSI error
  * @phba: Pointer to hba context object.
  * @vport: Pointer to vport object.
@@ -1504,15 +1565,15 @@ lpfc_send_scsi_error_event(struct lpfc_h
 }
 
 /**
- * lpfc_scsi_unprep_dma_buf - Routine to un-map DMA mapping of scatter gather
- * @phba: The Hba for which this call is being executed.
+ * lpfc_scsi_unprep_dma_buf_s3 - Un-map DMA mapping of SG-list for SLI3 dev
+ * @phba: The HBA for which this call is being executed.
  * @psb: The scsi buffer which is going to be un-mapped.
  *
  * This routine does DMA un-mapping of scatter gather list of scsi command
- * field of @lpfc_cmd.
+ * field of @lpfc_cmd for device with SLI-3 interface spec.
  **/
 static void
-lpfc_scsi_unprep_dma_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * psb)
+lpfc_scsi_unprep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 {
 	/*
 	 * There are only two special cases to consider.  (1) the scsi command
@@ -1529,6 +1590,20 @@ lpfc_scsi_unprep_dma_buf(struct lpfc_hba
 }
 
 /**
+ * lpfc_scsi_unprep_dma_buf - Wrapper function for unmap DMA mapping of SG-list
+ * @phba: The Hba for which this call is being executed.
+ * @psb: The scsi buffer which is going to be un-mapped.
+ *
+ * This routine does DMA un-mapping of scatter gather list of scsi command
+ * field of @lpfc_cmd for device with SLI-4 interface spec.
+ **/
+static void
+lpfc_scsi_unprep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
+{
+	phba->lpfc_scsi_unprep_dma_buf(phba, psb);
+}
+
+/**
  * lpfc_handler_fcp_err - FCP response handler
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
@@ -1676,7 +1751,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
  * lpfc_scsi_cmd_iocb_cmpl - Scsi cmnd IOCB completion routine
  * @phba: The Hba for which this call is being executed.
  * @pIocbIn: The command IOCBQ for the scsi cmnd.
- * @pIocbOut: The response IOCBQ for the scsi cmnd .
+ * @pIocbOut: The response IOCBQ for the scsi cmnd.
  *
  * This routine assigns scsi command result by looking into response IOCB
  * status field appropriately. This routine handles QUEUE FULL condition as
@@ -1957,16 +2032,16 @@ lpfc_fcpcmd_to_iocb(uint8_t *data, struc
 }
 
 /**
- * lpfc_scsi_prep_cmnd -  Routine to convert scsi cmnd to FCP information unit
+ * lpfc_scsi_prep_cmnd_s3 - Convert scsi cmnd to FCP infor unit for SLI3 dev
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: The scsi command which needs to send.
  * @pnode: Pointer to lpfc_nodelist.
  *
  * This routine initializes fcp_cmnd and iocb data structure from scsi command
- * to transfer.
+ * to transfer for device with SLI3 interface spec.
  **/
 static void
-lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
+lpfc_scsi_prep_cmnd_s3(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		    struct lpfc_nodelist *pnode)
 {
 	struct lpfc_hba *phba = vport->phba;
@@ -2013,8 +2088,11 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	if (scsi_sg_count(scsi_cmnd)) {
 		if (datadir == DMA_TO_DEVICE) {
 			iocb_cmd->ulpCommand = CMD_FCP_IWRITE64_CR;
-			iocb_cmd->un.fcpi.fcpi_parm = 0;
-			iocb_cmd->ulpPU = 0;
+			if (phba->sli_rev < LPFC_SLI_REV4) {
+				iocb_cmd->un.fcpi.fcpi_parm = 0;
+				iocb_cmd->ulpPU = 0;
+			} else
+				iocb_cmd->ulpPU = PARM_READ_CHECK;
 			fcp_cmnd->fcpCntl3 = WRITE_DATA;
 			phba->fc4OutputRequests++;
 		} else {
@@ -2051,20 +2129,37 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 }
 
 /**
- * lpfc_scsi_prep_task_mgmt_cmnd - Convert scsi TM cmnd to FCP information unit
+ * lpfc_scsi_prep_cmnd - Wrapper func for convert scsi cmnd to FCP info unit
+ * @vport: The virtual port for which this call is being executed.
+ * @lpfc_cmd: The scsi command which needs to send.
+ * @pnode: Pointer to lpfc_nodelist.
+ *
+ * This routine wraps the actual convert SCSI cmnd function pointer from
+ * the lpfc_hba struct.
+ **/
+static inline void
+lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
+		    struct lpfc_nodelist *pnode)
+{
+	vport->phba->lpfc_scsi_prep_cmnd(vport, lpfc_cmd, pnode);
+}
+
+/**
+ * lpfc_scsi_prep_task_mgmt_cmnd_s3 - Convert SLI3 scsi TM cmd to FCP info unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
  * @lun: Logical unit number.
  * @task_mgmt_cmd: SCSI task management command.
  *
- * This routine creates FCP information unit corresponding to @task_mgmt_cmd.
+ * This routine creates FCP information unit corresponding to @task_mgmt_cmd
+ * for device with SLI-3 interface spec.
  *
  * Return codes:
  *   0 - Error
  *   1 - Success
  **/
 static int
-lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
+lpfc_scsi_prep_task_mgmt_cmd_s3(struct lpfc_vport *vport,
 			     struct lpfc_scsi_buf *lpfc_cmd,
 			     unsigned int lun,
 			     uint8_t task_mgmt_cmd)
@@ -2114,6 +2209,67 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 }
 
 /**
+ * lpfc_scsi_prep_task_mgmt_cmnd - Wrapper func convert scsi TM cmd to FCP info
+ * @vport: The virtual port for which this call is being executed.
+ * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
+ * @lun: Logical unit number.
+ * @task_mgmt_cmd: SCSI task management command.
+ *
+ * This routine wraps the actual convert SCSI TM to FCP information unit
+ * function pointer from the lpfc_hba struct.
+ *
+ * Return codes:
+ * 	0 - Error
+ * 	1 - Success
+ **/
+static inline int
+lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
+			     struct lpfc_scsi_buf *lpfc_cmd,
+			     unsigned int lun,
+			     uint8_t task_mgmt_cmd)
+{
+	struct lpfc_hba *phba = vport->phba;
+
+	return phba->lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun,
+						  task_mgmt_cmd);
+}
+
+/**
+ * lpfc_scsi_api_table_setup - Set up scsi api fucntion jump table
+ * @phba: The hba struct for which this call is being executed.
+ * @dev_grp: The HBA PCI-Device group number.
+ *
+ * This routine sets up the SCSI interface API function jump table in @phba
+ * struct.
+ * Returns: 0 - success, -ENODEV - failure.
+ **/
+int
+lpfc_scsi_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
+{
+
+	switch (dev_grp) {
+	case LPFC_PCI_DEV_LP:
+		phba->lpfc_new_scsi_buf = lpfc_new_scsi_buf_s3;
+		phba->lpfc_scsi_prep_dma_buf = lpfc_scsi_prep_dma_buf_s3;
+		phba->lpfc_scsi_prep_cmnd = lpfc_scsi_prep_cmnd_s3;
+		phba->lpfc_scsi_unprep_dma_buf = lpfc_scsi_unprep_dma_buf_s3;
+		phba->lpfc_scsi_prep_task_mgmt_cmd =
+					lpfc_scsi_prep_task_mgmt_cmd_s3;
+		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s3;
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"1418 Invalid HBA PCI-device group: 0x%x\n",
+				dev_grp);
+		return -ENODEV;
+		break;
+	}
+	phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf;
+	phba->lpfc_rampdown_queue_depth = lpfc_rampdown_queue_depth;
+	return 0;
+}
+
+/**
  * lpfc_taskmgmt_def_cmpl - IOCB completion routine for task management command
  * @phba: The Hba for which this call is being executed.
  * @cmdiocbq: Pointer to lpfc_iocbq data structure.
@@ -2531,7 +2687,10 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	icmd = &abtsiocb->iocb;
 	icmd->un.acxri.abortType = ABORT_TYPE_ABTS;
 	icmd->un.acxri.abortContextTag = cmd->ulpContext;
-	icmd->un.acxri.abortIoTag = cmd->ulpIoTag;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		icmd->un.acxri.abortIoTag = iocb->sli4_xritag;
+	else
+		icmd->un.acxri.abortIoTag = cmd->ulpIoTag;
 
 	icmd->ulpLe = 1;
 	icmd->ulpClass = cmd->ulpClass;
@@ -2825,11 +2984,10 @@ lpfc_slave_alloc(struct scsi_device *sde
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_scsi_buf *scsi_buf = NULL;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
-	uint32_t total = 0, i;
+	uint32_t total = 0;
 	uint32_t num_to_alloc = 0;
-	unsigned long flags;
+	int num_allocated = 0;
 
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
@@ -2863,20 +3021,13 @@ lpfc_slave_alloc(struct scsi_device *sde
 				 (phba->cfg_hba_queue_depth - total));
 		num_to_alloc = phba->cfg_hba_queue_depth - total;
 	}
-
-	for (i = 0; i < num_to_alloc; i++) {
-		scsi_buf = lpfc_new_scsi_buf(vport);
-		if (!scsi_buf) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-					 "0706 Failed to allocate "
-					 "command buffer\n");
-			break;
-		}
-
-		spin_lock_irqsave(&phba->scsi_buf_list_lock, flags);
-		phba->total_scsi_bufs++;
-		list_add_tail(&scsi_buf->list, &phba->lpfc_scsi_buf_list);
-		spin_unlock_irqrestore(&phba->scsi_buf_list_lock, flags);
+	num_allocated = lpfc_new_scsi_buf(vport, num_to_alloc);
+	if (num_to_alloc != num_allocated) {
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
+				 "0708 Allocation request of %d "
+				 "command buffers did not succeed.  "
+				 "Allocated %d buffers.\n",
+				 num_to_alloc, num_allocated);
 	}
 	return 0;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-05-19 09:39:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 13:14:55.000000000 -0400
@@ -142,7 +142,7 @@ lpfc_sli_get_iocbq(struct lpfc_hba *phba
 }
 
 /**
- * __lpfc_sli_release_iocbq - Release iocb to the iocb pool
+ * __lpfc_sli_release_iocbq_s3 - Release iocb to the iocb pool
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to driver iocb object.
  *
@@ -152,7 +152,7 @@ lpfc_sli_get_iocbq(struct lpfc_hba *phba
  * clears all other fields of the iocb object when it is freed.
  **/
 static void
-__lpfc_sli_release_iocbq(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
+__lpfc_sli_release_iocbq_s3(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
 
@@ -160,10 +160,27 @@ __lpfc_sli_release_iocbq(struct lpfc_hba
 	 * Clean all volatile data fields, preserve iotag and node struct.
 	 */
 	memset((char*)iocbq + start_clean, 0, sizeof(*iocbq) - start_clean);
+	iocbq->sli4_xritag = NO_XRI;
 	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
 }
 
 /**
+ * __lpfc_sli_release_iocbq - Release iocb to the iocb pool
+ * @phba: Pointer to HBA context object.
+ * @iocbq: Pointer to driver iocb object.
+ *
+ * This function is called with hbalock held to release driver
+ * iocb object to the iocb pool. The iotag in the iocb object
+ * does not change for each use of the iocb object. This function
+ * clears all other fields of the iocb object when it is freed.
+ **/
+static void
+__lpfc_sli_release_iocbq(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
+{
+	phba->__lpfc_sli_release_iocbq(phba, iocbq);
+}
+
+/**
  * lpfc_sli_release_iocbq - Release iocb to the iocb pool
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to driver iocb object.
@@ -779,8 +796,8 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba
 		phba->hbqs[i].buffer_count = 0;
 	}
 	/* Return all HBQ buffer that are in-fly */
-	list_for_each_entry_safe(dmabuf, next_dmabuf,
-			&phba->hbqbuf_in_list, list) {
+	list_for_each_entry_safe(dmabuf, next_dmabuf, &phba->rb_pend_list,
+				 list) {
 		hbq_buf = container_of(dmabuf, struct hbq_dmabuf, dbuf);
 		list_del(&hbq_buf->dbuf.list);
 		if (hbq_buf->tag == -1) {
@@ -814,10 +831,28 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba
  * pointer to the hbq entry if it successfully post the buffer
  * else it will return NULL.
  **/
-static struct lpfc_hbq_entry *
+static int
 lpfc_sli_hbq_to_firmware(struct lpfc_hba *phba, uint32_t hbqno,
 			 struct hbq_dmabuf *hbq_buf)
 {
+	return phba->lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buf);
+}
+
+/**
+ * lpfc_sli_hbq_to_firmware_s3 - Post the hbq buffer to SLI3 firmware
+ * @phba: Pointer to HBA context object.
+ * @hbqno: HBQ number.
+ * @hbq_buf: Pointer to HBQ buffer.
+ *
+ * This function is called with the hbalock held to post a hbq buffer to the
+ * firmware. If the function finds an empty slot in the HBQ, it will post the
+ * buffer and place it on the hbq_buffer_list. The function will return zero if
+ * it successfully post the buffer else it will return an error.
+ **/
+static int
+lpfc_sli_hbq_to_firmware_s3(struct lpfc_hba *phba, uint32_t hbqno,
+			    struct hbq_dmabuf *hbq_buf)
+{
 	struct lpfc_hbq_entry *hbqe;
 	dma_addr_t physaddr = hbq_buf->dbuf.phys;
 
@@ -838,8 +873,9 @@ lpfc_sli_hbq_to_firmware(struct lpfc_hba
 				/* flush */
 		readl(phba->hbq_put + hbqno);
 		list_add_tail(&hbq_buf->dbuf.list, &hbqp->hbq_buffer_list);
-	}
-	return hbqe;
+		return 0;
+	} else
+		return -ENOMEM;
 }
 
 /* HBQ for ELS and CT traffic. */
@@ -914,7 +950,7 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hb
 				 dbuf.list);
 		hbq_buffer->tag = (phba->hbqs[hbqno].buffer_count |
 				      (hbqno << 16));
-		if (lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer)) {
+		if (!lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer)) {
 			phba->hbqs[hbqno].buffer_count++;
 			posted++;
 		} else
@@ -965,6 +1001,25 @@ lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hb
 }
 
 /**
+ * lpfc_sli_hbqbuf_get - Remove the first hbq off of an hbq list
+ * @phba: Pointer to HBA context object.
+ * @hbqno: HBQ number.
+ *
+ * This function removes the first hbq buffer on an hbq list and returns a
+ * pointer to that buffer. If it finds no buffers on the list it returns NULL.
+ **/
+static struct hbq_dmabuf *
+lpfc_sli_hbqbuf_get(struct list_head *rb_list)
+{
+	struct lpfc_dmabuf *d_buf;
+
+	list_remove_head(rb_list, d_buf, struct lpfc_dmabuf, list);
+	if (!d_buf)
+		return NULL;
+	return container_of(d_buf, struct hbq_dmabuf, dbuf);
+}
+
+/**
  * lpfc_sli_hbqbuf_find - Find the hbq buffer associated with a tag
  * @phba: Pointer to HBA context object.
  * @tag: Tag of the hbq buffer.
@@ -985,12 +1040,15 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *ph
 	if (hbqno >= LPFC_MAX_HBQS)
 		return NULL;
 
+	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry(d_buf, &phba->hbqs[hbqno].hbq_buffer_list, list) {
 		hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 		if (hbq_buf->tag == tag) {
+			spin_unlock_irq(&phba->hbalock);
 			return hbq_buf;
 		}
 	}
+	spin_unlock_irq(&phba->hbalock);
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI | LOG_VPORT,
 			"1803 Bad hbq tag. Data: x%x x%x\n",
 			tag, phba->hbqs[tag >> 16].buffer_count);
@@ -1013,9 +1071,8 @@ lpfc_sli_free_hbq(struct lpfc_hba *phba,
 
 	if (hbq_buffer) {
 		hbqno = hbq_buffer->tag >> 16;
-		if (!lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer)) {
+		if (lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer))
 			(phba->hbqs[hbqno].hbq_free_buffer)(phba, hbq_buffer);
-		}
 	}
 }
 
@@ -1317,6 +1374,45 @@ lpfc_sli_get_buff(struct lpfc_hba *phba,
 	return &hbq_entry->dbuf;
 }
 
+/**
+ * lpfc_complete_unsol_iocb - Complete an unsolicited sequence
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @saveq: Pointer to the iocbq struct representing the sequence starting frame.
+ * @fch_r_ctl: the r_ctl for the first frame of the sequence.
+ * @fch_type: the type for the first frame of the sequence.
+ *
+ * This function is called with no lock held. This function uses the r_ctl and
+ * type of the received sequence to find the correct callback function to call
+ * to process the sequence.
+ **/
+static int
+lpfc_complete_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			 struct lpfc_iocbq *saveq, uint32_t fch_r_ctl,
+			 uint32_t fch_type)
+{
+	int i;
+
+	/* unSolicited Responses */
+	if (pring->prt[0].profile) {
+		if (pring->prt[0].lpfc_sli_rcv_unsol_event)
+			(pring->prt[0].lpfc_sli_rcv_unsol_event) (phba, pring,
+									saveq);
+		return 1;
+	}
+	/* We must search, based on rctl / type
+	   for the right routine */
+	for (i = 0; i < pring->num_mask; i++) {
+		if ((pring->prt[i].rctl == fch_r_ctl) &&
+		    (pring->prt[i].type == fch_type)) {
+			if (pring->prt[i].lpfc_sli_rcv_unsol_event)
+				(pring->prt[i].lpfc_sli_rcv_unsol_event)
+						(phba, pring, saveq);
+			return 1;
+		}
+	}
+	return 0;
+}
 
 /**
  * lpfc_sli_process_unsol_iocb - Unsolicited iocb handler
@@ -1339,7 +1435,7 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 	IOCB_t           * irsp;
 	WORD5            * w5p;
 	uint32_t           Rctl, Type;
-	uint32_t           match, i;
+	uint32_t           match;
 	struct lpfc_iocbq *iocbq;
 	struct lpfc_dmabuf *dmzbuf;
 
@@ -1482,35 +1578,12 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 		}
 	}
 
-	/* unSolicited Responses */
-	if (pring->prt[0].profile) {
-		if (pring->prt[0].lpfc_sli_rcv_unsol_event)
-			(pring->prt[0].lpfc_sli_rcv_unsol_event) (phba, pring,
-									saveq);
-		match = 1;
-	} else {
-		/* We must search, based on rctl / type
-		   for the right routine */
-		for (i = 0; i < pring->num_mask; i++) {
-			if ((pring->prt[i].rctl == Rctl)
-			    && (pring->prt[i].type == Type)) {
-				if (pring->prt[i].lpfc_sli_rcv_unsol_event)
-					(pring->prt[i].lpfc_sli_rcv_unsol_event)
-							(phba, pring, saveq);
-				match = 1;
-				break;
-			}
-		}
-	}
-	if (match == 0) {
-		/* Unexpected Rctl / Type received */
-		/* Ring <ringno> handler: unexpected
-		   Rctl <Rctl> Type <Type> received */
+	if (!lpfc_complete_unsol_iocb(phba, pring, saveq, Rctl, Type))
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0313 Ring %d handler: unexpected Rctl x%x "
 				"Type x%x received\n",
 				pring->ringno, Rctl, Type);
-	}
+
 	return 1;
 }
 
@@ -1552,6 +1625,37 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *p
 }
 
 /**
+ * lpfc_sli_iocbq_lookup_by_tag - Find command iocb for the iotag
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @iotag: IOCB tag.
+ *
+ * This function looks up the iocb_lookup table to get the command iocb
+ * corresponding to the given iotag. This function is called with the
+ * hbalock held.
+ * This function returns the command iocb object if it finds the command
+ * iocb else returns NULL.
+ **/
+static struct lpfc_iocbq *
+lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
+			     struct lpfc_sli_ring *pring, uint16_t iotag)
+{
+	struct lpfc_iocbq *cmd_iocb;
+
+	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
+		cmd_iocb = phba->sli.iocbq_lookup[iotag];
+		list_del_init(&cmd_iocb->list);
+		pring->txcmplq_cnt--;
+		return cmd_iocb;
+	}
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+			"0372 iotag x%x is out off range: max iotag (x%x)\n",
+			iotag, phba->sli.last_iotag);
+	return NULL;
+}
+
+/**
  * lpfc_sli_process_sol_iocb - process solicited iocb completion
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
@@ -1954,7 +2058,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 			if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
 				(irsp->un.ulpWord[4] == IOERR_NO_RESOURCES)) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				lpfc_rampdown_queue_depth(phba);
+				phba->lpfc_rampdown_queue_depth(phba);
 				spin_lock_irqsave(&phba->hbalock, iflag);
 			}
 
@@ -2068,39 +2172,215 @@ lpfc_sli_handle_fast_ring_event(struct l
 }
 
 /**
- * lpfc_sli_handle_slow_ring_event - Handle ring events for non-FCP rings
+ * lpfc_sli_sp_handle_rspiocb - Handle slow-path response iocb
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @rspiocbp: Pointer to driver response IOCB object.
+ *
+ * This function is called from the worker thread when there is a slow-path
+ * response IOCB to process. This function chains all the response iocbs until
+ * seeing the iocb with the LE bit set. The function will call
+ * lpfc_sli_process_sol_iocb function if the response iocb indicates a
+ * completion of a command iocb. The function will call the
+ * lpfc_sli_process_unsol_iocb function if this is an unsolicited iocb.
+ * The function frees the resources or calls the completion handler if this
+ * iocb is an abort completion. The function returns NULL when the response
+ * iocb has the LE bit set and all the chained iocbs are processed, otherwise
+ * this function shall chain the iocb on to the iocb_continueq and return the
+ * response iocb passed in.
+ **/
+static struct lpfc_iocbq *
+lpfc_sli_sp_handle_rspiocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			struct lpfc_iocbq *rspiocbp)
+{
+	struct lpfc_iocbq *saveq;
+	struct lpfc_iocbq *cmdiocbp;
+	struct lpfc_iocbq *next_iocb;
+	IOCB_t *irsp = NULL;
+	uint32_t free_saveq;
+	uint8_t iocb_cmd_type;
+	lpfc_iocb_type type;
+	unsigned long iflag;
+	int rc;
+
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	/* First add the response iocb to the countinueq list */
+	list_add_tail(&rspiocbp->list, &(pring->iocb_continueq));
+	pring->iocb_continueq_cnt++;
+
+	/* Now, determine whetehr the list is completed for processing */
+	irsp = &rspiocbp->iocb;
+	if (irsp->ulpLe) {
+		/*
+		 * By default, the driver expects to free all resources
+		 * associated with this iocb completion.
+		 */
+		free_saveq = 1;
+		saveq = list_get_first(&pring->iocb_continueq,
+				       struct lpfc_iocbq, list);
+		irsp = &(saveq->iocb);
+		list_del_init(&pring->iocb_continueq);
+		pring->iocb_continueq_cnt = 0;
+
+		pring->stats.iocb_rsp++;
+
+		/*
+		 * If resource errors reported from HBA, reduce
+		 * queuedepths of the SCSI device.
+		 */
+		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
+		    (irsp->un.ulpWord[4] == IOERR_NO_RESOURCES)) {
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			phba->lpfc_rampdown_queue_depth(phba);
+			spin_lock_irqsave(&phba->hbalock, iflag);
+		}
+
+		if (irsp->ulpStatus) {
+			/* Rsp ring <ringno> error: IOCB */
+			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+					"0328 Rsp Ring %d error: "
+					"IOCB Data: "
+					"x%x x%x x%x x%x "
+					"x%x x%x x%x x%x "
+					"x%x x%x x%x x%x "
+					"x%x x%x x%x x%x\n",
+					pring->ringno,
+					irsp->un.ulpWord[0],
+					irsp->un.ulpWord[1],
+					irsp->un.ulpWord[2],
+					irsp->un.ulpWord[3],
+					irsp->un.ulpWord[4],
+					irsp->un.ulpWord[5],
+					*(((uint32_t *) irsp) + 6),
+					*(((uint32_t *) irsp) + 7),
+					*(((uint32_t *) irsp) + 8),
+					*(((uint32_t *) irsp) + 9),
+					*(((uint32_t *) irsp) + 10),
+					*(((uint32_t *) irsp) + 11),
+					*(((uint32_t *) irsp) + 12),
+					*(((uint32_t *) irsp) + 13),
+					*(((uint32_t *) irsp) + 14),
+					*(((uint32_t *) irsp) + 15));
+		}
+
+		/*
+		 * Fetch the IOCB command type and call the correct completion
+		 * routine. Solicited and Unsolicited IOCBs on the ELS ring
+		 * get freed back to the lpfc_iocb_list by the discovery
+		 * kernel thread.
+		 */
+		iocb_cmd_type = irsp->ulpCommand & CMD_IOCB_MASK;
+		type = lpfc_sli_iocb_cmd_type(iocb_cmd_type);
+		switch (type) {
+		case LPFC_SOL_IOCB:
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			rc = lpfc_sli_process_sol_iocb(phba, pring, saveq);
+			spin_lock_irqsave(&phba->hbalock, iflag);
+			break;
+
+		case LPFC_UNSOL_IOCB:
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			rc = lpfc_sli_process_unsol_iocb(phba, pring, saveq);
+			spin_lock_irqsave(&phba->hbalock, iflag);
+			if (!rc)
+				free_saveq = 0;
+			break;
+
+		case LPFC_ABORT_IOCB:
+			cmdiocbp = NULL;
+			if (irsp->ulpCommand != CMD_XRI_ABORTED_CX)
+				cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring,
+								 saveq);
+			if (cmdiocbp) {
+				/* Call the specified completion routine */
+				if (cmdiocbp->iocb_cmpl) {
+					spin_unlock_irqrestore(&phba->hbalock,
+							       iflag);
+					(cmdiocbp->iocb_cmpl)(phba, cmdiocbp,
+							      saveq);
+					spin_lock_irqsave(&phba->hbalock,
+							  iflag);
+				} else
+					__lpfc_sli_release_iocbq(phba,
+								 cmdiocbp);
+			}
+			break;
+
+		case LPFC_UNKNOWN_IOCB:
+			if (irsp->ulpCommand == CMD_ADAPTER_MSG) {
+				char adaptermsg[LPFC_MAX_ADPTMSG];
+				memset(adaptermsg, 0, LPFC_MAX_ADPTMSG);
+				memcpy(&adaptermsg[0], (uint8_t *)irsp,
+				       MAX_MSG_DATA);
+				dev_warn(&((phba->pcidev)->dev),
+					 "lpfc%d: %s\n",
+					 phba->brd_no, adaptermsg);
+			} else {
+				/* Unknown IOCB command */
+				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+						"0335 Unknown IOCB "
+						"command Data: x%x "
+						"x%x x%x x%x\n",
+						irsp->ulpCommand,
+						irsp->ulpStatus,
+						irsp->ulpIoTag,
+						irsp->ulpContext);
+			}
+			break;
+		}
+
+		if (free_saveq) {
+			list_for_each_entry_safe(rspiocbp, next_iocb,
+						 &saveq->list, list) {
+				list_del(&rspiocbp->list);
+				__lpfc_sli_release_iocbq(phba, rspiocbp);
+			}
+			__lpfc_sli_release_iocbq(phba, saveq);
+		}
+		rspiocbp = NULL;
+	}
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	return rspiocbp;
+}
+
+/**
+ * lpfc_sli_handle_slow_ring_event - Wrapper func for handling slow-path iocbs
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @mask: Host attention register mask for this ring.
  *
- * This function is called from the worker thread when there is a ring
- * event for non-fcp rings. The caller does not hold any lock .
- * The function processes each response iocb in the response ring until it
- * finds an iocb with LE bit set and chains all the iocbs upto the iocb with
- * LE bit set. The function will call lpfc_sli_process_sol_iocb function if the
- * response iocb indicates a completion of a command iocb. The function
- * will call lpfc_sli_process_unsol_iocb function if this is an unsolicited
- * iocb. The function frees the resources or calls the completion handler if
- * this iocb is an abort completion. The function returns 0 when the allocated
- * iocbs are not freed, otherwise returns 1.
+ * This routine wraps the actual slow_ring event process routine from the
+ * API jump table function pointer from the lpfc_hba struct.
  **/
-int
+void
 lpfc_sli_handle_slow_ring_event(struct lpfc_hba *phba,
 				struct lpfc_sli_ring *pring, uint32_t mask)
 {
+	phba->lpfc_sli_handle_slow_ring_event(phba, pring, mask);
+}
+
+/**
+ * lpfc_sli_handle_slow_ring_event_s3 - Handle SLI3 ring event for non-FCP rings
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @mask: Host attention register mask for this ring.
+ *
+ * This function is called from the worker thread when there is a ring event
+ * for non-fcp rings. The caller does not hold any lock. The function will
+ * remove each response iocb in the response ring and calls the handle
+ * response iocb routine (lpfc_sli_sp_handle_rspiocb) to process it.
+ **/
+static void
+lpfc_sli_handle_slow_ring_event_s3(struct lpfc_hba *phba,
+				   struct lpfc_sli_ring *pring, uint32_t mask)
+{
 	struct lpfc_pgp *pgp;
 	IOCB_t *entry;
 	IOCB_t *irsp = NULL;
 	struct lpfc_iocbq *rspiocbp = NULL;
-	struct lpfc_iocbq *next_iocb;
-	struct lpfc_iocbq *cmdiocbp;
-	struct lpfc_iocbq *saveq;
-	uint8_t iocb_cmd_type;
-	lpfc_iocb_type type;
-	uint32_t status, free_saveq;
 	uint32_t portRspPut, portRspMax;
-	int rc = 1;
 	unsigned long iflag;
+	uint32_t status;
 
 	pgp = &phba->port_gp[pring->ringno];
 	spin_lock_irqsave(&phba->hbalock, iflag);
@@ -2128,7 +2408,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 		phba->work_hs = HS_FFER3;
 		lpfc_handle_eratt(phba);
 
-		return 1;
+		return;
 	}
 
 	rmb();
@@ -2173,138 +2453,10 @@ lpfc_sli_handle_slow_ring_event(struct l
 
 		writel(pring->rspidx, &phba->host_gp[pring->ringno].rspGetInx);
 
-		list_add_tail(&rspiocbp->list, &(pring->iocb_continueq));
-
-		pring->iocb_continueq_cnt++;
-		if (irsp->ulpLe) {
-			/*
-			 * By default, the driver expects to free all resources
-			 * associated with this iocb completion.
-			 */
-			free_saveq = 1;
-			saveq = list_get_first(&pring->iocb_continueq,
-					       struct lpfc_iocbq, list);
-			irsp = &(saveq->iocb);
-			list_del_init(&pring->iocb_continueq);
-			pring->iocb_continueq_cnt = 0;
-
-			pring->stats.iocb_rsp++;
-
-			/*
-			 * If resource errors reported from HBA, reduce
-			 * queuedepths of the SCSI device.
-			 */
-			if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
-			     (irsp->un.ulpWord[4] == IOERR_NO_RESOURCES)) {
-				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				lpfc_rampdown_queue_depth(phba);
-				spin_lock_irqsave(&phba->hbalock, iflag);
-			}
-
-			if (irsp->ulpStatus) {
-				/* Rsp ring <ringno> error: IOCB */
-				lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-						"0328 Rsp Ring %d error: "
-						"IOCB Data: "
-						"x%x x%x x%x x%x "
-						"x%x x%x x%x x%x "
-						"x%x x%x x%x x%x "
-						"x%x x%x x%x x%x\n",
-						pring->ringno,
-						irsp->un.ulpWord[0],
-						irsp->un.ulpWord[1],
-						irsp->un.ulpWord[2],
-						irsp->un.ulpWord[3],
-						irsp->un.ulpWord[4],
-						irsp->un.ulpWord[5],
-						*(((uint32_t *) irsp) + 6),
-						*(((uint32_t *) irsp) + 7),
-						*(((uint32_t *) irsp) + 8),
-						*(((uint32_t *) irsp) + 9),
-						*(((uint32_t *) irsp) + 10),
-						*(((uint32_t *) irsp) + 11),
-						*(((uint32_t *) irsp) + 12),
-						*(((uint32_t *) irsp) + 13),
-						*(((uint32_t *) irsp) + 14),
-						*(((uint32_t *) irsp) + 15));
-			}
-
-			/*
-			 * Fetch the IOCB command type and call the correct
-			 * completion routine.  Solicited and Unsolicited
-			 * IOCBs on the ELS ring get freed back to the
-			 * lpfc_iocb_list by the discovery kernel thread.
-			 */
-			iocb_cmd_type = irsp->ulpCommand & CMD_IOCB_MASK;
-			type = lpfc_sli_iocb_cmd_type(iocb_cmd_type);
-			if (type == LPFC_SOL_IOCB) {
-				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				rc = lpfc_sli_process_sol_iocb(phba, pring,
-							       saveq);
-				spin_lock_irqsave(&phba->hbalock, iflag);
-			} else if (type == LPFC_UNSOL_IOCB) {
-				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				rc = lpfc_sli_process_unsol_iocb(phba, pring,
-								 saveq);
-				spin_lock_irqsave(&phba->hbalock, iflag);
-				if (!rc)
-					free_saveq = 0;
-			} else if (type == LPFC_ABORT_IOCB) {
-				if ((irsp->ulpCommand != CMD_XRI_ABORTED_CX) &&
-				    ((cmdiocbp =
-				      lpfc_sli_iocbq_lookup(phba, pring,
-							    saveq)))) {
-					/* Call the specified completion
-					   routine */
-					if (cmdiocbp->iocb_cmpl) {
-						spin_unlock_irqrestore(
-						       &phba->hbalock,
-						       iflag);
-						(cmdiocbp->iocb_cmpl) (phba,
-							     cmdiocbp, saveq);
-						spin_lock_irqsave(
-							  &phba->hbalock,
-							  iflag);
-					} else
-						__lpfc_sli_release_iocbq(phba,
-								      cmdiocbp);
-				}
-			} else if (type == LPFC_UNKNOWN_IOCB) {
-				if (irsp->ulpCommand == CMD_ADAPTER_MSG) {
-
-					char adaptermsg[LPFC_MAX_ADPTMSG];
-
-					memset(adaptermsg, 0,
-					       LPFC_MAX_ADPTMSG);
-					memcpy(&adaptermsg[0], (uint8_t *) irsp,
-					       MAX_MSG_DATA);
-					dev_warn(&((phba->pcidev)->dev),
-						 "lpfc%d: %s\n",
-						 phba->brd_no, adaptermsg);
-				} else {
-					/* Unknown IOCB command */
-					lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-							"0335 Unknown IOCB "
-							"command Data: x%x "
-							"x%x x%x x%x\n",
-							irsp->ulpCommand,
-							irsp->ulpStatus,
-							irsp->ulpIoTag,
-							irsp->ulpContext);
-				}
-			}
-
-			if (free_saveq) {
-				list_for_each_entry_safe(rspiocbp, next_iocb,
-							 &saveq->list, list) {
-					list_del(&rspiocbp->list);
-					__lpfc_sli_release_iocbq(phba,
-								 rspiocbp);
-				}
-				__lpfc_sli_release_iocbq(phba, saveq);
-			}
-			rspiocbp = NULL;
-		}
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		/* Handle the response IOCB */
+		rspiocbp = lpfc_sli_sp_handle_rspiocb(phba, pring, rspiocbp);
+		spin_lock_irqsave(&phba->hbalock, iflag);
 
 		/*
 		 * If the port response put pointer has not been updated, sync
@@ -2338,7 +2490,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 	}
 
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
-	return rc;
+	return;
 }
 
 /**
@@ -2420,7 +2572,7 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_brdready - Check for host status bits
+ * lpfc_sli_brdready_s3 - Check for sli3 host ready status
  * @phba: Pointer to HBA context object.
  * @mask: Bit mask to be checked.
  *
@@ -2432,8 +2584,8 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba
  * function returns 1 when HBA fail to restart otherwise returns
  * zero.
  **/
-int
-lpfc_sli_brdready(struct lpfc_hba *phba, uint32_t mask)
+static int
+lpfc_sli_brdready_s3(struct lpfc_hba *phba, uint32_t mask)
 {
 	uint32_t status;
 	int i = 0;
@@ -2647,7 +2799,7 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_brdreset - Reset the HBA
+ * lpfc_sli_brdreset - Reset a sli-2 or sli-3 HBA
  * @phba: Pointer to HBA context object.
  *
  * This function resets the HBA by writing HC_INITFF to the control
@@ -2683,7 +2835,8 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
 			      (cfg_value &
 			       ~(PCI_COMMAND_PARITY | PCI_COMMAND_SERR)));
 
-	psli->sli_flag &= ~(LPFC_SLI2_ACTIVE | LPFC_PROCESS_LA);
+	psli->sli_flag &= ~(LPFC_SLI_ACTIVE | LPFC_PROCESS_LA);
+
 	/* Now toggle INITFF bit in the Host Control Register */
 	writel(HC_INITFF, phba->HCregaddr);
 	mdelay(1);
@@ -3289,32 +3442,20 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 			"0345 Resetting board due to mailbox timeout\n");
-	/*
-	 * lpfc_offline calls lpfc_sli_hba_down which will clean up
-	 * on oustanding mailbox commands.
-	 */
-	/* If resets are disabled then set error state and return. */
-	if (!phba->cfg_enable_hba_reset) {
-		phba->link_state = LPFC_HBA_ERROR;
-		return;
-	}
-	lpfc_offline_prep(phba);
-	lpfc_offline(phba);
-	lpfc_sli_brdrestart(phba);
-	lpfc_online(phba);
-	lpfc_unblock_mgmt_io(phba);
-	return;
+
+	/* Reset the HBA device */
+	lpfc_reset_hba(phba);
 }
 
 /**
- * lpfc_sli_issue_mbox - Issue a mailbox command to firmware
+ * lpfc_sli_issue_mbox_s3 - Issue an SLI3 mailbox command to firmware
  * @phba: Pointer to HBA context object.
  * @pmbox: Pointer to mailbox object.
  * @flag: Flag indicating how the mailbox need to be processed.
  *
  * This function is called by discovery code and HBA management code
- * to submit a mailbox command to firmware. This function gets the
- * hbalock to protect the data structures.
+ * to submit a mailbox command to firmware with SLI-3 interface spec. This
+ * function gets the hbalock to protect the data structures.
  * The mailbox command can be submitted in polling mode, in which case
  * this function will wait in a polling loop for the completion of the
  * mailbox.
@@ -3332,8 +3473,9 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
  * return codes the caller owns the mailbox command after the return of
  * the function.
  **/
-int
-lpfc_sli_issue_mbox(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox, uint32_t flag)
+static int
+lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
+		       uint32_t flag)
 {
 	MAILBOX_t *mb;
 	struct lpfc_sli *psli = &phba->sli;
@@ -3349,6 +3491,10 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 	spin_lock_irqsave(&phba->hbalock, drvr_flag);
 	if (!pmbox) {
 		/* processing mbox queue from intr_handler */
+		if (unlikely(psli->sli_flag & LPFC_SLI_ASYNC_MBX_BLK)) {
+			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
+			return MBX_SUCCESS;
+		}
 		processing_queue = 1;
 		phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 		pmbox = lpfc_mbox_get(phba);
@@ -3365,7 +3511,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 			lpfc_printf_log(phba, KERN_ERR,
 					LOG_MBOX | LOG_VPORT,
 					"1806 Mbox x%x failed. No vport\n",
-					pmbox->mb.mbxCommand);
+					pmbox->u.mb.mbxCommand);
 			dump_stack();
 			goto out_not_finished;
 		}
@@ -3385,21 +3531,29 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 
 	psli = &phba->sli;
 
-	mb = &pmbox->mb;
+	mb = &pmbox->u.mb;
 	status = MBX_SUCCESS;
 
 	if (phba->link_state == LPFC_HBA_ERROR) {
 		spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 
 		/* Mbox command <mbxCommand> cannot issue */
-		LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"(%d):0311 Mailbox command x%x cannot "
+				"issue Data: x%x x%x\n",
+				pmbox->vport ? pmbox->vport->vpi : 0,
+				pmbox->u.mb.mbxCommand, psli->sli_flag, flag);
 		goto out_not_finished;
 	}
 
 	if (mb->mbxCommand != MBX_KILL_BOARD && flag & MBX_NOWAIT &&
 	    !(readl(phba->HCregaddr) & HC_MBINT_ENA)) {
 		spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
-		LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
+		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+				"(%d):2528 Mailbox command x%x cannot "
+				"issue Data: x%x x%x\n",
+				pmbox->vport ? pmbox->vport->vpi : 0,
+				pmbox->u.mb.mbxCommand, psli->sli_flag, flag);
 		goto out_not_finished;
 	}
 
@@ -3413,14 +3567,24 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 
 			/* Mbox command <mbxCommand> cannot issue */
-			LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"(%d):2529 Mailbox command x%x "
+					"cannot issue Data: x%x x%x\n",
+					pmbox->vport ? pmbox->vport->vpi : 0,
+					pmbox->u.mb.mbxCommand,
+					psli->sli_flag, flag);
 			goto out_not_finished;
 		}
 
-		if (!(psli->sli_flag & LPFC_SLI2_ACTIVE)) {
+		if (!(psli->sli_flag & LPFC_SLI_ACTIVE)) {
 			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 			/* Mbox command <mbxCommand> cannot issue */
-			LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"(%d):2530 Mailbox command x%x "
+					"cannot issue Data: x%x x%x\n",
+					pmbox->vport ? pmbox->vport->vpi : 0,
+					pmbox->u.mb.mbxCommand,
+					psli->sli_flag, flag);
 			goto out_not_finished;
 		}
 
@@ -3462,12 +3626,17 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 
 	/* If we are not polling, we MUST be in SLI2 mode */
 	if (flag != MBX_POLL) {
-		if (!(psli->sli_flag & LPFC_SLI2_ACTIVE) &&
+		if (!(psli->sli_flag & LPFC_SLI_ACTIVE) &&
 		    (mb->mbxCommand != MBX_KILL_BOARD)) {
 			psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 			spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
 			/* Mbox command <mbxCommand> cannot issue */
-			LOG_MBOX_CANNOT_ISSUE_DATA(phba, pmbox, psli, flag);
+			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+					"(%d):2531 Mailbox command x%x "
+					"cannot issue Data: x%x x%x\n",
+					pmbox->vport ? pmbox->vport->vpi : 0,
+					pmbox->u.mb.mbxCommand,
+					psli->sli_flag, flag);
 			goto out_not_finished;
 		}
 		/* timeout active mbox command */
@@ -3506,7 +3675,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 	/* next set own bit for the adapter and copy over command word */
 	mb->mbxOwner = OWN_CHIP;
 
-	if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
+	if (psli->sli_flag & LPFC_SLI_ACTIVE) {
 		/* First copy command data to host SLIM area */
 		lpfc_sli_pcimem_bcopy(mb, phba->mbox, MAILBOX_CMD_SIZE);
 	} else {
@@ -3529,7 +3698,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 
 		if (mb->mbxCommand == MBX_CONFIG_PORT) {
 			/* switch over to host mailbox */
-			psli->sli_flag |= LPFC_SLI2_ACTIVE;
+			psli->sli_flag |= LPFC_SLI_ACTIVE;
 		}
 	}
 
@@ -3552,7 +3721,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 		writel(CA_MBATT, phba->CAregaddr);
 		readl(phba->CAregaddr); /* flush */
 
-		if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
+		if (psli->sli_flag & LPFC_SLI_ACTIVE) {
 			/* First read mbox status word */
 			word0 = *((uint32_t *)phba->mbox);
 			word0 = le32_to_cpu(word0);
@@ -3591,7 +3760,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 				spin_lock_irqsave(&phba->hbalock, drvr_flag);
 			}
 
-			if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
+			if (psli->sli_flag & LPFC_SLI_ACTIVE) {
 				/* First copy command data */
 				word0 = *((uint32_t *)phba->mbox);
 				word0 = le32_to_cpu(word0);
@@ -3604,7 +3773,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 					if (((slimword0 & OWN_CHIP) != OWN_CHIP)
 					    && slimmb->mbxStatus) {
 						psli->sli_flag &=
-						    ~LPFC_SLI2_ACTIVE;
+						    ~LPFC_SLI_ACTIVE;
 						word0 = slimword0;
 					}
 				}
@@ -3616,7 +3785,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 			ha_copy = readl(phba->HAregaddr);
 		}
 
-		if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
+		if (psli->sli_flag & LPFC_SLI_ACTIVE) {
 			/* copy results back to user */
 			lpfc_sli_pcimem_bcopy(phba->mbox, mb, MAILBOX_CMD_SIZE);
 		} else {
@@ -3701,35 +3870,34 @@ lpfc_sli_next_iocb(struct lpfc_hba *phba
 }
 
 /**
- * __lpfc_sli_issue_iocb - Lockless version of lpfc_sli_issue_iocb
+ * __lpfc_sli_issue_iocb_s3 - SLI3 device lockless ver of lpfc_sli_issue_iocb
  * @phba: Pointer to HBA context object.
- * @pring: Pointer to driver SLI ring object.
+ * @ring_number: SLI ring number to issue iocb on.
  * @piocb: Pointer to command iocb.
  * @flag: Flag indicating if this command can be put into txq.
  *
- * __lpfc_sli_issue_iocb is used by other functions in the driver
- * to issue an iocb command to the HBA. If the PCI slot is recovering
- * from error state or if HBA is resetting or if LPFC_STOP_IOCB_EVENT
- * flag is turned on, the function returns IOCB_ERROR.
- * When the link is down, this function allows only iocbs for
- * posting buffers.
- * This function finds next available slot in the command ring and
- * posts the command to the available slot and writes the port
- * attention register to request HBA start processing new iocb.
- * If there is no slot available in the ring and
- * flag & SLI_IOCB_RET_IOCB is set, the new iocb is added to the
- * txq, otherwise the function returns IOCB_BUSY.
- *
- * This function is called with hbalock held.
- * The function will return success after it successfully submit the
- * iocb to firmware or after adding to the txq.
+ * __lpfc_sli_issue_iocb_s3 is used by other functions in the driver to issue
+ * an iocb command to an HBA with SLI-3 interface spec. If the PCI slot is
+ * recovering from error state, if HBA is resetting or if LPFC_STOP_IOCB_EVENT
+ * flag is turned on, the function returns IOCB_ERROR. When the link is down,
+ * this function allows only iocbs for posting buffers. This function finds
+ * next available slot in the command ring and posts the command to the
+ * available slot and writes the port attention register to request HBA start
+ * processing new iocb. If there is no slot available in the ring and
+ * flag & SLI_IOCB_RET_IOCB is set, the new iocb is added to the txq, otherwise
+ * the function returns IOCB_BUSY.
+ *
+ * This function is called with hbalock held. The function will return success
+ * after it successfully submit the iocb to firmware or after adding to the
+ * txq.
  **/
 static int
-__lpfc_sli_issue_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+__lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
 		    struct lpfc_iocbq *piocb, uint32_t flag)
 {
 	struct lpfc_iocbq *nextiocb;
 	IOCB_t *iocb;
+	struct lpfc_sli_ring *pring = &phba->sli.ring[ring_number];
 
 	if (piocb->iocb_cmpl && (!piocb->vport) &&
 	   (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
@@ -3833,6 +4001,52 @@ __lpfc_sli_issue_iocb(struct lpfc_hba *p
 	return IOCB_BUSY;
 }
 
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
 
 /**
  * lpfc_sli_issue_iocb - Wrapper function for __lpfc_sli_issue_iocb
@@ -3848,14 +4062,14 @@ __lpfc_sli_issue_iocb(struct lpfc_hba *p
  * functions which do not hold hbalock.
  **/
 int
-lpfc_sli_issue_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+lpfc_sli_issue_iocb(struct lpfc_hba *phba, uint32_t ring_number,
 		    struct lpfc_iocbq *piocb, uint32_t flag)
 {
 	unsigned long iflags;
 	int rc;
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
-	rc = __lpfc_sli_issue_iocb(phba, pring, piocb, flag);
+	rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
 	return rc;
@@ -5077,53 +5291,104 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_flush_mbox_queue - mailbox queue cleanup function
+ * lpfc_sli_mbox_sys_shutdown - shutdown mailbox command sub-system
  * @phba: Pointer to HBA context.
  *
- * This function is called to cleanup any pending mailbox
- * objects in the driver queue before bringing the HBA offline.
- * This function is called while resetting the HBA.
- * The function is called without any lock held. The function
- * takes hbalock to update SLI data structure.
- * This function returns 1 when there is an active mailbox
- * command pending else returns 0.
+ * This function is called to shutdown the driver's mailbox sub-system.
+ * It first marks the mailbox sub-system is in a block state to prevent
+ * the asynchronous mailbox command from issued off the pending mailbox
+ * command queue. If the mailbox command sub-system shutdown is due to
+ * HBA error conditions such as EEH or ERATT, this routine shall invoke
+ * the mailbox sub-system flush routine to forcefully bring down the
+ * mailbox sub-system. Otherwise, if it is due to normal condition (such
+ * as with offline or HBA function reset), this routine will wait for the
+ * outstanding mailbox command to complete before invoking the mailbox
+ * sub-system flush routine to gracefully bring down mailbox sub-system.
  **/
-int
-lpfc_sli_flush_mbox_queue(struct lpfc_hba * phba)
+void
+lpfc_sli_mbox_sys_shutdown(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport = phba->pport;
-	int i = 0;
-	uint32_t ha_copy;
+	struct lpfc_sli *psli = &phba->sli;
+	uint8_t actcmd = MBX_HEARTBEAT;
+	unsigned long timeout;
 
-	while (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE && !vport->stopped) {
-		if (i++ > LPFC_MBOX_TMO * 1000)
-			return 1;
+	spin_lock_irq(&phba->hbalock);
+	psli->sli_flag |= LPFC_SLI_ASYNC_MBX_BLK;
+	spin_unlock_irq(&phba->hbalock);
 
-		/*
-		 * Call lpfc_sli_handle_mb_event only if a mailbox cmd
-		 * did finish. This way we won't get the misleading
-		 * "Stray Mailbox Interrupt" message.
-		 */
+	if (psli->sli_flag & LPFC_SLI_ACTIVE) {
 		spin_lock_irq(&phba->hbalock);
-		ha_copy = phba->work_ha;
-		phba->work_ha &= ~HA_MBATT;
+		if (phba->sli.mbox_active)
+			actcmd = phba->sli.mbox_active->u.mb.mbxCommand;
 		spin_unlock_irq(&phba->hbalock);
+		/* Determine how long we might wait for the active mailbox
+		 * command to be gracefully completed by firmware.
+		 */
+		timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, actcmd) *
+					   1000) + jiffies;
+		while (phba->sli.mbox_active) {
+			/* Check active mailbox complete status every 2ms */
+			msleep(2);
+			if (time_after(jiffies, timeout))
+				/* Timeout, let the mailbox flush routine to
+				 * forcefully release active mailbox command
+				 */
+				break;
+		}
+	}
+	lpfc_sli_mbox_sys_flush(phba);
+}
 
-		if (ha_copy & HA_MBATT)
-			if (lpfc_sli_handle_mb_event(phba) == 0)
-				i = 0;
+/**
+ * lpfc_sli_eratt_read - read sli-3 error attention events
+ * @phba: Pointer to HBA context.
+ *
+ * This function is called to read the SLI3 device error attention registers
+ * for possible error attention events. The caller must hold the hostlock
+ * with spin_lock_irq().
+ *
+ * This fucntion returns 1 when there is Error Attention in the Host Attention
+ * Register and returns 0 otherwise.
+ **/
+static int
+lpfc_sli_eratt_read(struct lpfc_hba *phba)
+{
+	uint32_t ha_copy;
 
-		msleep(1);
-	}
+	/* Read chip Host Attention (HA) register */
+	ha_copy = readl(phba->HAregaddr);
+	if (ha_copy & HA_ERATT) {
+		/* Read host status register to retrieve error event */
+		lpfc_sli_read_hs(phba);
 
-	return (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE) ? 1 : 0;
+		/* Check if there is a deferred error condition is active */
+		if ((HS_FFER1 & phba->work_hs) &&
+		    ((HS_FFER2 | HS_FFER3 | HS_FFER4 | HS_FFER5 |
+		     HS_FFER6 | HS_FFER7) & phba->work_hs)) {
+			spin_lock_irq(&phba->hbalock);
+			phba->hba_flag |= DEFER_ERATT;
+			spin_unlock_irq(&phba->hbalock);
+			/* Clear all interrupt enable conditions */
+			writel(0, phba->HCregaddr);
+			readl(phba->HCregaddr);
+		}
+
+		/* Set the driver HA work bitmap */
+		spin_lock_irq(&phba->hbalock);
+		phba->work_ha |= HA_ERATT;
+		/* Indicate polling handles this ERATT */
+		phba->hba_flag |= HBA_ERATT_HANDLED;
+		spin_unlock_irq(&phba->hbalock);
+		return 1;
+	}
+	return 0;
 }
 
 /**
  * lpfc_sli_check_eratt - check error attention events
  * @phba: Pointer to HBA context.
  *
- * This function is called form timer soft interrupt context to check HBA's
+ * This function is called from timer soft interrupt context to check HBA's
  * error attention register bit for error attention events.
  *
  * This fucntion returns 1 when there is Error Attention in the Host Attention
@@ -5134,10 +5399,6 @@ lpfc_sli_check_eratt(struct lpfc_hba *ph
 {
 	uint32_t ha_copy;
 
-	/* If PCI channel is offline, don't process it */
-	if (unlikely(pci_channel_offline(phba->pcidev)))
-		return 0;
-
 	/* If somebody is waiting to handle an eratt, don't process it
 	 * here. The brdkill function will do this.
 	 */
@@ -5161,56 +5422,80 @@ lpfc_sli_check_eratt(struct lpfc_hba *ph
 		return 0;
 	}
 
-	/* Read chip Host Attention (HA) register */
-	ha_copy = readl(phba->HAregaddr);
-	if (ha_copy & HA_ERATT) {
-		/* Read host status register to retrieve error event */
-		lpfc_sli_read_hs(phba);
-
-		/* Check if there is a deferred error condition is active */
-		if ((HS_FFER1 & phba->work_hs) &&
-			((HS_FFER2 | HS_FFER3 | HS_FFER4 | HS_FFER5 |
-			HS_FFER6 | HS_FFER7) & phba->work_hs)) {
-			phba->hba_flag |= DEFER_ERATT;
-			/* Clear all interrupt enable conditions */
-			writel(0, phba->HCregaddr);
-			readl(phba->HCregaddr);
-		}
-
-		/* Set the driver HA work bitmap */
-		phba->work_ha |= HA_ERATT;
-		/* Indicate polling handles this ERATT */
-		phba->hba_flag |= HBA_ERATT_HANDLED;
+	/* If PCI channel is offline, don't process it */
+	if (unlikely(pci_channel_offline(phba->pcidev))) {
 		spin_unlock_irq(&phba->hbalock);
-		return 1;
+		return 0;
+	}
+
+	switch (phba->sli_rev) {
+	case LPFC_SLI_REV2:
+	case LPFC_SLI_REV3:
+		/* Read chip Host Attention (HA) register */
+		ha_copy = lpfc_sli_eratt_read(phba);
+		break;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0299 Invalid SLI revision (%d)\n",
+				phba->sli_rev);
+		ha_copy = 0;
+		break;
 	}
 	spin_unlock_irq(&phba->hbalock);
+
+	return ha_copy;
+}
+
+/**
+ * lpfc_intr_state_check - Check device state for interrupt handling
+ * @phba: Pointer to HBA context.
+ *
+ * This inline routine checks whether a device or its PCI slot is in a state
+ * that the interrupt should be handled.
+ *
+ * This function returns 0 if the device or the PCI slot is in a state that
+ * interrupt should be handled, otherwise -EIO.
+ */
+static inline int
+lpfc_intr_state_check(struct lpfc_hba *phba)
+{
+	/* If the pci channel is offline, ignore all the interrupts */
+	if (unlikely(pci_channel_offline(phba->pcidev)))
+		return -EIO;
+
+	/* Update device level interrupt statistics */
+	phba->sli.slistat.sli_intr++;
+
+	/* Ignore all interrupts during initialization. */
+	if (unlikely(phba->link_state < LPFC_LINK_DOWN))
+		return -EIO;
+
 	return 0;
 }
 
 /**
- * lpfc_sp_intr_handler - The slow-path interrupt handler of lpfc driver
+ * lpfc_sli_sp_intr_handler - Slow-path interrupt handler to SLI-3 device
  * @irq: Interrupt number.
  * @dev_id: The device context pointer.
  *
  * This function is directly called from the PCI layer as an interrupt
- * service routine when the device is enabled with MSI-X multi-message
- * interrupt mode and there are slow-path events in the HBA. However,
- * when the device is enabled with either MSI or Pin-IRQ interrupt mode,
- * this function is called as part of the device-level interrupt handler.
- * When the PCI slot is in error recovery or the HBA is undergoing
- * initialization, the interrupt handler will not process the interrupt.
- * The link attention and ELS ring attention events are handled by the
- * worker thread. The interrupt handler signals the worker thread and
- * and returns for these events. This function is called without any
- * lock held. It gets the hbalock to access and update SLI data
+ * service routine when device with SLI-3 interface spec is enabled with
+ * MSI-X multi-message interrupt mode and there are slow-path events in
+ * the HBA. However, when the device is enabled with either MSI or Pin-IRQ
+ * interrupt mode, this function is called as part of the device-level
+ * interrupt handler. When the PCI slot is in error recovery or the HBA
+ * is undergoing initialization, the interrupt handler will not process
+ * the interrupt. The link attention and ELS ring attention events are
+ * handled by the worker thread. The interrupt handler signals the worker
+ * thread and returns for these events. This function is called without
+ * any lock held. It gets the hbalock to access and update SLI data
  * structures.
  *
  * This function returns IRQ_HANDLED when interrupt is handled else it
  * returns IRQ_NONE.
  **/
 irqreturn_t
-lpfc_sp_intr_handler(int irq, void *dev_id)
+lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 {
 	struct lpfc_hba  *phba;
 	uint32_t ha_copy;
@@ -5240,13 +5525,8 @@ lpfc_sp_intr_handler(int irq, void *dev_
 	 * individual interrupt handler in MSI-X multi-message interrupt mode
 	 */
 	if (phba->intr_type == MSIX) {
-		/* If the pci channel is offline, ignore all the interrupts */
-		if (unlikely(pci_channel_offline(phba->pcidev)))
-			return IRQ_NONE;
-		/* Update device-level interrupt statistics */
-		phba->sli.slistat.sli_intr++;
-		/* Ignore all interrupts during initialization. */
-		if (unlikely(phba->link_state < LPFC_LINK_DOWN))
+		/* Check device state for handling interrupt */
+		if (lpfc_intr_state_check(phba))
 			return IRQ_NONE;
 		/* Need to read HA REG for slow-path events */
 		spin_lock_irqsave(&phba->hbalock, iflag);
@@ -5271,7 +5551,7 @@ lpfc_sp_intr_handler(int irq, void *dev_
 		 * interrupt.
 		 */
 		if (unlikely(phba->hba_flag & DEFER_ERATT)) {
-			spin_unlock_irq(&phba->hbalock);
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			return IRQ_NONE;
 		}
 
@@ -5434,7 +5714,8 @@ lpfc_sp_intr_handler(int irq, void *dev_
 							LOG_MBOX | LOG_SLI,
 							"0350 rc should have"
 							"been MBX_BUSY");
-						goto send_current_mbox;
+						if (rc != MBX_NOT_FINISHED)
+							goto send_current_mbox;
 					}
 				}
 				spin_lock_irqsave(
@@ -5471,29 +5752,29 @@ send_current_mbox:
 	}
 	return IRQ_HANDLED;
 
-} /* lpfc_sp_intr_handler */
+} /* lpfc_sli_sp_intr_handler */
 
 /**
- * lpfc_fp_intr_handler - The fast-path interrupt handler of lpfc driver
+ * lpfc_sli_fp_intr_handler - Fast-path interrupt handler to SLI-3 device.
  * @irq: Interrupt number.
  * @dev_id: The device context pointer.
  *
  * This function is directly called from the PCI layer as an interrupt
- * service routine when the device is enabled with MSI-X multi-message
- * interrupt mode and there is a fast-path FCP IOCB ring event in the
- * HBA. However, when the device is enabled with either MSI or Pin-IRQ
- * interrupt mode, this function is called as part of the device-level
- * interrupt handler. When the PCI slot is in error recovery or the HBA
- * is undergoing initialization, the interrupt handler will not process
- * the interrupt. The SCSI FCP fast-path ring event are handled in the
- * intrrupt context. This function is called without any lock held. It
- * gets the hbalock to access and update SLI data structures.
+ * service routine when device with SLI-3 interface spec is enabled with
+ * MSI-X multi-message interrupt mode and there is a fast-path FCP IOCB
+ * ring event in the HBA. However, when the device is enabled with either
+ * MSI or Pin-IRQ interrupt mode, this function is called as part of the
+ * device-level interrupt handler. When the PCI slot is in error recovery
+ * or the HBA is undergoing initialization, the interrupt handler will not
+ * process the interrupt. The SCSI FCP fast-path ring event are handled in
+ * the intrrupt context. This function is called without any lock held.
+ * It gets the hbalock to access and update SLI data structures.
  *
  * This function returns IRQ_HANDLED when interrupt is handled else it
  * returns IRQ_NONE.
  **/
 irqreturn_t
-lpfc_fp_intr_handler(int irq, void *dev_id)
+lpfc_sli_fp_intr_handler(int irq, void *dev_id)
 {
 	struct lpfc_hba  *phba;
 	uint32_t ha_copy;
@@ -5513,13 +5794,8 @@ lpfc_fp_intr_handler(int irq, void *dev_
 	 * individual interrupt handler in MSI-X multi-message interrupt mode
 	 */
 	if (phba->intr_type == MSIX) {
-		/* If pci channel is offline, ignore all the interrupts */
-		if (unlikely(pci_channel_offline(phba->pcidev)))
-			return IRQ_NONE;
-		/* Update device-level interrupt statistics */
-		phba->sli.slistat.sli_intr++;
-		/* Ignore all interrupts during initialization. */
-		if (unlikely(phba->link_state < LPFC_LINK_DOWN))
+		/* Check device state for handling interrupt */
+		if (lpfc_intr_state_check(phba))
 			return IRQ_NONE;
 		/* Need to read HA REG for FCP ring and other ring events */
 		ha_copy = readl(phba->HAregaddr);
@@ -5530,7 +5806,7 @@ lpfc_fp_intr_handler(int irq, void *dev_
 		 * any interrupt.
 		 */
 		if (unlikely(phba->hba_flag & DEFER_ERATT)) {
-			spin_unlock_irq(&phba->hbalock);
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			return IRQ_NONE;
 		}
 		writel((ha_copy & (HA_R0_CLR_MSK | HA_R1_CLR_MSK)),
@@ -5566,26 +5842,27 @@ lpfc_fp_intr_handler(int irq, void *dev_
 		}
 	}
 	return IRQ_HANDLED;
-}  /* lpfc_fp_intr_handler */
+}  /* lpfc_sli_fp_intr_handler */
 
 /**
- * lpfc_intr_handler - The device-level interrupt handler of lpfc driver
+ * lpfc_sli_intr_handler - Device-level interrupt handler to SLI-3 device
  * @irq: Interrupt number.
  * @dev_id: The device context pointer.
  *
- * This function is the device-level interrupt handler called from the PCI
- * layer when either MSI or Pin-IRQ interrupt mode is enabled and there is
- * an event in the HBA which requires driver attention. This function
- * invokes the slow-path interrupt attention handling function and fast-path
- * interrupt attention handling function in turn to process the relevant
- * HBA attention events. This function is called without any lock held. It
- * gets the hbalock to access and update SLI data structures.
+ * This function is the HBA device-level interrupt handler to device with
+ * SLI-3 interface spec, called from the PCI layer when either MSI or
+ * Pin-IRQ interrupt mode is enabled and there is an event in the HBA which
+ * requires driver attention. This function invokes the slow-path interrupt
+ * attention handling function and fast-path interrupt attention handling
+ * function in turn to process the relevant HBA attention events. This
+ * function is called without any lock held. It gets the hbalock to access
+ * and update SLI data structures.
  *
  * This function returns IRQ_HANDLED when interrupt is handled, else it
  * returns IRQ_NONE.
  **/
 irqreturn_t
-lpfc_intr_handler(int irq, void *dev_id)
+lpfc_sli_intr_handler(int irq, void *dev_id)
 {
 	struct lpfc_hba  *phba;
 	irqreturn_t sp_irq_rc, fp_irq_rc;
@@ -5600,15 +5877,8 @@ lpfc_intr_handler(int irq, void *dev_id)
 	if (unlikely(!phba))
 		return IRQ_NONE;
 
-	/* If the pci channel is offline, ignore all the interrupts. */
-	if (unlikely(pci_channel_offline(phba->pcidev)))
-		return IRQ_NONE;
-
-	/* Update device level interrupt statistics */
-	phba->sli.slistat.sli_intr++;
-
-	/* Ignore all interrupts during initialization. */
-	if (unlikely(phba->link_state < LPFC_LINK_DOWN))
+	/* Check device state for handling interrupt */
+	if (lpfc_intr_state_check(phba))
 		return IRQ_NONE;
 
 	spin_lock(&phba->hbalock);
@@ -5650,7 +5920,7 @@ lpfc_intr_handler(int irq, void *dev_id)
 	status2 >>= (4*LPFC_ELS_RING);
 
 	if (status1 || (status2 & HA_RXMASK))
-		sp_irq_rc = lpfc_sp_intr_handler(irq, dev_id);
+		sp_irq_rc = lpfc_sli_sp_intr_handler(irq, dev_id);
 	else
 		sp_irq_rc = IRQ_NONE;
 
@@ -5670,10 +5940,10 @@ lpfc_intr_handler(int irq, void *dev_id)
 		status2 = 0;
 
 	if ((status1 & HA_RXMASK) || (status2 & HA_RXMASK))
-		fp_irq_rc = lpfc_fp_intr_handler(irq, dev_id);
+		fp_irq_rc = lpfc_sli_fp_intr_handler(irq, dev_id);
 	else
 		fp_irq_rc = IRQ_NONE;
 
 	/* Return device-level interrupt handling status */
 	return (sp_irq_rc == IRQ_HANDLED) ? sp_irq_rc : fp_irq_rc;
-}  /* lpfc_intr_handler */
+}  /* lpfc_sli_intr_handler */


