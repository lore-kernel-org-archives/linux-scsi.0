From: James Smart <James.Smart@Emulex.com>
Subject: [PATCH 4/22] lpfc 8.1.2 : Handling of ELS commands RRQ, RPS, RPL
 and LIRR correctly
Date: Wed, 08 Feb 2006 10:41:26 -0500
Message-ID: <43EA1126.10307@emulex.com>
Reply-To: James.Smart@Emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:24973 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030385AbWBHPlb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:41:31 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18FfRrh011817
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:41:29 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Handling of ELS commands RRQ, RPS, RPL and LIRR correctly


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -336,6 +336,23 @@ lpfc_read_config(struct lpfc_hba * phba,
  	return;
  }

+/*************************************************/
+/*  lpfc_read_lnk_stat  Issue a READ LINK STATUS */
+/*                mailbox command                */
+/*************************************************/
+void
+lpfc_read_lnk_stat(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
+{
+	MAILBOX_t *mb;
+
+	mb = &pmb->mb;
+	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
+
+	mb->mbxCommand = MBX_READ_LNK_STAT;
+	mb->mbxOwner = OWN_HOST;
+	return;
+}
+
  /********************************************/
  /*  lpfc_reg_login  Issue a REG_LOGIN       */
  /*                  mailbox command         */
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -26,6 +26,7 @@ void lpfc_clear_la(struct lpfc_hba *, LP
  void lpfc_config_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
  int lpfc_read_sparam(struct lpfc_hba *, LPFC_MBOXQ_t *);
  void lpfc_read_config(struct lpfc_hba *, LPFC_MBOXQ_t *);
+void lpfc_read_lnk_stat(struct lpfc_hba *, LPFC_MBOXQ_t *);
  void lpfc_set_slim(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
  int lpfc_reg_login(struct lpfc_hba *, uint32_t, uint8_t *, LPFC_MBOXQ_t *,
  		   uint32_t);
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -454,10 +454,13 @@ struct serv_parm {	/* Structure is in Bi
  #define ELS_CMD_ADISC     0x52000000
  #define ELS_CMD_FARP      0x54000000
  #define ELS_CMD_FARPR     0x55000000
+#define ELS_CMD_RPS       0x56000000
+#define ELS_CMD_RPL       0x57000000
  #define ELS_CMD_FAN       0x60000000
  #define ELS_CMD_RSCN      0x61040000
  #define ELS_CMD_SCR       0x62000000
  #define ELS_CMD_RNID      0x78000000
+#define ELS_CMD_LIRR      0x7A000000
  #else	/*  __LITTLE_ENDIAN_BITFIELD */
  #define ELS_CMD_MASK      0xffff
  #define ELS_RSP_MASK      0xff
@@ -486,10 +489,13 @@ struct serv_parm {	/* Structure is in Bi
  #define ELS_CMD_ADISC     0x52
  #define ELS_CMD_FARP      0x54
  #define ELS_CMD_FARPR     0x55
+#define ELS_CMD_RPS       0x56
+#define ELS_CMD_RPL       0x57
  #define ELS_CMD_FAN       0x60
  #define ELS_CMD_RSCN      0x0461
  #define ELS_CMD_SCR       0x62
  #define ELS_CMD_RNID      0x78
+#define ELS_CMD_LIRR      0x7A
  #endif

  /*
@@ -758,12 +764,40 @@ typedef struct _RNID {		/* Structure is
  	} un;
  } RNID;

-typedef struct _RRQ {		/* Structure is in Big Endian format */
-	uint32_t SID;
-	uint16_t Oxid;
-	uint16_t Rxid;
-	uint8_t resv[32];	/* optional association hdr */
-} RRQ;
+typedef struct  _RPS {  	/* Structure is in Big Endian format */
+	union {
+		uint32_t portNum;
+		struct lpfc_name portName;
+	} un;
+} RPS;
+
+typedef struct  _RPS_RSP {	/* Structure is in Big Endian format */
+	uint16_t rsvd1;
+	uint16_t portStatus;
+	uint32_t linkFailureCnt;
+	uint32_t lossSyncCnt;
+	uint32_t lossSignalCnt;
+	uint32_t primSeqErrCnt;
+	uint32_t invalidXmitWord;
+	uint32_t crcCnt;
+} RPS_RSP;
+
+typedef struct  _RPL {  	/* Structure is in Big Endian format */
+	uint32_t maxsize;
+	uint32_t index;
+} RPL;
+
+typedef struct  _PORT_NUM_BLK {
+	uint32_t portNum;
+	uint32_t portID;
+	struct lpfc_name portName;
+} PORT_NUM_BLK;
+
+typedef struct  _RPL_RSP { 	/* Structure is in Big Endian format */
+	uint32_t listLen;
+	uint32_t index;
+	PORT_NUM_BLK port_num_blk;
+} RPL_RSP;

  /* This is used for RSCN command */
  typedef struct _D_ID {		/* Structure is in Big Endian format */
@@ -804,7 +838,6 @@ typedef struct _ELS_PKT {	/* Structure i
  		FARP farp;	/* Payload for FARP/ACC */
  		FAN fan;	/* Payload for FAN */
  		SCR scr;	/* Payload for SCR/ACC */
-		RRQ rrq;	/* Payload for RRQ */
  		RNID rnid;	/* Payload for RNID */
  		uint8_t pad[128 - 4];	/* Pad out to payload of 128 bytes */
  	} un;
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2654,41 +2654,243 @@ lpfc_els_rcv_rnid(struct lpfc_hba * phba
  }

  static int
-lpfc_els_rcv_rrq(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
+lpfc_els_rcv_lirr(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
+		 struct lpfc_nodelist * ndlp)
+{
+	struct ls_rjt stat;
+
+	/* For now, unconditionally reject this command */
+	stat.un.b.lsRjtRsvd0 = 0;
+	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
+	stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
+	stat.un.b.vendorUnique = 0;
+	lpfc_els_rsp_reject(phba, stat.un.lsRjtError, cmdiocb, ndlp);
+	return 0;
+}
+
+void
+lpfc_els_rsp_rps_acc(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
+{
+	struct lpfc_sli *psli;
+	struct lpfc_sli_ring *pring;
+	MAILBOX_t *mb;
+	IOCB_t *icmd;
+	RPS_RSP *rps_rsp;
+	uint8_t *pcmd;
+	struct lpfc_iocbq *elsiocb;
+	struct lpfc_nodelist *ndlp;
+	uint16_t xri, status;
+	uint32_t cmdsize;
+
+	psli = &phba->sli;
+	pring = &psli->ring[LPFC_ELS_RING];
+	mb = &pmb->mb;
+
+	ndlp = (struct lpfc_nodelist *) pmb->context2;
+	xri = (uint16_t) ((unsigned long)(pmb->context1));
+	pmb->context1 = 0;
+	pmb->context2 = 0;
+
+	if (mb->mbxStatus) {
+		mempool_free( pmb, phba->mbox_mem_pool);
+		return;
+	}
+
+	cmdsize = sizeof(RPS_RSP) + sizeof(uint32_t);
+	mempool_free( pmb, phba->mbox_mem_pool);
+	if ((elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, 3,
+					  ndlp, ELS_CMD_ACC)) == 0) {
+		return;
+	}
+
+	icmd = &elsiocb->iocb;
+	icmd->ulpContext = xri;
+
+	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
+	pcmd += sizeof (uint32_t); /* Skip past command */
+	rps_rsp = (RPS_RSP *)pcmd;
+
+	if (phba->fc_topology != TOPOLOGY_LOOP)
+		status = 0x10;
+	else
+		status = 0x8;
+	if (phba->fc_flag & FC_FABRIC)
+		status |= 0x4;
+
+	rps_rsp->rsvd1 = 0;
+	rps_rsp->portStatus = be16_to_cpu(status);
+	rps_rsp->linkFailureCnt = be32_to_cpu(mb->un.varRdLnk.linkFailureCnt);
+	rps_rsp->lossSyncCnt = be32_to_cpu(mb->un.varRdLnk.lossSyncCnt);
+	rps_rsp->lossSignalCnt = be32_to_cpu(mb->un.varRdLnk.lossSignalCnt);
+	rps_rsp->primSeqErrCnt = be32_to_cpu(mb->un.varRdLnk.primSeqErrCnt);
+	rps_rsp->invalidXmitWord = be32_to_cpu(mb->un.varRdLnk.invalidXmitWord);
+	rps_rsp->crcCnt = be32_to_cpu(mb->un.varRdLnk.crcCnt);
+
+	/* Xmit ELS RPS ACC response tag <ulpIoTag> */
+	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+			"%d:0128 Xmit ELS RPS ACC response tag x%x "
+			"Data: x%x x%x x%x x%x x%x\n",
+			phba->brd_no,
+			elsiocb->iocb.ulpIoTag,
+			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
+			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
+
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_acc;
+	phba->fc_stat.elsXmitACC++;
+	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+	}
+	return;
+}
+
+static int
+lpfc_els_rcv_rps(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
  		 struct lpfc_nodelist * ndlp)
  {
-	struct lpfc_dmabuf *pcmd;
  	uint32_t *lp;
+	uint8_t flag;
+	LPFC_MBOXQ_t *mbox;
+	struct lpfc_dmabuf *pcmd;
+	RPS *rps;
+	struct ls_rjt stat;
+
+	if((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
+	   (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
+		stat.un.b.lsRjtRsvd0 = 0;
+		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
+		stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
+		stat.un.b.vendorUnique = 0;
+		lpfc_els_rsp_reject(phba, stat.un.lsRjtError, cmdiocb, ndlp);
+	}
+
+	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+	lp = (uint32_t *) pcmd->virt;
+	flag = (be32_to_cpu(*lp++) & 0xf);
+	rps = (RPS *) lp;
+
+	if ((flag == 0) ||
+	    ((flag == 1) && (be32_to_cpu(rps->un.portNum) == 0)) ||
+	    ((flag == 2) && (memcmp(&rps->un.portName, &phba->fc_portname,
+			   sizeof (struct lpfc_name)) == 0))) {
+		if ((mbox = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC))) {
+			lpfc_read_lnk_stat(phba, mbox);
+			mbox->context1 =
+			    (void *)((unsigned long)cmdiocb->iocb.ulpContext);
+			mbox->context2 = ndlp;
+			mbox->mbox_cmpl = lpfc_els_rsp_rps_acc;
+			if (lpfc_sli_issue_mbox (phba, mbox,
+			    (MBX_NOWAIT | MBX_STOP_IOCB)) != MBX_NOT_FINISHED) {
+				/* Mbox completion will send ELS Response */
+				return 0;
+			}
+			mempool_free(mbox, phba->mbox_mem_pool);
+		}
+	}
+	stat.un.b.lsRjtRsvd0 = 0;
+	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
+	stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
+	stat.un.b.vendorUnique = 0;
+	lpfc_els_rsp_reject(phba, stat.un.lsRjtError, cmdiocb, ndlp);
+	return 0;
+}
+
+int
+lpfc_els_rsp_rpl_acc(struct lpfc_hba * phba, uint16_t cmdsize,
+		 struct lpfc_iocbq * oldiocb, struct lpfc_nodelist * ndlp)
+{
  	IOCB_t *icmd;
+	IOCB_t *oldcmd;
+	RPL_RSP rpl_rsp;
+	struct lpfc_iocbq *elsiocb;
  	struct lpfc_sli_ring *pring;
  	struct lpfc_sli *psli;
-	RRQ *rrq;
-	uint32_t cmd, did;
+	uint8_t *pcmd;

  	psli = &phba->sli;
-	pring = &psli->ring[LPFC_FCP_RING];
-	icmd = &cmdiocb->iocb;
-	did = icmd->un.elsreq64.remoteID;
+	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
+
+	if ((elsiocb =
+	     lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
+				ndlp, ELS_CMD_ACC)) == 0) {
+		return 1;
+	}
+	icmd = &elsiocb->iocb;
+	oldcmd = &oldiocb->iocb;
+	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
+
+	pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
+	pcmd += sizeof (uint16_t);
+	*((uint16_t *)(pcmd)) = be16_to_cpu(cmdsize);
+	pcmd += sizeof(uint16_t);
+
+	/* Setup the RPL ACC payload */
+	rpl_rsp.listLen = be32_to_cpu(1);
+	rpl_rsp.index = 0;
+	rpl_rsp.port_num_blk.portNum = 0;
+	rpl_rsp.port_num_blk.portID = be32_to_cpu(phba->fc_myDID);
+	memcpy(&rpl_rsp.port_num_blk.portName, &phba->fc_portname,
+	    sizeof(struct lpfc_name));
+
+	memcpy(pcmd, &rpl_rsp, cmdsize - sizeof(uint32_t));
+
+
+	/* Xmit ELS RPL ACC response tag <ulpIoTag> */
+	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+			"%d:0128 Xmit ELS RPL ACC response tag x%x "
+			"Data: x%x x%x x%x x%x x%x\n",
+			phba->brd_no,
+			elsiocb->iocb.ulpIoTag,
+			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
+			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
+
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_acc;
+
+	phba->fc_stat.elsXmitACC++;
+	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
+	return 0;
+}
+
+static int
+lpfc_els_rcv_rpl(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
+		 struct lpfc_nodelist * ndlp)
+{
+	struct lpfc_dmabuf *pcmd;
+	uint32_t *lp;
+	uint32_t maxsize;
+	uint16_t cmdsize;
+	RPL *rpl;
+	struct ls_rjt stat;
+
+	if((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
+	   (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
+		stat.un.b.lsRjtRsvd0 = 0;
+		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
+		stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
+		stat.un.b.vendorUnique = 0;
+		lpfc_els_rsp_reject(phba, stat.un.lsRjtError, cmdiocb, ndlp);
+	}
+
  	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
  	lp = (uint32_t *) pcmd->virt;
+	rpl = (RPL *) (lp + 1);

-	cmd = *lp++;
-	rrq = (RRQ *) lp;
+	maxsize = be32_to_cpu(rpl->maxsize);

-	/* RRQ received */
-	/* Get oxid / rxid from payload and abort it */
-	spin_lock_irq(phba->host->host_lock);
-	if ((rrq->SID == be32_to_cpu(phba->fc_myDID))) {
-		lpfc_sli_abort_iocb(phba, pring, 0, 0, rrq->Oxid,
-							LPFC_CTX_CTX);
-	} else {
-		lpfc_sli_abort_iocb(phba, pring, 0, 0, rrq->Rxid,
-							LPFC_CTX_CTX);
+	/* We support only one port */
+	if ((rpl->index == 0) &&
+	    ((maxsize == 0) ||
+	     ((maxsize * sizeof(uint32_t)) >= sizeof(RPL_RSP)))) {
+		cmdsize = sizeof(uint32_t) + sizeof(RPL_RSP);
  	}
-
-	spin_unlock_irq(phba->host->host_lock);
-	/* ACCEPT the rrq request */
-	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+	else {
+		cmdsize = sizeof(uint32_t) + maxsize * sizeof(uint32_t);
+	}
+	lpfc_els_rsp_rpl_acc(phba, cmdsize, cmdiocb, ndlp);

  	return 0;
  }
@@ -3201,10 +3403,6 @@ lpfc_els_unsol_event(struct lpfc_hba * p
  		phba->fc_stat.elsRcvFAN++;
  		lpfc_els_rcv_fan(phba, elsiocb, ndlp);
  		break;
-	case ELS_CMD_RRQ:
-		phba->fc_stat.elsRcvRRQ++;
-		lpfc_els_rcv_rrq(phba, elsiocb, ndlp);
-		break;
  	case ELS_CMD_PRLI:
  		phba->fc_stat.elsRcvPRLI++;
  		if (phba->hba_state < LPFC_DISC_AUTH) {
@@ -3213,9 +3411,33 @@ lpfc_els_unsol_event(struct lpfc_hba * p
  		}
  		lpfc_disc_state_machine(phba, ndlp, elsiocb, NLP_EVT_RCV_PRLI);
  		break;
+	case ELS_CMD_LIRR:
+		phba->fc_stat.elsRcvLIRR++;
+		lpfc_els_rcv_lirr(phba, elsiocb, ndlp);
+		if (newnode) {
+			mempool_free( ndlp, phba->nlp_mem_pool);
+		}
+		break;
+	case ELS_CMD_RPS:
+		phba->fc_stat.elsRcvRPS++;
+		lpfc_els_rcv_rps(phba, elsiocb, ndlp);
+		if (newnode) {
+			mempool_free( ndlp, phba->nlp_mem_pool);
+		}
+		break;
+	case ELS_CMD_RPL:
+		phba->fc_stat.elsRcvRPL++;
+		lpfc_els_rcv_rpl(phba, elsiocb, ndlp);
+		if (newnode) {
+			mempool_free( ndlp, phba->nlp_mem_pool);
+		}
+		break;
  	case ELS_CMD_RNID:
  		phba->fc_stat.elsRcvRNID++;
  		lpfc_els_rcv_rnid(phba, elsiocb, ndlp);
+		if (newnode) {
+			mempool_free( ndlp, phba->nlp_mem_pool);
+		}
  		break;
  	default:
  		/* Unsupported ELS command, reject */
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -121,7 +121,9 @@ struct lpfc_stats {
  	uint32_t elsRcvLOGO;
  	uint32_t elsRcvPRLO;
  	uint32_t elsRcvPRLI;
-	uint32_t elsRcvRRQ;
+	uint32_t elsRcvLIRR;
+	uint32_t elsRcvRPS;
+	uint32_t elsRcvRPL;
  	uint32_t elsXmitFLOGI;
  	uint32_t elsXmitPLOGI;
  	uint32_t elsXmitPRLI;

