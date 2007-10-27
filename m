From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/9] lpfc 8.2.3 : Miscellaneous Small Fixes - part 2
Date: Sat, 27 Oct 2007 13:37:53 -0400
Message-ID: <1193506673.8770.24.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46360 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbXJ0Rhr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 13:37:47 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l9RHbkl2021383
	for <linux-scsi@vger.kernel.org>; Sat, 27 Oct 2007 10:37:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous Small Fixes - part 2

- Fix ndlp left in PLOGI state after link up
- Fix cannot rcv unsol ELS frames after running HBA resets for a few minutes
- Fix HBQ buffer_count implemention
- Fix RPI leak
- Fix crash while deleting vports while HBA is reset
- Revert the FCP Fbits offset back to 7
- Fix panic when deleting vports
- Remove unused code in switch statement outside of a case
- Reject PLOGI from invalid PName or NName of 0
- Ignore PLOGI responses from WWPName or WWNName of 0
- Fix debugfs hbqinfo display for ppc
- Added 8G to list of supported speeds for sysfs parameter
- Defer ndlp cleanup to dev-loss timeout handler
- Added support for WRITE_VPARMS mailbox command by applications

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-10-27 10:45:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-10-27 13:11:06.000000000 -0400
@@ -187,12 +187,9 @@ lpfc_state_show(struct class_device *cde
 	case LPFC_LINK_UP:
 	case LPFC_CLEAR_LA:
 	case LPFC_HBA_READY:
-		len += snprintf(buf + len, PAGE_SIZE-len, "Link Up - \n");
+		len += snprintf(buf + len, PAGE_SIZE-len, "Link Up - ");
 
 		switch (vport->port_state) {
-			len += snprintf(buf + len, PAGE_SIZE-len,
-					"initializing\n");
-			break;
 		case LPFC_LOCAL_CFG_LINK:
 			len += snprintf(buf + len, PAGE_SIZE-len,
 					"Configuring Link\n");
@@ -1759,7 +1756,6 @@ sysfs_mbox_read(struct kobject *kobj, st
 
 		switch (phba->sysfs_mbox.mbox->mb.mbxCommand) {
 			/* Offline only */
-		case MBX_WRITE_NV:
 		case MBX_INIT_LINK:
 		case MBX_DOWN_LINK:
 		case MBX_CONFIG_LINK:
@@ -1782,6 +1778,8 @@ sysfs_mbox_read(struct kobject *kobj, st
 				spin_unlock_irq(&phba->hbalock);
 				return -EPERM;
 			}
+		case MBX_WRITE_NV:
+		case MBX_WRITE_VPARMS:
 		case MBX_LOAD_SM:
 		case MBX_READ_NV:
 		case MBX_READ_CONFIG:
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2007-10-19 09:09:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2007-10-27 13:11:06.000000000 -0400
@@ -243,16 +243,17 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 	raw_index = phba->hbq_get[i];
 	getidx = le32_to_cpu(raw_index);
 	len +=  snprintf(buf+len, size-len,
-		"entrys:%d Put:%d nPut:%d localGet:%d hbaGet:%d\n",
-		hbqs->entry_count, hbqs->hbqPutIdx, hbqs->next_hbqPutIdx,
-		hbqs->local_hbqGetIdx, getidx);
+		"entrys:%d bufcnt:%d Put:%d nPut:%d localGet:%d hbaGet:%d\n",
+		hbqs->entry_count, hbqs->buffer_count, hbqs->hbqPutIdx,
+		hbqs->next_hbqPutIdx, hbqs->local_hbqGetIdx, getidx);
 
 	hbqe = (struct lpfc_hbq_entry *) phba->hbqs[i].hbq_virt;
 	for (j=0; j<hbqs->entry_count; j++) {
 		len +=  snprintf(buf+len, size-len,
 			"%03d: %08x %04x %05x ", j,
-			hbqe->bde.addrLow, hbqe->bde.tus.w, hbqe->buffer_tag);
-
+			le32_to_cpu(hbqe->bde.addrLow),
+			le32_to_cpu(hbqe->bde.tus.w),
+			le32_to_cpu(hbqe->buffer_tag));
 		i = 0;
 		found = 0;
 
@@ -276,7 +277,7 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 		list_for_each_entry(d_buf, &hbqs->hbq_buffer_list, list) {
 			hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 			phys = ((uint64_t)hbq_buf->dbuf.phys & 0xffffffff);
-			if (phys == hbqe->bde.addrLow) {
+			if (phys == le32_to_cpu(hbqe->bde.addrLow)) {
 				len +=  snprintf(buf+len, size-len,
 					"Buf%d: %p %06x\n", i,
 					hbq_buf->dbuf.virt, hbq_buf->tag);
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2007-10-27 13:06:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2007-10-27 13:11:06.000000000 -0400
@@ -91,6 +91,7 @@ struct lpfc_nodelist {
 #define NLP_LOGO_SND       0x100	/* sent LOGO request for this entry */
 #define NLP_RNID_SND       0x400	/* sent RNID request for this entry */
 #define NLP_ELS_SND_MASK   0x7e0	/* sent ELS request for this entry */
+#define NLP_DEFER_RM       0x10000	/* Remove this ndlp if no longer used */
 #define NLP_DELAY_TMO      0x20000	/* delay timeout is running for node */
 #define NLP_NPR_2B_DISC    0x40000	/* node is included in num_disc_nodes */
 #define NLP_RCV_PLOGI      0x80000	/* Rcv'ed PLOGI from remote system */
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-10-27 13:07:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-10-27 13:11:06.000000000 -0400
@@ -2069,9 +2069,25 @@ int
 lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 {
 	struct lpfc_dmabuf *buf_ptr, *buf_ptr1;
+	struct lpfc_nodelist *ndlp;
 
-	if (elsiocb->context1) {
-		lpfc_nlp_put(elsiocb->context1);
+	ndlp = (struct lpfc_nodelist *)elsiocb->context1;
+	if (ndlp) {
+		if (ndlp->nlp_flag & NLP_DEFER_RM) {
+			lpfc_nlp_put(ndlp);
+
+			/* If the ndlp is not being used by another discovery
+			 * thread, free it.
+			 */
+			if (!lpfc_nlp_not_used(ndlp)) {
+				/* If ndlp is being used by another discovery
+				 * thread, just clear NLP_DEFER_RM
+				 */
+				ndlp->nlp_flag &= ~NLP_DEFER_RM;
+			}
+		}
+		else
+			lpfc_nlp_put(ndlp);
 		elsiocb->context1 = NULL;
 	}
 	/* context2  = cmd,  context2->next = rsp, context3 = bpl */
@@ -2130,13 +2146,15 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
-	lpfc_nlp_put(ndlp);
+	if (ndlp) {
+		lpfc_nlp_put(ndlp);
 
-	/* This is the end of the default RPI cleanup logic for this
-	 * ndlp. If no other discovery threads are using this ndlp.
-	 * we should free all resources associated with it.
-	 */
-	lpfc_nlp_not_used(ndlp);
+		/* This is the end of the default RPI cleanup logic for this
+		 * ndlp. If no other discovery threads are using this ndlp.
+		 * we should free all resources associated with it.
+		 */
+		lpfc_nlp_not_used(ndlp);
+	}
 	return;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-10-27 10:37:26.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-10-27 13:11:06.000000000 -0400
@@ -367,6 +367,7 @@ struct lpfc_vport {
 
 struct hbq_s {
 	uint16_t entry_count;	  /* Current number of HBQ slots */
+	uint16_t buffer_count;	  /* Current number of buffers posted */
 	uint32_t next_hbqPutIdx;  /* Index to next HBQ slot to use */
 	uint32_t hbqPutIdx;	  /* HBQ slot to use */
 	uint32_t local_hbqGetIdx; /* Local copy of Get index from Port */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-10-27 13:06:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-10-27 13:11:06.000000000 -0400
@@ -108,6 +108,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 	struct lpfc_vport *vport;
 	struct lpfc_hba   *phba;
 	struct lpfc_work_evt *evtp;
+	int  put_node;
+	int  put_rport;
 
 	rdata = rport->dd_data;
 	ndlp = rdata->pnode;
@@ -128,6 +130,25 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 		"rport devlosscb: sid:x%x did:x%x flg:x%x",
 		ndlp->nlp_sid, ndlp->nlp_DID, ndlp->nlp_flag);
 
+	/* Don't defer this if we are in the process of deleting the vport
+	 * or unloading the driver. The unload will cleanup the node
+	 * appropriately we just need to cleanup the ndlp rport info here.
+	 */
+	if (vport->load_flag & FC_UNLOADING) {
+		put_node = rdata->pnode != NULL;
+		put_rport = ndlp->rport != NULL;
+		rdata->pnode = NULL;
+		ndlp->rport = NULL;
+		if (put_node)
+			lpfc_nlp_put(ndlp);
+		if (put_rport)
+			put_device(&rport->dev);
+		return;
+	}
+
+	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
+		return;
+
 	evtp = &ndlp->dev_loss_evt;
 
 	if (!list_empty(&evtp->evt_listp))
@@ -175,8 +196,23 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 		"rport devlosstmo:did:x%x type:x%x id:x%x",
 		ndlp->nlp_DID, ndlp->nlp_type, rport->scsi_target_id);
 
-	if (!(vport->load_flag & FC_UNLOADING) &&
-	    ndlp->nlp_state == NLP_STE_MAPPED_NODE)
+	/* Don't defer this if we are in the process of deleting the vport
+	 * or unloading the driver. The unload will cleanup the node
+	 * appropriately we just need to cleanup the ndlp rport info here.
+	 */
+	if (vport->load_flag & FC_UNLOADING) {
+		put_node = rdata->pnode != NULL;
+		put_rport = ndlp->rport != NULL;
+		rdata->pnode = NULL;
+		ndlp->rport = NULL;
+		if (put_node)
+			lpfc_nlp_put(ndlp);
+		if (put_rport)
+			put_device(&rport->dev);
+		return;
+	}
+
+	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
 		return;
 
 	if (ndlp->nlp_type & NLP_FABRIC) {
@@ -1965,12 +2001,39 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 static void
 lpfc_nlp_remove(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
+	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_rport_data *rdata;
+	LPFC_MBOXQ_t *mbox;
+	int rc;
 
 	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
 		lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	}
 
+	if (ndlp->nlp_flag & NLP_DEFER_RM && !ndlp->nlp_rpi) {
+		/* For this case we need to cleanup the default rpi
+		 * allocated by the firmware.
+		 */
+		if ((mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL))
+			!= NULL) {
+			rc = lpfc_reg_login(phba, vport->vpi, ndlp->nlp_DID,
+			    (uint8_t *) &vport->fc_sparam, mbox, 0);
+			if (rc) {
+				mempool_free(mbox, phba->mbox_mem_pool);
+			}
+			else {
+				mbox->mbox_flag |= LPFC_MBX_IMED_UNREG;
+				mbox->mbox_cmpl = lpfc_mbx_cmpl_dflt_rpi;
+				mbox->vport = vport;
+				mbox->context2 = 0;
+				rc =lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+				if (rc == MBX_NOT_FINISHED) {
+					mempool_free(mbox, phba->mbox_mem_pool);
+				}
+			}
+		}
+	}
+
 	lpfc_cleanup_node(vport, ndlp);
 
 	/*
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2007-10-27 10:37:26.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2007-10-27 13:11:06.000000000 -0400
@@ -153,11 +153,7 @@ struct lpfc_sli_ct_request {
 		struct gff_acc {
 			uint8_t fbits[128];
 		} gff_acc;
-#ifdef __BIG_ENDIAN_BITFIELD
 #define FCP_TYPE_FEATURE_OFFSET 7
-#else	/*  __LITTLE_ENDIAN_BITFIELD */
-#define FCP_TYPE_FEATURE_OFFSET 4
-#endif
 		struct rff {
 			uint32_t PortId;
 			uint8_t reserved[2];
@@ -1288,8 +1284,9 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_KILL_BOARD      0x24
 #define MBX_CONFIG_FARP     0x25
 #define MBX_BEACON          0x2A
-#define MBX_ASYNCEVT_ENABLE 0x33
 #define MBX_HEARTBEAT       0x31
+#define MBX_WRITE_VPARMS    0x32
+#define MBX_ASYNCEVT_ENABLE 0x33
 
 #define MBX_CONFIG_HBQ	    0x7C
 #define MBX_LOAD_AREA       0x81
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 13:06:59.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-10-27 13:11:06.000000000 -0400
@@ -1339,6 +1339,7 @@ lpfc_cleanup(struct lpfc_vport *vport)
 {
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nodelist *ndlp, *next_ndlp;
+	int i = 0;
 
 	if (phba->link_state > LPFC_LINK_DOWN)
 		lpfc_port_link_failure(vport);
@@ -1351,17 +1352,20 @@ lpfc_cleanup(struct lpfc_vport *vport)
 					     NLP_EVT_DEVICE_RM);
 	}
 
-	/* At this point, ALL ndlp's should be gone */
+	/* At this point, ALL ndlp's should be gone
+	 * because of the previous NLP_EVT_DEVICE_RM.
+	 * Lets wait for this to happen, if needed.
+	 */
 	while (!list_empty(&vport->fc_nodes)) {
 
-		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
-			nlp_listp) {
+		if (i++ > 3000) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
-				"0233 Nodelist x%x not free: %d\n",
-				ndlp->nlp_DID,
-				atomic_read(&ndlp->kref.refcount));
-			lpfc_drop_node(vport, ndlp);
+				"0233 Nodelist not empty\n");
+			break;
 		}
+
+		/* Wait for any activity on ndlps to settle */
+		msleep(10);
 	}
 	return;
 }
@@ -1499,6 +1503,8 @@ lpfc_offline_prep(struct lpfc_hba * phba
 		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
 			struct Scsi_Host *shost;
 
+			if (vports[i]->load_flag & FC_UNLOADING)
+				continue;
 			shost =	lpfc_shost_from_vport(vports[i]);
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						 &vports[i]->fc_nodes,
@@ -1771,6 +1777,8 @@ void lpfc_host_attrib_init(struct Scsi_H
 	fc_host_supported_speeds(shost) = 0;
 	if (phba->lmt & LMT_10Gb)
 		fc_host_supported_speeds(shost) |= FC_PORTSPEED_10GBIT;
+	if (phba->lmt & LMT_8Gb)
+		fc_host_supported_speeds(shost) |= FC_PORTSPEED_8GBIT;
 	if (phba->lmt & LMT_4Gb)
 		fc_host_supported_speeds(shost) |= FC_PORTSPEED_4GBIT;
 	if (phba->lmt & LMT_2Gb)
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-10-27 13:07:36.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-10-27 13:11:06.000000000 -0400
@@ -287,6 +287,24 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	lp = (uint32_t *) pcmd->virt;
 	sp = (struct serv_parm *) ((uint8_t *) lp + sizeof (uint32_t));
+	if (wwn_to_u64(sp->portName.u.wwn) == 0) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "0140 PLOGI Reject: invalid nname\n");
+		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
+		stat.un.b.lsRjtRsnCodeExp = LSEXP_INVALID_PNAME;
+		lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp,
+			NULL);
+		return 0;
+	}
+	if (wwn_to_u64(sp->nodeName.u.wwn) == 0) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "0141 PLOGI Reject: invalid pname\n");
+		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
+		stat.un.b.lsRjtRsnCodeExp = LSEXP_INVALID_NNAME;
+		lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp,
+			NULL);
+		return 0;
+	}
 	if ((lpfc_check_sparm(vport, ndlp, sp, CLASS3) == 0)) {
 		/* Reject this request because invalid parameters */
 		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
@@ -821,6 +839,12 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 
 	lp = (uint32_t *) prsp->virt;
 	sp = (struct serv_parm *) ((uint8_t *) lp + sizeof (uint32_t));
+	if (wwn_to_u64(sp->portName.u.wwn) == 0 ||
+	    wwn_to_u64(sp->nodeName.u.wwn) == 0) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+				 "0142 PLOGI RSP: Invalid WWN.\n");
+		goto out;
+	}
 	if (!lpfc_check_sparm(vport, ndlp, sp, CLASS3))
 		goto out;
 	/* PLOGI chkparm OK */
@@ -906,9 +930,7 @@ out:
 				 "0261 Cannot Register NameServer login\n");
 	}
 
-	/* Free this node since the driver cannot login or has the wrong
-	   sparm */
-	lpfc_nlp_not_used(ndlp);
+	ndlp->nlp_flag |= NLP_DEFER_RM;
 	return NLP_STE_FREED_NODE;
 }
 
@@ -1795,7 +1817,7 @@ lpfc_cmpl_plogi_npr_node(struct lpfc_vpo
 
 	irsp = &rspiocb->iocb;
 	if (irsp->ulpStatus) {
-		lpfc_nlp_not_used(ndlp);
+		ndlp->nlp_flag |= NLP_DEFER_RM;
 		return NLP_STE_FREED_NODE;
 	}
 	return ndlp->nlp_state;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-10-27 10:45:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-10-27 13:11:06.000000000 -0400
@@ -540,6 +540,7 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba
 			list_del(&hbq_buf->dbuf.list);
 			(phba->hbqs[i].hbq_free_buffer)(phba, hbq_buf);
 		}
+		phba->hbqs[i].buffer_count = 0;
 	}
 }
 
@@ -608,8 +609,8 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hb
 		return 0;
 	}
 
-	start = lpfc_hbq_defs[hbqno]->buffer_count;
-	end = count + lpfc_hbq_defs[hbqno]->buffer_count;
+	start = phba->hbqs[hbqno].buffer_count;
+	end = count + start;
 	if (end > lpfc_hbq_defs[hbqno]->entry_count) {
 		end = lpfc_hbq_defs[hbqno]->entry_count;
 	}
@@ -621,7 +622,7 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hb
 			return 1;
 		hbq_buffer->tag = (i | (hbqno << 16));
 		if (lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer))
-			lpfc_hbq_defs[hbqno]->buffer_count++;
+			phba->hbqs[hbqno].buffer_count++;
 		else
 			(phba->hbqs[hbqno].hbq_free_buffer)(phba, hbq_buffer);
 	}
@@ -661,7 +662,7 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *ph
 	}
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI | LOG_VPORT,
 			"1803 Bad hbq tag. Data: x%x x%x\n",
-			tag, lpfc_hbq_defs[tag >> 16]->buffer_count);
+			tag, phba->hbqs[tag >> 16].buffer_count);
 	return NULL;
 }
 
@@ -687,6 +688,7 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_LOAD_SM:
 	case MBX_READ_NV:
 	case MBX_WRITE_NV:
+	case MBX_WRITE_VPARMS:
 	case MBX_RUN_BIU_DIAG:
 	case MBX_INIT_LINK:
 	case MBX_DOWN_LINK:


