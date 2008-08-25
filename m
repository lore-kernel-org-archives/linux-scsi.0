From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 8/15] lpfc 8.2.8 : Miscellaneous Bug Fixes
Date: Sun, 24 Aug 2008 21:50:00 -0400
Message-ID: <1219629000.7890.35.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52485 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbYHYBt6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:49:58 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1nvKQ019974
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:49:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous Fixes:
- Fix the wrong variable name used for checking node active usage status
- Fix numerous duplicate log message numbers
- Fix change KERN_WARNING messages to KERN_INFO.
- Stop sending erroneous LOGO to fabric after vport is already terminated
- Fix HBQ allocates that were kalloc'ing w/ GFP_KERNEL while holding a lock.
- Fix gcc 4.3.2 compiler warnings and a sparse warning
- Fix bugs in handling unsolicited ct event queue
- Reorder some of the initial link up checks, to remove odd VPI states.
- Correct poor VPI handling
- Add debug messages
- Expand Update_CFG mailbox definition
- Fix handling of VPD data offsets
- Reorder loopback flags
- convert to use offsetof()	


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    2 -
 lpfc_attr.c      |   32 +++++++---------
 lpfc_crtn.h      |    2 -
 lpfc_ct.c        |   15 +++----
 lpfc_debugfs.c   |   20 +++++-----
 lpfc_els.c       |   87 +++++++++++++++++++++++----------------------
 lpfc_hbadisc.c   |   18 +++++++--
 lpfc_hw.h        |   31 ++++++++++++++++
 lpfc_init.c      |   30 ++++++---------
 lpfc_nportdisc.c |    9 +++-
 lpfc_scsi.c      |    6 +--
 lpfc_sli.c       |  105 ++++++++++++++++++++++++++++++++-----------------------
 lpfc_vport.c     |   14 +++++--
 13 files changed, 219 insertions(+), 152 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-08-24 18:58:43.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-08-24 20:43:31.000000000 -0400
@@ -1302,7 +1302,7 @@ lpfc_##attr##_init(struct lpfc_vport *vp
 		return 0;\
 	}\
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT, \
-			 "0449 lpfc_"#attr" attribute cannot be set to %d, "\
+			 "0423 lpfc_"#attr" attribute cannot be set to %d, "\
 			 "allowed range is ["#minval", "#maxval"]\n", val); \
 	vport->cfg_##attr = default;\
 	return -EINVAL;\
@@ -1334,7 +1334,7 @@ lpfc_##attr##_set(struct lpfc_vport *vpo
 		return 0;\
 	}\
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT, \
-			 "0450 lpfc_"#attr" attribute cannot be set to %d, "\
+			 "0424 lpfc_"#attr" attribute cannot be set to %d, "\
 			 "allowed range is ["#minval", "#maxval"]\n", val); \
 	return -EINVAL;\
 }
@@ -1803,7 +1803,7 @@ lpfc_nodev_tmo_init(struct lpfc_vport *v
 		vport->cfg_nodev_tmo = vport->cfg_devloss_tmo;
 		if (val != LPFC_DEF_DEVLOSS_TMO)
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "0402 Ignoring nodev_tmo module "
+					 "0407 Ignoring nodev_tmo module "
 					 "parameter because devloss_tmo is "
 					 "set.\n");
 		return 0;
@@ -2030,7 +2030,7 @@ lpfc_restrict_login_init(struct lpfc_vpo
 {
 	if (val < 0 || val > 1) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				 "0449 lpfc_restrict_login attribute cannot "
+				 "0422 lpfc_restrict_login attribute cannot "
 				 "be set to %d, allowed range is [0, 1]\n",
 				 val);
 		vport->cfg_restrict_login = 1;
@@ -2065,7 +2065,7 @@ lpfc_restrict_login_set(struct lpfc_vpor
 {
 	if (val < 0 || val > 1) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				 "0450 lpfc_restrict_login attribute cannot "
+				 "0425 lpfc_restrict_login attribute cannot "
 				 "be set to %d, allowed range is [0, 1]\n",
 				 val);
 		vport->cfg_restrict_login = 1;
@@ -2249,7 +2249,7 @@ lpfc_link_speed_init(struct lpfc_hba *ph
 		return 0;
 	}
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"0454 lpfc_link_speed attribute cannot "
+			"0405 lpfc_link_speed attribute cannot "
 			"be set to %d, allowed values are "
 			"["LPFC_LINK_SPEED_STRING"]\n", val);
 	phba->cfg_link_speed = 0;
@@ -2787,17 +2787,15 @@ sysfs_mbox_read(struct kobject *kobj, st
 		/* If HBA encountered an error attention, allow only DUMP
 		 * or RESTART mailbox commands until the HBA is restarted.
 		 */
-		if ((phba->pport->stopped) &&
-			(phba->sysfs_mbox.mbox->mb.mbxCommand !=
-				MBX_DUMP_MEMORY &&
-			 phba->sysfs_mbox.mbox->mb.mbxCommand !=
-				MBX_RESTART &&
-			 phba->sysfs_mbox.mbox->mb.mbxCommand !=
-				MBX_WRITE_VPARMS)) {
-			sysfs_mbox_idle(phba);
-			spin_unlock_irq(&phba->hbalock);
-			return -EPERM;
-		}
+		if (phba->pport->stopped &&
+		    phba->sysfs_mbox.mbox->mb.mbxCommand != MBX_DUMP_MEMORY &&
+		    phba->sysfs_mbox.mbox->mb.mbxCommand != MBX_RESTART &&
+		    phba->sysfs_mbox.mbox->mb.mbxCommand != MBX_WRITE_VPARMS &&
+		    phba->sysfs_mbox.mbox->mb.mbxCommand != MBX_WRITE_WWN)
+			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
+					"1259 mbox: Issued mailbox cmd "
+					"0x%x while in stopped state.\n",
+					phba->sysfs_mbox.mbox->mb.mbxCommand);
 
 		phba->sysfs_mbox.mbox->vport = vport;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2008-06-30 09:31:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2008-08-24 20:43:45.000000000 -0400
@@ -269,7 +269,7 @@ void lpfc_dev_loss_tmo_callbk(struct fc_
 
 struct lpfc_vport *lpfc_create_port(struct lpfc_hba *, int, struct device *);
 int  lpfc_vport_disable(struct fc_vport *fc_vport, bool disable);
-void lpfc_mbx_unreg_vpi(struct lpfc_vport *);
+int lpfc_mbx_unreg_vpi(struct lpfc_vport *);
 void destroy_port(struct lpfc_vport *);
 int lpfc_get_instance(void);
 void lpfc_host_attrib_init(struct Scsi_Host *);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-08-24 20:41:44.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-08-24 20:43:45.000000000 -0400
@@ -134,25 +134,24 @@ lpfc_ct_unsol_event(struct lpfc_hba *phb
 		}
 		list_del(&head);
 	} else {
-		struct lpfc_iocbq  *next;
-
-		list_for_each_entry_safe(iocbq, next, &piocbq->list, list) {
+		INIT_LIST_HEAD(&head);
+		list_add_tail(&head, &piocbq->list);
+		list_for_each_entry(iocbq, &head, list) {
 			icmd = &iocbq->iocb;
 			if (icmd->ulpBdeCount == 0)
-				lpfc_ct_unsol_buffer(phba, piocbq, NULL, 0);
+				lpfc_ct_unsol_buffer(phba, iocbq, NULL, 0);
 			for (i = 0; i < icmd->ulpBdeCount; i++) {
 				paddr = getPaddr(icmd->un.cont64[i].addrHigh,
 						 icmd->un.cont64[i].addrLow);
 				mp = lpfc_sli_ringpostbuf_get(phba, pring,
 							      paddr);
 				size = icmd->un.cont64[i].tus.f.bdeSize;
-				lpfc_ct_unsol_buffer(phba, piocbq, mp, size);
+				lpfc_ct_unsol_buffer(phba, iocbq, mp, size);
 				lpfc_in_buf_free(phba, mp);
 			}
-			list_del(&iocbq->list);
-			lpfc_sli_release_iocbq(phba, iocbq);
 			lpfc_post_buffer(phba, pring, i);
 		}
+		list_del(&head);
 	}
 }
 
@@ -861,7 +860,7 @@ lpfc_cmpl_ct(struct lpfc_hba *phba, stru
 
 		retry++;
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-				 "0216 Retrying NS cmd %x\n", cmdcode);
+				 "0250 Retrying NS cmd %x\n", cmdcode);
 		rc = lpfc_ns_cmd(vport, cmdcode, retry, 0);
 		if (rc == 0)
 			goto out;
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2008-08-24 20:41:07.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2008-08-24 20:43:16.000000000 -0400
@@ -1120,7 +1120,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 		atomic_set(&lpfc_debugfs_hba_count, 0);
 		if (!lpfc_debugfs_root) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "0409 Cannot create debugfs root\n");
+					 "0408 Cannot create debugfs root\n");
 			goto debug_failed;
 		}
 	}
@@ -1134,7 +1134,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 			debugfs_create_dir(name, lpfc_debugfs_root);
 		if (!phba->hba_debugfs_root) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "0409 Cannot create debugfs hba\n");
+					 "0412 Cannot create debugfs hba\n");
 			goto debug_failed;
 		}
 		atomic_inc(&lpfc_debugfs_hba_count);
@@ -1148,7 +1148,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 				 phba, &lpfc_debugfs_op_hbqinfo);
 		if (!phba->debug_hbqinfo) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				"0409 Cannot create debugfs hbqinfo\n");
+				"0411 Cannot create debugfs hbqinfo\n");
 			goto debug_failed;
 		}
 
@@ -1160,7 +1160,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 				 phba, &lpfc_debugfs_op_dumpHBASlim);
 		if (!phba->debug_dumpHBASlim) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				"0409 Cannot create debugfs dumpHBASlim\n");
+				"0413 Cannot create debugfs dumpHBASlim\n");
 			goto debug_failed;
 		}
 
@@ -1172,7 +1172,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 				 phba, &lpfc_debugfs_op_dumpHostSlim);
 		if (!phba->debug_dumpHostSlim) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				"0409 Cannot create debugfs dumpHostSlim\n");
+				"0414 Cannot create debugfs dumpHostSlim\n");
 			goto debug_failed;
 		}
 
@@ -1202,7 +1202,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 				 phba, &lpfc_debugfs_op_slow_ring_trc);
 		if (!phba->debug_slow_ring_trc) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "0409 Cannot create debugfs "
+					 "0415 Cannot create debugfs "
 					 "slow_ring_trace\n");
 			goto debug_failed;
 		}
@@ -1213,7 +1213,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 				GFP_KERNEL);
 			if (!phba->slow_ring_trc) {
 				lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-						 "0409 Cannot create debugfs "
+						 "0416 Cannot create debugfs "
 						 "slow_ring buffer\n");
 				goto debug_failed;
 			}
@@ -1230,7 +1230,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 			debugfs_create_dir(name, phba->hba_debugfs_root);
 		if (!vport->vport_debugfs_root) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "0409 Cant create debugfs");
+					 "0417 Cant create debugfs");
 			goto debug_failed;
 		}
 		atomic_inc(&phba->debugfs_vport_count);
@@ -1259,7 +1259,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 
 	if (!vport->disc_trc) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				 "0409 Cannot create debugfs disc trace "
+				 "0418 Cannot create debugfs disc trace "
 				 "buffer\n");
 		goto debug_failed;
 	}
@@ -1272,7 +1272,7 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 				 vport, &lpfc_debugfs_op_disc_trc);
 	if (!vport->debug_disc_trc) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				 "0409 Cannot create debugfs "
+				 "0419 Cannot create debugfs "
 				 "discovery_trace\n");
 		goto debug_failed;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-08-24 20:41:44.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-08-24 20:43:45.000000000 -0400
@@ -473,7 +473,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 		 */
 		list_for_each_entry_safe(np, next_np,
 					&vport->fc_nodes, nlp_listp) {
-			if (!NLP_CHK_NODE_ACT(ndlp))
+			if (!NLP_CHK_NODE_ACT(np))
 				continue;
 			if ((np->nlp_state != NLP_STE_NPR_NODE) ||
 				   !(np->nlp_flag & NLP_NPR_ADISC))
@@ -2585,7 +2585,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 			  (stat.un.b.lsRjtRsnCodeExp == LSEXP_INVALID_NPORT_ID))
 			  ) {
 				lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-						 "0123 FDISC Failed (x%x). "
+						 "0122 FDISC Failed (x%x). "
 						 "Fabric Detected Bad WWN\n",
 						 stat.un.lsRjtError);
 				lpfc_vport_set_state(vport,
@@ -3966,7 +3966,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 		if (rscn_id == hba_id) {
 			/* ALL NPortIDs in RSCN are on HBA */
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-					 "0214 Ignore RSCN "
+					 "0219 Ignore RSCN "
 					 "Data: x%x x%x x%x x%x\n",
 					 vport->fc_flag, payload_len,
 					 *lp, vport->fc_rscn_id_cnt);
@@ -5165,8 +5165,6 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 	}
 
 	phba->fc_stat.elsRcvFrame++;
-	if (elsiocb->context1)
-		lpfc_nlp_put(elsiocb->context1);
 
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	elsiocb->vport = vport;
@@ -5376,6 +5374,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 			NULL);
 	}
 
+	lpfc_nlp_put(elsiocb->context1);
+	elsiocb->context1 = NULL;
 	return;
 
 dropit:
@@ -5440,6 +5440,7 @@ lpfc_els_unsol_event(struct lpfc_hba *ph
 	struct lpfc_dmabuf *bdeBuf1 = elsiocb->context2;
 	struct lpfc_dmabuf *bdeBuf2 = elsiocb->context3;
 
+	elsiocb->context1 = NULL;
 	elsiocb->context2 = NULL;
 	elsiocb->context3 = NULL;
 
@@ -5487,8 +5488,6 @@ lpfc_els_unsol_event(struct lpfc_hba *ph
 	 * The different unsolicited event handlers would tell us
 	 * if they are done with "mp" by setting context2 to NULL.
 	 */
-	lpfc_nlp_put(elsiocb->context1);
-	elsiocb->context1 = NULL;
 	if (elsiocb->context2) {
 		lpfc_in_buf_free(phba, (struct lpfc_dmabuf *)elsiocb->context2);
 		elsiocb->context2 = NULL;
@@ -5750,54 +5749,56 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 			goto out;
 		/* FDISC failed */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-				 "0124 FDISC failed. (%d/%d)\n",
+				 "0126 FDISC failed. (%d/%d)\n",
 				 irsp->ulpStatus, irsp->un.ulpWord[4]);
+		goto fdisc_failed;
+	}
 		if (vport->fc_vport->vport_state == FC_VPORT_INITIALIZING)
 			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		lpfc_nlp_put(ndlp);
 		/* giving up on FDISC. Cancel discovery timer */
 		lpfc_can_disctmo(vport);
-	} else {
-		spin_lock_irq(shost->host_lock);
-		vport->fc_flag |= FC_FABRIC;
-		if (vport->phba->fc_topology == TOPOLOGY_LOOP)
-			vport->fc_flag |=  FC_PUBLIC_LOOP;
-		spin_unlock_irq(shost->host_lock);
+	spin_lock_irq(shost->host_lock);
+	vport->fc_flag |= FC_FABRIC;
+	if (vport->phba->fc_topology == TOPOLOGY_LOOP)
+		vport->fc_flag |=  FC_PUBLIC_LOOP;
+	spin_unlock_irq(shost->host_lock);
 
-		vport->fc_myDID = irsp->un.ulpWord[4] & Mask_DID;
-		lpfc_vport_set_state(vport, FC_VPORT_ACTIVE);
-		if ((vport->fc_prevDID != vport->fc_myDID) &&
-			!(vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)) {
-			/* If our NportID changed, we need to ensure all
-			 * remaining NPORTs get unreg_login'ed so we can
-			 * issue unreg_vpi.
-			 */
-			list_for_each_entry_safe(np, next_np,
-				&vport->fc_nodes, nlp_listp) {
-				if (!NLP_CHK_NODE_ACT(ndlp) ||
-				    (np->nlp_state != NLP_STE_NPR_NODE) ||
-				    !(np->nlp_flag & NLP_NPR_ADISC))
-					continue;
-				spin_lock_irq(shost->host_lock);
-				np->nlp_flag &= ~NLP_NPR_ADISC;
-				spin_unlock_irq(shost->host_lock);
-				lpfc_unreg_rpi(vport, np);
-			}
-			lpfc_mbx_unreg_vpi(vport);
+	vport->fc_myDID = irsp->un.ulpWord[4] & Mask_DID;
+	lpfc_vport_set_state(vport, FC_VPORT_ACTIVE);
+	if ((vport->fc_prevDID != vport->fc_myDID) &&
+		!(vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)) {
+		/* If our NportID changed, we need to ensure all
+		 * remaining NPORTs get unreg_login'ed so we can
+		 * issue unreg_vpi.
+		 */
+		list_for_each_entry_safe(np, next_np,
+			&vport->fc_nodes, nlp_listp) {
+			if (!NLP_CHK_NODE_ACT(ndlp) ||
+			    (np->nlp_state != NLP_STE_NPR_NODE) ||
+			    !(np->nlp_flag & NLP_NPR_ADISC))
+				continue;
 			spin_lock_irq(shost->host_lock);
-			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+			np->nlp_flag &= ~NLP_NPR_ADISC;
 			spin_unlock_irq(shost->host_lock);
+			lpfc_unreg_rpi(vport, np);
 		}
-
-		if (vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)
-			lpfc_register_new_vport(phba, vport, ndlp);
-		else
-			lpfc_do_scr_ns_plogi(phba, vport);
-
-		/* Unconditionaly kick off releasing fabric node for vports */
-		lpfc_nlp_put(ndlp);
+		lpfc_mbx_unreg_vpi(vport);
+		spin_lock_irq(shost->host_lock);
+		vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
+		spin_unlock_irq(shost->host_lock);
 	}
 
+	if (vport->fc_flag & FC_VPORT_NEEDS_REG_VPI)
+		lpfc_register_new_vport(phba, vport, ndlp);
+	else
+		lpfc_do_scr_ns_plogi(phba, vport);
+	goto out;
+fdisc_failed:
+	lpfc_vport_set_state(vport, FC_VPORT_FAILED);
+	/* Cancel discovery timer */
+	lpfc_can_disctmo(vport);
+	lpfc_nlp_put(ndlp);
 out:
 	lpfc_els_free_iocb(phba, cmdiocb);
 }
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-08-24 20:41:07.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2008-08-24 20:44:33.000000000 -0400
@@ -499,7 +499,7 @@ struct lpfc_hba {
 
 	wait_queue_head_t    work_waitq;
 	struct task_struct   *worker_thread;
-	long data_flags;
+	unsigned long data_flags;
 
 	uint32_t hbq_in_use;		/* HBQs in use flag */
 	struct list_head hbqbuf_in_list;  /* in-fly hbq buffer list */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-06-30 09:31:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-08-24 20:43:45.000000000 -0400
@@ -215,8 +215,16 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 		return;
 	}
 
-	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
+	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "0284 Devloss timeout Ignored on "
+				 "WWPN %x:%x:%x:%x:%x:%x:%x:%x "
+				 "NPort x%x\n",
+				 *name, *(name+1), *(name+2), *(name+3),
+				 *(name+4), *(name+5), *(name+6), *(name+7),
+				 ndlp->nlp_DID);
 		return;
+	}
 
 	if (ndlp->nlp_type & NLP_FABRIC) {
 		/* We will clean up these Nodes in linkup */
@@ -1177,7 +1185,7 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba 
 		scsi_host_put(shost);
 }
 
-void
+int
 lpfc_mbx_unreg_vpi(struct lpfc_vport *vport)
 {
 	struct lpfc_hba  *phba = vport->phba;
@@ -1186,7 +1194,7 @@ lpfc_mbx_unreg_vpi(struct lpfc_vport *vp
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
-		return;
+		return 1;
 
 	lpfc_unreg_vpi(phba, vport->vpi, mbox);
 	mbox->vport = vport;
@@ -1197,7 +1205,9 @@ lpfc_mbx_unreg_vpi(struct lpfc_vport *vp
 				 "1800 Could not issue unreg_vpi\n");
 		mempool_free(mbox, phba->mbox_mem_pool);
 		vport->unreg_vpi_cmpl = VPORT_ERROR;
+		return rc;
 	}
+	return 0;
 }
 
 static void
@@ -2786,7 +2796,7 @@ restart_disc:
 
 	default:
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
-				 "0229 Unexpected discovery timeout, "
+				 "0273 Unexpected discovery timeout, "
 				 "vport State x%x\n", vport->port_state);
 		break;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2008-08-24 20:41:44.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2008-08-24 20:43:45.000000000 -0400
@@ -2318,6 +2318,36 @@ typedef struct {
 #define  DMP_RSP_OFFSET          0x14   /* word 5 contains first word of rsp */
 #define  DMP_RSP_SIZE            0x6C   /* maximum of 27 words of rsp data */
 
+/* Structure for MB Command UPDATE_CFG (0x1B) */
+
+struct update_cfg_var {
+#ifdef __BIG_ENDIAN_BITFIELD
+	uint32_t rsvd2:16;
+	uint32_t type:8;
+	uint32_t rsvd:1;
+	uint32_t ra:1;
+	uint32_t co:1;
+	uint32_t cv:1;
+	uint32_t req:4;
+	uint32_t entry_length:16;
+	uint32_t region_id:16;
+#else  /*  __LITTLE_ENDIAN_BITFIELD */
+	uint32_t req:4;
+	uint32_t cv:1;
+	uint32_t co:1;
+	uint32_t ra:1;
+	uint32_t rsvd:1;
+	uint32_t type:8;
+	uint32_t rsvd2:16;
+	uint32_t region_id:16;
+	uint32_t entry_length:16;
+#endif
+
+	uint32_t resp_info;
+	uint32_t byte_cnt;
+	uint32_t data_offset;
+};
+
 struct hbq_mask {
 #ifdef __BIG_ENDIAN_BITFIELD
 	uint8_t tmatch;
@@ -2672,6 +2702,7 @@ typedef union {
 					 * NEW_FEATURE
 					 */
 	struct config_hbq_var varCfgHbq;/* cmd = 0x7c (CONFIG_HBQ)  */
+	struct update_cfg_var varUpdateCfg; /* cmd = 0x1B (UPDATE_CFG)*/
 	CONFIG_PORT_VAR varCfgPort;	/* cmd = 0x88 (CONFIG_PORT)  */
 	REG_VPI_VAR varRegVpi;		/* cmd = 0x96 (REG_VPI) */
 	UNREG_VPI_VAR varUnregVpi;	/* cmd = 0x97 (UNREG_VPI) */
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 20:41:07.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 20:43:45.000000000 -0400
@@ -183,12 +183,9 @@ lpfc_config_port_prep(struct lpfc_hba *p
 						sizeof (phba->RandomData));
 
 	/* Get adapter VPD information */
-	pmb->context2 = kmalloc(DMP_RSP_SIZE, GFP_KERNEL);
-	if (!pmb->context2)
-		goto out_free_mbox;
 	lpfc_vpd_data = kmalloc(DMP_VPD_SIZE, GFP_KERNEL);
 	if (!lpfc_vpd_data)
-		goto out_free_context2;
+		goto out_free_mbox;
 
 	do {
 		lpfc_dump_mem(phba, pmb, offset);
@@ -203,15 +200,14 @@ lpfc_config_port_prep(struct lpfc_hba *p
 		}
 		if (mb->un.varDmp.word_cnt > DMP_VPD_SIZE - offset)
 			mb->un.varDmp.word_cnt = DMP_VPD_SIZE - offset;
-		lpfc_sli_pcimem_bcopy(pmb->context2, lpfc_vpd_data + offset,
+		lpfc_sli_pcimem_bcopy(((uint8_t *)mb) + DMP_RSP_OFFSET,
+				      lpfc_vpd_data + offset,
 				      mb->un.varDmp.word_cnt);
 		offset += mb->un.varDmp.word_cnt;
 	} while (mb->un.varDmp.word_cnt && offset < DMP_VPD_SIZE);
 	lpfc_parse_vpd(phba, lpfc_vpd_data, offset);
 
 	kfree(lpfc_vpd_data);
-out_free_context2:
-	kfree(pmb->context2);
 out_free_mbox:
 	mempool_free(pmb, phba->mbox_mem_pool);
 	return 0;
@@ -425,9 +421,8 @@ lpfc_config_port_post(struct lpfc_hba *p
 
 	lpfc_init_link(phba, pmb, phba->cfg_topology, phba->cfg_link_speed);
 	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-	pmb->vport = vport;
-	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
 	lpfc_set_loopback_flag(phba);
+	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
 	if (rc != MBX_SUCCESS) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"0454 Adapter failed to init, mbxCmd x%x "
@@ -462,7 +457,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 				rc);
 		mempool_free(pmb, phba->mbox_mem_pool);
 	}
-	return (0);
+	return 0;
 }
 
 /**
@@ -841,7 +836,7 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 		temp_event_data.data = (uint32_t)temperature;
 
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0459 Adapter maximum temperature exceeded "
+				"0406 Adapter maximum temperature exceeded "
 				"(%ld), taking this port offline "
 				"Data: x%x x%x x%x\n",
 				temperature, phba->work_hs,
@@ -1595,7 +1590,7 @@ lpfc_cleanup(struct lpfc_vport *vport)
 						&vport->fc_nodes, nlp_listp) {
 				lpfc_printf_vlog(ndlp->vport, KERN_ERR,
 						LOG_NODE,
-						"0282: did:x%x ndlp:x%p "
+						"0282 did:x%x ndlp:x%p "
 						"usgmap:x%x refcnt:%d\n",
 						ndlp->nlp_DID, (void *)ndlp,
 						ndlp->nlp_usg_map,
@@ -2320,10 +2315,10 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		goto out_iounmap;
 
 	memset(phba->slim2p.virt, 0, SLI2_SLIM_SIZE);
-	phba->mbox = phba->slim2p.virt;
-	phba->pcb = (phba->slim2p.virt + sizeof(MAILBOX_t));
-	phba->IOCBs = (phba->slim2p.virt + sizeof(MAILBOX_t) +
-		       sizeof(struct _PCB));
+	phba->mbox = phba->slim2p.virt + offsetof(struct lpfc_sli2_slim, mbx);
+	phba->pcb = (phba->slim2p.virt + offsetof(struct lpfc_sli2_slim, pcb));
+	phba->IOCBs = (phba->slim2p.virt +
+		       offsetof(struct lpfc_sli2_slim, IOCBs));
 
 	phba->hbqslimp.virt = dma_alloc_coherent(&phba->pcidev->dev,
 						 lpfc_sli_hbq_size(),
@@ -2889,7 +2884,8 @@ lpfc_init(void)
 	error = pci_register_driver(&lpfc_driver);
 	if (error) {
 		fc_release_transport(lpfc_transport_template);
-		fc_release_transport(lpfc_vport_transport_template);
+		if (lpfc_enable_npiv)
+			fc_release_transport(lpfc_vport_transport_template);
 	}
 
 	return error;
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-08-24 20:36:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-08-24 20:43:45.000000000 -0400
@@ -1853,8 +1853,13 @@ static uint32_t
 lpfc_cmpl_logo_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			void *arg, uint32_t evt)
 {
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	if (ndlp->nlp_DID == Fabric_DID) {
+		spin_lock_irq(shost->host_lock);
+		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
+		spin_unlock_irq(shost->host_lock);
+	}
 	lpfc_unreg_rpi(vport, ndlp);
-	/* This routine does nothing, just return the current state */
 	return ndlp->nlp_state;
 }
 
@@ -2143,7 +2148,7 @@ lpfc_disc_state_machine(struct lpfc_vpor
 		lpfc_nlp_put(ndlp);
 	} else {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-			"0212 DSM out state %d on NPort free\n", rc);
+			"0213 DSM out state %d on NPort free\n", rc);
 
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_DSM,
 			"DSM out:         ste:%d did:x%x flg:x%x",
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-08-24 20:41:44.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-08-24 20:44:33.000000000 -0400
@@ -627,9 +627,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			cmd->result = ScsiResult(DID_BUS_BUSY, 0);
 			break;
 		case IOSTAT_LOCAL_REJECT:
-			if (lpfc_cmd->result == RJT_UNAVAIL_PERM ||
+			if (lpfc_cmd->result == IOERR_INVALID_RPI ||
 			    lpfc_cmd->result == IOERR_NO_RESOURCES ||
-			    lpfc_cmd->result == RJT_LOGIN_REQUIRED) {
+			    lpfc_cmd->result == IOERR_ABORT_REQUESTED) {
 				cmd->result = ScsiResult(DID_REQUEUE, 0);
 				break;
 			} /* else: fall through */
@@ -1317,7 +1317,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nodelist *ndlp = NULL;
 	int match;
-	int ret = SUCCESS, status, i;
+	int ret = SUCCESS, status = SUCCESS, i;
 	int cnt;
 	struct lpfc_scsi_buf * lpfc_cmd;
 	unsigned long later;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-08-24 20:41:07.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-08-24 20:44:33.000000000 -0400
@@ -844,48 +844,58 @@ struct lpfc_hbq_init *lpfc_hbq_defs[] = 
  * @hbqno: HBQ number.
  * @count: Number of HBQ buffers to be posted.
  *
- * This function is called with no lock held to post more
- * hbq buffers to the given HBQ. The function returns 0
- * when successful and returns 1 other wise.
+ * This function is called with no lock held to post more hbq buffers to the
+ * given HBQ. The function returns the number of HBQ buffers successfully
+ * posted.
  **/
 static int
 lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, uint32_t hbqno, uint32_t count)
 {
-	uint32_t i, start, end;
+	uint32_t i, posted = 0;
 	unsigned long flags;
 	struct hbq_dmabuf *hbq_buffer;
-
+	LIST_HEAD(hbq_buf_list);
 	if (!phba->hbqs[hbqno].hbq_alloc_buffer)
 		return 0;
 
-	start = phba->hbqs[hbqno].buffer_count;
-	end = count + start;
-	if (end > lpfc_hbq_defs[hbqno]->entry_count)
-		end = lpfc_hbq_defs[hbqno]->entry_count;
-
+	if ((phba->hbqs[hbqno].buffer_count + count) >
+	    lpfc_hbq_defs[hbqno]->entry_count)
+		count = lpfc_hbq_defs[hbqno]->entry_count -
+					phba->hbqs[hbqno].buffer_count;
+	if (!count)
+		return 0;
+	/* Allocate HBQ entries */
+	for (i = 0; i < count; i++) {
+		hbq_buffer = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
+		if (!hbq_buffer)
+			break;
+		list_add_tail(&hbq_buffer->dbuf.list, &hbq_buf_list);
+	}
 	/* Check whether HBQ is still in use */
 	spin_lock_irqsave(&phba->hbalock, flags);
 	if (!phba->hbq_in_use)
-		goto out;
-
-	/* Populate HBQ entries */
-	for (i = start; i < end; i++) {
-		hbq_buffer = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
-		if (!hbq_buffer)
-			goto err;
-		hbq_buffer->tag = (i | (hbqno << 16));
-		if (lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer))
+		goto err;
+	while (!list_empty(&hbq_buf_list)) {
+		list_remove_head(&hbq_buf_list, hbq_buffer, struct hbq_dmabuf,
+				 dbuf.list);
+		hbq_buffer->tag = (phba->hbqs[hbqno].buffer_count |
+				      (hbqno << 16));
+		if (lpfc_sli_hbq_to_firmware(phba, hbqno, hbq_buffer)) {
 			phba->hbqs[hbqno].buffer_count++;
-		else
+			posted++;
+		} else
 			(phba->hbqs[hbqno].hbq_free_buffer)(phba, hbq_buffer);
 	}
-
- out:
 	spin_unlock_irqrestore(&phba->hbalock, flags);
-	return 0;
- err:
+	return posted;
+err:
 	spin_unlock_irqrestore(&phba->hbalock, flags);
-	return 1;
+	while (!list_empty(&hbq_buf_list)) {
+		list_remove_head(&hbq_buf_list, hbq_buffer, struct hbq_dmabuf,
+				 dbuf.list);
+		(phba->hbqs[hbqno].hbq_free_buffer)(phba, hbq_buffer);
+	}
+	return 0;
 }
 
 /**
@@ -894,8 +904,8 @@ lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hb
  * @qno: HBQ number.
  *
  * This function posts more buffers to the HBQ. This function
- * is called with no lock held. The function returns 0 when
- * successful and returns 1 otherwise.
+ * is called with no lock held. The function returns the number of HBQ entries
+ * successfully allocated.
  **/
 int
 lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba *phba, uint32_t qno)
@@ -911,7 +921,7 @@ lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba
  *
  * This function is called from SLI initialization code path with
  * no lock held to post initial HBQ buffers to firmware. The
- * function returns 0 when successful and returns 1 otherwise.
+ * function returns the number of HBQ entries successfully allocated.
  **/
 static int
 lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hba *phba, uint32_t qno)
@@ -1253,7 +1263,9 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
  * This function is called from unsolicited event handler code path to get the
  * HBQ buffer associated with an unsolicited iocb. This function is called with
  * no lock held. It returns the buffer associated with the given tag and posts
- * another buffer to the firmware.
+ * another buffer to the firmware. Note that the new buffer must be allocated
+ * before taking the hbalock and that the hba lock must be held until it is
+ * finished with the hbq entry swap.
  **/
 static struct lpfc_dmabuf *
 lpfc_sli_replace_hbqbuff(struct lpfc_hba *phba, uint32_t tag)
@@ -1264,22 +1276,28 @@ lpfc_sli_replace_hbqbuff(struct lpfc_hba
 	dma_addr_t phys;	/* mapped address */
 	unsigned long flags;
 
+	hbqno = tag >> 16;
+	new_hbq_entry = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
 	/* Check whether HBQ is still in use */
 	spin_lock_irqsave(&phba->hbalock, flags);
 	if (!phba->hbq_in_use) {
+		if (new_hbq_entry)
+			(phba->hbqs[hbqno].hbq_free_buffer)(phba,
+							    new_hbq_entry);
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return NULL;
 	}
 
 	hbq_entry = lpfc_sli_hbqbuf_find(phba, tag);
 	if (hbq_entry == NULL) {
+		if (new_hbq_entry)
+			(phba->hbqs[hbqno].hbq_free_buffer)(phba,
+							    new_hbq_entry);
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return NULL;
 	}
 	list_del(&hbq_entry->dbuf.list);
 
-	hbqno = tag >> 16;
-	new_hbq_entry = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);
 	if (new_hbq_entry == NULL) {
 		list_add_tail(&hbq_entry->dbuf.list, &phba->hbqbuf_in_list);
 		spin_unlock_irqrestore(&phba->hbalock, flags);
@@ -1748,8 +1766,8 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
 					irsp->un.ulpWord[3],
 					irsp->un.ulpWord[4],
 					irsp->un.ulpWord[5],
-					*(((uint32_t *) irsp) + 6),
-					*(((uint32_t *) irsp) + 7));
+					*(uint32_t *)&irsp->un1,
+					*((uint32_t *)&irsp->un1 + 1));
 		}
 
 		switch (type) {
@@ -1935,8 +1953,8 @@ lpfc_sli_handle_fast_ring_event(struct l
 					irsp->un.ulpWord[3],
 					irsp->un.ulpWord[4],
 					irsp->un.ulpWord[5],
-					*(((uint32_t *) irsp) + 6),
-					*(((uint32_t *) irsp) + 7));
+					*(uint32_t *)&irsp->un1,
+					*((uint32_t *)&irsp->un1 + 1));
 		}
 
 		switch (type) {
@@ -2921,10 +2939,8 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	/* Initially populate or replenish the HBQs */
-	for (hbqno = 0; hbqno < hbq_count; ++hbqno) {
-		if (lpfc_sli_hbqbuf_init_hbqs(phba, hbqno))
-			return -ENOMEM;
-	}
+	for (hbqno = 0; hbqno < hbq_count; ++hbqno)
+		lpfc_sli_hbqbuf_init_hbqs(phba, hbqno);
 	return 0;
 }
 
@@ -3034,6 +3050,7 @@ lpfc_do_config_port(struct lpfc_hba *phb
 		phba->port_gp = phba->mbox->us.s2.port;
 		phba->inb_ha_copy = NULL;
 		phba->inb_counter = NULL;
+		phba->max_vpi = 0;
 	}
 do_prep_failed:
 	mempool_free(pmb, phba->mbox_mem_pool);
@@ -4335,7 +4352,7 @@ lpfc_sli_ring_taggedbuf_get(struct lpfc_
 
 	spin_unlock_irq(&phba->hbalock);
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"0410 Cannot find virtual addr for buffer tag on "
+			"0402 Cannot find virtual addr for buffer tag on "
 			"ring %d Data x%lx x%p x%p x%x\n",
 			pring->ringno, (unsigned long) tag,
 			slp->next, slp->prev, pring->postbufq_cnt);
@@ -4482,7 +4499,7 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *ph
 
 	/* ELS cmd tag <ulpIoTag> completes */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"0133 Ignoring ELS cmd tag x%x completion Data: "
+			"0139 Ignoring ELS cmd tag x%x completion Data: "
 			"x%x x%x x%x\n",
 			irsp->ulpIoTag, irsp->ulpStatus,
 			irsp->un.ulpWord[4], irsp->ulpTimeout);
@@ -4568,6 +4585,8 @@ lpfc_sli_issue_abort_iotag(struct lpfc_h
 			 iabt->un.acxri.abortIoTag, abtsiocbp->iotag);
 	retval = __lpfc_sli_issue_iocb(phba, pring, abtsiocbp, 0);
 
+	if (retval)
+		__lpfc_sli_release_iocbq(phba, abtsiocbp);
 abort_iotag_exit:
 	/*
 	 * Caller to this routine should check for IOCB_ERROR
@@ -4899,7 +4918,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 		}
 	} else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-				":0332 IOCB wait issue failed, Data x%x\n",
+				"0332 IOCB wait issue failed, Data x%x\n",
 				retval);
 		retval = IOCB_ERROR;
 	}
@@ -5271,7 +5290,7 @@ lpfc_intr_handler(int irq, void *dev_id)
 							lpfc_printf_log(phba,
 							KERN_ERR,
 							LOG_MBOX | LOG_SLI,
-							"0306 rc should have"
+							"0350 rc should have"
 							"been MBX_BUSY");
 						goto send_current_mbox;
 					}
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2008-08-24 20:36:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2008-08-24 20:44:04.000000000 -0400
@@ -577,8 +577,12 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 	 * initiated after we've disposed of all other resources associated
 	 * with the port.
 	 */
-	if (!scsi_host_get(shost) || !scsi_host_get(shost))
+	if (!scsi_host_get(shost))
 		return VPORT_INVAL;
+	if (!scsi_host_get(shost)) {
+		scsi_host_put(shost);
+		return VPORT_INVAL;
+	}
 	spin_lock_irq(&phba->hbalock);
 	vport->load_flag |= FC_UNLOADING;
 	spin_unlock_irq(&phba->hbalock);
@@ -668,6 +672,8 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 		}
 		vport->unreg_vpi_cmpl = VPORT_INVAL;
 		timeout = msecs_to_jiffies(phba->fc_ratov * 2000);
+		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
+			goto skip_logo;
 		if (!lpfc_issue_els_npiv_logo(vport, ndlp))
 			while (vport->unreg_vpi_cmpl == VPORT_INVAL && timeout)
 				timeout = schedule_timeout(timeout);
@@ -689,8 +695,10 @@ skip_logo:
 		 * Completion of unreg_vpi (lpfc_mbx_cmpl_unreg_vpi)
 		 * does the scsi_host_put() to release the vport.
 		 */
-		lpfc_mbx_unreg_vpi(vport);
-	}
+		if (lpfc_mbx_unreg_vpi(vport))
+			scsi_host_put(shost);
+	} else
+		scsi_host_put(shost);
 
 	lpfc_free_vpi(phba, vport->vpi);
 	vport->work_port_events = 0;


