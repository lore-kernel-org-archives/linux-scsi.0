From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] dead code and missing statics in lpfc
Date: Mon, 31 May 2004 12:04:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040531100454.GA14860@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:60586 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262063AbUEaKFB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2004 06:05:01 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: linux-scsi@vger.kernel.org


 - remove dead EXPORT_SYMBOLS
 - mark everything static that can be (thanks to Tridge's findstatic.pl)
 - kill all dead functions
(- small lpfc_evt_iocb_free fixes that sneaked into the context)


diff -uNr lpfcdriver-2.6-8.0.2/lpfc_crtn.h lpfcdriver-2.6-8.0.2.hch/lpfc_crtn.h
--- lpfcdriver-2.6-8.0.2/lpfc_crtn.h	2004-05-27 11:07:54.000000000 +0200
+++ lpfcdriver-2.6-8.0.2.hch/lpfc_crtn.h	2004-05-28 13:53:53.126165400 +0200
@@ -101,10 +101,6 @@
 
 int lpfc_check_sparm(lpfcHBA_t *, LPFC_NODELIST_t *, SERV_PARM *, uint32_t);
 int lpfc_geportname(NAME_TYPE *, NAME_TYPE *);
-uint32_t lpfc_add_bind(lpfcHBA_t * phba, uint8_t bind_type,
-		       void *bind_id, uint32_t scsi_id);
-uint32_t lpfc_del_bind(lpfcHBA_t * phba, uint8_t bind_type,
-		       void *bind_id, uint32_t scsi_id);
 
 int lpfc_initial_flogi(lpfcHBA_t *);
 int lpfc_issue_els_plogi(lpfcHBA_t *, LPFC_NODELIST_t *, uint8_t);
@@ -112,8 +108,6 @@
 int lpfc_issue_els_adisc(lpfcHBA_t *, LPFC_NODELIST_t *, uint8_t);
 int lpfc_issue_els_logo(lpfcHBA_t *, LPFC_NODELIST_t *, uint8_t);
 int lpfc_issue_els_scr(lpfcHBA_t *, uint32_t, uint8_t);
-LPFC_IOCBQ_t *lpfc_prep_els_iocb(lpfcHBA_t *, uint8_t expectRsp,
-				uint16_t, uint8_t, LPFC_NODELIST_t *, uint32_t);
 int lpfc_els_free_iocb(lpfcHBA_t *, LPFC_IOCBQ_t *);
 void lpfc_cmpl_els_flogi(lpfcHBA_t *, LPFC_IOCBQ_t *, LPFC_IOCBQ_t *);
 void lpfc_cmpl_els_plogi(lpfcHBA_t *, LPFC_IOCBQ_t *, LPFC_IOCBQ_t *);
@@ -138,7 +132,6 @@
 
 void lpfc_ct_unsol_event(lpfcHBA_t *, LPFC_SLI_RING_t *, LPFC_IOCBQ_t *);
 int lpfc_ns_cmd(lpfcHBA_t *, LPFC_NODELIST_t *, int);
-int lpfc_issue_ct_rsp(lpfcHBA_t *, uint32_t, DMABUF_t *, DMABUFEXT_t *);
 int lpfc_fdmi_cmd(lpfcHBA_t *, LPFC_NODELIST_t *, int);
 void lpfc_fdmi_tmo(unsigned long);
 
@@ -150,8 +143,6 @@
 void lpfc_hba_init(lpfcHBA_t *);
 int lpfc_post_buffer(lpfcHBA_t *, LPFC_SLI_RING_t *, int, int);
 void lpfc_cleanup(lpfcHBA_t *, uint32_t);
-int lpfc_online(lpfcHBA_t *);
-int lpfc_offline(lpfcHBA_t *);
 int lpfc_scsi_free(lpfcHBA_t *);
 int lpfc_parse_binding_entry(lpfcHBA_t *, uint8_t *, uint8_t *,
 			     int, int, int, unsigned int *, int, int *);
@@ -162,7 +153,6 @@
 int lpfc_hba_put_event(lpfcHBA_t *, uint32_t, uint32_t, uint32_t, uint32_t,
 		      uint32_t);
 void lpfc_get_hba_model_desc(lpfcHBA_t *, uint8_t *, uint8_t *);
-void lpfc_get_hba_sym_node_name(lpfcHBA_t *, uint8_t *);
 
 
 int lpfc_sli_queue_setup(lpfcHBA_t *);
@@ -200,7 +190,6 @@
 int lpfc_sli_issue_mbox(lpfcHBA_t *, LPFC_MBOXQ_t *, uint32_t);
 int lpfc_sli_issue_iocb(lpfcHBA_t *, LPFC_SLI_RING_t *, LPFC_IOCBQ_t *,
 			uint32_t);
-int lpfc_sli_brdreset(lpfcHBA_t *);
 void lpfc_sli_pcimem_bcopy(uint32_t *, uint32_t *, uint32_t);
 int lpfc_sli_ringpostbuf_put(lpfcHBA_t *, LPFC_SLI_RING_t *, DMABUF_t *);
 DMABUF_t *lpfc_sli_ringpostbuf_get(lpfcHBA_t *, LPFC_SLI_RING_t *, dma_addr_t);
@@ -220,17 +209,12 @@
 
 int lpfc_sli_issue_iocb_wait(lpfcHBA_t *, LPFC_SLI_RING_t *,
 			    LPFC_IOCBQ_t *, uint32_t, LPFC_IOCBQ_t *, uint32_t);
-int lpfc_sli_issue_mbox_wait(lpfcHBA_t *, LPFC_MBOXQ_t *, uint32_t);
-int lpfc_sleep(lpfcHBA_t *, void *, long tmo);
-void lpfc_wakeup(lpfcHBA_t *, void *);
 
 LPFC_SCSI_BUF_t *lpfc_get_scsi_buf(lpfcHBA_t *);
 void lpfc_free_scsi_buf(LPFC_SCSI_BUF_t *);
 void lpfc_map_fcp_cmnd_to_bpl(lpfcHBA_t *, LPFC_SCSI_BUF_t *);
 void lpfc_free_scsi_cmd(LPFC_SCSI_BUF_t *);
 uint32_t lpfc_os_timeout_transform(lpfcHBA_t *, uint32_t);
-int lpfc_scsi_lun_reset(LPFC_SCSI_BUF_t *, lpfcHBA_t *, uint32_t);
-int lpfc_scsi_tgt_reset(LPFC_SCSI_BUF_t *, lpfcHBA_t *, uint32_t);
 
 lpfcHBA_t *lpfc_get_phba_by_inst(int);
 
@@ -257,7 +241,6 @@
 
 void *lpfc_mbuf_alloc(lpfcHBA_t *, int, dma_addr_t *);
 void lpfc_mbuf_free(lpfcHBA_t *, void *, dma_addr_t);
-int lpfc_valid_lun(LPFCSCSITARGET_t *, uint64_t);
 
 void lpfc_sleep_ms(lpfcHBA_t *, int);
 
diff -uNr lpfcdriver-2.6-8.0.2/lpfc_ct.c lpfcdriver-2.6-8.0.2.hch/lpfc_ct.c
--- lpfcdriver-2.6-8.0.2/lpfc_ct.c	2004-05-27 11:07:54.000000000 +0200
+++ lpfcdriver-2.6-8.0.2.hch/lpfc_ct.c	2004-05-28 13:49:39.625703328 +0200
@@ -74,6 +74,7 @@
 						 LPFC_IOCBQ_t *),
 		uint32_t);
 static int lpfc_free_ct_rsp(lpfcHBA_t *, DMABUF_t *);
+static void lpfc_get_hba_sym_node_name(lpfcHBA_t *, uint8_t *);
 
 
 /*
@@ -680,65 +681,6 @@
 	return (0);
 }
 
-int
-lpfc_issue_ct_rsp(lpfcHBA_t * phba,
-		  uint32_t tag, DMABUF_t * bmp, DMABUFEXT_t * inp)
-{
-	LPFC_SLI_t *psli;
-	IOCB_t *icmd;
-	LPFC_IOCBQ_t *ctiocb;
-	LPFC_SLI_RING_t *pring;
-	uint32_t num_entry;
-	int rc = 0;
-
-	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
-	num_entry = (uint32_t) inp->flag;
-	inp->flag = 0;
-
-	/* Allocate buffer for  command iocb */
-	if ((ctiocb = mempool_alloc(phba->iocb_mem_pool, GFP_ATOMIC)) == 0) {
-		return (ENOMEM);
-	}
-	memset(ctiocb, 0, sizeof (LPFC_IOCBQ_t));
-	icmd = &ctiocb->iocb;
-
-	icmd->un.xseq64.bdl.ulpIoTag32 = 0;
-	icmd->un.xseq64.bdl.addrHigh = putPaddrHigh(bmp->phys);
-	icmd->un.xseq64.bdl.addrLow = putPaddrLow(bmp->phys);
-	icmd->un.xseq64.bdl.bdeFlags = BUFF_TYPE_BDL;
-	icmd->un.xseq64.bdl.bdeSize = (num_entry * sizeof (ULP_BDE64));
-
-	icmd->un.xseq64.w5.hcsw.Fctl = (LS | LA);
-	icmd->un.xseq64.w5.hcsw.Dfctl = 0;
-	icmd->un.xseq64.w5.hcsw.Rctl = FC_SOL_CTL;
-	icmd->un.xseq64.w5.hcsw.Type = FC_COMMON_TRANSPORT_ULP;
-
-	dma_sync_single(&phba->pcidev->dev, bmp->phys, 
-			LPFC_BPL_SIZE, DMA_TO_DEVICE);
-
-	icmd->ulpIoTag = lpfc_sli_next_iotag(phba, pring);
-
-	/* Fill in rest of iocb */
-	icmd->ulpCommand = CMD_XMIT_SEQUENCE64_CX;
-	icmd->ulpBdeCount = 1;
-	icmd->ulpLe = 1;
-	icmd->ulpClass = CLASS3;
-	icmd->ulpContext = (ushort) tag;
-	/* Xmit CT response on exchange <xid> */
-	lpfc_printf_log(phba->brd_no, &lpfc_msgBlk0118,
-			lpfc_mes0118, lpfc_msgBlk0118.msgPreambleStr,
-			icmd->ulpContext, icmd->ulpIoTag, phba->hba_state);
-
-	ctiocb->iocb_cmpl = 0;
-	ctiocb->iocb_flag |= LPFC_IO_LIBDFC;
-
-	rc = lpfc_sli_issue_iocb_wait(phba, pring, ctiocb, SLI_IOCB_USE_TXQ, 0,
-				     phba->fc_ratov * 2 + LPFC_DRVR_TIMEOUT);
-	mempool_free( ctiocb, phba->iocb_mem_pool);
-	return (rc);
-}				/* lpfc_issue_ct_rsp */
-
 static int
 lpfc_gen_req(lpfcHBA_t * phba,
 	     DMABUF_t * bmp,
@@ -2019,7 +1961,7 @@
 	}
 }
 
-void
+static void
 lpfc_get_hba_sym_node_name(lpfcHBA_t * phba, uint8_t * symbp)
 {
 	uint8_t buf[16];
Binary files lpfcdriver-2.6-8.0.2/lpfc_ct.o and lpfcdriver-2.6-8.0.2.hch/lpfc_ct.o differ
diff -uNr lpfcdriver-2.6-8.0.2/lpfc_els.c lpfcdriver-2.6-8.0.2.hch/lpfc_els.c
--- lpfcdriver-2.6-8.0.2/lpfc_els.c	2004-05-27 11:07:54.000000000 +0200
+++ lpfcdriver-2.6-8.0.2.hch/lpfc_els.c	2004-05-28 13:47:04.079349968 +0200
@@ -57,6 +57,8 @@
 static int lpfc_issue_els_flogi(lpfcHBA_t *, LPFC_NODELIST_t *, uint8_t);
 static void lpfc_more_plogi(lpfcHBA_t *);
 static void lpfc_more_adisc(lpfcHBA_t *);
+static LPFC_IOCBQ_t *lpfc_prep_els_iocb(lpfcHBA_t *, uint8_t, uint16_t,
+		uint8_t, LPFC_NODELIST_t *, uint32_t);
 
 static int lpfc_max_els_tries = 3;
 
@@ -1379,7 +1381,7 @@
 	return (0);
 }
 
-LPFC_IOCBQ_t *
+static LPFC_IOCBQ_t *
 lpfc_prep_els_iocb(lpfcHBA_t * phba,
 		   uint8_t expectRsp,
 		   uint16_t cmdSize,
Binary files lpfcdriver-2.6-8.0.2/lpfc_els.o and lpfcdriver-2.6-8.0.2.hch/lpfc_els.o differ
diff -uNr lpfcdriver-2.6-8.0.2/lpfc_fcp.c lpfcdriver-2.6-8.0.2.hch/lpfc_fcp.c
--- lpfcdriver-2.6-8.0.2/lpfc_fcp.c	2004-05-27 11:07:54.000000000 +0200
+++ lpfcdriver-2.6-8.0.2.hch/lpfc_fcp.c	2004-05-28 13:54:16.054679736 +0200
@@ -107,6 +107,7 @@
 static uint32_t lpfc_get_cfgparam(int, int);
 
 static int lpfc_do_dpc(void *);
+static int lpfc_valid_lun(LPFCSCSITARGET_t *, uint64_t);
 
 /* Binding Definitions: Max string size  */
 #define FC_MAX_DID_STRING       6
@@ -967,7 +968,8 @@
 	writel((ha_copy & ~(HA_LATT | HA_ERATT)), phba->HAregaddr);
 	return (ha_copy);
 }				/* lpfc_intr_prep */
-int
+
+static int
 lpfc_valid_lun(LPFCSCSITARGET_t * targetp, uint64_t lun)
 {
 	uint32_t rptLunLen;
@@ -2086,33 +2088,6 @@
 }
 
 
-int
-lpfc_sleep(lpfcHBA_t * phba, void *wait_q_head, long tmo)
-{
-	wait_queue_t wq_entry;
-	int rc = 1;
-	long left;
-
-	init_waitqueue_entry(&wq_entry, current);
-	/* start to sleep before we wait, to avoid races */
-	set_current_state(TASK_INTERRUPTIBLE);
-	add_wait_queue((wait_queue_head_t *) wait_q_head, &wq_entry);
-	if (tmo > 0) {
-		left = schedule_timeout(tmo * HZ);
-	} else {
-		schedule();
-		left = 0;
-	}
-	remove_wait_queue((wait_queue_head_t *) wait_q_head, &wq_entry);
-
-	if (signal_pending(current))
-		return (EINTR);
-	if (rc > 0)
-		return (0);
-	else
-		return (ETIMEDOUT);
-}
-
 /*
  * This is only called to handle FC discovery events. Since this a rare
  * occurance, we allocate an LPFC_DISC_EVT_t structure here instead of
@@ -2149,19 +2124,18 @@
 }
 
 
-static int
+static void
 lpfc_evt_iocb_free(lpfcHBA_t * phba, LPFC_IOCBQ_t * saveq)
 {
 	LPFC_IOCBQ_t     * rspiocbp;
 	LPFC_IOCBQ_t     * tmpiocbp;
 
 	/* Free up iocb buffer chain for cmd just processed */
-	list_for_each_entry_safe(rspiocbp, tmpiocbp, 
-		&saveq->list, list) {
+	list_for_each_entry_safe(rspiocbp, tmpiocbp, &saveq->list, list) {
 		list_del(&rspiocbp->list);
-		mempool_free( rspiocbp, phba->iocb_mem_pool);
+		mempool_free(rspiocbp, phba->iocb_mem_pool);
 	}
-	mempool_free( saveq, phba->iocb_mem_pool);
+	mempool_free(saveq, phba->iocb_mem_pool);
 }
 
 int
@@ -2264,55 +2238,3 @@
 module_init(lpfc_init);
 module_exit(lpfc_exit);
 MODULE_LICENSE("GPL");
-/*
- * Note: PPC64 architecture has function descriptors,
- * so insmod on 2.4 does not automatically export all symbols.
- */
-EXPORT_SYMBOL(lpfc_add_bind);
-EXPORT_SYMBOL(lpfc_block_requests);
-EXPORT_SYMBOL(lpfc_build_scsi_cmd);
-EXPORT_SYMBOL(lpfc_decode_firmware_rev);
-EXPORT_SYMBOL(lpfc_del_bind);
-EXPORT_SYMBOL(lpfc_drvr_name);
-EXPORT_SYMBOL(lpfc_els_free_iocb);
-EXPORT_SYMBOL(lpfc_find_lun);
-EXPORT_SYMBOL(lpfc_findnode_did);
-EXPORT_SYMBOL(lpfc_findnode_scsiid);
-EXPORT_SYMBOL(lpfc_findnode_wwnn);
-EXPORT_SYMBOL(lpfc_findnode_wwpn);
-EXPORT_SYMBOL(lpfc_free_scsi_buf);
-EXPORT_SYMBOL(lpfc_geportname);
-EXPORT_SYMBOL(lpfc_get_hba_model_desc);
-EXPORT_SYMBOL(lpfc_get_hba_sym_node_name);
-EXPORT_SYMBOL(lpfc_get_scsi_buf);
-EXPORT_SYMBOL(lpfc_init_link);
-EXPORT_SYMBOL(lpfc_issue_ct_rsp);
-EXPORT_SYMBOL(lpfc_issue_els_adisc);
-EXPORT_SYMBOL(lpfc_issue_els_logo);
-EXPORT_SYMBOL(lpfc_issue_els_plogi);
-EXPORT_SYMBOL(lpfc_mbuf_alloc);
-EXPORT_SYMBOL(lpfc_mbuf_free);
-EXPORT_SYMBOL(lpfc_nlp_bind);
-EXPORT_SYMBOL(lpfc_page_alloc);
-EXPORT_SYMBOL(lpfc_page_free);
-EXPORT_SYMBOL(lpfc_offline);
-EXPORT_SYMBOL(lpfc_online);
-EXPORT_SYMBOL(lpfc_prep_els_iocb);
-EXPORT_SYMBOL(lpfc_release_version);
-EXPORT_SYMBOL(lpfc_scsi_lun_reset);
-EXPORT_SYMBOL(lpfc_scsi_tgt_reset);
-EXPORT_SYMBOL(lpfc_sleep);
-EXPORT_SYMBOL(lpfc_sleep_ms);
-EXPORT_SYMBOL(lpfc_sli_brdreset);
-EXPORT_SYMBOL(lpfc_sli_issue_iocb_wait);
-EXPORT_SYMBOL(lpfc_sli_issue_mbox);
-EXPORT_SYMBOL(lpfc_sli_issue_mbox_wait);
-EXPORT_SYMBOL(lpfc_sli_next_iotag);
-EXPORT_SYMBOL(lpfc_sli_pcimem_bcopy);
-EXPORT_SYMBOL(lpfc_unblock_requests);
-EXPORT_SYMBOL(lpfc_get_phba_by_inst);
-EXPORT_SYMBOL(lpfc_num_hba);
-EXPORT_SYMBOL(lpfc_loadtime);
-EXPORT_SYMBOL(lpfc_hba_list);
-
-
Binary files lpfcdriver-2.6-8.0.2/lpfc_fcp.o and lpfcdriver-2.6-8.0.2.hch/lpfc_fcp.o differ
Binary files lpfcdriver-2.6-8.0.2/lpfc_hbadisc.o and lpfcdriver-2.6-8.0.2.hch/lpfc_hbadisc.o differ
diff -uNr lpfcdriver-2.6-8.0.2/lpfc_init.c lpfcdriver-2.6-8.0.2.hch/lpfc_init.c
--- lpfcdriver-2.6-8.0.2/lpfc_init.c	2004-05-27 11:07:55.000000000 +0200
+++ lpfcdriver-2.6-8.0.2.hch/lpfc_init.c	2004-05-28 13:45:44.284480632 +0200
@@ -47,6 +47,8 @@
 static void lpfc_establish_link_tmo(unsigned long ptr);
 static int lpfc_check_for_vpd = 1;
 static int lpfc_rdrev_wd30 = 0;
+static int lpfc_online(lpfcHBA_t *);
+static int lpfc_offline(lpfcHBA_t *);
 
 
 /************************************************************************/
@@ -1153,7 +1155,7 @@
 	spin_unlock_irqrestore(&(phba->drvrlock), iflag);
 }
 
-int
+static int
 lpfc_online(lpfcHBA_t * phba)
 {
 	uint32_t timeout;
@@ -1199,7 +1201,7 @@
 	return (0);
 }
 
-int
+static int
 lpfc_offline(lpfcHBA_t * phba)
 {
 	LPFC_SLI_RING_t *pring;
Binary files lpfcdriver-2.6-8.0.2/lpfc_init.o and lpfcdriver-2.6-8.0.2.hch/lpfc_init.o differ
Binary files lpfcdriver-2.6-8.0.2/lpfc_logmsg.o and lpfcdriver-2.6-8.0.2.hch/lpfc_logmsg.o differ
Binary files lpfcdriver-2.6-8.0.2/lpfc_mbox.o and lpfcdriver-2.6-8.0.2.hch/lpfc_mbox.o differ
Binary files lpfcdriver-2.6-8.0.2/lpfc_mem.o and lpfcdriver-2.6-8.0.2.hch/lpfc_mem.o differ
diff -uNr lpfcdriver-2.6-8.0.2/lpfc_nportdisc.c lpfcdriver-2.6-8.0.2.hch/lpfc_nportdisc.c
--- lpfcdriver-2.6-8.0.2/lpfc_nportdisc.c	2004-05-27 11:07:55.000000000 +0200
+++ lpfcdriver-2.6-8.0.2.hch/lpfc_nportdisc.c	2004-05-28 13:51:25.075672496 +0200
@@ -3021,264 +3021,6 @@
 	return (0);
 }
 
-uint32_t
-lpfc_add_bind(lpfcHBA_t * phba, uint8_t bind_type,	/* NN/PN/DID */
-	      void *bind_id,	/* pointer to the bind id value */
-	      uint32_t scsi_id)
-{
-	LPFC_NODELIST_t *ndlp;
-	LPFC_BINDLIST_t *blp;
-	LPFCSCSITARGET_t *targetp;
-	LPFCSCSILUN_t *lunp;
-	struct list_head *pos;
-	struct list_head *curr, *next;
-
-	/* Check if the SCSI ID is currently mapped */
-	ndlp = lpfc_findnode_scsiid(phba, scsi_id);
-	if (ndlp && (ndlp != &phba->fc_fcpnodev)) {
-		return ENOENT;
-	}
-	/* Check if the SCSI ID is currently in the bind list. */
-	list_for_each(pos, &phba->fc_nlpbind_list) {
-		blp = list_entry(pos, LPFC_BINDLIST_t, nlp_listp);
-	
-		if (blp->nlp_sid == scsi_id) {
-			return ENOENT;
-		}
-		switch (bind_type) {
-		case FCP_SEED_WWPN:
-			if ((blp->nlp_bind_type & FCP_SEED_WWPN) &&
-			    (lpfc_geportname(bind_id, &blp->nlp_portname) ==
-			     2)) {
-				return EBUSY;
-			}
-			break;
-		case FCP_SEED_WWNN:
-			if ((blp->nlp_bind_type & FCP_SEED_WWNN) &&
-			    (lpfc_geportname(bind_id, &blp->nlp_nodename) ==
-			     2)) {
-				return EBUSY;
-			}
-			break;
-		case FCP_SEED_DID:
-			if ((blp->nlp_bind_type & FCP_SEED_DID) &&
-			    (*((uint32_t *) bind_id) == blp->nlp_DID)) {
-				return EBUSY;
-			}
-			break;
-		}
-	}
-	if (phba->fcp_mapping != bind_type) {
-		return EINVAL;
-	}
-	switch (bind_type) {
-	case FCP_SEED_WWNN:
-		{
-			/* Check if the node name present in the mapped list */
-			ndlp =
-			    lpfc_findnode_wwnn(phba, NLP_SEARCH_MAPPED,
-					       bind_id);
-			if (ndlp) {
-				return EBUSY;
-			}
-			ndlp =
-			    lpfc_findnode_wwnn(phba, NLP_SEARCH_UNMAPPED,
-					       bind_id);
-			break;
-		}
-	case FCP_SEED_WWPN:
-		{
-			/* Check if the port name present in the mapped list */
-			ndlp =
-			    lpfc_findnode_wwpn(phba, NLP_SEARCH_MAPPED,
-					       bind_id);
-			if (ndlp)
-				return EBUSY;
-			ndlp =
-			    lpfc_findnode_wwpn(phba, NLP_SEARCH_UNMAPPED,
-					       bind_id);
-			break;
-		}
-	case FCP_SEED_DID:
-		{
-			/* Check if the DID present in the mapped list */
-			ndlp =
-			    lpfc_findnode_did(phba, NLP_SEARCH_MAPPED,
-					      *((uint32_t *) bind_id));
-			if (ndlp)
-				return EBUSY;
-			ndlp =
-			    lpfc_findnode_did(phba, NLP_SEARCH_UNMAPPED,
-					      *((uint32_t *) bind_id));
-			break;
-		}
-	}
-
-	/* Add to the bind list */
-	if ((blp = (LPFC_BINDLIST_t *) mempool_alloc(phba->bind_mem_pool, GFP_ATOMIC)) == 0) {
-		return EIO;
-	}
-	memset(blp, 0, sizeof (LPFC_BINDLIST_t));
-	blp->nlp_bind_type = bind_type;
-	blp->nlp_sid = (scsi_id & 0xff);
-
-	switch (bind_type) {
-	case FCP_SEED_WWNN:
-		memcpy(&blp->nlp_nodename, (uint8_t *) bind_id,
-		       sizeof (NAME_TYPE));
-		break;
-
-	case FCP_SEED_WWPN:
-		memcpy(&blp->nlp_portname, (uint8_t *) bind_id,
-		       sizeof (NAME_TYPE));
-		break;
-
-	case FCP_SEED_DID:
-		blp->nlp_DID = *((uint32_t *) bind_id);
-		break;
-
-	}
-
-	lpfc_nlp_bind(phba, blp);
-	/* 
-	   If the newly added node is in the unmapped list, assign a
-	   SCSI ID to the node.
-	 */
-
-	if (ndlp) {
-		if ((blp = lpfc_assign_scsid(phba, ndlp, 0))) {
-			lpfc_nlp_mapped(phba, ndlp, blp);
-			ndlp->nlp_failMask = 0;
-			targetp = ndlp->nlp_Target;
-			if (targetp) {
-				list_for_each_safe(curr, next,
-						   &targetp->lunlist) {
-					lunp = list_entry(curr, LPFCSCSILUN_t,
-							  list);
-					lunp->failMask = 0;
-				}
-				if (targetp->tmofunc.function) {
-					del_timer_sync(&targetp->tmofunc);
-					targetp->tmofunc.function = 0;
-					list_del((struct list_head *)
-						&targetp->tmofunc_data);
-				}
-			} else {
-				/* new target to driver, allocate space to
-				   target <sid> lun 0 */
-				if (blp->nlp_Target == 0) {
-					lpfc_find_lun(phba, blp->nlp_sid, 0, 1);
-					blp->nlp_Target =
-					    phba->device_queue_hash[blp->
-								    nlp_sid];
-				}
-			}
-			lpfc_set_failmask(phba, ndlp, LPFC_DEV_RPTLUN,
-					  LPFC_SET_BITMASK);
-			ndlp->nlp_state = NLP_STE_MAPPED_NODE;
-			lpfc_disc_issue_rptlun(phba, ndlp);
-		}
-	}
-	return (0);
-}
-
-uint32_t
-lpfc_del_bind(lpfcHBA_t * phba, uint8_t bind_type,	/* NN/PN/DID */
-	      void *bind_id,	/* pointer to the bind id value */
-	      uint32_t scsi_id)
-{
-	LPFC_BINDLIST_t *blp = 0;
-	uint32_t found = 0;
-	LPFC_NODELIST_t *ndlp = 0;
-	struct list_head *pos;
-
-	/* Search the mapped list for the bind_id */
-	if (!bind_id) {
-		ndlp = lpfc_findnode_scsiid(phba, scsi_id);
-		if ((ndlp == &phba->fc_fcpnodev) ||
-		    (ndlp && (!(ndlp->nlp_flag & NLP_MAPPED_LIST))))
-			ndlp = 0;
-	} else {
-
-		if (bind_type != phba->fcp_mapping)
-			return EINVAL;
-
-		switch (bind_type) {
-		case FCP_SEED_WWNN:
-			ndlp =
-			    lpfc_findnode_wwnn(phba, NLP_SEARCH_MAPPED,
-					       bind_id);
-			break;
-
-		case FCP_SEED_WWPN:
-			ndlp =
-			    lpfc_findnode_wwpn(phba, NLP_SEARCH_MAPPED,
-					       bind_id);
-			break;
-
-		case FCP_SEED_DID:
-			ndlp =
-			    lpfc_findnode_did(phba, NLP_SEARCH_MAPPED,
-					      *((uint32_t *) bind_id));
-			break;
-		}
-	}
-
-	/* If there is a mapped target for this bing unmap it */
-	if (ndlp) {
-		return EBUSY;
-	}
-
-	/* check binding list */
-	list_for_each(pos, &phba->fc_nlpbind_list) {
-		blp = list_entry(pos, LPFC_BINDLIST_t, nlp_listp);
-
-		if (!bind_id) {
-			/* Search binding based on SCSI ID */
-			if (blp->nlp_sid == scsi_id) {
-				found = 1;
-				break;
-			} else {
-				continue;
-			}
-		}
-
-		switch (bind_type) {
-		case FCP_SEED_WWPN:
-			if ((blp->nlp_bind_type & FCP_SEED_WWPN) &&
-			    (lpfc_geportname(bind_id, &blp->nlp_portname) ==
-			     2)) {
-				found = 1;
-			}
-			break;
-		case FCP_SEED_WWNN:
-			if ((blp->nlp_bind_type & FCP_SEED_WWNN) &&
-			    (lpfc_geportname(bind_id, &blp->nlp_nodename) ==
-			     2)) {
-				found = 1;
-			}
-			break;
-		case FCP_SEED_DID:
-			if ((blp->nlp_bind_type & FCP_SEED_DID) &&
-			    (*((uint32_t *) bind_id) == blp->nlp_DID)) {
-				found = 1;
-			}
-			break;
-		}
-		if (found)
-			break;
-	}
-
-	if (found) {
-		/* take it off the bind list */
-		phba->fc_bind_cnt--;
-		list_del(&blp->nlp_listp);
-		return 0;
-	}
-
-	return ENOENT;
-}
-
 static LPFC_BINDLIST_t *
 lpfc_assign_scsid(lpfcHBA_t * phba, LPFC_NODELIST_t * ndlp,
 		  int prev_flag)
diff -uNr lpfcdriver-2.6-8.0.2/lpfc_scsiport.c lpfcdriver-2.6-8.0.2.hch/lpfc_scsiport.c
--- lpfcdriver-2.6-8.0.2/lpfc_scsiport.c	2004-05-27 11:07:55.000000000 +0200
+++ lpfcdriver-2.6-8.0.2.hch/lpfc_scsiport.c	2004-05-28 14:45:03.229438760 +0200
@@ -537,7 +411,7 @@
 
 }
 
-int
+static int
 lpfc_scsi_lun_reset(LPFC_SCSI_BUF_t * lpfc_cmd, 
 		    lpfcHBA_t *phba, uint32_t flag)
 {
@@ -640,7 +514,7 @@
 
 }
 
-int
+static int
 lpfc_scsi_tgt_reset(LPFC_SCSI_BUF_t * lpfc_cmd,
 		    lpfcHBA_t * phba, uint32_t flag)
 {
diff -uNr lpfcdriver-2.6-8.0.2/lpfc_sli.c lpfcdriver-2.6-8.0.2.hch/lpfc_sli.c
--- lpfcdriver-2.6-8.0.2/lpfc_sli.c	2004-05-27 11:07:55.000000000 +0200
+++ lpfcdriver-2.6-8.0.2.hch/lpfc_sli.c	2004-05-28 13:56:00.790757432 +0200
@@ -61,9 +61,9 @@
 static DMABUF_t *lpfc_sli_ringpostbuf_search(lpfcHBA_t *, LPFC_SLI_RING_t *,
 	dma_addr_t, int);
 static void lpfc_sli_wake_iocb_wait(lpfcHBA_t *, LPFC_IOCBQ_t *, LPFC_IOCBQ_t *);
-static void lpfc_sli_wake_mbox_wait(lpfcHBA_t *, LPFC_MBOXQ_t *);
 static int lpfc_sli_abort_iocb_ring(lpfcHBA_t *, LPFC_SLI_RING_t *, uint32_t);
 static int lpfc_sli_resume_iocb(lpfcHBA_t *, LPFC_SLI_RING_t *);
+static int lpfc_sli_brdreset(lpfcHBA_t *);
 
 /*
  * Define macro to log: Mailbox command x%x cannot issue Data
@@ -2226,7 +2226,7 @@
 	return (portCmdGet);
 }
 
-int
+static int
 lpfc_sli_brdreset(lpfcHBA_t * phba)
 {
 	MAILBOX_t *swpmb;
@@ -3521,61 +3521,3 @@
 
 	return retval;
 }
-
-void
-lpfc_sli_wake_mbox_wait(lpfcHBA_t * phba, LPFC_MBOXQ_t * pmboxq)
-{
-	wait_queue_head_t *pdone_q;
-
-	/* 
-	 * If pdone_q is empty, the driver thread gave up waiting and
-	 * continued running.
-	 */
-	pdone_q = (wait_queue_head_t *) pmboxq->context1;
-	if (pdone_q)
-		wake_up_interruptible(pdone_q);
-	return;
-}
-
-int
-lpfc_sli_issue_mbox_wait(lpfcHBA_t * phba, LPFC_MBOXQ_t * pmboxq,
-			 uint32_t timeout)
-{
-	DECLARE_WAIT_QUEUE_HEAD(done_q);
-	DECLARE_WAITQUEUE(wq_entry, current);
-	uint32_t timeleft = 0;
-	int retval;
-
-	/* The caller must leave context1 empty. */
-	if (pmboxq->context1 != 0) {
-		return (MBX_NOT_FINISHED);
-	}
-
-	/* setup wake call as IOCB callback */
-	pmboxq->mbox_cmpl = lpfc_sli_wake_mbox_wait;
-	/* setup context field to pass wait_queue pointer to wake function  */
-	pmboxq->context1 = &done_q;
-
-	/* start to sleep before we wait, to avoid races */
-	set_current_state(TASK_INTERRUPTIBLE);
-	add_wait_queue(&done_q, &wq_entry);
-
-	/* now issue the command */
-	retval = lpfc_sli_issue_mbox(phba, pmboxq, MBX_NOWAIT);
-	if (retval == MBX_BUSY || retval == MBX_SUCCESS) {
-		timeleft = schedule_timeout(timeout * HZ);
-		pmboxq->context1 = 0;
-		/* if schedule_timeout returns 0, we timed out and were not
-		   woken up */
-		if (timeleft == 0) {
-			retval = MBX_TIMEOUT;
-		} else {
-			retval = MBX_SUCCESS;
-		}
-	}
-
-
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&done_q, &wq_entry);
-	return retval;
-}
Binary files lpfcdriver-2.6-8.0.2/lpfc_sli.o and lpfcdriver-2.6-8.0.2.hch/lpfc_sli.o differ
Binary files lpfcdriver-2.6-8.0.2/lpfc_sysfs.o and lpfcdriver-2.6-8.0.2.hch/lpfc_sysfs.o differ
