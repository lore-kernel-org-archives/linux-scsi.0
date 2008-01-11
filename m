From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/10] lpfc 8.2.4 : Fix Unsolicited Data items
Date: Fri, 11 Jan 2008 01:53:18 -0500
Message-ID: <1200034398.27954.27.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51537 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYAKGxZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 01:53:25 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m0B6rNAx021671
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 22:53:24 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix Drivers Unsolicited CT command handling - we did not handle multiframe
  sequences well.
Fix error due to delay in replenishing buffers for unsolicited data.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-01-11 01:04:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-01-11 01:25:48.000000000 -0500
@@ -57,45 +57,27 @@
 
 static char *lpfc_release_version = LPFC_DRIVER_VERSION;
 
-/*
- * lpfc_ct_unsol_event
- */
 static void
-lpfc_ct_unsol_buffer(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq,
-		     struct lpfc_dmabuf *mp, uint32_t size)
+lpfc_ct_ignore_hbq_buffer(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq,
+			  struct lpfc_dmabuf *mp, uint32_t size)
 {
 	if (!mp) {
-		printk(KERN_ERR "%s (%d): Unsolited CT, no buffer, "
-		       "piocbq = %p, status = x%x, mp = %p, size = %d\n",
-		       __FUNCTION__, __LINE__,
-		       piocbq, piocbq->iocb.ulpStatus, mp, size);
-	}
-
-	printk(KERN_ERR "%s (%d): Ignoring unsolicted CT piocbq = %p, "
-	       "buffer = %p, size = %d, status = x%x\n",
-	       __FUNCTION__, __LINE__,
-	       piocbq, mp, size,
-	       piocbq->iocb.ulpStatus);
-
+		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+				"0146 Ignoring unsolicted CT No HBQ "
+				"status = x%x\n",
+				piocbq->iocb.ulpStatus);
+	}
+	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+			"0145 Ignoring unsolicted CT HBQ Size:%d "
+			"status = x%x\n",
+			size, piocbq->iocb.ulpStatus);
 }
 
 static void
-lpfc_ct_ignore_hbq_buffer(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq,
-			  struct lpfc_dmabuf *mp, uint32_t size)
+lpfc_ct_unsol_buffer(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq,
+		     struct lpfc_dmabuf *mp, uint32_t size)
 {
-	if (!mp) {
-		printk(KERN_ERR "%s (%d): Unsolited CT, no "
-		       "HBQ buffer, piocbq = %p, status = x%x\n",
-		       __FUNCTION__, __LINE__,
-		       piocbq, piocbq->iocb.ulpStatus);
-	} else {
-		lpfc_ct_unsol_buffer(phba, piocbq, mp, size);
-		printk(KERN_ERR "%s (%d): Ignoring unsolicted CT "
-		       "piocbq = %p, buffer = %p, size = %d, "
-		       "status = x%x\n",
-		       __FUNCTION__, __LINE__,
-		       piocbq, mp, size, piocbq->iocb.ulpStatus);
-	}
+	lpfc_ct_ignore_hbq_buffer(phba, piocbq, mp, size);
 }
 
 void
@@ -109,11 +91,8 @@ lpfc_ct_unsol_event(struct lpfc_hba *phb
 	struct lpfc_iocbq *iocbq;
 	dma_addr_t paddr;
 	uint32_t size;
-	struct lpfc_dmabuf *bdeBuf1 = piocbq->context2;
-	struct lpfc_dmabuf *bdeBuf2 = piocbq->context3;
-
-	piocbq->context2 = NULL;
-	piocbq->context3 = NULL;
+	struct list_head head;
+	struct lpfc_dmabuf *bdeBuf;
 
 	if (unlikely(icmd->ulpStatus == IOSTAT_NEED_BUFFER)) {
 		lpfc_sli_hbqbuf_add_hbqs(phba, LPFC_ELS_HBQ);
@@ -122,7 +101,7 @@ lpfc_ct_unsol_event(struct lpfc_hba *phb
 		/* Not enough posted buffers; Try posting more buffers */
 		phba->fc_stat.NoRcvBuf++;
 		if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
-			lpfc_post_buffer(phba, pring, 0, 1);
+			lpfc_post_buffer(phba, pring, 2, 1);
 		return;
 	}
 
@@ -133,38 +112,34 @@ lpfc_ct_unsol_event(struct lpfc_hba *phb
 		return;
 
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
-		list_for_each_entry(iocbq, &piocbq->list, list) {
+		INIT_LIST_HEAD(&head);
+		list_add_tail(&head, &piocbq->list);
+		list_for_each_entry(iocbq, &head, list) {
 			icmd = &iocbq->iocb;
-			if (icmd->ulpBdeCount == 0) {
-				printk(KERN_ERR "%s (%d): Unsolited CT, no "
-				       "BDE, iocbq = %p, status = x%x\n",
-				       __FUNCTION__, __LINE__,
-				       iocbq, iocbq->iocb.ulpStatus);
+			if (icmd->ulpBdeCount == 0)
 				continue;
-			}
-
+			bdeBuf = iocbq->context2;
+			iocbq->context2 = NULL;
 			size  = icmd->un.cont64[0].tus.f.bdeSize;
-			lpfc_ct_ignore_hbq_buffer(phba, piocbq, bdeBuf1, size);
-			lpfc_in_buf_free(phba, bdeBuf1);
+			lpfc_ct_unsol_buffer(phba, piocbq, bdeBuf, size);
+			lpfc_in_buf_free(phba, bdeBuf);
 			if (icmd->ulpBdeCount == 2) {
-				lpfc_ct_ignore_hbq_buffer(phba, piocbq, bdeBuf2,
-							  size);
-				lpfc_in_buf_free(phba, bdeBuf2);
+				bdeBuf = iocbq->context3;
+				iocbq->context3 = NULL;
+				size  = icmd->unsli3.rcvsli3.bde2.tus.f.bdeSize;
+				lpfc_ct_unsol_buffer(phba, piocbq, bdeBuf,
+						     size);
+				lpfc_in_buf_free(phba, bdeBuf);
 			}
 		}
+		list_del(&head);
 	} else {
 		struct lpfc_iocbq  *next;
 
 		list_for_each_entry_safe(iocbq, next, &piocbq->list, list) {
 			icmd = &iocbq->iocb;
-			if (icmd->ulpBdeCount == 0) {
-				printk(KERN_ERR "%s (%d): Unsolited CT, no "
-				       "BDE, iocbq = %p, status = x%x\n",
-				       __FUNCTION__, __LINE__,
-				       iocbq, iocbq->iocb.ulpStatus);
-				continue;
-			}
-
+			if (icmd->ulpBdeCount == 0)
+				lpfc_ct_unsol_buffer(phba, piocbq, NULL, 0);
 			for (i = 0; i < icmd->ulpBdeCount; i++) {
 				paddr = getPaddr(icmd->un.cont64[i].addrHigh,
 						 icmd->un.cont64[i].addrLow);
@@ -176,6 +151,7 @@ lpfc_ct_unsol_event(struct lpfc_hba *phb
 			}
 			list_del(&iocbq->list);
 			lpfc_sli_release_iocbq(phba, iocbq);
+			lpfc_post_buffer(phba, pring, i, 1);
 		}
 	}
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2008-01-11 01:04:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2008-01-11 01:25:42.000000000 -0500
@@ -2994,6 +2994,34 @@ typedef struct {
 #endif
 } RCV_ELS_REQ64;
 
+/* IOCB Command template for RCV_SEQ64 */
+struct rcv_seq64 {
+	struct ulp_bde64 elsReq;
+	uint32_t hbq_1;
+	uint32_t parmRo;
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t rctl:8;
+	uint32_t type:8;
+	uint32_t dfctl:8;
+	uint32_t ls:1;
+	uint32_t fs:1;
+	uint32_t rsvd2:3;
+	uint32_t si:1;
+	uint32_t bc:1;
+	uint32_t rsvd3:1;
+#else	/*  __LITTLE_ENDIAN_BITFIELD */
+	uint32_t rsvd3:1;
+	uint32_t bc:1;
+	uint32_t si:1;
+	uint32_t rsvd2:3;
+	uint32_t fs:1;
+	uint32_t ls:1;
+	uint32_t dfctl:8;
+	uint32_t type:8;
+	uint32_t rctl:8;
+#endif
+};
+
 /* IOCB Command template for all 64 bit FCP Initiator commands */
 typedef struct {
 	ULP_BDL bdl;
@@ -3085,6 +3113,7 @@ typedef struct _IOCB {	/* IOCB structure
 		FCPT_FIELDS64 fcpt64;	/* FCP 64 bit target template */
 		ASYNCSTAT_FIELDS asyncstat; /* async_status iocb */
 		QUE_XRI64_CX_FIELDS quexri64cx; /* que_xri64_cx fields */
+		struct rcv_seq64 rcvseq64;	/* RCV_SEQ64 and RCV_CONT64 */
 
 		uint32_t ulpWord[IOCB_WORD_SZ - 2];	/* generic 6 'words' */
 	} un;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-01-11 01:04:23.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-01-11 01:25:42.000000000 -0500
@@ -955,6 +955,8 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 	match = 0;
 	irsp = &(saveq->iocb);
 
+	if (irsp->ulpStatus == IOSTAT_NEED_BUFFER)
+		return 1;
 	if (irsp->ulpCommand == CMD_ASYNC_STATUS) {
 		if (pring->lpfc_sli_rcv_async_status)
 			pring->lpfc_sli_rcv_async_status(phba, pring, saveq);
@@ -970,36 +972,7 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 		return 1;
 	}
 
-	if ((irsp->ulpCommand == CMD_RCV_ELS_REQ64_CX)
-	    || (irsp->ulpCommand == CMD_RCV_ELS_REQ_CX)
-	    || (irsp->ulpCommand == CMD_IOCB_RCV_ELS64_CX)
-	    || (irsp->ulpCommand == CMD_IOCB_RCV_CONT64_CX)) {
-		Rctl = FC_ELS_REQ;
-		Type = FC_ELS_DATA;
-	} else {
-		w5p =
-		    (WORD5 *) & (saveq->iocb.un.
-				 ulpWord[5]);
-		Rctl = w5p->hcsw.Rctl;
-		Type = w5p->hcsw.Type;
-
-		/* Firmware Workaround */
-		if ((Rctl == 0) && (pring->ringno == LPFC_ELS_RING) &&
-			(irsp->ulpCommand == CMD_RCV_SEQUENCE64_CX ||
-			 irsp->ulpCommand == CMD_IOCB_RCV_SEQ64_CX)) {
-			Rctl = FC_ELS_REQ;
-			Type = FC_ELS_DATA;
-			w5p->hcsw.Rctl = Rctl;
-			w5p->hcsw.Type = Type;
-		}
-	}
-
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
-		struct lpfc_hbq_entry *hbqe_1, *hbqe_2;
-		hbqe_1 = (struct lpfc_hbq_entry *) &saveq->iocb.un.ulpWord[0];
-		hbqe_2 = (struct lpfc_hbq_entry *) &saveq->iocb.
-				unsli3.sli3Words[4];
-
 		if (irsp->ulpBdeCount != 0) {
 			saveq->context2 = lpfc_sli_get_buff(phba, pring,
 						irsp->un.ulpWord[3]);
@@ -1011,7 +984,6 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 					"an unsolicited iocb. tag 0x%x\n",
 					pring->ringno,
 					irsp->un.ulpWord[3]);
-
 		}
 		if (irsp->ulpBdeCount == 2) {
 			saveq->context3 = lpfc_sli_get_buff(phba, pring,
@@ -1026,16 +998,11 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 					irsp->unsli3.sli3Words[7]);
 		}
 		list_for_each_entry(iocbq, &saveq->list, list) {
-			hbqe_1 = (struct lpfc_hbq_entry *) &iocbq->iocb.
-				un.ulpWord[0];
-			hbqe_2 = (struct lpfc_hbq_entry *) &iocbq->iocb.
-				unsli3.sli3Words[4];
 			irsp = &(iocbq->iocb);
-
 			if (irsp->ulpBdeCount != 0) {
 				iocbq->context2 = lpfc_sli_get_buff(phba, pring,
 							irsp->un.ulpWord[3]);
-				if (!saveq->context2)
+				if (!iocbq->context2)
 					lpfc_printf_log(phba,
 						KERN_ERR,
 						LOG_SLI,
@@ -1047,7 +1014,7 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 			if (irsp->ulpBdeCount == 2) {
 				iocbq->context3 = lpfc_sli_get_buff(phba, pring,
 						irsp->unsli3.sli3Words[7]);
-				if (!saveq->context3)
+				if (!iocbq->context3)
 					lpfc_printf_log(phba,
 						KERN_ERR,
 						LOG_SLI,
@@ -1059,6 +1026,49 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 			}
 		}
 	}
+	if (irsp->ulpBdeCount != 0 &&
+	    (irsp->ulpCommand == CMD_IOCB_RCV_CONT64_CX ||
+	     irsp->ulpStatus == IOSTAT_INTERMED_RSP)) {
+		int found = 0;
+
+		/* search continue save q for same XRI */
+		list_for_each_entry(iocbq, &pring->iocb_continue_saveq, clist) {
+			if (iocbq->iocb.ulpContext == saveq->iocb.ulpContext) {
+				list_add_tail(&saveq->list, &iocbq->list);
+				found = 1;
+				break;
+			}
+		}
+		if (!found)
+			list_add_tail(&saveq->clist,
+				      &pring->iocb_continue_saveq);
+		if (saveq->iocb.ulpStatus != IOSTAT_INTERMED_RSP) {
+			list_del_init(&iocbq->clist);
+			saveq = iocbq;
+			irsp = &(saveq->iocb);
+		} else
+			return 0;
+	}
+	if ((irsp->ulpCommand == CMD_RCV_ELS_REQ64_CX) ||
+	    (irsp->ulpCommand == CMD_RCV_ELS_REQ_CX) ||
+	    (irsp->ulpCommand == CMD_IOCB_RCV_ELS64_CX)) {
+		Rctl = FC_ELS_REQ;
+		Type = FC_ELS_DATA;
+	} else {
+		w5p = (WORD5 *)&(saveq->iocb.un.ulpWord[5]);
+		Rctl = w5p->hcsw.Rctl;
+		Type = w5p->hcsw.Type;
+
+		/* Firmware Workaround */
+		if ((Rctl == 0) && (pring->ringno == LPFC_ELS_RING) &&
+			(irsp->ulpCommand == CMD_RCV_SEQUENCE64_CX ||
+			 irsp->ulpCommand == CMD_IOCB_RCV_SEQ64_CX)) {
+			Rctl = FC_ELS_REQ;
+			Type = FC_ELS_DATA;
+			w5p->hcsw.Rctl = Rctl;
+			w5p->hcsw.Type = Type;
+		}
+	}
 
 	/* unSolicited Responses */
 	if (pring->prt[0].profile) {
@@ -1069,12 +1079,9 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 	} else {
 		/* We must search, based on rctl / type
 		   for the right routine */
-		for (i = 0; i < pring->num_mask;
-		     i++) {
-			if ((pring->prt[i].rctl ==
-			     Rctl)
-			    && (pring->prt[i].
-				type == Type)) {
+		for (i = 0; i < pring->num_mask; i++) {
+			if ((pring->prt[i].rctl == Rctl)
+			    && (pring->prt[i].type == Type)) {
 				if (pring->prt[i].lpfc_sli_rcv_unsol_event)
 					(pring->prt[i].lpfc_sli_rcv_unsol_event)
 							(phba, pring, saveq);
@@ -1641,12 +1648,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 
 		writel(pring->rspidx, &phba->host_gp[pring->ringno].rspGetInx);
 
-		if (list_empty(&(pring->iocb_continueq))) {
-			list_add(&rspiocbp->list, &(pring->iocb_continueq));
-		} else {
-			list_add_tail(&rspiocbp->list,
-				      &(pring->iocb_continueq));
-		}
+		list_add_tail(&rspiocbp->list, &(pring->iocb_continueq));
 
 		pring->iocb_continueq_cnt++;
 		if (irsp->ulpLe) {
@@ -1711,17 +1713,17 @@ lpfc_sli_handle_slow_ring_event(struct l
 			iocb_cmd_type = irsp->ulpCommand & CMD_IOCB_MASK;
 			type = lpfc_sli_iocb_cmd_type(iocb_cmd_type);
 			if (type == LPFC_SOL_IOCB) {
-				spin_unlock_irqrestore(&phba->hbalock,
-						       iflag);
+				spin_unlock_irqrestore(&phba->hbalock, iflag);
 				rc = lpfc_sli_process_sol_iocb(phba, pring,
 							       saveq);
 				spin_lock_irqsave(&phba->hbalock, iflag);
 			} else if (type == LPFC_UNSOL_IOCB) {
-				spin_unlock_irqrestore(&phba->hbalock,
-						       iflag);
+				spin_unlock_irqrestore(&phba->hbalock, iflag);
 				rc = lpfc_sli_process_unsol_iocb(phba, pring,
 								 saveq);
 				spin_lock_irqsave(&phba->hbalock, iflag);
+				if (!rc)
+					free_saveq = 0;
 			} else if (type == LPFC_ABORT_IOCB) {
 				if ((irsp->ulpCommand != CMD_XRI_ABORTED_CX) &&
 				    ((cmdiocbp =
@@ -3238,6 +3240,7 @@ lpfc_sli_queue_setup(struct lpfc_hba *ph
 		INIT_LIST_HEAD(&pring->txq);
 		INIT_LIST_HEAD(&pring->txcmplq);
 		INIT_LIST_HEAD(&pring->iocb_continueq);
+		INIT_LIST_HEAD(&pring->iocb_continue_saveq);
 		INIT_LIST_HEAD(&pring->postbufq);
 	}
 	spin_unlock_irq(&phba->hbalock);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2008-01-11 00:51:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2008-01-11 01:25:42.000000000 -0500
@@ -33,6 +33,7 @@ typedef enum _lpfc_ctx_cmd {
 struct lpfc_iocbq {
 	/* lpfc_iocbqs are used in double linked lists */
 	struct list_head list;
+	struct list_head clist;
 	uint16_t iotag;         /* pre-assigned IO tag */
 	uint16_t rsvd1;
 
@@ -160,6 +161,7 @@ struct lpfc_sli_ring {
 	struct list_head iocb_continueq;
 	uint16_t iocb_continueq_cnt;	/* current length of queue */
 	uint16_t iocb_continueq_max;	/* max length */
+	struct list_head iocb_continue_saveq;
 
 	struct lpfc_sli_ring_mask prt[LPFC_MAX_RING_MASK];
 	uint32_t num_mask;	/* number of mask entries in prt array */


