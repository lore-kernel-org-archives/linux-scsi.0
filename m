From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove dead event counters from lpfc
Date: Sun, 20 Jun 2004 17:25:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040620152559.GA16809@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:42429 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264571AbUFTP0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2004 11:26:05 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org


diff -ur lpfcdriver-2.6-8.0.4/lpfc.h lpfcdriver-2.6-8.0.4-hch/lpfc.h
--- lpfcdriver-2.6-8.0.4/lpfc.h	2004-06-15 00:07:01.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc.h	2004-06-20 17:17:14.148703680 +0200
@@ -122,15 +122,6 @@
 struct lpfc_lun;
 struct lpfc_scsi_buf;
 
-/* This should correspond with the HBA API event structure */
-struct lpfc_hba_event {
-	uint32_t fc_eventcode;
-	uint32_t fc_evdata1;
-	uint32_t fc_evdata2;
-	uint32_t fc_evdata3;
-	uint32_t fc_evdata4;
-};
-
 /*
  * lpfc stat counters
  */
@@ -251,16 +242,8 @@
 	struct timer_list fc_fdmitmo;	/* fdmi timer */
 
 
-	void *fc_evt_head;	/* waiting for event queue */
-	void *fc_evt_tail;	/* waiting for event queue */
-
-	uint16_t hba_event_put;	/* hbaevent event put word anchor */
-	uint16_t hba_event_get;	/* hbaevent event get word anchor */
-	uint32_t hba_event_missed;	/* hbaevent missed event word anchor */
 	uint32_t sid_cnt;	/* SCSI ID counter */
 
-	struct lpfc_hba_event hbaevt[MAX_HBAEVT];
-
 #define FC_CPQ_LUNMAP   0x1	/* SCSI passthru interface LUN 0 mapping */
 
 	/* These fields used to be binfo */
@@ -361,7 +344,6 @@
 	uint16_t fc_unmap_cnt;
 	uint16_t fc_map_cnt;
 	struct lpfc_nodelist fc_fcpnodev; /* nodelist entry for no device */
-	uint32_t nport_event_cnt;	/* timestamp for nlplist entry */
 
 	struct lpfc_target *device_queue_hash[MAX_FCP_TARGET];
 #define LPFC_RPI_HASH_SIZE     64
@@ -405,10 +387,6 @@
 	void *CAregaddr;	/* virtual address for chip attn reg */
 	void *HSregaddr;	/* virtual address for host status reg */
 	void *HCregaddr;	/* virtual address for host ctl reg */
-	wait_queue_head_t linkevtwq;
-	wait_queue_head_t rscnevtwq;
-	wait_queue_head_t ctevtwq;
-
 
 	uint8_t brd_no;		/* FC board number */
 	uint8_t fc_busflag;	/* bus access flags */
diff -ur lpfcdriver-2.6-8.0.4/lpfc_crtn.h lpfcdriver-2.6-8.0.4-hch/lpfc_crtn.h
--- lpfcdriver-2.6-8.0.4/lpfc_crtn.h	2004-06-15 00:07:01.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc_crtn.h	2004-06-20 17:15:36.287580832 +0200
@@ -163,9 +163,6 @@
 void lpfc_decode_firmware_rev(struct lpfc_hba *, char *, int);
 uint8_t *lpfc_get_lpfchba_info(struct lpfc_hba *, uint8_t *);
 int lpfc_fcp_abort(struct lpfc_hba *, int, int, int);
-int lpfc_put_event(struct lpfc_hba *, uint32_t, uint32_t, void *, void *);
-int lpfc_hba_put_event(struct lpfc_hba *, uint32_t, uint32_t, uint32_t,
-		       uint32_t, uint32_t);
 void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
 
 
diff -ur lpfcdriver-2.6-8.0.4/lpfc_ct.c lpfcdriver-2.6-8.0.4-hch/lpfc_ct.c
--- lpfcdriver-2.6-8.0.4/lpfc_ct.c	2004-06-15 00:07:01.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc_ct.c	2004-06-20 17:15:29.603596952 +0200
@@ -98,7 +98,6 @@
 	uint32_t count;
 	IOCB_t *icmd;
 	int i;
-	int status;
 	int go_exit = 0;
 	struct list_head head;
 
@@ -165,21 +164,6 @@
 		icmd->ulpBdeCount = 0;
 	}
 
-	/*
-	 * if not early-exiting and there is pmbuf,
-	 * then do  FC_REG_CT_EVENT for libdfc
-	 */
-	if (go_exit == 0  &&  pmbuf != 0) {
-		status = lpfc_put_event(phba, FC_REG_CT_EVENT, ctx,
-				       pmbuf,
-				       (void *) (unsigned long)count);
-
-		if ( status) {
-			/* Need to free IOCB buffer ? */
-			return;
-		}
-	}
-
 exit_unsol_event:
 	list_for_each_entry_safe(matp, next_matp, &pmbuf->list, list) {
 		lpfc_mbuf_free(phba, matp->virt, matp->phys);
diff -ur lpfcdriver-2.6-8.0.4/lpfc_els.c lpfcdriver-2.6-8.0.4-hch/lpfc_els.c
--- lpfcdriver-2.6-8.0.4/lpfc_els.c	2004-06-15 00:07:01.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc_els.c	2004-06-20 17:15:04.760373696 +0200
@@ -2595,10 +2595,6 @@
 {
 	struct lpfc_nodelist *ndlp;
 
-	lpfc_hba_put_event(phba, HBA_EVENT_RSCN, phba->fc_myDID,
-			  phba->fc_myDID, 0, 0);
-	lpfc_put_event(phba, FC_REG_RSCN_EVENT, phba->fc_myDID, 0, 0);
-
 	/* RSCN processed */
 	lpfc_printf_log(phba,
 			KERN_INFO,
diff -ur lpfcdriver-2.6-8.0.4/lpfc_fcp.c lpfcdriver-2.6-8.0.4-hch/lpfc_fcp.c
--- lpfcdriver-2.6-8.0.4/lpfc_fcp.c	2004-06-15 00:07:01.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc_fcp.c	2004-06-20 17:15:44.693302968 +0200
@@ -414,9 +413,6 @@
 
 	/* Initialize plxhba - LINUX specific */
 	phba->pcidev = pdev;
-	init_waitqueue_head(&phba->linkevtwq);
-	init_waitqueue_head(&phba->rscnevtwq);
-	init_waitqueue_head(&phba->ctevtwq);
 
 	if ((rc = lpfc_pcimap(phba))) {
 		goto error_2;
@@ -1771,134 +1735,6 @@
 	return (0);
 }
 
-static void
-lpfc_wakeup_event(struct lpfc_hba * phba, fcEVTHDR_t * ep)
-{
-	ep->e_mode &= ~E_SLEEPING_MODE;
-	switch (ep->e_mask) {
-	case FC_REG_LINK_EVENT:
-		wake_up_interruptible(&phba->linkevtwq);
-		break;
-	case FC_REG_RSCN_EVENT:
-		wake_up_interruptible(&phba->rscnevtwq);
-		break;
-	case FC_REG_CT_EVENT:
-		wake_up_interruptible(&phba->ctevtwq);
-		break;
-	}
-	return;
-}
-
-int
-lpfc_put_event(struct lpfc_hba * phba,
-	      uint32_t evcode, uint32_t evdata0, void *evdata1, void *evdata2)
-{
-	fcEVT_t *ep;
-	fcEVT_t *oep;
-	fcEVTHDR_t *ehp = 0;
-	int found;
-	DMABUF_t *mp;
-	void *fstype;
-	struct lpfc_sli_ct_request *ctp;
-
-	ehp = (fcEVTHDR_t *) phba->fc_evt_head;
-	fstype = 0;
-	switch (evcode) {
-	case FC_REG_CT_EVENT:
-		mp = (DMABUF_t *) evdata1;
-		ctp = (struct lpfc_sli_ct_request *) mp->virt;
-		fstype = (void *)(ulong) (ctp->FsType);
-		break;
-	}
-
-	while (ehp) {
-		if ((ehp->e_mask == evcode) && (ehp->e_type == fstype))
-			break;
-		
-		ehp = (fcEVTHDR_t *) ehp->e_next_header;
-	}
-
-	if (!ehp) {
-		return (0);
-	}
-
-	ep = ehp->e_head;
-	oep = 0;
-	found = 0;
-
-	while (ep && !(found)) {
-		if (ep->evt_sleep) {
-			switch (evcode) {
-			case FC_REG_CT_EVENT:
-				if ((ep->evt_type ==
-				     (void *)(ulong) FC_FSTYPE_ALL)
-				    || (ep->evt_type == fstype)) {
-					found++;
-					ep->evt_data0 = evdata0; /* tag */
-					ep->evt_data1 = evdata1; /* buffer
-								    ptr */
-					ep->evt_data2 = evdata2; /* count */
-					ep->evt_sleep = 0;
-					if (ehp->e_mode & E_SLEEPING_MODE) {
-						ehp->e_flag |=
-						    E_GET_EVENT_ACTIVE;
-						lpfc_wakeup_event(phba, ehp);
-					}
-					/* For FC_REG_CT_EVENT just give it to
-					   first one found */
-				}
-				break;
-			default:
-				found++;
-				ep->evt_data0 = evdata0;
-				ep->evt_data1 = evdata1;
-				ep->evt_data2 = evdata2;
-				ep->evt_sleep = 0;
-				if ((ehp->e_mode & E_SLEEPING_MODE)
-				    && !(ehp->e_flag & E_GET_EVENT_ACTIVE)) {
-					ehp->e_flag |= E_GET_EVENT_ACTIVE;
-					lpfc_wakeup_event(phba, ehp);
-				}
-				/* For all other events, give it to every one
-				   waiting */
-				break;
-			}
-		}
-		oep = ep;
-		
-		ep = ep->evt_next;
-	}
-	return (found);
-}
-
-int
-lpfc_hba_put_event(struct lpfc_hba * phba, uint32_t evcode, uint32_t evdata1,
-		  uint32_t evdata2, uint32_t evdata3, uint32_t evdata4)
-{
-	struct lpfc_hba_event *rec;
-
-	rec = &phba->hbaevt[phba->hba_event_put];
-	rec->fc_eventcode = evcode;
-
-	rec->fc_evdata1 = evdata1;
-	rec->fc_evdata2 = evdata2;
-	rec->fc_evdata3 = evdata3;
-	rec->fc_evdata4 = evdata4;
-	phba->hba_event_put++;
-	if (phba->hba_event_put >= MAX_HBAEVT) {
-		phba->hba_event_put = 0;
-	}
-	if (phba->hba_event_put == phba->hba_event_get) {
-		phba->hba_event_missed++;
-		phba->hba_event_get++;
-		if (phba->hba_event_get >= MAX_HBAEVT) {
-			phba->hba_event_get = 0;
-		}
-	}
-
-	return (0);
-}
-
 static uint32_t
 lpfc_get_cfgtkval(const char *string, const char *tk)
 {
diff -ur lpfcdriver-2.6-8.0.4/lpfc_hbadisc.c lpfcdriver-2.6-8.0.4-hch/lpfc_hbadisc.c
--- lpfcdriver-2.6-8.0.4/lpfc_hbadisc.c	2004-06-15 00:07:01.000000000 +0200
+++ lpfcdriver-2.6-8.0.4-hch/lpfc_hbadisc.c	2004-06-20 17:16:58.376101480 +0200
@@ -136,11 +136,6 @@
 	phba->hba_state = LPFC_LINK_DOWN;
 	phba->fc_flag |= FC_LNK_DOWN;
 
-	lpfc_put_event(phba, FC_REG_LINK_EVENT, 0, 0, 0);
-	phba->nport_event_cnt++;
-
-	lpfc_hba_put_event(phba, HBA_EVENT_LINK_DOWN, phba->fc_myDID, 0, 0, 0);
-
 	/* Clean up any firmware default rpi's */
 	if ((mb = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC))) {
 		lpfc_unreg_did(phba, 0xffffffff, mb);
@@ -294,12 +289,6 @@
 			   FC_LD_TIMEOUT);
 	phba->fc_ns_retry = 0;
 
-	lpfc_put_event(phba, FC_REG_LINK_EVENT, 0, 0, 0);
-	phba->nport_event_cnt++;
-
-	lpfc_hba_put_event(phba, HBA_EVENT_LINK_UP, phba->fc_myDID,
-			  phba->fc_topology, 0, phba->fc_linkspeed);
-
 	if (phba->fc_linkdown.function) {
 		del_timer_sync(&phba->fc_linkdown);
 		phba->fc_linkdown.function = 0;
@@ -991,7 +980,6 @@
 			nlp->nlp_flag &= ~NLP_MAPPED_LIST;
 			phba->fc_map_cnt--;
 			list_del(&nlp->nlp_listp);
-			phba->nport_event_cnt++;
 
 			/* Must call before binding is removed */
 			lpfc_set_failmask(phba, nlp, LPFC_DEV_DISCONNECTED,
@@ -1017,7 +1005,6 @@
 			    ~(NLP_UNMAPPED_LIST | NLP_TGT_NO_SCSIID);
 			phba->fc_unmap_cnt--;
 			list_del(&nlp->nlp_listp);
-			phba->nport_event_cnt++;
 
 		} else if (nlp->nlp_flag & NLP_PLOGI_LIST) {
 			return (0);	/* Already on plogi list */
@@ -1062,7 +1049,6 @@
 			nlp->nlp_flag &= ~NLP_MAPPED_LIST;
 			phba->fc_map_cnt--;
 			list_del(&nlp->nlp_listp);
-			phba->nport_event_cnt++;
 
 			/* Must call before binding is removed */
 			lpfc_set_failmask(phba, nlp, LPFC_DEV_DISAPPEARED,
@@ -1094,9 +1080,6 @@
 			    ~(NLP_UNMAPPED_LIST | NLP_TGT_NO_SCSIID);
 			phba->fc_unmap_cnt--;
 			list_del(&nlp->nlp_listp);
-			phba->nport_event_cnt++;
-
-
 		} else if (nlp->nlp_flag & NLP_PLOGI_LIST) {
 			nlp->nlp_flag &= ~NLP_PLOGI_LIST;
 			phba->fc_plogi_cnt--;
@@ -1177,7 +1160,6 @@
 
 	/* Put it at the end of the unmapped list */
 	list_add_tail(&nlp->nlp_listp, &phba->fc_nlpunmap_list);
-	phba->nport_event_cnt++;
 	phba->fc_unmap_cnt++;
 	nlp->nlp_type |= NLP_FC_NODE;
 	nlp->nlp_flag |= NLP_UNMAPPED_LIST;
@@ -1229,7 +1211,6 @@
 
 	/* Put it at the end of the mapped list */
 	list_add_tail(&nlp->nlp_listp, &phba->fc_nlpmap_list);
-	phba->nport_event_cnt++;
 	phba->fc_map_cnt++;
 	nlp->nlp_flag |= NLP_MAPPED_LIST;
 	nlp->nlp_type |= NLP_FCP_TARGET;
@@ -1749,7 +1730,6 @@
 					      NLP_TGT_NO_SCSIID);
 					phba->fc_unmap_cnt--;
 					list_del(&ndlp->nlp_listp);
-					phba->nport_event_cnt++;
 				}
 
 				return (ndlp);
@@ -1777,7 +1757,6 @@
 					ndlp->nlp_flag &= ~NLP_MAPPED_LIST;
 					phba->fc_map_cnt--;
 					list_del(&ndlp->nlp_listp);
-					phba->nport_event_cnt++;
 
 					/* Must call before binding is
 					   removed */
