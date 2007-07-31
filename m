From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/8] lpfc 8.2.2 : Miscellaneous Bug Fixes
Date: Tue, 31 Jul 2007 21:27:59 +0000 (UTC)
Message-ID: <1186067431.14374.24.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50154 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762075AbXGaV07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 17:26:59 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l6VLQnio028958
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 14:26:58 -0700 (PDT)
Date: Thu, 02 Aug 2007 11:10:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous Bug Fixes:
- Fix vport ndlp ref counting errors
- Fix use after free of ndlp structure
- Use the correct flag to check for LOADING setting.
- Fix driver unload bugs (related to shost references) after link down or rscn
- Fix up HBQ initialization
- Fix port_list locking around driver unload.
- Fix references to hostdata as a phba
- Fix GFFID type offset to work correctly with big endian structure.
- Only call pci_disable_msi if the pci_enable_msi succeeded
- Fix vport_delete wait/fail if in discovery
- Put a reference on the nameservers ndlp when performing CT traffic.
- Remove unbalanced hba unlock.
- Fix up HBQ processing
- Fix lpfc debugfs discovery trace output for ELS rsp cmpl
- Send ADISC when rpi is 0
- Stop FDISC retrying forever
- Unable to retrieve correct config parameter for vport
- Fix sli_validate_fcp_iocb, sli_sum_iocb, sli_abort_iocb to be vport-aware.
- Fix index-out-of-range error in iocb. Spotted by Coverity.


Signed-off-by: James Smart <James.Smart@emulex.com>



diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-08-02 07:12:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-08-02 07:47:05.000000000 -0400
@@ -1027,8 +1027,8 @@ static CLASS_DEVICE_ATTR(lpfc_soft_wwpn,
 static ssize_t
 lpfc_soft_wwnn_show(struct class_device *cdev, char *buf)
 {
-	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
 			(unsigned long long)phba->cfg_soft_wwnn);
 }
@@ -1037,8 +1037,8 @@ lpfc_soft_wwnn_show(struct class_device 
 static ssize_t
 lpfc_soft_wwnn_store(struct class_device *cdev, const char *buf, size_t count)
 {
-	struct Scsi_Host *host = class_to_shost(cdev);
-	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	unsigned int i, j, cnt=count;
 	u8 wwnn[8];
 
@@ -1153,24 +1153,15 @@ lpfc_nodev_tmo_init(struct lpfc_vport *v
 static void
 lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
 {
-	struct lpfc_vport **vports;
 	struct Scsi_Host  *shost;
 	struct lpfc_nodelist  *ndlp;
-	int i;
 
-	vports = lpfc_create_vport_work_array(vport->phba);
-	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
-			shost = lpfc_shost_from_vport(vports[i]);
-			spin_lock_irq(shost->host_lock);
-			list_for_each_entry(ndlp, &vports[i]->fc_nodes,
-					    nlp_listp)
-			if (ndlp->rport)
-				ndlp->rport->dev_loss_tmo =
-						vport->cfg_devloss_tmo;
-			spin_unlock_irq(shost->host_lock);
-		}
-	lpfc_destroy_vport_work_array(vports);
+	shost = lpfc_shost_from_vport(vport);
+	spin_lock_irq(shost->host_lock);
+	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp)
+		if (ndlp->rport)
+			ndlp->rport->dev_loss_tmo = vport->cfg_devloss_tmo;
+	spin_unlock_irq(shost->host_lock);
 }
 
 static int
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-08-02 06:48:35.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-08-02 09:05:59.000000000 -0400
@@ -102,7 +102,7 @@ int lpfc_issue_els_scr(struct lpfc_vport
 int lpfc_els_free_iocb(struct lpfc_hba *, struct lpfc_iocbq *);
 int lpfc_ct_free_iocb(struct lpfc_hba *, struct lpfc_iocbq *);
 int lpfc_els_rsp_acc(struct lpfc_vport *, uint32_t, struct lpfc_iocbq *,
-		     struct lpfc_nodelist *, LPFC_MBOXQ_t *, uint8_t);
+		     struct lpfc_nodelist *, LPFC_MBOXQ_t *);
 int lpfc_els_rsp_reject(struct lpfc_vport *, uint32_t, struct lpfc_iocbq *,
 			struct lpfc_nodelist *, LPFC_MBOXQ_t *);
 int lpfc_els_rsp_adisc_acc(struct lpfc_vport *, struct lpfc_iocbq *,
@@ -163,9 +163,11 @@ LPFC_MBOXQ_t *lpfc_mbox_get(struct lpfc_
 void lpfc_mbox_cmpl_put(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_mbox_tmo_val(struct lpfc_hba *, int);
 
-void lpfc_config_hbq(struct lpfc_hba *, struct lpfc_hbq_init *, uint32_t ,
-		     LPFC_MBOXQ_t *);
+void lpfc_config_hbq(struct lpfc_hba *, uint32_t, struct lpfc_hbq_init *,
+	uint32_t , LPFC_MBOXQ_t *);
 struct lpfc_hbq_entry * lpfc_sli_next_hbq_slot(struct lpfc_hba *, uint32_t);
+struct hbq_dmabuf *lpfc_els_hbq_alloc(struct lpfc_hba *);
+void lpfc_els_hbq_free(struct lpfc_hba *, struct hbq_dmabuf *);
 
 int lpfc_mem_alloc(struct lpfc_hba *);
 void lpfc_mem_free(struct lpfc_hba *);
@@ -202,6 +204,7 @@ int lpfc_sli_ringpostbuf_put(struct lpfc
 struct lpfc_dmabuf *lpfc_sli_ringpostbuf_get(struct lpfc_hba *,
 					     struct lpfc_sli_ring *,
 					     dma_addr_t);
+int lpfc_sli_hbq_count(void);
 int lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hba *, uint32_t);
 int lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *, uint32_t);
 void lpfc_sli_hbqbuf_free_all(struct lpfc_hba *);
@@ -209,10 +212,9 @@ struct hbq_dmabuf *lpfc_sli_hbqbuf_find(
 int lpfc_sli_hbq_size(void);
 int lpfc_sli_issue_abort_iotag(struct lpfc_hba *, struct lpfc_sli_ring *,
 			       struct lpfc_iocbq *);
-int lpfc_sli_sum_iocb(struct lpfc_hba *, struct lpfc_sli_ring *, uint16_t,
-		      uint64_t, lpfc_ctx_cmd);
-int lpfc_sli_abort_iocb(struct lpfc_hba *, struct lpfc_sli_ring *, uint16_t,
-			uint64_t, uint32_t, lpfc_ctx_cmd);
+int lpfc_sli_sum_iocb(struct lpfc_vport *, uint16_t, uint64_t, lpfc_ctx_cmd);
+int lpfc_sli_abort_iocb(struct lpfc_vport *, struct lpfc_sli_ring *, uint16_t,
+			uint64_t, lpfc_ctx_cmd);
 
 void lpfc_mbox_timeout(unsigned long);
 void lpfc_mbox_timeout_handler(struct lpfc_hba *);
@@ -236,8 +238,6 @@ void lpfc_sli_abort_fcp_cmpl(struct lpfc
 			     struct lpfc_iocbq * cmdiocb,
 			     struct lpfc_iocbq * rspiocb);
 
-void *lpfc_hbq_alloc(struct lpfc_hba *, int, dma_addr_t *);
-void lpfc_hbq_free(struct lpfc_hba *, void *, dma_addr_t);
 void lpfc_sli_free_hbq(struct lpfc_hba *, struct hbq_dmabuf *);
 
 void *lpfc_mbuf_alloc(struct lpfc_hba *, int, dma_addr_t *);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-08-02 06:51:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-08-02 07:54:07.000000000 -0400
@@ -257,6 +257,10 @@ lpfc_ct_free_iocb(struct lpfc_hba *phba,
 {
 	struct lpfc_dmabuf *buf_ptr;
 
+	if (ctiocb->context_un.ndlp) {
+		lpfc_nlp_put(ctiocb->context_un.ndlp);
+		ctiocb->context_un.ndlp = NULL;
+	}
 	if (ctiocb->context1) {
 		buf_ptr = (struct lpfc_dmabuf *) ctiocb->context1;
 		lpfc_mbuf_free(phba, buf_ptr->virt, buf_ptr->phys);
@@ -314,6 +318,7 @@ lpfc_gen_req(struct lpfc_vport *vport, s
 	/* Save for completion so we can release these resources */
 	geniocb->context1 = (uint8_t *) inp;
 	geniocb->context2 = (uint8_t *) outp;
+	geniocb->context_un.ndlp = ndlp;
 
 	/* Fill in payload, bp points to frame payload */
 	icmd->ulpCommand = CMD_GEN_REQUEST64_CR;
@@ -548,8 +553,12 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 	struct lpfc_dmabuf *bmp;
 	struct lpfc_dmabuf *outp;
 	struct lpfc_sli_ct_request *CTrsp;
+	struct lpfc_nodelist *ndlp;
 	int rc;
 
+	/* First save ndlp, before we overwrite it */
+	ndlp = cmdiocb->context_un.ndlp;
+
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
@@ -674,6 +683,7 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 		lpfc_disc_start(vport);
 	}
 out:
+	cmdiocb->context_un.ndlp = ndlp; /* Now restore ndlp for free */
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	return;
 }
@@ -776,10 +786,14 @@ lpfc_cmpl_ct_cmd_rft_id(struct lpfc_hba 
 	struct lpfc_dmabuf *outp;
 	IOCB_t *irsp;
 	struct lpfc_sli_ct_request *CTrsp;
+	struct lpfc_nodelist *ndlp;
 	int cmdcode, rc;
 	uint8_t retry;
 	uint32_t latt;
 
+	/* First save ndlp, before we overwrite it */
+	ndlp = cmdiocb->context_un.ndlp;
+
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
 
@@ -828,6 +842,7 @@ lpfc_cmpl_ct_cmd_rft_id(struct lpfc_hba 
 	}
 
 out:
+	cmdiocb->context_un.ndlp = ndlp; /* Now restore ndlp for free */
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	return;
 }
@@ -1066,6 +1081,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 		cmpl = lpfc_cmpl_ct_cmd_rff_id;
 		break;
 	}
+	lpfc_nlp_get(ndlp);
 
 	if (!lpfc_ct_cmd(vport, mp, bmp, ndlp, cmpl, rsp_size, retry)) {
 		/* On success, The cmpl function will free the buffers */
@@ -1076,6 +1092,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, in
 	}
 
 	rc=6;
+	lpfc_nlp_put(ndlp);
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
 ns_cmd_free_bmp:
 	kfree(bmp);
@@ -1501,10 +1518,12 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, 
 	bpl->tus.w = le32_to_cpu(bpl->tus.w);
 
 	cmpl = lpfc_cmpl_ct_cmd_fdmi;
+	lpfc_nlp_get(ndlp);
 
 	if (!lpfc_ct_cmd(vport, mp, bmp, ndlp, cmpl, FC_MAX_NS_RSP, 0))
 		return 0;
 
+	lpfc_nlp_put(ndlp);
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
 fdmi_cmd_free_bmp:
 	kfree(bmp);
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2007-08-02 07:08:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2007-08-02 07:55:03.000000000 -0400
@@ -71,7 +71,7 @@
  * lpfc_debugfs_mask_disc_trc=Y  Where Y is an event mask as defined in
  *                               lpfc_debugfs.h .
  */
-static int lpfc_debugfs_enable = 0;
+static int lpfc_debugfs_enable = 1;
 module_param(lpfc_debugfs_enable, int, 0);
 MODULE_PARM_DESC(lpfc_debugfs_enable, "Enable debugfs services");
 
@@ -113,7 +113,6 @@ struct lpfc_debug {
 };
 
 extern struct lpfc_hbq_init *lpfc_hbq_defs[];
-extern int lpfc_sli_hbq_count(void);
 
 atomic_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
 unsigned long lpfc_debugfs_start_time = 0L;
@@ -233,8 +232,9 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 
 	len +=  snprintf(buf+len, size-len, "HBQ %d Info\n", i);
 
+	hbqs =  &phba->hbqs[i];
 	posted = 0;
-	list_for_each_entry(d_buf, &phba->hbq_buffer_list, list)
+	list_for_each_entry(d_buf, &hbqs->hbq_buffer_list, list)
 		posted++;
 
 	hip =  lpfc_hbq_defs[i];
@@ -243,7 +243,6 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 		hip->hbq_index, hip->profile, hip->rn,
 		hip->buffer_count, hip->init_count, hip->add_count, posted);
 
-	hbqs =  &phba->hbqs[i];
 	raw_index = phba->hbq_get[i];
 	getidx = le32_to_cpu(raw_index);
 	len +=  snprintf(buf+len, size-len,
@@ -251,7 +250,7 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 		hbqs->entry_count, hbqs->hbqPutIdx, hbqs->next_hbqPutIdx,
 		hbqs->local_hbqGetIdx, getidx);
 
-	hbqe = (struct lpfc_hbq_entry *) phba->hbqslimp.virt;
+	hbqe = (struct lpfc_hbq_entry *) phba->hbqs[i].hbq_virt;
 	for (j=0; j<hbqs->entry_count; j++) {
 		len +=  snprintf(buf+len, size-len,
 			"%03d: %08x %04x %05x ", j,
@@ -277,7 +276,7 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 		}
 
 		/* Get the Buffer info for the posted buffer */
-		list_for_each_entry(d_buf, &phba->hbq_buffer_list, list) {
+		list_for_each_entry(d_buf, &hbqs->hbq_buffer_list, list) {
 			hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 			phys = ((uint64_t)hbq_buf->dbuf.phys & 0xffffffff);
 			if (phys == hbqe->bde.addrLow) {
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-08-02 07:01:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-08-02 09:05:42.000000000 -0400
@@ -196,9 +196,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 		bpl->tus.w = le32_to_cpu(bpl->tus.w);
 	}
 
-	/* Save for completion so we can release these resources */
-	if (elscmd != ELS_CMD_LS_RJT)
-		elsiocb->context1 = lpfc_nlp_get(ndlp);
+	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	elsiocb->context2 = pcmd;
 	elsiocb->context3 = pbuflist;
 	elsiocb->retry = retry;
@@ -1809,8 +1807,10 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 						 "retrying...\n");
 				lpfc_mbx_unreg_vpi(vport);
 				retry = 1;
-				/* Always retry for this case */
-				cmdiocb->retry = 0;
+				/* FDISC retry policy */
+				maxretry = 48;
+				if (cmdiocb->retry >= 32)
+					delay = 1000;
 			}
 			break;
 
@@ -1886,8 +1886,10 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 				delay = 1000;
 				maxretry = 48;
 			} else if (cmd == ELS_CMD_FDISC) {
-				/* Always retry for this case */
-				cmdiocb->retry = 0;
+				/* FDISC retry policy */
+				maxretry = 48;
+				if (cmdiocb->retry >= 32)
+					delay = 1000;
 			}
 			retry = 1;
 			break;
@@ -2121,9 +2123,9 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
-		"ACC cmpl:        status:x%x/x%x did:x%x",
+		"ELS rsp cmpl:    status:x%x/x%x did:x%x",
 		irsp->ulpStatus, irsp->un.ulpWord[4],
-		irsp->un.rcvels.remoteID);
+		cmdiocb->iocb.un.elsreq64.remoteID);
 	/* ELS response tag <ulpIoTag> completes */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0110 ELS response tag x%x completes "
@@ -2184,7 +2186,7 @@ out:
 int
 lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 		 struct lpfc_iocbq *oldiocb, struct lpfc_nodelist *ndlp,
-		 LPFC_MBOXQ_t *mbox, uint8_t newnode)
+		 LPFC_MBOXQ_t *mbox)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
@@ -2270,11 +2272,6 @@ lpfc_els_rsp_acc(struct lpfc_vport *vpor
 	default:
 		return 1;
 	}
-
-	if (newnode) {
-		lpfc_nlp_put(ndlp);
-		elsiocb->context1 = NULL;
-	}
 	/* Xmit ELS ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0128 Xmit ELS ACC response tag x%x, XRI: x%x, "
@@ -2333,10 +2330,8 @@ lpfc_els_rsp_reject(struct lpfc_vport *v
 	pcmd += sizeof(uint32_t);
 	*((uint32_t *) (pcmd)) = rejectError;
 
-	if (mbox) {
+	if (mbox)
 		elsiocb->context_un.mbox = mbox;
-		elsiocb->context1 = lpfc_nlp_get(ndlp);
-	}
 
 	/* Xmit ELS RJT <err> response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
@@ -2353,6 +2348,15 @@ lpfc_els_rsp_reject(struct lpfc_vport *v
 	phba->fc_stat.elsXmitLSRJT++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	rc = lpfc_sli_issue_iocb(phba, pring, elsiocb, 0);
+
+	/* If the node is in the UNUSED state, and we are sending
+	 * a reject, we are done with it.  Release driver reference
+	 * count here.  The outstanding els will release its reference on
+	 * completion and the node can be freed then.
+	 */
+	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
+		lpfc_nlp_put(ndlp);
+
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
@@ -2747,7 +2751,7 @@ lpfc_rscn_recovery_check(struct lpfc_vpo
 
 static int
 lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
-		  struct lpfc_nodelist *ndlp, uint8_t newnode)
+		  struct lpfc_nodelist *ndlp)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
@@ -2781,8 +2785,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 			"RCV RSCN ignore: did:x%x/ste:x%x flg:x%x",
 			ndlp->nlp_DID, vport->port_state, ndlp->nlp_flag);
 
-		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL,
-				 newnode);
+		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 		return 0;
 	}
 
@@ -2814,7 +2817,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 				ndlp->nlp_flag);
 
 			lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb,
-				ndlp, NULL, newnode);
+				ndlp, NULL);
 			return 0;
 		}
 	}
@@ -2870,8 +2873,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 					 vport->port_state);
 		}
 		/* Send back ACC */
-		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL,
-								newnode);
+		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 
 		/* send RECOVERY event for ALL nodes that match RSCN payload */
 		lpfc_rscn_recovery_check(vport);
@@ -2896,7 +2898,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 	lpfc_set_disctmo(vport);
 
 	/* Send back ACC */
-	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL, newnode);
+	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 
 	/* send RECOVERY event for ALL nodes that match RSCN payload */
 	lpfc_rscn_recovery_check(vport);
@@ -2965,7 +2967,7 @@ lpfc_els_handle_rscn(struct lpfc_vport *
 
 static int
 lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
-		   struct lpfc_nodelist *ndlp, uint8_t newnode)
+		   struct lpfc_nodelist *ndlp)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
@@ -3048,7 +3050,7 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vp
 	}
 
 	/* Send back ACC */
-	lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL, newnode);
+	lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL);
 
 	return 0;
 }
@@ -3409,7 +3411,7 @@ lpfc_els_rcv_farpr(struct lpfc_vport *vp
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0600 FARP-RSP received from DID x%x\n", did);
 	/* ACCEPT the Farp resp request */
-	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 
 	return 0;
 }
@@ -3791,7 +3793,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 			did, vport->port_state, ndlp->nlp_flag);
 
 		phba->fc_stat.elsRcvFLOGI++;
-		lpfc_els_rcv_flogi(vport, elsiocb, ndlp, newnode);
+		lpfc_els_rcv_flogi(vport, elsiocb, ndlp);
 		if (newnode)
 			lpfc_drop_node(vport, ndlp);
 		break;
@@ -3821,7 +3823,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		break;
 	case ELS_CMD_RSCN:
 		phba->fc_stat.elsRcvRSCN++;
-		lpfc_els_rcv_rscn(vport, elsiocb, ndlp, newnode);
+		lpfc_els_rcv_rscn(vport, elsiocb, ndlp);
 		if (newnode)
 			lpfc_drop_node(vport, ndlp);
 		break;
@@ -3951,8 +3953,6 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
 		lpfc_els_rsp_reject(vport, stat.un.lsRjtError, elsiocb, ndlp,
 			NULL);
-		if (newnode)
-			lpfc_drop_node(vport, ndlp);
 	}
 
 	return;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-08-02 07:08:19.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-08-02 09:05:49.000000000 -0400
@@ -78,6 +78,7 @@ struct lpfc_dma_pool {
 
 struct hbq_dmabuf {
 	struct lpfc_dmabuf dbuf;
+	uint32_t size;
 	uint32_t tag;
 };
 
@@ -329,15 +330,7 @@ struct lpfc_vport {
 #define FC_LOADING		0x1	/* HBA in process of loading drvr */
 #define FC_UNLOADING		0x2	/* HBA in process of unloading drvr */
 	char  *vname;		        /* Application assigned name */
-	struct fc_vport *fc_vport;
 
-#ifdef CONFIG_LPFC_DEBUG_FS
-	struct dentry *debug_disc_trc;
-	struct dentry *debug_nodelist;
-	struct dentry *vport_debugfs_root;
-	struct lpfc_debugfs_trc *disc_trc;
-	atomic_t disc_trc_cnt;
-#endif
 	/* Vport Config Parameters */
 	uint32_t cfg_scan_down;
 	uint32_t cfg_lun_queue_depth;
@@ -353,6 +346,16 @@ struct lpfc_vport {
 	uint32_t cfg_max_luns;
 
 	uint32_t dev_loss_tmo_changed;
+
+	struct fc_vport *fc_vport;
+
+#ifdef CONFIG_LPFC_DEBUG_FS
+	struct dentry *debug_disc_trc;
+	struct dentry *debug_nodelist;
+	struct dentry *vport_debugfs_root;
+	struct lpfc_debugfs_trc *disc_trc;
+	atomic_t disc_trc_cnt;
+#endif
 };
 
 struct hbq_s {
@@ -360,11 +363,19 @@ struct hbq_s {
 	uint32_t next_hbqPutIdx;  /* Index to next HBQ slot to use */
 	uint32_t hbqPutIdx;	  /* HBQ slot to use */
 	uint32_t local_hbqGetIdx; /* Local copy of Get index from Port */
+	void    *hbq_virt;	  /* Virtual ptr to this hbq */
+	struct list_head hbq_buffer_list;  /* buffers assigned to this HBQ */
+				  /* Callback for HBQ buffer allocation */
+	struct hbq_dmabuf *(*hbq_alloc_buffer) (struct lpfc_hba *);
+				  /* Callback for HBQ buffer free */
+	void               (*hbq_free_buffer) (struct lpfc_hba *,
+					       struct hbq_dmabuf *);
 };
 
-#define LPFC_MAX_HBQS  16
-/* this matches the possition in the lpfc_hbq_defs array */
+#define LPFC_MAX_HBQS  4
+/* this matches the position in the lpfc_hbq_defs array */
 #define LPFC_ELS_HBQ	0
+#define LPFC_EXTRA_HBQ	1
 
 struct lpfc_hba {
 	struct lpfc_sli sli;
@@ -460,7 +471,6 @@ struct lpfc_hba {
 	wait_queue_head_t    *work_wait;
 	struct task_struct   *worker_thread;
 
-	struct list_head hbq_buffer_list;
 	uint32_t hbq_count;	        /* Count of configured HBQs */
 	struct hbq_s hbqs[LPFC_MAX_HBQS]; /* local copy of hbq indicies  */
 
@@ -529,6 +539,7 @@ struct lpfc_hba {
 	mempool_t *nlp_mem_pool;
 
 	struct fc_host_statistics link_stats;
+	uint8_t using_msi;
 
 	struct list_head port_list;
 	struct lpfc_vport *pport;	/* physical lpfc_vport pointer */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 07:08:19.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 09:05:59.000000000 -0400
@@ -83,10 +83,17 @@ lpfc_terminate_rport_io(struct fc_rport 
 		ndlp->nlp_sid, ndlp->nlp_DID, ndlp->nlp_flag);
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
-		lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
-			ndlp->nlp_sid, 0, 0, LPFC_CTX_TGT);
+		lpfc_sli_abort_iocb(ndlp->vport,
+			&phba->sli.ring[phba->sli.fcp_ring],
+			ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
 
+	/*
+	 * A device is normally blocked for rediscovery and unblocked when
+	 * devloss timeout happens.  In case a vport is removed or driver
+	 * unloaded before devloss timeout happens, we need to unblock here.
+	 */
+	scsi_target_unblock(&rport->dev);
 	return;
 }
 
@@ -194,8 +201,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 	if (ndlp->nlp_sid != NLP_NO_SID) {
 		warn_on = 1;
 		/* flush the target */
-		lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
-				    ndlp->nlp_sid, 0, 0, LPFC_CTX_TGT);
+		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
+				    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
 	if (vport->load_flag & FC_UNLOADING)
 		warn_on = 0;
@@ -348,6 +355,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 	struct lpfc_sli_ring *pring;
 	uint32_t ha_copy, status, control, work_port_events;
 	struct lpfc_vport **vports;
+	struct lpfc_vport *vport;
 	int i;
 
 	spin_lock_irq(&phba->hbalock);
@@ -365,12 +373,22 @@ lpfc_work_done(struct lpfc_hba *phba)
 		lpfc_handle_latt(phba);
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
-			work_port_events = vports[i]->work_port_events;
+		for(i = 0; i < LPFC_MAX_VPORTS; i++) {
+			/*
+			 * We could have no vports in array if unloading, so if
+			 * this happens then just use the pport
+			 */
+			if (vports[i] == NULL && i == 0)
+				vport = phba->pport;
+			else
+				vport = vports[i];
+			if (vport == NULL)
+				break;
+			work_port_events = vport->work_port_events;
 			if (work_port_events & WORKER_DISC_TMO)
-				lpfc_disc_timeout_handler(vports[i]);
+				lpfc_disc_timeout_handler(vport);
 			if (work_port_events & WORKER_ELS_TMO)
-				lpfc_els_timeout_handler(vports[i]);
+				lpfc_els_timeout_handler(vport);
 			if (work_port_events & WORKER_HB_TMO)
 				lpfc_hb_timeout_handler(phba);
 			if (work_port_events & WORKER_MBOX_TMO)
@@ -378,14 +396,14 @@ lpfc_work_done(struct lpfc_hba *phba)
 			if (work_port_events & WORKER_FABRIC_BLOCK_TMO)
 				lpfc_unblock_fabric_iocbs(phba);
 			if (work_port_events & WORKER_FDMI_TMO)
-				lpfc_fdmi_timeout_handler(vports[i]);
+				lpfc_fdmi_timeout_handler(vport);
 			if (work_port_events & WORKER_RAMP_DOWN_QUEUE)
 				lpfc_ramp_down_queue_handler(phba);
 			if (work_port_events & WORKER_RAMP_UP_QUEUE)
 				lpfc_ramp_up_queue_handler(phba);
-			spin_lock_irq(&vports[i]->work_port_lock);
-			vports[i]->work_port_events &= ~work_port_events;
-			spin_unlock_irq(&vports[i]->work_port_lock);
+			spin_lock_irq(&vport->work_port_lock);
+			vport->work_port_events &= ~work_port_events;
+			spin_unlock_irq(&vport->work_port_lock);
 		}
 	lpfc_destroy_vport_work_array(vports);
 
@@ -1638,16 +1656,7 @@ lpfc_dequeue_node(struct lpfc_vport *vpo
 void
 lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
-	if ((ndlp->nlp_flag & NLP_DELAY_TMO) != 0)
-		lpfc_cancel_retry_delay_tmo(vport, ndlp);
-	if (ndlp->nlp_state && !list_empty(&ndlp->nlp_listp))
-		lpfc_nlp_counters(vport, ndlp->nlp_state, -1);
-	spin_lock_irq(shost->host_lock);
-	list_del_init(&ndlp->nlp_listp);
-	ndlp->nlp_flag &= ~NLP_TARGET_REMOVE;
-	spin_unlock_irq(shost->host_lock);
+	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
 	lpfc_nlp_put(ndlp);
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2007-08-02 07:46:06.000000000 -0400
@@ -150,7 +150,11 @@ struct lpfc_sli_ct_request {
 		struct gff_acc {
 			uint8_t fbits[128];
 		} gff_acc;
+#ifdef __BIG_ENDIAN_BITFIELD
+#define FCP_TYPE_FEATURE_OFFSET 7
+#else	/*  __LITTLE_ENDIAN_BITFIELD */
 #define FCP_TYPE_FEATURE_OFFSET 4
+#endif
 		struct rff {
 			uint32_t PortId;
 			uint8_t reserved[2];
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-08-02 06:51:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-08-02 07:55:04.000000000 -0400
@@ -55,6 +55,8 @@ static DEFINE_IDR(lpfc_hba_index);
 


+extern struct lpfc_hbq_init *lpfc_hbq_defs[];
+
 /************************************************************************/
 /*                                                                      */
 /*    lpfc_config_port_prep                                             */
@@ -429,18 +431,11 @@ lpfc_config_port_post(struct lpfc_hba *p
 int
 lpfc_hba_down_prep(struct lpfc_hba *phba)
 {
-	struct lpfc_vport **vports;
-	int i;
-
 	/* Disable interrupts */
 	writel(0, phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
 
-	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++)
-			lpfc_cleanup_discovery_resources(vports[i]);
-	lpfc_destroy_vport_work_array(vports);
+	lpfc_cleanup_discovery_resources(phba->pport);
 	return 0;
 }
 
@@ -512,7 +507,7 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba
 	mempool_free(pmboxq, phba->mbox_mem_pool);
 	if (!(phba->pport->fc_flag & FC_OFFLINE_MODE) &&
 		!(phba->link_state == LPFC_HBA_ERROR) &&
-		!(phba->pport->fc_flag & FC_UNLOADING))
+		!(phba->pport->load_flag & FC_UNLOADING))
 		mod_timer(&phba->hb_tmofunc,
 			jiffies + HZ * LPFC_HB_MBOX_INTERVAL);
 	return;
@@ -526,7 +521,7 @@ lpfc_hb_timeout_handler(struct lpfc_hba 
 	struct lpfc_sli *psli = &phba->sli;
 
 	if ((phba->link_state == LPFC_HBA_ERROR) ||
-		(phba->pport->fc_flag & FC_UNLOADING) ||
+		(phba->pport->load_flag & FC_UNLOADING) ||
 		(phba->pport->fc_flag & FC_OFFLINE_MODE))
 		return;
 
@@ -1340,16 +1335,9 @@ lpfc_stop_vport_timers(struct lpfc_vport
 static void
 lpfc_stop_phba_timers(struct lpfc_hba *phba)
 {
-	struct lpfc_vport **vports;
-	int i;
-
 	del_timer_sync(&phba->fcp_poll_timer);
 	del_timer_sync(&phba->fc_estabtmo);
-	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL)
-		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++)
-			lpfc_stop_vport_timers(vports[i]);
-	lpfc_destroy_vport_work_array(vports);
+	lpfc_stop_vport_timers(phba->pport);
 	del_timer_sync(&phba->sli.mbox_tmo);
 	del_timer_sync(&phba->fabric_block_timer);
 	phba->hb_outstanding = 0;
@@ -1455,6 +1443,11 @@ lpfc_offline(struct lpfc_hba *phba)
 
 	/* stop all timers associated with this hba */
 	lpfc_stop_phba_timers(phba);
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++)
+			lpfc_stop_vport_timers(vports[i]);
+	lpfc_destroy_vport_work_array(vports);
 	lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 			"0460 Bring Adapter offline\n");
 	/* Bring down the SLI Layer and cleanup.  The HBA is offline
@@ -1629,7 +1622,7 @@ int lpfc_scan_finished(struct Scsi_Host 
 
 	spin_lock_irq(shost->host_lock);
 
-	if (vport->fc_flag & FC_UNLOADING) {
+	if (vport->load_flag & FC_UNLOADING) {
 		stat = 1;
 		goto finished;
 	}
@@ -1706,7 +1699,7 @@ void lpfc_host_attrib_init(struct Scsi_H
 
 	fc_host_max_npiv_vports(shost) = phba->max_vpi;
 	spin_lock_irq(shost->host_lock);
-	vport->fc_flag &= ~FC_LOADING;
+	vport->load_flag &= ~FC_LOADING;
 	spin_unlock_irq(shost->host_lock);
 }
 
@@ -1718,9 +1711,10 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	struct lpfc_sli   *psli;
 	struct lpfc_iocbq *iocbq_entry = NULL, *iocbq_next = NULL;
 	struct Scsi_Host  *shost = NULL;
+	void *ptr;
 	unsigned long bar0map_len, bar2map_len;
 	int error = -ENODEV;
-	int i;
+	int  i, hbq_count;
 	uint16_t iotag;
 
 	if (pci_enable_device(pdev))
@@ -1741,7 +1735,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		goto out_free_phba;
 
 	INIT_LIST_HEAD(&phba->port_list);
-	INIT_LIST_HEAD(&phba->hbq_buffer_list);
 	/*
 	 * Get all the module params for configuring this host and then
 	 * establish the host.
@@ -1819,6 +1812,17 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	if (!phba->hbqslimp.virt)
 		goto out_free_slim;
 
+	hbq_count = lpfc_sli_hbq_count();
+	ptr = phba->hbqslimp.virt;
+	for (i = 0; i < hbq_count; ++i) {
+		phba->hbqs[i].hbq_virt = ptr;
+		INIT_LIST_HEAD(&phba->hbqs[i].hbq_buffer_list);
+		ptr += (lpfc_hbq_defs[i]->entry_count *
+			sizeof(struct lpfc_hbq_entry));
+	}
+	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_els_hbq_alloc;
+	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer  = lpfc_els_hbq_free;
+
 	memset(phba->hbqslimp.virt, 0, lpfc_sli_hbq_size());
 
 	/* Initialize the SLI Layer to run with lpfc HBAs. */
@@ -1895,7 +1899,9 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 
 	if (phba->cfg_use_msi) {
 		error = pci_enable_msi(phba->pcidev);
-		if (error)
+		if (!error)
+			phba->using_msi = 1;
+		else
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 					"0452 Enable MSI failed, continuing "
 					"with IRQ\n");
@@ -1942,14 +1948,15 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 out_remove_device:
 	lpfc_free_sysfs_attr(vport);
 	spin_lock_irq(shost->host_lock);
-	vport->fc_flag |= FC_UNLOADING;
+	vport->load_flag |= FC_UNLOADING;
 	spin_unlock_irq(shost->host_lock);
 out_free_irq:
 	lpfc_stop_phba_timers(phba);
 	phba->pport->work_port_events = 0;
 	free_irq(phba->pcidev->irq, phba);
 out_disable_msi:
-	pci_disable_msi(phba->pcidev);
+	if (phba->using_msi)
+		pci_disable_msi(phba->pcidev);
 	destroy_port(vport);
 out_kthread_stop:
 	kthread_stop(phba->worker_thread);
@@ -1991,10 +1998,8 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	struct Scsi_Host  *shost = pci_get_drvdata(pdev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_vport *port_iterator;
 	spin_lock_irq(&phba->hbalock);
-	list_for_each_entry(port_iterator, &phba->port_list, listentry)
-		port_iterator->load_flag |= FC_UNLOADING;
+	vport->load_flag |= FC_UNLOADING;
 	spin_unlock_irq(&phba->hbalock);
 
 	kfree(vport->vname);
@@ -2002,7 +2007,6 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
-
 	/*
 	 * Bring down the SLI Layer. This step disable all interrupts,
 	 * clears the rings, discards all mailbox commands, and resets
@@ -2023,7 +2027,8 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 
 	/* Release the irq reservation */
 	free_irq(phba->pcidev->irq, phba);
-	pci_disable_msi(phba->pcidev);
+	if (phba->using_msi)
+		pci_disable_msi(phba->pcidev);
 
 	pci_set_drvdata(pdev, NULL);
 	scsi_host_put(shost);
@@ -2065,8 +2070,8 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 static pci_ers_result_t lpfc_io_error_detected(struct pci_dev *pdev,
 				pci_channel_state_t state)
 {
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
-	struct lpfc_hba *phba = (struct lpfc_hba *)host->hostdata;
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
 
@@ -2082,6 +2087,11 @@ static pci_ers_result_t lpfc_io_error_de
 	pring = &psli->ring[psli->fcp_ring];
 	lpfc_sli_abort_iocb_ring(phba, pring);
 
+	/* Release the irq reservation */
+	free_irq(phba->pcidev->irq, phba);
+	if (phba->using_msi)
+		pci_disable_msi(phba->pcidev);
+
 	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
@@ -2094,8 +2104,8 @@ static pci_ers_result_t lpfc_io_error_de
  */
 static pci_ers_result_t lpfc_io_slot_reset(struct pci_dev *pdev)
 {
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
-	struct lpfc_hba *phba = (struct lpfc_hba *)host->hostdata;
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 	struct lpfc_sli *psli = &phba->sli;
 	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
 
@@ -2109,9 +2119,9 @@ static pci_ers_result_t lpfc_io_slot_res
 	pci_set_master(pdev);
 
 	/* Re-establishing Link */
-	spin_lock_irq(host->host_lock);
+	spin_lock_irq(shost->host_lock);
 	phba->pport->fc_flag |= FC_ESTABLISH_LINK;
-	spin_unlock_irq(host->host_lock);
+	spin_unlock_irq(shost->host_lock);
 
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
@@ -2134,8 +2144,8 @@ static pci_ers_result_t lpfc_io_slot_res
  */
 static void lpfc_io_resume(struct pci_dev *pdev)
 {
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
-	struct lpfc_hba *phba = (struct lpfc_hba *)host->hostdata;
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
 	if (lpfc_online(phba) == 0) {
 		mod_timer(&phba->fc_estabtmo, jiffies + HZ * 60);
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2007-08-02 07:11:24.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2007-08-02 09:05:09.000000000 -0400
@@ -560,7 +560,8 @@ lpfc_build_hbq_profile5(struct config_hb
 }
 
 void
-lpfc_config_hbq(struct lpfc_hba *phba, struct lpfc_hbq_init *hbq_desc,
+lpfc_config_hbq(struct lpfc_hba *phba, uint32_t id,
+		 struct lpfc_hbq_init *hbq_desc,
 		uint32_t hbq_entry_index, LPFC_MBOXQ_t *pmb)
 {
 	int i;
@@ -568,6 +569,7 @@ lpfc_config_hbq(struct lpfc_hba *phba, s
 	struct config_hbq_var *hbqmb = &mb->un.varCfgHbq;
 
 	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
+	hbqmb->hbqId = id;
 	hbqmb->entry_count = hbq_desc->entry_count;   /* # entries in HBQ */
 	hbqmb->recvNotify = hbq_desc->rn;             /* Receive
 						       * Notification */
@@ -687,7 +689,7 @@ lpfc_config_port(struct lpfc_hba *phba, 
 
 	if (phba->sli_rev == 3 && phba->vpd.sli3Feat.cerbm) {
 		mb->un.varCfgPort.cerbm = 1; /* Request HBQs */
-		mb->un.varCfgPort.max_hbq = 1; /* Requesting 2 HBQs */
+		mb->un.varCfgPort.max_hbq = lpfc_sli_hbq_count();
 		if (phba->max_vpi && phba->cfg_enable_npiv &&
 		    phba->vpd.sli3Feat.cmv) {
 			mb->un.varCfgPort.max_vpi = phba->max_vpi;
diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2007-08-02 07:55:04.000000000 -0400
@@ -231,21 +231,34 @@ lpfc_mbuf_free(struct lpfc_hba * phba, v
 	return;
 }
 
-void *
-lpfc_hbq_alloc(struct lpfc_hba *phba, int mem_flags, dma_addr_t *handle)
+struct hbq_dmabuf *
+lpfc_els_hbq_alloc(struct lpfc_hba *phba)
 {
-	void *ret;
-	ret = pci_pool_alloc(phba->lpfc_hbq_pool, GFP_ATOMIC, handle);
-	return ret;
+	struct hbq_dmabuf *hbqbp;
+
+	hbqbp = kmalloc(sizeof(struct hbq_dmabuf), GFP_KERNEL);
+	if (!hbqbp)
+		return NULL;
+
+	hbqbp->dbuf.virt = pci_pool_alloc(phba->lpfc_hbq_pool, GFP_KERNEL,
+					  &hbqbp->dbuf.phys);
+	if (!hbqbp->dbuf.virt) {
+		kfree(hbqbp);
+		return NULL;
+	}
+	hbqbp->size = LPFC_BPL_SIZE;
+	return hbqbp;
 }
 
 void
-lpfc_hbq_free(struct lpfc_hba *phba, void *virt, dma_addr_t dma)
+lpfc_els_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp)
 {
-	pci_pool_free(phba->lpfc_hbq_pool, virt, dma);
+	pci_pool_free(phba->lpfc_hbq_pool, hbqbp->dbuf.virt, hbqbp->dbuf.phys);
+	kfree(hbqbp);
 	return;
 }
 
+/* This is ONLY called for the LPFC_ELS_HBQ */
 void
 lpfc_in_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 {
@@ -254,9 +267,8 @@ lpfc_in_buf_free(struct lpfc_hba *phba, 
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 		hbq_entry = container_of(mp, struct hbq_dmabuf, dbuf);
 		if (hbq_entry->tag == -1) {
-			lpfc_hbq_free(phba, hbq_entry->dbuf.virt,
-				      hbq_entry->dbuf.phys);
-			kfree(hbq_entry);
+			(phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer)
+				(phba, hbq_entry);
 		} else {
 			lpfc_sli_free_hbq(phba, hbq_entry);
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-08-02 06:51:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-08-02 09:05:59.000000000 -0400
@@ -329,7 +329,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	case  NLP_STE_PRLI_ISSUE:
 	case  NLP_STE_UNMAPPED_NODE:
 	case  NLP_STE_MAPPED_NODE:
-		lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL, 0);
+		lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL);
 		return 1;
 	}
 
@@ -407,7 +407,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 			ndlp, mbox);
 		return 1;
 	}
-	lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox, 0);
+	lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox);
 	return 1;
 
 out:
@@ -451,7 +451,7 @@ lpfc_rcv_padisc(struct lpfc_vport *vport
 			lpfc_els_rsp_adisc_acc(vport, cmdiocb, ndlp);
 		} else {
 			lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp,
-					 NULL, 0);
+					 NULL);
 		}
 		return 1;
 	}
@@ -488,9 +488,9 @@ lpfc_rcv_logo(struct lpfc_vport *vport, 
 	ndlp->nlp_flag |= NLP_LOGO_ACC;
 	spin_unlock_irq(shost->host_lock);
 	if (els_cmd == ELS_CMD_PRLO)
-		lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL, 0);
+		lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL);
 	else
-		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 
 	if (!(ndlp->nlp_type & NLP_FABRIC) ||
 	    (ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
@@ -564,6 +564,11 @@ lpfc_disc_set_adisc(struct lpfc_vport *v
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
+	if (!ndlp->nlp_rpi) {
+		ndlp->nlp_flag &= ~NLP_NPR_ADISC;
+		return 0;
+	}
+
 	/* Check config parameter use-adisc or FCP-2 */
 	if ((vport->cfg_use_adisc && (vport->fc_flag & FC_RSCN_MODE)) ||
 	    ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) {
@@ -627,7 +632,7 @@ lpfc_rcv_logo_unused_node(struct lpfc_vp
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= NLP_LOGO_ACC;
 	spin_unlock_irq(shost->host_lock);
-	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
 
 	return ndlp->nlp_state;
@@ -723,7 +728,7 @@ lpfc_rcv_els_plogi_issue(struct lpfc_vpo
 	lpfc_els_abort(phba, ndlp);
 
 	if (evt == NLP_EVT_RCV_LOGO) {
-		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 	} else {
 		lpfc_issue_els_logo(vport, ndlp, 0);
 	}
@@ -1167,7 +1172,7 @@ lpfc_rcv_prlo_reglogin_issue(struct lpfc
 	struct lpfc_iocbq *cmdiocb;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
-	lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL, 0);
+	lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL);
 	return ndlp->nlp_state;
 }
 
@@ -1322,7 +1327,7 @@ lpfc_rcv_prlo_prli_issue(struct lpfc_vpo
 {
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 
-	lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL, 0);
+	lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL);
 	return ndlp->nlp_state;
 }
 
@@ -1514,7 +1519,7 @@ lpfc_rcv_prlo_unmap_node(struct lpfc_vpo
 {
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 
-	lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL, 0);
+	lpfc_els_rsp_acc(vport, ELS_CMD_PRLO, cmdiocb, ndlp, NULL);
 	return ndlp->nlp_state;
 }
 
@@ -1585,8 +1590,8 @@ lpfc_rcv_prlo_mapped_node(struct lpfc_vp
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 
 	/* flush the target */
-	lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
-			    ndlp->nlp_sid, 0, 0, LPFC_CTX_TGT);
+	lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
+			    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 
 	/* Treat like rcv logo */
 	lpfc_rcv_logo(vport, ndlp, cmdiocb, ELS_CMD_PRLO);
@@ -1719,7 +1724,7 @@ lpfc_rcv_prlo_npr_node(struct lpfc_vport
 	ndlp->nlp_flag |= NLP_LOGO_ACC;
 	spin_unlock_irq(shost->host_lock);
 
-	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+	lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 
 	if ((ndlp->nlp_flag & NLP_DELAY_TMO) == 0) {
 		mod_timer(&ndlp->nlp_delayfunc, jiffies + HZ * 1);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-08-02 06:51:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2007-08-02 09:05:59.000000000 -0400
@@ -152,7 +152,6 @@ lpfc_ramp_down_queue_handler(struct lpfc
 			}
 		}
 	lpfc_destroy_vport_work_array(vports);
-	spin_unlock_irq(&phba->hbalock);
 	atomic_set(&phba->num_rsrc_err, 0);
 	atomic_set(&phba->num_cmd_success, 0);
 }
@@ -1195,14 +1194,12 @@ lpfc_device_reset_handler(struct scsi_cm
 	 * Unfortunately, some targets do not abide by this forcing the driver
 	 * to double check.
 	 */
-	cnt = lpfc_sli_sum_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
-				cmnd->device->id, cmnd->device->lun,
+	cnt = lpfc_sli_sum_iocb(vport, cmnd->device->id, cmnd->device->lun,
 				LPFC_CTX_LUN);
 	if (cnt)
-		lpfc_sli_abort_iocb(phba,
-				    &phba->sli.ring[phba->sli.fcp_ring],
+		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
 				    cmnd->device->id, cmnd->device->lun,
-				    0, LPFC_CTX_LUN);
+				    LPFC_CTX_LUN);
 	loopcnt = 0;
 	while(cnt) {
 		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
@@ -1211,10 +1208,8 @@ lpfc_device_reset_handler(struct scsi_cm
 		    > (2 * vport->cfg_devloss_tmo)/LPFC_RESET_WAIT)
 			break;
 
-		cnt = lpfc_sli_sum_iocb(phba,
-					&phba->sli.ring[phba->sli.fcp_ring],
-					cmnd->device->id, cmnd->device->lun,
-					LPFC_CTX_LUN);
+		cnt = lpfc_sli_sum_iocb(vport, cmnd->device->id,
+					cmnd->device->lun, LPFC_CTX_LUN);
 	}
 
 	if (cnt) {
@@ -1304,11 +1299,10 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 	 * the targets.  Unfortunately, some targets do not abide by
 	 * this forcing the driver to double check.
 	 */
-	cnt = lpfc_sli_sum_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
-				0, 0, LPFC_CTX_HOST);
+	cnt = lpfc_sli_sum_iocb(vport, 0, 0, LPFC_CTX_HOST);
 	if (cnt)
-		lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
-				    0, 0, 0, LPFC_CTX_HOST);
+		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
+				    0, 0, LPFC_CTX_HOST);
 	loopcnt = 0;
 	while(cnt) {
 		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
@@ -1317,9 +1311,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 		    > (2 * vport->cfg_devloss_tmo)/LPFC_RESET_WAIT)
 			break;
 
-		cnt = lpfc_sli_sum_iocb(phba,
-					&phba->sli.ring[phba->sli.fcp_ring],
-					0, 0, LPFC_CTX_HOST);
+		cnt = lpfc_sli_sum_iocb(vport, 0, 0, LPFC_CTX_HOST);
 	}
 
 	if (cnt) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-08-02 07:08:19.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-08-02 09:06:07.000000000 -0400
@@ -545,7 +545,8 @@ lpfc_sli_next_hbq_slot(struct lpfc_hba *
 			return NULL;
 	}
 
-	return (struct lpfc_hbq_entry *) phba->hbqslimp.virt + hbqp->hbqPutIdx;
+	return (struct lpfc_hbq_entry *) phba->hbqs[hbqno].hbq_virt +
+			hbqp->hbqPutIdx;
 }
 
 void
@@ -553,18 +554,21 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba
 {
 	struct lpfc_dmabuf *dmabuf, *next_dmabuf;
 	struct hbq_dmabuf *hbq_buf;
+	int i, hbq_count;
 
+	hbq_count = lpfc_sli_hbq_count();
 	/* Return all memory used by all HBQs */
-	list_for_each_entry_safe(dmabuf, next_dmabuf,
-				 &phba->hbq_buffer_list, list) {
-		hbq_buf = container_of(dmabuf, struct hbq_dmabuf, dbuf);
-		list_del(&hbq_buf->dbuf.list);
-		lpfc_hbq_free(phba, hbq_buf->dbuf.virt, hbq_buf->dbuf.phys);
-		kfree(hbq_buf);
+	for (i = 0; i < hbq_count; ++i) {
+		list_for_each_entry_safe(dmabuf, next_dmabuf,
+				&phba->hbqs[i].hbq_buffer_list, list) {
+			hbq_buf = container_of(dmabuf, struct hbq_dmabuf, dbuf);
+			list_del(&hbq_buf->dbuf.list);
+			(phba->hbqs[i].hbq_free_buffer)(phba, hbq_buf);
+		}
 	}
 }
 
-static void
+static struct lpfc_hbq_entry *
 lpfc_sli_hbq_to_firmware(struct lpfc_hba *phba, uint32_t hbqno,
 			 struct hbq_dmabuf *hbq_buf)
 {
@@ -578,7 +582,7 @@ lpfc_sli_hbq_to_firmware(struct lpfc_hba
 
 		hbqe->bde.addrHigh = le32_to_cpu(putPaddrHigh(physaddr));
 		hbqe->bde.addrLow  = le32_to_cpu(putPaddrLow(physaddr));
-		hbqe->bde.tus.f.bdeSize = FCELSSIZE;
+		hbqe->bde.tus.f.bdeSize = hbq_buf->size;
 		hbqe->bde.tus.f.bdeFlags = 0;
 		hbqe->bde.tus.w = le32_to_cpu(hbqe->bde.tus.w);
 		hbqe->buffer_tag = le32_to_cpu(hbq_buf->tag);
@@ -587,8 +591,9 @@ lpfc_sli_hbq_to_firmware(struct lpfc_hba
 		writel(hbqp->hbqPutIdx, phba->hbq_put + hbqno);
 				/* flush */
 		readl(phba->hbq_put + hbqno);
-		list_add_tail(&hbq_buf->dbuf.list, &phba->hbq_buffer_list);
+		list_add_tail(&hbq_buf->dbuf.list, &hbqp->hbq_buffer_list);
 	}
+	return hbqe;
 }
 
 static struct lpfc_hbq_init lpfc_els_hbq = {
@@ -596,14 +601,26 @@ static struct lpfc_hbq_init lpfc_els_hbq
 	.entry_count = 200,
 	.mask_count = 0,
 	.profile = 0,
-	.ring_mask = 1 << LPFC_ELS_RING,
+	.ring_mask = (1 << LPFC_ELS_RING),
 	.buffer_count = 0,
 	.init_count = 20,
 	.add_count = 5,
 };
 
+static struct lpfc_hbq_init lpfc_extra_hbq = {
+	.rn = 1,
+	.entry_count = 200,
+	.mask_count = 0,
+	.profile = 0,
+	.ring_mask = (1 << LPFC_EXTRA_RING),
+	.buffer_count = 0,
+	.init_count = 0,
+	.add_count = 5,
+};
+
 struct lpfc_hbq_init *lpfc_hbq_defs[] = {
 	&lpfc_els_hbq,
+	&lpfc_extra_hbq,
 };
 
 int
@@ -612,6 +629,10 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hb
 	uint32_t i, start, end;
 	struct hbq_dmabuf *hbq_buffer;
 
+	if (!phba->hbqs[hbqno].hbq_alloc_buffer) {
+		return 0;
+	}
+
 	start = lpfc_hbq_defs[hbqno]->buffer_count;
 	end = count + lpfc_hbq_defs[hbqno]->buffer_count;
 	if (end > lpfc_hbq_defs[hbqno]->entry_count) {
@@ -620,17 +641,14 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hb
 
 	/* Populate HBQ entries */
 	for (i = start; i < end; i++) {
-		hbq_buffer = kmalloc(sizeof(struct hbq_dmabuf),
-				     GFP_KERNEL);
+		hbq_buffer = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
 		if (!hbq_buffer)
 			return 1;
-		hbq_buffer->dbuf.virt = lpfc_hbq_alloc(phba, MEM_PRI,
-							&hbq_buffer->dbuf.phys);
-		if (hbq_buffer->dbuf.virt == NULL)
-			return 1;
 		hbq_buffer->tag = (i | (hbqno << 16));
-		lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer);
-		lpfc_hbq_defs[hbqno]->buffer_count++;
+		if (lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer))
+			lpfc_hbq_defs[hbqno]->buffer_count++;
+		else
+			(phba->hbqs[hbqno].hbq_free_buffer)(phba, hbq_buffer);
 	}
 	return 0;
 }
@@ -654,10 +672,15 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *ph
 {
 	struct lpfc_dmabuf *d_buf;
 	struct hbq_dmabuf *hbq_buf;
+	uint32_t hbqno;
+
+	hbqno = tag >> 16;
+	if (hbqno > LPFC_MAX_HBQS)
+		return NULL;
 
-	list_for_each_entry(d_buf, &phba->hbq_buffer_list, list) {
+	list_for_each_entry(d_buf, &phba->hbqs[hbqno].hbq_buffer_list, list) {
 		hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
-		if ((hbq_buf->tag & 0xffff) == tag) {
+		if (hbq_buf->tag == tag) {
 			return hbq_buf;
 		}
 	}
@@ -668,13 +691,15 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *ph
 }
 
 void
-lpfc_sli_free_hbq(struct lpfc_hba *phba, struct hbq_dmabuf *sp)
+lpfc_sli_free_hbq(struct lpfc_hba *phba, struct hbq_dmabuf *hbq_buffer)
 {
 	uint32_t hbqno;
 
-	if (sp) {
-		hbqno = sp->tag >> 16;
-		lpfc_sli_hbq_to_firmware(phba, hbqno, sp);
+	if (hbq_buffer) {
+		hbqno = hbq_buffer->tag >> 16;
+		if (!lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer)) {
+			(phba->hbqs[hbqno].hbq_free_buffer)(phba, hbq_buffer);
+		}
 	}
 }
 
@@ -904,21 +929,26 @@ static struct lpfc_dmabuf *
 lpfc_sli_replace_hbqbuff(struct lpfc_hba *phba, uint32_t tag)
 {
 	struct hbq_dmabuf *hbq_entry, *new_hbq_entry;
+	uint32_t hbqno;
+	void *virt;		/* virtual address ptr */
+	dma_addr_t phys;	/* mapped address */
 
 	hbq_entry = lpfc_sli_hbqbuf_find(phba, tag);
 	if (hbq_entry == NULL)
 		return NULL;
 	list_del(&hbq_entry->dbuf.list);
-	new_hbq_entry = kmalloc(sizeof(struct hbq_dmabuf), GFP_ATOMIC);
+
+	hbqno = tag >> 16;
+	new_hbq_entry = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
 	if (new_hbq_entry == NULL)
 		return &hbq_entry->dbuf;
-	new_hbq_entry->dbuf = hbq_entry->dbuf;
 	new_hbq_entry->tag = -1;
-	hbq_entry->dbuf.virt = lpfc_hbq_alloc(phba, 0, &hbq_entry->dbuf.phys);
-	if (hbq_entry->dbuf.virt == NULL) {
-		kfree(new_hbq_entry);
-		return &hbq_entry->dbuf;
-	}
+	phys = new_hbq_entry->dbuf.phys;
+	virt = new_hbq_entry->dbuf.virt;
+	new_hbq_entry->dbuf.phys = hbq_entry->dbuf.phys;
+	new_hbq_entry->dbuf.virt = hbq_entry->dbuf.virt;
+	hbq_entry->dbuf.phys = phys;
+	hbq_entry->dbuf.virt = virt;
 	lpfc_sli_free_hbq(phba, hbq_entry);
 	return &new_hbq_entry->dbuf;
 }
@@ -964,7 +994,7 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 						irsp->un.ulpWord[3]);
 		if (irsp->ulpBdeCount == 2)
 			saveq->context3 = lpfc_sli_replace_hbqbuff(phba,
-						irsp->un.ulpWord[15]);
+						irsp->unsli3.sli3Words[7]);
 	}
 
 	/* unSolicited Responses */
@@ -2189,8 +2219,8 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
 		phba->hbqs[hbqno].local_hbqGetIdx   = 0;
 		phba->hbqs[hbqno].entry_count =
 			lpfc_hbq_defs[hbqno]->entry_count;
-		lpfc_config_hbq(phba, lpfc_hbq_defs[hbqno], hbq_entry_index,
-				pmb);
+		lpfc_config_hbq(phba, hbqno, lpfc_hbq_defs[hbqno],
+			hbq_entry_index, pmb);
 		hbq_entry_index += phba->hbqs[hbqno].entry_count;
 
 		if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS) {
@@ -3433,8 +3463,8 @@ abort_iotag_exit:
 }
 
 static int
-lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, uint16_t tgt_id,
-			   uint64_t lun_id, uint32_t ctx,
+lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
+			   uint16_t tgt_id, uint64_t lun_id,
 			   lpfc_ctx_cmd ctx_cmd)
 {
 	struct lpfc_scsi_buf *lpfc_cmd;
@@ -3444,6 +3474,9 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_i
 	if (!(iocbq->iocb_flag &  LPFC_IO_FCP))
 		return rc;
 
+	if (iocbq->vport != vport)
+		return rc;
+
 	lpfc_cmd = container_of(iocbq, struct lpfc_scsi_buf, cur_iocbq);
 	cmnd = lpfc_cmd->pCmd;
 
@@ -3460,10 +3493,6 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_i
 		if (cmnd->device->id == tgt_id)
 			rc = 0;
 		break;
-	case LPFC_CTX_CTX:
-		if (iocbq->iocb.ulpContext == ctx)
-			rc = 0;
-		break;
 	case LPFC_CTX_HOST:
 		rc = 0;
 		break;
@@ -3477,17 +3506,18 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_i
 }
 
 int
-lpfc_sli_sum_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
-		  uint16_t tgt_id, uint64_t lun_id, lpfc_ctx_cmd ctx_cmd)
+lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
+		  lpfc_ctx_cmd ctx_cmd)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *iocbq;
 	int sum, i;
 
 	for (i = 1, sum = 0; i <= phba->sli.last_iotag; i++) {
 		iocbq = phba->sli.iocbq_lookup[i];
 
-		if (lpfc_sli_validate_fcp_iocb (iocbq, tgt_id, lun_id,
-						0, ctx_cmd) == 0)
+		if (lpfc_sli_validate_fcp_iocb (iocbq, vport, tgt_id, lun_id,
+						ctx_cmd) == 0)
 			sum++;
 	}
 
@@ -3503,10 +3533,10 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba 
 }
 
 int
-lpfc_sli_abort_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
-		    uint16_t tgt_id, uint64_t lun_id, uint32_t ctx,
-		    lpfc_ctx_cmd abort_cmd)
+lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
+		    uint16_t tgt_id, uint64_t lun_id, lpfc_ctx_cmd abort_cmd)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *iocbq;
 	struct lpfc_iocbq *abtsiocb;
 	IOCB_t *cmd = NULL;
@@ -3516,7 +3546,7 @@ lpfc_sli_abort_iocb(struct lpfc_hba *phb
 	for (i = 1; i <= phba->sli.last_iotag; i++) {
 		iocbq = phba->sli.iocbq_lookup[i];
 
-		if (lpfc_sli_validate_fcp_iocb(iocbq, tgt_id, lun_id, 0,
+		if (lpfc_sli_validate_fcp_iocb(iocbq, vport, tgt_id, lun_id,
 					       abort_cmd) != 0)
 			continue;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2007-08-02 09:05:59.000000000 -0400
@@ -26,7 +26,6 @@ struct lpfc_vport;
 typedef enum _lpfc_ctx_cmd {
 	LPFC_CTX_LUN,
 	LPFC_CTX_TGT,
-	LPFC_CTX_CTX,
 	LPFC_CTX_HOST
 } lpfc_ctx_cmd;
 
@@ -54,9 +53,10 @@ struct lpfc_iocbq {
 	void *context2;		/* caller context information */
 	void *context3;		/* caller context information */
 	union {
-		wait_queue_head_t  *wait_queue;
-		struct lpfc_iocbq  *rsp_iocb;
-		struct lpfcMboxq   *mbox;
+		wait_queue_head_t    *wait_queue;
+		struct lpfc_iocbq    *rsp_iocb;
+		struct lpfcMboxq     *mbox;
+		struct lpfc_nodelist *ndlp;
 	} context_un;
 
 	void (*fabric_iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2007-08-02 07:04:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2007-08-02 07:53:23.000000000 -0400
@@ -432,8 +432,29 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
 	struct lpfc_hba   *phba = vport->phba;
 	long timeout;
-	int rc = VPORT_ERROR;
 
+	if (vport->port_type == LPFC_PHYSICAL_PORT) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
+				 "1812 vport_delete failed: Cannot delete "
+				 "physical host\n");
+		return VPORT_ERROR;
+	}
+	/*
+	 * If we are not unloading the driver then prevent the vport_delete
+	 * from happening until after this vport's discovery is finished.
+	 */
+	if (!(phba->pport->load_flag & FC_UNLOADING)) {
+		int check_count = 0;
+		while (check_count < ((phba->fc_ratov * 3) + 3) &&
+		       vport->port_state > LPFC_VPORT_FAILED &&
+		       vport->port_state < LPFC_VPORT_READY) {
+			check_count++;
+			msleep(1000);
+		}
+		if (vport->port_state > LPFC_VPORT_FAILED &&
+		    vport->port_state < LPFC_VPORT_READY)
+			return -EAGAIN;
+	}
 	/*
 	 * This is a bit of a mess.  We want to ensure the shost doesn't get
 	 * torn down until we're done with the embedded lpfc_vport structure.
@@ -451,16 +472,9 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 	 */
 	if (!scsi_host_get(shost) || !scsi_host_get(shost))
 		return VPORT_INVAL;
-
-	if (vport->port_type == LPFC_PHYSICAL_PORT) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
-				 "1812 vport_delete failed: Cannot delete "
-				 "physical host\n");
-		goto out;
-	}
-
+	spin_lock_irq(&phba->hbalock);
 	vport->load_flag |= FC_UNLOADING;
-
+	spin_unlock_irq(&phba->hbalock);
 	kfree(vport->vname);
 	lpfc_debugfs_terminate(vport);
 	fc_remove_host(lpfc_shost_from_vport(vport));
@@ -514,10 +528,8 @@ skip_logo:
 	spin_unlock_irq(&phba->hbalock);
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
 			 "1828 Vport Deleted.\n");
-	rc = VPORT_OK;
-out:
 	scsi_host_put(shost);
-	return rc;
+	return VPORT_OK;
 }
 
 EXPORT_SYMBOL(lpfc_vport_create);
@@ -536,7 +548,7 @@ lpfc_create_vport_work_array(struct lpfc
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
 		if (!scsi_host_get(lpfc_shost_from_vport(port_iterator))) {
-			lpfc_printf_vlog(port_iterator, KERN_ERR, LOG_VPORT,
+			lpfc_printf_vlog(port_iterator, KERN_WARNING, LOG_VPORT,
 					 "1801 Create vport work array FAILED: "
 					 "cannot do scsi_host_get\n");
 			continue;


