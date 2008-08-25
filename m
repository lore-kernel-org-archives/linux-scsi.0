From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/15] lpfc 8.2.8 : Update driver for new SLI-3 features
Date: Sun, 24 Aug 2008 21:49:55 -0400
Message-ID: <1219628995.7890.33.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52481 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbYHYBtx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:49:53 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1nqbh019969
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:49:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update driver for new SLI-3 features:
- interrupt enhancements
- lose adapter doorbell writes
- inlining support for FCP_Ixx cmds 


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |   22 +++++--
 lpfc_ct.c      |    4 -
 lpfc_debugfs.c |   52 ++++-------------
 lpfc_els.c     |    4 -
 lpfc_hw.h      |   63 ++++++++++++++-------
 lpfc_init.c    |   28 +++++----
 lpfc_mbox.c    |   75 +++++++++++++------------
 lpfc_scsi.c    |  165 +++++++++++++++++++++++++++++++++++++++++----------------
 lpfc_sli.c     |  122 ++++++++++++++++++++++--------------------
 9 files changed, 315 insertions(+), 220 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-06-30 09:31:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-08-24 20:41:44.000000000 -0400
@@ -212,7 +212,7 @@ lpfc_alloc_ct_rsp(struct lpfc_hba *phba,
 		else
 			list_add_tail(&mp->list, &mlist->list);
 
-		bpl->tus.f.bdeFlags = BUFF_USE_RCV;
+		bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64I;
 		/* build buffer ptr list for IOCB */
 		bpl->addrLow = le32_to_cpu(putPaddrLow(mp->phys) );
 		bpl->addrHigh = le32_to_cpu(putPaddrHigh(mp->phys) );
@@ -283,7 +283,7 @@ lpfc_gen_req(struct lpfc_vport *vport, s
 	icmd->un.genreq64.bdl.ulpIoTag32 = 0;
 	icmd->un.genreq64.bdl.addrHigh = putPaddrHigh(bmp->phys);
 	icmd->un.genreq64.bdl.addrLow = putPaddrLow(bmp->phys);
-	icmd->un.genreq64.bdl.bdeFlags = BUFF_TYPE_BDL;
+	icmd->un.genreq64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
 	icmd->un.genreq64.bdl.bdeSize = (num_entry * sizeof (struct ulp_bde64));
 
 	if (usr_flg)
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2008-08-24 18:58:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2008-08-24 20:41:07.000000000 -0400
@@ -455,7 +455,7 @@ lpfc_debugfs_dumpHostSlim_data(struct lp
 	spin_lock_irq(&phba->hbalock);
 
 	len +=  snprintf(buf+len, size-len, "SLIM Mailbox\n");
-	ptr = (uint32_t *)phba->slim2p;
+	ptr = (uint32_t *)phba->slim2p.virt;
 	i = sizeof(MAILBOX_t);
 	while (i > 0) {
 		len +=  snprintf(buf+len, size-len,
@@ -468,7 +468,7 @@ lpfc_debugfs_dumpHostSlim_data(struct lp
 	}
 
 	len +=  snprintf(buf+len, size-len, "SLIM PCB\n");
-	ptr = (uint32_t *)&phba->slim2p->pcb;
+	ptr = (uint32_t *)phba->pcb;
 	i = sizeof(PCB_t);
 	while (i > 0) {
 		len +=  snprintf(buf+len, size-len,
@@ -480,44 +480,16 @@ lpfc_debugfs_dumpHostSlim_data(struct lp
 		off += (8 * sizeof(uint32_t));
 	}
 
-	pgpp = (struct lpfc_pgp *)&phba->slim2p->mbx.us.s3_pgp.port;
-	pring = &psli->ring[0];
-	len +=  snprintf(buf+len, size-len,
-		"Ring 0: CMD GetInx:%d (Max:%d Next:%d Local:%d flg:x%x)  "
-		"RSP PutInx:%d Max:%d\n",
-		pgpp->cmdGetInx, pring->numCiocb,
-		pring->next_cmdidx, pring->local_getidx, pring->flag,
-		pgpp->rspPutInx, pring->numRiocb);
-	pgpp++;
-
-	pring = &psli->ring[1];
-	len +=  snprintf(buf+len, size-len,
-		"Ring 1: CMD GetInx:%d (Max:%d Next:%d Local:%d flg:x%x)  "
-		"RSP PutInx:%d Max:%d\n",
-		pgpp->cmdGetInx, pring->numCiocb,
-		pring->next_cmdidx, pring->local_getidx, pring->flag,
-		pgpp->rspPutInx, pring->numRiocb);
-	pgpp++;
-
-	pring = &psli->ring[2];
-	len +=  snprintf(buf+len, size-len,
-		"Ring 2: CMD GetInx:%d (Max:%d Next:%d Local:%d flg:x%x)  "
-		"RSP PutInx:%d Max:%d\n",
-		pgpp->cmdGetInx, pring->numCiocb,
-		pring->next_cmdidx, pring->local_getidx, pring->flag,
-		pgpp->rspPutInx, pring->numRiocb);
-	pgpp++;
-
-	pring = &psli->ring[3];
-	len +=  snprintf(buf+len, size-len,
-		"Ring 3: CMD GetInx:%d (Max:%d Next:%d Local:%d flg:x%x)  "
-		"RSP PutInx:%d Max:%d\n",
-		pgpp->cmdGetInx, pring->numCiocb,
-		pring->next_cmdidx, pring->local_getidx, pring->flag,
-		pgpp->rspPutInx, pring->numRiocb);
-
-
-	ptr = (uint32_t *)&phba->slim2p->mbx.us.s3_pgp.hbq_get;
+	for (i = 0; i < 4; i++) {
+		pgpp = &phba->port_gp[i];
+		pring = &psli->ring[i];
+		len +=  snprintf(buf+len, size-len,
+				 "Ring %d: CMD GetInx:%d (Max:%d Next:%d "
+				 "Local:%d flg:x%x)  RSP PutInx:%d Max:%d\n",
+				 i, pgpp->cmdGetInx, pring->numCiocb,
+				 pring->next_cmdidx, pring->local_getidx,
+				 pring->flag, pgpp->rspPutInx, pring->numRiocb);
+	}
 	word0 = readl(phba->HAregaddr);
 	word1 = readl(phba->CAregaddr);
 	word2 = readl(phba->HSregaddr);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-08-24 20:36:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-08-24 20:41:44.000000000 -0400
@@ -200,7 +200,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 
 	icmd->un.elsreq64.bdl.addrHigh = putPaddrHigh(pbuflist->phys);
 	icmd->un.elsreq64.bdl.addrLow = putPaddrLow(pbuflist->phys);
-	icmd->un.elsreq64.bdl.bdeFlags = BUFF_TYPE_BDL;
+	icmd->un.elsreq64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
 	icmd->un.elsreq64.remoteID = did;	/* DID */
 	if (expectRsp) {
 		icmd->un.elsreq64.bdl.bdeSize = (2 * sizeof(struct ulp_bde64));
@@ -235,7 +235,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 		bpl->addrLow = le32_to_cpu(putPaddrLow(prsp->phys));
 		bpl->addrHigh = le32_to_cpu(putPaddrHigh(prsp->phys));
 		bpl->tus.f.bdeSize = FCELSSIZE;
-		bpl->tus.f.bdeFlags = BUFF_USE_RCV;
+		bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 		bpl->tus.w = le32_to_cpu(bpl->tus.w);
 	}
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-06-30 09:31:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2008-08-24 20:41:07.000000000 -0400
@@ -407,10 +407,11 @@ struct lpfc_hba {
 	struct lpfc_sli sli;
 	uint32_t sli_rev;		/* SLI2 or SLI3 */
 	uint32_t sli3_options;		/* Mask of enabled SLI3 options */
-#define LPFC_SLI3_ENABLED	 0x01
-#define LPFC_SLI3_HBQ_ENABLED	 0x02
-#define LPFC_SLI3_NPIV_ENABLED	 0x04
-#define LPFC_SLI3_VPORT_TEARDOWN 0x08
+#define LPFC_SLI3_HBQ_ENABLED		0x01
+#define LPFC_SLI3_NPIV_ENABLED		0x02
+#define LPFC_SLI3_VPORT_TEARDOWN	0x04
+#define LPFC_SLI3_CRP_ENABLED		0x08
+#define LPFC_SLI3_INB_ENABLED		0x10
 	uint32_t iocb_cmd_size;
 	uint32_t iocb_rsp_size;
 
@@ -422,10 +423,16 @@ struct lpfc_hba {
 #define LS_NPIV_FAB_SUPPORTED 0x2	/* Fabric supports NPIV */
 #define LS_IGNORE_ERATT       0x4	/* intr handler should ignore ERATT */
 
-	struct lpfc_sli2_slim *slim2p;
-	struct lpfc_dmabuf hbqslimp;
+	struct lpfc_dmabuf slim2p;
+
+	MAILBOX_t *mbox;
+	uint32_t *inb_ha_copy;
+	uint32_t *inb_counter;
+	uint32_t inb_last_counter;
+	struct _PCB *pcb;
+	struct _IOCB *IOCBs;
 
-	dma_addr_t slim2p_mapping;
+	struct lpfc_dmabuf hbqslimp;
 
 	uint16_t pci_cfg_value;
 
@@ -514,6 +521,7 @@ struct lpfc_hba {
 	void __iomem *HCregaddr;	/* virtual address for host ctl reg */
 
 	struct lpfc_hgp __iomem *host_gp; /* Host side get/put pointers */
+	struct lpfc_pgp   *port_gp;
 	uint32_t __iomem  *hbq_put;     /* Address in SLIM to HBQ put ptrs */
 	uint32_t          *hbq_get;     /* Host mem address of HBQ get ptrs */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2008-02-22 15:59:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2008-08-24 20:41:44.000000000 -0400
@@ -1474,24 +1474,18 @@ struct ulp_bde64 {	/* SLI-2 */
 			uint32_t bdeFlags:8;	/* BDE Flags 0 IS A SUPPORTED
 						   VALUE !! */
 #endif
-
-#define BUFF_USE_RSVD       0x01	/* bdeFlags */
-#define BUFF_USE_INTRPT     0x02	/* Not Implemented with LP6000 */
-#define BUFF_USE_CMND       0x04	/* Optional, 1=cmd/rsp 0=data buffer */
-#define BUFF_USE_RCV        0x08	/*  "" "", 1=rcv buffer, 0=xmit
-					    buffer */
-#define BUFF_TYPE_32BIT     0x10	/*  "" "", 1=32 bit addr 0=64 bit
-					    addr */
-#define BUFF_TYPE_SPECIAL   0x20	/* Not Implemented with LP6000  */
-#define BUFF_TYPE_BDL       0x40	/* Optional,  may be set in BDL */
-#define BUFF_TYPE_INVALID   0x80	/*  ""  "" */
+#define BUFF_TYPE_BDE_64    0x00	/* BDE (Host_resident) */
+#define BUFF_TYPE_BDE_IMMED 0x01	/* Immediate Data BDE */
+#define BUFF_TYPE_BDE_64P   0x02	/* BDE (Port-resident) */
+#define BUFF_TYPE_BDE_64I   0x08	/* Input BDE (Host-resident) */
+#define BUFF_TYPE_BDE_64IP  0x0A	/* Input BDE (Port-resident) */
+#define BUFF_TYPE_BLP_64    0x40	/* BLP (Host-resident) */
+#define BUFF_TYPE_BLP_64P   0x42	/* BLP (Port-resident) */
 		} f;
 	} tus;
 	uint32_t addrLow;
 	uint32_t addrHigh;
 };
-#define BDE64_SIZE_WORD 0
-#define BPL64_SIZE_WORD 0x40
 
 typedef struct ULP_BDL {	/* SLI-2 */
 #ifdef __BIG_ENDIAN_BITFIELD
@@ -2715,11 +2709,19 @@ struct sli3_pgp {
 	uint32_t hbq_get[16];
 };
 
-typedef union {
-	struct sli2_desc s2;
-	struct sli3_desc s3;
-	struct sli3_pgp  s3_pgp;
-} SLI_VAR;
+struct sli3_inb_pgp {
+	uint32_t ha_copy;
+	uint32_t counter;
+	struct lpfc_pgp port[MAX_RINGS];
+	uint32_t hbq_get[16];
+};
+
+union sli_var {
+	struct sli2_desc	s2;
+	struct sli3_desc	s3;
+	struct sli3_pgp		s3_pgp;
+	struct sli3_inb_pgp	s3_inb_pgp;
+};
 
 typedef struct {
 #ifdef __BIG_ENDIAN_BITFIELD
@@ -2737,7 +2739,7 @@ typedef struct {
 #endif
 
 	MAILVARIANTS un;
-	SLI_VAR us;
+	union sli_var us;
 } MAILBOX_t;
 
 /*
@@ -3105,6 +3107,27 @@ struct que_xri64cx_ext_fields {
 	struct lpfc_hbq_entry	buff[5];
 };
 
+#define LPFC_EXT_DATA_BDE_COUNT 3
+struct fcp_irw_ext {
+	uint32_t	io_tag64_low;
+	uint32_t	io_tag64_high;
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint8_t		reserved1;
+	uint8_t		reserved2;
+	uint8_t		reserved3;
+	uint8_t		ebde_count;
+#else  /* __LITTLE_ENDIAN */
+	uint8_t		ebde_count;
+	uint8_t		reserved3;
+	uint8_t		reserved2;
+	uint8_t		reserved1;
+#endif
+	uint32_t	reserved4;
+	struct ulp_bde64 rbde;		/* response bde */
+	struct ulp_bde64 dbde[LPFC_EXT_DATA_BDE_COUNT];	/* data BDE or BPL */
+	uint8_t icd[32];		/* immediate command data (32 bytes) */
+};
+
 typedef struct _IOCB {	/* IOCB structure */
 	union {
 		GENERIC_RSP grsp;	/* Generic response */
@@ -3190,7 +3213,7 @@ typedef struct _IOCB {	/* IOCB structure
 
 		/* words 8-31 used for que_xri_cx iocb */
 		struct que_xri64cx_ext_fields que_xri64cx_ext_words;
-
+		struct fcp_irw_ext fcp_ext;
 		uint32_t sli3Words[24]; /* 96 extra bytes for SLI-3 */
 	} unsli3;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 20:36:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 20:41:07.000000000 -0400
@@ -2312,12 +2312,18 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	}
 
 	/* Allocate memory for SLI-2 structures */
-	phba->slim2p = dma_alloc_coherent(&phba->pcidev->dev, SLI2_SLIM_SIZE,
-					  &phba->slim2p_mapping, GFP_KERNEL);
-	if (!phba->slim2p)
+	phba->slim2p.virt = dma_alloc_coherent(&phba->pcidev->dev,
+					       SLI2_SLIM_SIZE,
+					       &phba->slim2p.phys,
+					       GFP_KERNEL);
+	if (!phba->slim2p.virt)
 		goto out_iounmap;
 
-	memset(phba->slim2p, 0, SLI2_SLIM_SIZE);
+	memset(phba->slim2p.virt, 0, SLI2_SLIM_SIZE);
+	phba->mbox = phba->slim2p.virt;
+	phba->pcb = (phba->slim2p.virt + sizeof(MAILBOX_t));
+	phba->IOCBs = (phba->slim2p.virt + sizeof(MAILBOX_t) +
+		       sizeof(struct _PCB));
 
 	phba->hbqslimp.virt = dma_alloc_coherent(&phba->pcidev->dev,
 						 lpfc_sli_hbq_size(),
@@ -2513,11 +2519,11 @@ out_free_iocbq:
 	}
 	lpfc_mem_free(phba);
 out_free_hbqslimp:
-	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(), phba->hbqslimp.virt,
-			  phba->hbqslimp.phys);
+	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
+			  phba->hbqslimp.virt, phba->hbqslimp.phys);
 out_free_slim:
-	dma_free_coherent(&pdev->dev, SLI2_SLIM_SIZE, phba->slim2p,
-							phba->slim2p_mapping);
+	dma_free_coherent(&pdev->dev, SLI2_SLIM_SIZE,
+			  phba->slim2p.virt, phba->slim2p.phys);
 out_iounmap:
 	iounmap(phba->ctrl_regs_memmap_p);
 out_iounmap_slim:
@@ -2599,12 +2605,12 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	lpfc_scsi_free(phba);
 	lpfc_mem_free(phba);
 
-	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(), phba->hbqslimp.virt,
-			  phba->hbqslimp.phys);
+	dma_free_coherent(&pdev->dev, lpfc_sli_hbq_size(),
+			  phba->hbqslimp.virt, phba->hbqslimp.phys);
 
 	/* Free resources associated with SLI2 interface */
 	dma_free_coherent(&pdev->dev, SLI2_SLIM_SIZE,
-			  phba->slim2p, phba->slim2p_mapping);
+			  phba->slim2p.virt, phba->slim2p.phys);
 
 	/* unmap adapter SLIM and Control Registers */
 	iounmap(phba->ctrl_regs_memmap_p);
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2008-08-24 18:58:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2008-08-24 20:41:07.000000000 -0400
@@ -671,7 +671,7 @@ lpfc_config_pcb_setup(struct lpfc_hba * 
 {
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
-	PCB_t *pcbp = &phba->slim2p->pcb;
+	PCB_t *pcbp = phba->pcb;
 	dma_addr_t pdma_addr;
 	uint32_t offset;
 	uint32_t iocbCnt = 0;
@@ -700,23 +700,23 @@ lpfc_config_pcb_setup(struct lpfc_hba * 
 			continue;
 		}
 		/* Command ring setup for ring */
-		pring->cmdringaddr = (void *) &phba->slim2p->IOCBs[iocbCnt];
+		pring->cmdringaddr = (void *)&phba->IOCBs[iocbCnt];
 		pcbp->rdsc[i].cmdEntries = pring->numCiocb;
 
-		offset = (uint8_t *) &phba->slim2p->IOCBs[iocbCnt] -
-			 (uint8_t *) phba->slim2p;
-		pdma_addr = phba->slim2p_mapping + offset;
+		offset = (uint8_t *) &phba->IOCBs[iocbCnt] -
+			 (uint8_t *) phba->slim2p.virt;
+		pdma_addr = phba->slim2p.phys + offset;
 		pcbp->rdsc[i].cmdAddrHigh = putPaddrHigh(pdma_addr);
 		pcbp->rdsc[i].cmdAddrLow = putPaddrLow(pdma_addr);
 		iocbCnt += pring->numCiocb;
 
 		/* Response ring setup for ring */
-		pring->rspringaddr = (void *) &phba->slim2p->IOCBs[iocbCnt];
+		pring->rspringaddr = (void *) &phba->IOCBs[iocbCnt];
 
 		pcbp->rdsc[i].rspEntries = pring->numRiocb;
-		offset = (uint8_t *)&phba->slim2p->IOCBs[iocbCnt] -
-			 (uint8_t *)phba->slim2p;
-		pdma_addr = phba->slim2p_mapping + offset;
+		offset = (uint8_t *)&phba->IOCBs[iocbCnt] -
+			 (uint8_t *)phba->slim2p.virt;
+		pdma_addr = phba->slim2p.phys + offset;
 		pcbp->rdsc[i].rspAddrHigh = putPaddrHigh(pdma_addr);
 		pcbp->rdsc[i].rspAddrLow = putPaddrLow(pdma_addr);
 		iocbCnt += pring->numRiocb;
@@ -977,8 +977,8 @@ lpfc_config_port(struct lpfc_hba *phba, 
 
 	mb->un.varCfgPort.pcbLen = sizeof(PCB_t);
 
-	offset = (uint8_t *)&phba->slim2p->pcb - (uint8_t *)phba->slim2p;
-	pdma_addr = phba->slim2p_mapping + offset;
+	offset = (uint8_t *)phba->pcb - (uint8_t *)phba->slim2p.virt;
+	pdma_addr = phba->slim2p.phys + offset;
 	mb->un.varCfgPort.pcbLow = putPaddrLow(pdma_addr);
 	mb->un.varCfgPort.pcbHigh = putPaddrHigh(pdma_addr);
 
@@ -986,12 +986,13 @@ lpfc_config_port(struct lpfc_hba *phba, 
 
 	if (phba->sli_rev == 3 && phba->vpd.sli3Feat.cerbm) {
 		mb->un.varCfgPort.cerbm = 1; /* Request HBQs */
+		mb->un.varCfgPort.ccrp = 1; /* Command Ring Polling */
+		mb->un.varCfgPort.cinb = 1; /* Interrupt Notification Block */
 		mb->un.varCfgPort.max_hbq = lpfc_sli_hbq_count();
 		if (phba->max_vpi && phba->cfg_enable_npiv &&
 		    phba->vpd.sli3Feat.cmv) {
 			mb->un.varCfgPort.max_vpi = phba->max_vpi;
 			mb->un.varCfgPort.cmv = 1;
-			phba->sli3_options |= LPFC_SLI3_NPIV_ENABLED;
 		} else
 			mb->un.varCfgPort.max_vpi = phba->max_vpi = 0;
 	} else
@@ -999,16 +1000,15 @@ lpfc_config_port(struct lpfc_hba *phba, 
 	mb->un.varCfgPort.sli_mode = phba->sli_rev;
 
 	/* Now setup pcb */
-	phba->slim2p->pcb.type = TYPE_NATIVE_SLI2;
-	phba->slim2p->pcb.feature = FEATURE_INITIAL_SLI2;
+	phba->pcb->type = TYPE_NATIVE_SLI2;
+	phba->pcb->feature = FEATURE_INITIAL_SLI2;
 
 	/* Setup Mailbox pointers */
-	phba->slim2p->pcb.mailBoxSize = offsetof(MAILBOX_t, us) +
-		sizeof(struct sli2_desc);
-	offset = (uint8_t *)&phba->slim2p->mbx - (uint8_t *)phba->slim2p;
-	pdma_addr = phba->slim2p_mapping + offset;
-	phba->slim2p->pcb.mbAddrHigh = putPaddrHigh(pdma_addr);
-	phba->slim2p->pcb.mbAddrLow = putPaddrLow(pdma_addr);
+	phba->pcb->mailBoxSize = sizeof(MAILBOX_t);
+	offset = (uint8_t *)phba->mbox - (uint8_t *)phba->slim2p.virt;
+	pdma_addr = phba->slim2p.phys + offset;
+	phba->pcb->mbAddrHigh = putPaddrHigh(pdma_addr);
+	phba->pcb->mbAddrLow = putPaddrLow(pdma_addr);
 
 	/*
 	 * Setup Host Group ring pointer.
@@ -1069,13 +1069,13 @@ lpfc_config_port(struct lpfc_hba *phba, 
 	}
 
 	/* mask off BAR0's flag bits 0 - 3 */
-	phba->slim2p->pcb.hgpAddrLow = (bar_low & PCI_BASE_ADDRESS_MEM_MASK) +
-		(void __iomem *) phba->host_gp -
+	phba->pcb->hgpAddrLow = (bar_low & PCI_BASE_ADDRESS_MEM_MASK) +
+		(void __iomem *)phba->host_gp -
 		(void __iomem *)phba->MBslimaddr;
 	if (bar_low & PCI_BASE_ADDRESS_MEM_TYPE_64)
-		phba->slim2p->pcb.hgpAddrHigh = bar_high;
+		phba->pcb->hgpAddrHigh = bar_high;
 	else
-		phba->slim2p->pcb.hgpAddrHigh = 0;
+		phba->pcb->hgpAddrHigh = 0;
 	/* write HGP data to SLIM at the required longword offset */
 	memset(&hgp, 0, sizeof(struct lpfc_hgp));
 
@@ -1085,17 +1085,19 @@ lpfc_config_port(struct lpfc_hba *phba, 
 	}
 
 	/* Setup Port Group ring pointer */
-	if (phba->sli_rev == 3)
-		pgp_offset = (uint8_t *)&phba->slim2p->mbx.us.s3_pgp.port -
-			(uint8_t *)phba->slim2p;
-	else
-		pgp_offset = (uint8_t *)&phba->slim2p->mbx.us.s2.port -
-			(uint8_t *)phba->slim2p;
-
-	pdma_addr = phba->slim2p_mapping + pgp_offset;
-	phba->slim2p->pcb.pgpAddrHigh = putPaddrHigh(pdma_addr);
-	phba->slim2p->pcb.pgpAddrLow = putPaddrLow(pdma_addr);
-	phba->hbq_get = &phba->slim2p->mbx.us.s3_pgp.hbq_get[0];
+	if (phba->sli3_options & LPFC_SLI3_INB_ENABLED) {
+		pgp_offset = offsetof(struct lpfc_sli2_slim,
+				      mbx.us.s3_inb_pgp.port);
+		phba->hbq_get = phba->mbox->us.s3_inb_pgp.hbq_get;
+	} else if (phba->sli_rev == 3) {
+		pgp_offset = offsetof(struct lpfc_sli2_slim,
+				      mbx.us.s3_pgp.port);
+		phba->hbq_get = phba->mbox->us.s3_pgp.hbq_get;
+	} else
+		pgp_offset = offsetof(struct lpfc_sli2_slim, mbx.us.s2.port);
+	pdma_addr = phba->slim2p.phys + pgp_offset;
+	phba->pcb->pgpAddrHigh = putPaddrHigh(pdma_addr);
+	phba->pcb->pgpAddrLow = putPaddrLow(pdma_addr);
 
 	/* Use callback routine to setp rings in the pcb */
 	lpfc_config_pcb_setup(phba);
@@ -1110,8 +1112,7 @@ lpfc_config_port(struct lpfc_hba *phba, 
 	}
 
 	/* Swap PCB if needed */
-	lpfc_sli_pcimem_bcopy(&phba->slim2p->pcb, &phba->slim2p->pcb,
-			      sizeof(PCB_t));
+	lpfc_sli_pcimem_bcopy(phba->pcb, phba->pcb, sizeof(PCB_t));
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-07-30 13:05:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-08-24 20:41:44.000000000 -0400
@@ -198,7 +198,9 @@ lpfc_new_scsi_buf(struct lpfc_vport *vpo
 	struct lpfc_scsi_buf *psb;
 	struct ulp_bde64 *bpl;
 	IOCB_t *iocb;
-	dma_addr_t pdma_phys;
+	dma_addr_t pdma_phys_fcp_cmd;
+	dma_addr_t pdma_phys_fcp_rsp;
+	dma_addr_t pdma_phys_bpl;
 	uint16_t iotag;
 
 	psb = kzalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
@@ -238,40 +240,60 @@ lpfc_new_scsi_buf(struct lpfc_vport *vpo
 
 	/* Initialize local short-hand pointers. */
 	bpl = psb->fcp_bpl;
-	pdma_phys = psb->dma_handle;
+	pdma_phys_fcp_cmd = psb->dma_handle;
+	pdma_phys_fcp_rsp = psb->dma_handle + sizeof(struct fcp_cmnd);
+	pdma_phys_bpl = psb->dma_handle + sizeof(struct fcp_cmnd) +
+			sizeof(struct fcp_rsp);
 
 	/*
 	 * The first two bdes are the FCP_CMD and FCP_RSP.  The balance are sg
 	 * list bdes.  Initialize the first two and leave the rest for
 	 * queuecommand.
 	 */
-	bpl->addrHigh = le32_to_cpu(putPaddrHigh(pdma_phys));
-	bpl->addrLow = le32_to_cpu(putPaddrLow(pdma_phys));
-	bpl->tus.f.bdeSize = sizeof (struct fcp_cmnd);
-	bpl->tus.f.bdeFlags = BUFF_USE_CMND;
-	bpl->tus.w = le32_to_cpu(bpl->tus.w);
-	bpl++;
+	bpl[0].addrHigh = le32_to_cpu(putPaddrHigh(pdma_phys_fcp_cmd));
+	bpl[0].addrLow = le32_to_cpu(putPaddrLow(pdma_phys_fcp_cmd));
+	bpl[0].tus.f.bdeSize = sizeof(struct fcp_cmnd);
+	bpl[0].tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+	bpl[0].tus.w = le32_to_cpu(bpl->tus.w);
 
 	/* Setup the physical region for the FCP RSP */
-	pdma_phys += sizeof (struct fcp_cmnd);
-	bpl->addrHigh = le32_to_cpu(putPaddrHigh(pdma_phys));
-	bpl->addrLow = le32_to_cpu(putPaddrLow(pdma_phys));
-	bpl->tus.f.bdeSize = sizeof (struct fcp_rsp);
-	bpl->tus.f.bdeFlags = (BUFF_USE_CMND | BUFF_USE_RCV);
-	bpl->tus.w = le32_to_cpu(bpl->tus.w);
+	bpl[1].addrHigh = le32_to_cpu(putPaddrHigh(pdma_phys_fcp_rsp));
+	bpl[1].addrLow = le32_to_cpu(putPaddrLow(pdma_phys_fcp_rsp));
+	bpl[1].tus.f.bdeSize = sizeof(struct fcp_rsp);
+	bpl[1].tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+	bpl[1].tus.w = le32_to_cpu(bpl->tus.w);
 
 	/*
 	 * Since the IOCB for the FCP I/O is built into this lpfc_scsi_buf,
 	 * initialize it with all known data now.
 	 */
-	pdma_phys += (sizeof (struct fcp_rsp));
 	iocb = &psb->cur_iocbq.iocb;
 	iocb->un.fcpi64.bdl.ulpIoTag32 = 0;
-	iocb->un.fcpi64.bdl.addrHigh = putPaddrHigh(pdma_phys);
-	iocb->un.fcpi64.bdl.addrLow = putPaddrLow(pdma_phys);
-	iocb->un.fcpi64.bdl.bdeSize = (2 * sizeof (struct ulp_bde64));
-	iocb->un.fcpi64.bdl.bdeFlags = BUFF_TYPE_BDL;
-	iocb->ulpBdeCount = 1;
+	if (phba->sli_rev == 3) {
+		/* fill in immediate fcp command BDE */
+		iocb->un.fcpi64.bdl.bdeFlags = BUFF_TYPE_BDE_IMMED;
+		iocb->un.fcpi64.bdl.bdeSize = sizeof(struct fcp_cmnd);
+		iocb->un.fcpi64.bdl.addrLow = offsetof(IOCB_t,
+						       unsli3.fcp_ext.icd);
+		iocb->un.fcpi64.bdl.addrHigh = 0;
+		iocb->ulpBdeCount = 0;
+		iocb->ulpLe = 0;
+		/* fill in responce BDE */
+		iocb->unsli3.fcp_ext.rbde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		iocb->unsli3.fcp_ext.rbde.tus.f.bdeSize =
+						sizeof(struct fcp_rsp);
+		iocb->unsli3.fcp_ext.rbde.addrLow =
+						putPaddrLow(pdma_phys_fcp_rsp);
+		iocb->unsli3.fcp_ext.rbde.addrHigh =
+						putPaddrHigh(pdma_phys_fcp_rsp);
+	} else {
+		iocb->un.fcpi64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
+		iocb->un.fcpi64.bdl.bdeSize = (2 * sizeof(struct ulp_bde64));
+		iocb->un.fcpi64.bdl.addrLow = putPaddrLow(pdma_phys_bpl);
+		iocb->un.fcpi64.bdl.addrHigh = putPaddrHigh(pdma_phys_bpl);
+		iocb->ulpBdeCount = 1;
+		iocb->ulpLe = 1;
+	}
 	iocb->ulpClass = CLASS3;
 
 	return psb;
@@ -313,8 +335,9 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
 	struct ulp_bde64 *bpl = lpfc_cmd->fcp_bpl;
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
+	struct ulp_bde64 *data_bde = iocb_cmd->unsli3.fcp_ext.dbde;
 	dma_addr_t physaddr;
-	uint32_t i, num_bde = 0;
+	uint32_t num_bde = 0;
 	int nseg, datadir = scsi_cmnd->sc_data_direction;
 
 	/*
@@ -352,33 +375,64 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 		 * during probe that limits the number of sg elements in any
 		 * single scsi command.  Just run through the seg_cnt and format
 		 * the bde's.
+		 * When using SLI-3 the driver will try to fit all the BDEs into
+		 * the IOCB. If it can't then the BDEs get added to a BPL as it
+		 * does for SLI-2 mode.
 		 */
-		scsi_for_each_sg(scsi_cmnd, sgel, nseg, i) {
+		scsi_for_each_sg(scsi_cmnd, sgel, nseg, num_bde) {
 			physaddr = sg_dma_address(sgel);
-			bpl->addrLow = le32_to_cpu(putPaddrLow(physaddr));
-			bpl->addrHigh = le32_to_cpu(putPaddrHigh(physaddr));
-			bpl->tus.f.bdeSize = sg_dma_len(sgel);
-			if (datadir == DMA_TO_DEVICE)
-				bpl->tus.f.bdeFlags = 0;
-			else
-				bpl->tus.f.bdeFlags = BUFF_USE_RCV;
-			bpl->tus.w = le32_to_cpu(bpl->tus.w);
-			bpl++;
-			num_bde++;
+			if (phba->sli_rev == 3 &&
+			    nseg <= LPFC_EXT_DATA_BDE_COUNT) {
+				data_bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+				data_bde->tus.f.bdeSize = sg_dma_len(sgel);
+				data_bde->addrLow = putPaddrLow(physaddr);
+				data_bde->addrHigh = putPaddrHigh(physaddr);
+				data_bde++;
+			} else {
+				bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+				bpl->tus.f.bdeSize = sg_dma_len(sgel);
+				bpl->tus.w = le32_to_cpu(bpl->tus.w);
+				bpl->addrLow =
+					le32_to_cpu(putPaddrLow(physaddr));
+				bpl->addrHigh =
+					le32_to_cpu(putPaddrHigh(physaddr));
+				bpl++;
+			}
 		}
 	}
 
 	/*
 	 * Finish initializing those IOCB fields that are dependent on the
-	 * scsi_cmnd request_buffer.  Note that the bdeSize is explicitly
-	 * reinitialized since all iocb memory resources are used many times
-	 * for transmit, receive, and continuation bpl's.
-	 */
-	iocb_cmd->un.fcpi64.bdl.bdeSize = (2 * sizeof (struct ulp_bde64));
-	iocb_cmd->un.fcpi64.bdl.bdeSize +=
-		(num_bde * sizeof (struct ulp_bde64));
-	iocb_cmd->ulpBdeCount = 1;
-	iocb_cmd->ulpLe = 1;
+	 * scsi_cmnd request_buffer.  Note that for SLI-2 the bdeSize is
+	 * explicitly reinitialized and for SLI-3 the extended bde count is
+	 * explicitly reinitialized since all iocb memory resources are reused.
+	 */
+	if (phba->sli_rev == 3) {
+		if (num_bde > LPFC_EXT_DATA_BDE_COUNT) {
+			/*
+			 * The extended IOCB format can only fit 3 BDE or a BPL.
+			 * This I/O has more than 3 BDE so the 1st data bde will
+			 * be a BPL that is filled in here.
+			 */
+			physaddr = lpfc_cmd->dma_handle;
+			data_bde->tus.f.bdeFlags = BUFF_TYPE_BLP_64;
+			data_bde->tus.f.bdeSize = (num_bde *
+						   sizeof(struct ulp_bde64));
+			physaddr += (sizeof(struct fcp_cmnd) +
+				     sizeof(struct fcp_rsp) +
+				     (2 * sizeof(struct ulp_bde64)));
+			data_bde->addrHigh = putPaddrHigh(physaddr);
+			data_bde->addrLow = putPaddrLow(physaddr);
+			/* ebde count includes the responce bde and data bpl */
+			iocb_cmd->unsli3.fcp_ext.ebde_count = 2;
+		} else {
+			/* ebde count includes the responce bde and data bdes */
+			iocb_cmd->unsli3.fcp_ext.ebde_count = (num_bde + 1);
+		}
+	} else {
+		iocb_cmd->un.fcpi64.bdl.bdeSize =
+			((num_bde + 2) * sizeof(struct ulp_bde64));
+	}
 	fcp_cmnd->fcpDl = cpu_to_be32(scsi_bufflen(scsi_cmnd));
 	return 0;
 }
@@ -692,6 +746,24 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
 }
 
+/**
+ * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB.
+ * @data: A pointer to the immediate command data portion of the IOCB.
+ * @fcp_cmnd: The FCP Command that is provided by the SCSI layer.
+ *
+ * The routine copies the entire FCP command from @fcp_cmnd to @data while
+ * byte swapping the data to big endian format for transmission on the wire.
+ **/
+static void
+lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
+{
+	int i, j;
+	for (i = 0, j = 0; i < sizeof(struct fcp_cmnd);
+	     i += sizeof(uint32_t), j++) {
+		((uint32_t *)data)[j] = cpu_to_be32(((uint32_t *)fcp_cmnd)[j]);
+	}
+}
+
 static void
 lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		    struct lpfc_nodelist *pnode)
@@ -758,7 +830,8 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 		fcp_cmnd->fcpCntl3 = 0;
 		phba->fc4ControlRequests++;
 	}
-
+	if (phba->sli_rev == 3)
+		lpfc_fcpcmd_to_iocb(iocb_cmd->unsli3.fcp_ext.icd, fcp_cmnd);
 	/*
 	 * Finish initializing those IOCB fields that are independent
 	 * of the scsi_cmnd request_buffer
@@ -798,11 +871,13 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 	piocb = &piocbq->iocb;
 
 	fcp_cmnd = lpfc_cmd->fcp_cmnd;
-	int_to_scsilun(lun, &lpfc_cmd->fcp_cmnd->fcp_lun);
+	/* Clear out any old data in the FCP command area */
+	memset(fcp_cmnd, 0, sizeof(struct fcp_cmnd));
+	int_to_scsilun(lun, &fcp_cmnd->fcp_lun);
 	fcp_cmnd->fcpCntl2 = task_mgmt_cmd;
-
+	if (vport->phba->sli_rev == 3)
+		lpfc_fcpcmd_to_iocb(piocb->unsli3.fcp_ext.icd, fcp_cmnd);
 	piocb->ulpCommand = CMD_FCP_ICMND64_CR;
-
 	piocb->ulpContext = ndlp->nlp_rpi;
 	if (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) {
 		piocb->ulpFCP2Rcvy = 1;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-08-24 18:58:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-08-24 20:41:07.000000000 -0400
@@ -406,11 +406,8 @@ lpfc_sli_ringtx_get(struct lpfc_hba *phb
 static IOCB_t *
 lpfc_sli_next_iocb_slot (struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
-	struct lpfc_pgp *pgp = (phba->sli_rev == 3) ?
-		&phba->slim2p->mbx.us.s3_pgp.port[pring->ringno] :
-		&phba->slim2p->mbx.us.s2.port[pring->ringno];
+	struct lpfc_pgp *pgp = &phba->port_gp[pring->ringno];
 	uint32_t  max_cmd_idx = pring->numCiocb;
-
 	if ((pring->next_cmdidx == pring->cmdidx) &&
 	   (++pring->next_cmdidx >= max_cmd_idx))
 		pring->next_cmdidx = 0;
@@ -625,9 +622,11 @@ lpfc_sli_update_ring(struct lpfc_hba *ph
 	/*
 	 * Tell the HBA that there is work to do in this ring.
 	 */
-	wmb();
-	writel(CA_R0ATT << (ringno * 4), phba->CAregaddr);
-	readl(phba->CAregaddr); /* flush */
+	if (!(phba->sli3_options & LPFC_SLI3_CRP_ENABLED)) {
+		wmb();
+		writel(CA_R0ATT << (ringno * 4), phba->CAregaddr);
+		readl(phba->CAregaddr); /* flush */
+	}
 }
 
 /**
@@ -1654,9 +1653,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 static void
 lpfc_sli_rsp_pointers_error(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
-	struct lpfc_pgp *pgp = (phba->sli_rev == 3) ?
-		&phba->slim2p->mbx.us.s3_pgp.port[pring->ringno] :
-		&phba->slim2p->mbx.us.s2.port[pring->ringno];
+	struct lpfc_pgp *pgp = &phba->port_gp[pring->ringno];
 	/*
 	 * Ring <ringno> handler: portRspPut <portRspPut> is bigger then
 	 * rsp ring <portRspMax>
@@ -1704,7 +1701,7 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
 	IOCB_t *entry = NULL;
 	struct lpfc_iocbq *cmdiocbq = NULL;
 	struct lpfc_iocbq rspiocbq;
-	struct lpfc_pgp *pgp;
+	struct lpfc_pgp *pgp = &phba->port_gp[pring->ringno];
 	uint32_t status;
 	uint32_t portRspPut, portRspMax;
 	int type;
@@ -1714,11 +1711,6 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
 
 	pring->stats.iocb_event++;
 
-	pgp = (phba->sli_rev == 3) ?
-		&phba->slim2p->mbx.us.s3_pgp.port[pring->ringno] :
-		&phba->slim2p->mbx.us.s2.port[pring->ringno];
-
-
 	/*
 	 * The next available response entry should never exceed the maximum
 	 * entries.  If it does, treat it as an adapter hardware error.
@@ -1870,9 +1862,7 @@ static int
 lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				struct lpfc_sli_ring *pring, uint32_t mask)
 {
-	struct lpfc_pgp *pgp = (phba->sli_rev == 3) ?
-		&phba->slim2p->mbx.us.s3_pgp.port[pring->ringno] :
-		&phba->slim2p->mbx.us.s2.port[pring->ringno];
+	struct lpfc_pgp *pgp = &phba->port_gp[pring->ringno];
 	IOCB_t *irsp = NULL;
 	IOCB_t *entry = NULL;
 	struct lpfc_iocbq *cmdiocbq = NULL;
@@ -2064,9 +2054,7 @@ int
 lpfc_sli_handle_slow_ring_event(struct lpfc_hba *phba,
 				struct lpfc_sli_ring *pring, uint32_t mask)
 {
-	struct lpfc_pgp *pgp = (phba->sli_rev == 3) ?
-		&phba->slim2p->mbx.us.s3_pgp.port[pring->ringno] :
-		&phba->slim2p->mbx.us.s2.port[pring->ringno];
+	struct lpfc_pgp *pgp;
 	IOCB_t *entry;
 	IOCB_t *irsp = NULL;
 	struct lpfc_iocbq *rspiocbp = NULL;
@@ -2080,6 +2068,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 	int rc = 1;
 	unsigned long iflag;
 
+	pgp = &phba->port_gp[pring->ringno];
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	pring->stats.iocb_event++;
 
@@ -2990,13 +2979,15 @@ lpfc_do_config_port(struct lpfc_hba *phb
 		if (rc == -ERESTART) {
 			phba->link_state = LPFC_LINK_UNKNOWN;
 			continue;
-		} else if (rc) {
+		} else if (rc)
 			break;
-		}
-
 		phba->link_state = LPFC_INIT_MBX_CMDS;
 		lpfc_config_port(phba, pmb);
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
+		phba->sli3_options &= ~(LPFC_SLI3_NPIV_ENABLED |
+					LPFC_SLI3_HBQ_ENABLED |
+					LPFC_SLI3_CRP_ENABLED |
+					LPFC_SLI3_INB_ENABLED);
 		if (rc != MBX_SUCCESS) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0442 Adapter failed to init, mbxCmd x%x "
@@ -3006,25 +2997,44 @@ lpfc_do_config_port(struct lpfc_hba *phb
 			phba->sli.sli_flag &= ~LPFC_SLI2_ACTIVE;
 			spin_unlock_irq(&phba->hbalock);
 			rc = -ENXIO;
-		} else {
+		} else
 			done = 1;
-			phba->max_vpi = (phba->max_vpi &&
-					 pmb->mb.un.varCfgPort.gmv) != 0
-				? pmb->mb.un.varCfgPort.max_vpi
-				: 0;
-		}
 	}
-
 	if (!done) {
 		rc = -EINVAL;
 		goto do_prep_failed;
 	}
-
-	if ((pmb->mb.un.varCfgPort.sli_mode == 3) &&
-		(!pmb->mb.un.varCfgPort.cMA)) {
-		rc = -ENXIO;
+	if (pmb->mb.un.varCfgPort.sli_mode == 3) {
+		if (!pmb->mb.un.varCfgPort.cMA) {
+			rc = -ENXIO;
+			goto do_prep_failed;
+		}
+		if (phba->max_vpi && pmb->mb.un.varCfgPort.gmv) {
+			phba->sli3_options |= LPFC_SLI3_NPIV_ENABLED;
+			phba->max_vpi = pmb->mb.un.varCfgPort.max_vpi;
+		} else
+			phba->max_vpi = 0;
+		if (pmb->mb.un.varCfgPort.gerbm)
+			phba->sli3_options |= LPFC_SLI3_HBQ_ENABLED;
+		if (pmb->mb.un.varCfgPort.gcrp)
+			phba->sli3_options |= LPFC_SLI3_CRP_ENABLED;
+		if (pmb->mb.un.varCfgPort.ginb) {
+			phba->sli3_options |= LPFC_SLI3_INB_ENABLED;
+			phba->port_gp = phba->mbox->us.s3_inb_pgp.port;
+			phba->inb_ha_copy = &phba->mbox->us.s3_inb_pgp.ha_copy;
+			phba->inb_counter = &phba->mbox->us.s3_inb_pgp.counter;
+			phba->inb_last_counter =
+					phba->mbox->us.s3_inb_pgp.counter;
+		} else {
+			phba->port_gp = phba->mbox->us.s3_pgp.port;
+			phba->inb_ha_copy = NULL;
+			phba->inb_counter = NULL;
+		}
+	} else {
+		phba->port_gp = phba->mbox->us.s2.port;
+		phba->inb_ha_copy = NULL;
+		phba->inb_counter = NULL;
 	}
-
 do_prep_failed:
 	mempool_free(pmb, phba->mbox_mem_pool);
 	return rc;
@@ -3085,9 +3095,6 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
 	if (phba->sli_rev == 3) {
 		phba->iocb_cmd_size = SLI3_IOCB_CMD_SIZE;
 		phba->iocb_rsp_size = SLI3_IOCB_RSP_SIZE;
-		phba->sli3_options |= LPFC_SLI3_ENABLED;
-		phba->sli3_options |= LPFC_SLI3_HBQ_ENABLED;
-
 	} else {
 		phba->iocb_cmd_size = SLI2_IOCB_CMD_SIZE;
 		phba->iocb_rsp_size = SLI2_IOCB_RSP_SIZE;
@@ -3255,7 +3262,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 	int i;
 	unsigned long timeout;
 	unsigned long drvr_flag = 0;
-	volatile uint32_t word0, ldata;
+	uint32_t word0, ldata;
 	void __iomem *to_slim;
 	int processing_queue = 0;
 
@@ -3415,12 +3422,11 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 
 	if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
 		/* First copy command data to host SLIM area */
-		lpfc_sli_pcimem_bcopy(mb, &phba->slim2p->mbx, MAILBOX_CMD_SIZE);
+		lpfc_sli_pcimem_bcopy(mb, phba->mbox, MAILBOX_CMD_SIZE);
 	} else {
 		if (mb->mbxCommand == MBX_CONFIG_PORT) {
 			/* copy command data into host mbox for cmpl */
-			lpfc_sli_pcimem_bcopy(mb, &phba->slim2p->mbx,
-					      MAILBOX_CMD_SIZE);
+			lpfc_sli_pcimem_bcopy(mb, phba->mbox, MAILBOX_CMD_SIZE);
 		}
 
 		/* First copy mbox command data to HBA SLIM, skip past first
@@ -3430,7 +3436,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 			    MAILBOX_CMD_SIZE - sizeof (uint32_t));
 
 		/* Next copy over first word, with mbxOwner set */
-		ldata = *((volatile uint32_t *)mb);
+		ldata = *((uint32_t *)mb);
 		to_slim = phba->MBslimaddr;
 		writel(ldata, to_slim);
 		readl(to_slim); /* flush */
@@ -3462,7 +3468,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 
 		if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
 			/* First read mbox status word */
-			word0 = *((volatile uint32_t *)&phba->slim2p->mbx);
+			word0 = *((uint32_t *)phba->mbox);
 			word0 = le32_to_cpu(word0);
 		} else {
 			/* First read mbox status word */
@@ -3501,12 +3507,11 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 
 			if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
 				/* First copy command data */
-				word0 = *((volatile uint32_t *)
-						&phba->slim2p->mbx);
+				word0 = *((uint32_t *)phba->mbox);
 				word0 = le32_to_cpu(word0);
 				if (mb->mbxCommand == MBX_CONFIG_PORT) {
 					MAILBOX_t *slimmb;
-					volatile uint32_t slimword0;
+					uint32_t slimword0;
 					/* Check real SLIM for any errors */
 					slimword0 = readl(phba->MBslimaddr);
 					slimmb = (MAILBOX_t *) & slimword0;
@@ -3527,8 +3532,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 
 		if (psli->sli_flag & LPFC_SLI2_ACTIVE) {
 			/* copy results back to user */
-			lpfc_sli_pcimem_bcopy(&phba->slim2p->mbx, mb,
-					      MAILBOX_CMD_SIZE);
+			lpfc_sli_pcimem_bcopy(phba->mbox, mb, MAILBOX_CMD_SIZE);
 		} else {
 			/* First copy command data */
 			lpfc_memcpy_from_slim(mb, phba->MBslimaddr,
@@ -5095,7 +5099,16 @@ lpfc_intr_handler(int irq, void *dev_id)
 	 * preserve status) and Link Attention
 	 */
 	spin_lock(&phba->hbalock);
-	ha_copy = readl(phba->HAregaddr);
+	if (phba->sli3_options & LPFC_SLI3_INB_ENABLED &&
+	    (phba->inb_last_counter != *phba->inb_counter)) {
+		phba->inb_last_counter = *phba->inb_counter;
+		ha_copy = le32_to_cpu(*phba->inb_ha_copy);
+	} else
+		ha_copy = readl(phba->HAregaddr);
+	if (unlikely(!ha_copy)) {
+		spin_unlock(&phba->hbalock);
+		return IRQ_NONE;
+	}
 	/* If somebody is waiting to handle an eratt don't process it
 	 * here.  The brdkill function will do this.
 	 */
@@ -5105,9 +5118,6 @@ lpfc_intr_handler(int irq, void *dev_id)
 	readl(phba->HAregaddr); /* flush */
 	spin_unlock(&phba->hbalock);
 
-	if (unlikely(!ha_copy))
-		return IRQ_NONE;
-
 	work_ha_copy = ha_copy & phba->work_ha_mask;
 
 	if (unlikely(work_ha_copy)) {
@@ -5194,7 +5204,7 @@ lpfc_intr_handler(int irq, void *dev_id)
 		    (phba->sli.mbox_active)) {
 			pmb = phba->sli.mbox_active;
 			pmbox = &pmb->mb;
-			mbox = &phba->slim2p->mbx;
+			mbox = phba->mbox;
 			vport = pmb->vport;
 
 			/* First check out the status word */


