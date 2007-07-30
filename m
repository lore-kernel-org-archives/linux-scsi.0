From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 19/23] advansys: Move struct device out of the cfg structures
Date: Mon, 30 Jul 2007 10:57:04 -0600
Message-ID: <11858146283502-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx> <11858146283106-git-send-email-matthew@wil.cx> <11858146282252-git-send-email-matthew@wil.cx> <11858146281790-git-send-email-matthew@wil.cx> <11858146281215-git-send-email-matthew@wil.cx> <11858146282469-git-send-email-matthew@wil.cx> <11858146281137-git-send-email-matthew@wil.cx> <11858146282332-git-send-email-matthew@wil.cx> <11858146283924-git-send-email-matthew@wil.cx> <1185814628436-git-send-email-matthew@wil.cx> <11858146281677-git-send-email-matthew@wil.cx> <11858146282603-git-send-email-matthew@wil.cx> <11858146281750-git-send-email-matthew@wil.cx> <11858146282891-git-send-email-matthew@wil.cx> <11858146284113-git-send-email-matthew@wil.cx> <11858146281160-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:58824 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937311AbXG3Q5N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:13 -0400
In-Reply-To: <11858146281160-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The cfg structures are supposed to be disposable after initialisation;
with the 'dev' used for DMA mapping in there, that's not possible.  Move
the dev to the board.

Also inline AscInitFromAscDvcVar into its only caller, remove some
unnecessary prototypes and sort out a few minor formatting issues.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  104 ++++++++++++++++++----------------------------
 1 files changed, 41 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e79f795..73d974a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1380,7 +1380,6 @@ typedef struct asc_dvc_cfg {
 	uchar sdtr_period_offset[ASC_MAX_TID + 1];
 	ushort pci_slot_info;
 	uchar adapter_info[6];
-	struct device *dev;
 } ASC_DVC_CFG;
 
 #define ASC_DEF_DVC_CNTL       0xFFFF
@@ -1831,7 +1830,6 @@ static void AscMemDWordCopyPtrToLram(PortAddr, ushort, uchar *, int);
 static void AscMemWordCopyPtrFromLram(PortAddr, ushort, uchar *, int);
 static ushort AscInitAscDvcVar(ASC_DVC_VAR *);
 static ushort AscInitFromEEP(ASC_DVC_VAR *);
-static ushort AscInitFromAscDvcVar(ASC_DVC_VAR *);
 static ushort AscInitMicroCodeVar(ASC_DVC_VAR *);
 static int AscTestExternalLram(ASC_DVC_VAR *);
 static uchar AscMsgOutSDTR(ASC_DVC_VAR *, uchar, uchar);
@@ -2827,7 +2825,6 @@ typedef struct adv_dvc_cfg {
 	ushort serial1;		/* EEPROM serial number word 1 */
 	ushort serial2;		/* EEPROM serial number word 2 */
 	ushort serial3;		/* EEPROM serial number word 3 */
-	struct device *dev;	/* pointer to the pci dev structure for this board */
 } ADV_DVC_CFG;
 
 struct adv_dvc_var;
@@ -3000,7 +2997,6 @@ static void DvcDelayMicroSecond(ADV_DVC_VAR *, ushort);
  */
 static int AdvExeScsiQueue(ADV_DVC_VAR *, ADV_SCSI_REQ_Q *);
 static int AdvISR(ADV_DVC_VAR *);
-static int AdvInitGetConfig(ADV_DVC_VAR *);
 static int AdvInitAsc3550Driver(ADV_DVC_VAR *);
 static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *);
 static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *);
@@ -3597,6 +3593,7 @@ typedef struct adv_req {
  * field. It is guaranteed to be allocated from DMA-able memory.
  */
 typedef struct asc_board {
+	struct device *dev;
 	int id;			/* Board Id */
 	uint flags;		/* Board flags */
 	union {
@@ -4672,7 +4669,6 @@ static void asc_scsi_done_list(struct scsi_cmnd *scp)
 	ASC_DBG(2, "asc_scsi_done_list: begin\n");
 	while (scp != NULL) {
 		asc_board_t *boardp;
-		struct device *dev;
 
 		ASC_DBG1(3, "asc_scsi_done_list: scp 0x%lx\n", (ulong)scp);
 		tscp = REQPNEXT(scp);
@@ -4680,17 +4676,12 @@ static void asc_scsi_done_list(struct scsi_cmnd *scp)
 
 		boardp = ASC_BOARDP(scp->device->host);
 
-		if (ASC_NARROW_BOARD(boardp))
-			dev = boardp->dvc_cfg.asc_dvc_cfg.dev;
-		else
-			dev = boardp->dvc_cfg.adv_dvc_cfg.dev;
-
 		if (scp->use_sg)
-			dma_unmap_sg(dev,
+			dma_unmap_sg(boardp->dev,
 				     (struct scatterlist *)scp->request_buffer,
 				     scp->use_sg, scp->sc_data_direction);
 		else if (scp->request_bufflen)
-			dma_unmap_single(dev, scp->SCp.dma_handle,
+			dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
 					 scp->request_bufflen,
 					 scp->sc_data_direction);
 
@@ -4929,8 +4920,6 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
  */
 static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 {
-	struct device *dev = boardp->dvc_cfg.asc_dvc_cfg.dev;
-
 	/*
 	 * Mutually exclusive access is required to 'asc_scsi_q' and
 	 * 'asc_sg_head' until after the request is started.
@@ -4994,7 +4983,7 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 		 */
 		ASC_STATS(scp->device->host, cont_cnt);
 		scp->SCp.dma_handle = scp->request_bufflen ?
-		    dma_map_single(dev, scp->request_buffer,
+		    dma_map_single(boardp->dev, scp->request_buffer,
 				   scp->request_bufflen,
 				   scp->sc_data_direction) : 0;
 		asc_scsi_q.q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
@@ -5012,15 +5001,14 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 		struct scatterlist *slp;
 
 		slp = (struct scatterlist *)scp->request_buffer;
-		use_sg =
-		    dma_map_sg(dev, slp, scp->use_sg, scp->sc_data_direction);
+		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
+				    scp->sc_data_direction);
 
 		if (use_sg > scp->device->host->sg_tablesize) {
-			ASC_PRINT3
-			    ("asc_build_req: board %d: use_sg %d > sg_tablesize %d\n",
-			     boardp->id, use_sg,
-			     scp->device->host->sg_tablesize);
-			dma_unmap_sg(dev, slp, scp->use_sg,
+			ASC_PRINT3("asc_build_req: board %d: use_sg %d > "
+				   "sg_tablesize %d\n", boardp->id, use_sg,
+				   scp->device->host->sg_tablesize);
+			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
 				     scp->sc_data_direction);
 			scp->result = HOST_BYTE(DID_ERROR);
 			asc_enqueue(&boardp->done, scp, ASC_BACK);
@@ -5081,7 +5069,6 @@ adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 	ADV_SCSI_REQ_Q *scsiqp;
 	int i;
 	int ret;
-	struct device *dev = boardp->dvc_cfg.adv_dvc_cfg.dev;
 
 	/*
 	 * Allocate an adv_req_t structure from the board to execute
@@ -5168,7 +5155,7 @@ adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 		if (scp->request_bufflen) {
 			scsiqp->vdata_addr = scp->request_buffer;
 			scp->SCp.dma_handle =
-			    dma_map_single(dev, scp->request_buffer,
+			    dma_map_single(boardp->dev, scp->request_buffer,
 					   scp->request_bufflen,
 					   scp->sc_data_direction);
 		} else {
@@ -5189,22 +5176,21 @@ adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 		int use_sg;
 
 		slp = (struct scatterlist *)scp->request_buffer;
-		use_sg =
-		    dma_map_sg(dev, slp, scp->use_sg, scp->sc_data_direction);
+		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
+				    scp->sc_data_direction);
 
 		if (use_sg > ADV_MAX_SG_LIST) {
-			ASC_PRINT3
-			    ("adv_build_req: board %d: use_sg %d > ADV_MAX_SG_LIST %d\n",
-			     boardp->id, use_sg,
-			     scp->device->host->sg_tablesize);
-			dma_unmap_sg(dev, slp, scp->use_sg,
+			ASC_PRINT3("adv_build_req: board %d: use_sg %d > "
+				   "ADV_MAX_SG_LIST %d\n", boardp->id, use_sg,
+				   scp->device->host->sg_tablesize);
+			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
 				     scp->sc_data_direction);
 			scp->result = HOST_BYTE(DID_ERROR);
 			asc_enqueue(&boardp->done, scp, ASC_BACK);
 
 			/*
-			 * Free the 'adv_req_t' structure by adding it back to the
-			 * board free list.
+			 * Free the 'adv_req_t' structure by adding it back
+			 * to the board free list.
 			 */
 			reqp->next_reqp = boardp->adv_reqp;
 			boardp->adv_reqp = reqp;
@@ -5212,12 +5198,11 @@ adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 			return ASC_ERROR;
 		}
 
-		if ((ret =
-		     adv_get_sglist(boardp, reqp, scp,
-				    use_sg)) != ADV_SUCCESS) {
+		ret = adv_get_sglist(boardp, reqp, scp, use_sg);
+		if (ret != ADV_SUCCESS) {
 			/*
-			 * Free the adv_req_t structure by adding it back to the
-			 * board free list.
+			 * Free the adv_req_t structure by adding it back to
+			 * the board free list.
 			 */
 			reqp->next_reqp = boardp->adv_reqp;
 			boardp->adv_reqp = reqp;
@@ -10219,30 +10204,21 @@ static ushort __devinit AscInitGetConfig(ASC_DVC_VAR *asc_dvc)
 	return warn_code;
 }
 
-static ushort __devinit AscInitSetConfig(ASC_DVC_VAR *asc_dvc)
+static unsigned short __devinit
+AscInitSetConfig(struct pci_dev *pdev, ASC_DVC_VAR *asc_dvc)
 {
-	ushort warn_code = 0;
+	PortAddr iop_base = asc_dvc->iop_base;
+	unsigned short cfg_msw;
+	unsigned short warn_code = 0;
 
 	asc_dvc->init_state |= ASC_INIT_STATE_BEG_SET_CFG;
 	if (asc_dvc->err_code != 0)
-		return (UW_ERR);
-	if (AscFindSignature(asc_dvc->iop_base)) {
-		warn_code |= AscInitFromAscDvcVar(asc_dvc);
-		asc_dvc->init_state |= ASC_INIT_STATE_END_SET_CFG;
-	} else {
+		return UW_ERR;
+	if (!AscFindSignature(asc_dvc->iop_base)) {
 		asc_dvc->err_code = ASC_IERR_BAD_SIGNATURE;
+		return 0;
 	}
-	return (warn_code);
-}
-
-static ushort __devinit AscInitFromAscDvcVar(ASC_DVC_VAR *asc_dvc)
-{
-	PortAddr iop_base;
-	ushort cfg_msw;
-	ushort warn_code;
 
-	iop_base = asc_dvc->iop_base;
-	warn_code = 0;
 	cfg_msw = AscGetChipCfgMsw(iop_base);
 	if ((cfg_msw & ASC_CFG_MSW_CLR_MASK) != 0) {
 		cfg_msw &= (~(ASC_CFG_MSW_CLR_MASK));
@@ -10265,7 +10241,6 @@ static ushort __devinit AscInitFromAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	}
 #ifdef CONFIG_PCI
 	if (asc_dvc->bus_type & ASC_IS_PCI) {
-		struct pci_dev *pdev = to_pci_dev(asc_dvc->cfg->dev);
 		cfg_msw &= 0xFFC0;
 		AscSetChipCfgMsw(iop_base, cfg_msw);
 		if ((asc_dvc->bus_type & ASC_IS_PCI_ULTRA) == ASC_IS_PCI_ULTRA) {
@@ -10295,7 +10270,9 @@ static ushort __devinit AscInitFromAscDvcVar(ASC_DVC_VAR *asc_dvc)
 		AscSetIsaDmaSpeed(iop_base, asc_dvc->cfg->isa_dma_speed);
 	}
 #endif /* CONFIG_ISA */
-	return (warn_code);
+
+	asc_dvc->init_state |= ASC_INIT_STATE_END_SET_CFG;
+	return warn_code;
 }
 
 static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
@@ -13599,11 +13576,11 @@ static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __devinitdata =
  * For a non-fatal error return a warning code. If there are no warnings
  * then 0 is returned.
  */
-static int __devinit AdvInitGetConfig(ADV_DVC_VAR *asc_dvc)
+static int __devinit
+AdvInitGetConfig(struct pci_dev *pdev, ADV_DVC_VAR *asc_dvc)
 {
 	unsigned short warn_code = 0;
 	AdvPortAddr iop_base = asc_dvc->iop_base;
-	struct pci_dev *pdev = to_pci_dev(asc_dvc->cfg->dev);
 	u16 cmd;
 	int status;
 
@@ -17094,6 +17071,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	memset(boardp, 0, sizeof(asc_board_t));
 	boardp->id = asc_board_count++;
 	spin_lock_init(&boardp->lock);
+	boardp->dev = dev;
 
 	/*
 	 * Handle both narrow and wide boards.
@@ -17180,7 +17158,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 #endif /* CONFIG_PROC_FS */
 
 	if (ASC_NARROW_BOARD(boardp)) {
-		asc_dvc_varp->cfg->dev = dev;
 		/*
 		 * Set the board bus type and PCI IRQ before
 		 * calling AscInitGetConfig().
@@ -17220,7 +17197,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 			break;
 		}
 	} else {
-		adv_dvc_varp->cfg->dev = dev;
 		/*
 		 * For Wide boards set PCI information before calling
 		 * AdvInitGetConfig().
@@ -17289,7 +17265,9 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		}
 	} else {
 		ASC_DBG(2, "advansys_board_found: AdvInitGetConfig()\n");
-		if ((ret = AdvInitGetConfig(adv_dvc_varp)) != 0) {
+
+		ret = AdvInitGetConfig(pdev, adv_dvc_varp);
+		if (ret != 0) {
 			ASC_PRINT2
 			    ("AdvInitGetConfig: board %d: warning: 0x%x\n",
 			     boardp->id, ret);
@@ -17345,7 +17323,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		 * Modify board configuration.
 		 */
 		ASC_DBG(2, "advansys_board_found: AscInitSetConfig()\n");
-		switch (ret = AscInitSetConfig(asc_dvc_varp)) {
+		switch (ret = AscInitSetConfig(pdev, asc_dvc_varp)) {
 		case 0:	/* No error. */
 			break;
 		case ASC_WARN_IO_PORT_ROTATE:
-- 
1.4.4.4

