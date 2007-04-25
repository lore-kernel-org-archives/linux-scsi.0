From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/16] lpfc 8.1.12 : Misc bug fixes and code cleanup
Date: Wed, 25 Apr 2007 09:51:30 -0400
Message-ID: <1177509090.23155.8.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51528 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031005AbXDYNvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:51:22 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDpLYR006456
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:51:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Misc bug fixes and code cleanup:
 - Fix system hang while running on systems with IOMMU
 - Fix use after free issues with rports
 - Don't free mailbox structure if it's still on the mboxq list
 - Decrement txq_cnt rather than txcmplq_cnt when parsing the txq list
 - Use msleep for long delays to prevent soft lockup bug check
 - Don't remove node during dev_loss_tmo if discovery is active
 - Fix memory leaks in get/reset statistics and link attention paths
 - Fixed lpfc_ns_rsp to handle entire GID_FT response.
 - mbox interface should use MAILBOX_CMD_SIZE rather than sizeof(MAILBOX_t)
 - Fixed bug check in add_timer.
 - Fixup messages 0116, 0117, and 0128 to report ELS I/O tag.
 - Remove unused parameter to lpfc_cleanup.
 - Change mailbox timeout handling.
 - Remove unused buflist. Code cleanup.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-04-24 11:12:40.000000000 -0400
@@ -1227,11 +1227,11 @@ sysfs_mbox_read(struct kobject *kobj, ch
 	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
 	int rc;
 
-	if (off > sizeof(MAILBOX_t))
+	if (off > MAILBOX_CMD_SIZE)
 		return -ERANGE;
 
-	if ((count + off) > sizeof(MAILBOX_t))
-		count = sizeof(MAILBOX_t) - off;
+	if ((count + off) > MAILBOX_CMD_SIZE)
+		count = MAILBOX_CMD_SIZE - off;
 
 	if (off % 4 ||  count % 4 || (unsigned long)buf % 4)
 		return -EINVAL;
@@ -1326,6 +1326,11 @@ sysfs_mbox_read(struct kobject *kobj, ch
 		}
 
 		if (rc != MBX_SUCCESS) {
+			if (rc == MBX_TIMEOUT) {
+				phba->sysfs_mbox.mbox->mbox_cmpl =
+					lpfc_sli_def_mbox_cmpl;
+				phba->sysfs_mbox.mbox = NULL;
+			}
 			sysfs_mbox_idle(phba);
 			spin_unlock_irq(host->host_lock);
 			return  (rc == MBX_TIMEOUT) ? -ETIME : -ENODEV;
@@ -1344,7 +1349,7 @@ sysfs_mbox_read(struct kobject *kobj, ch
 
 	phba->sysfs_mbox.offset = off + count;
 
-	if (phba->sysfs_mbox.offset == sizeof(MAILBOX_t))
+	if (phba->sysfs_mbox.offset == MAILBOX_CMD_SIZE)
 		sysfs_mbox_idle(phba);
 
 	spin_unlock_irq(phba->host->host_lock);
@@ -1358,7 +1363,7 @@ static struct bin_attribute sysfs_mbox_a
 		.mode = S_IRUSR | S_IWUSR,
 		.owner = THIS_MODULE,
 	},
-	.size = sizeof(MAILBOX_t),
+	.size = MAILBOX_CMD_SIZE,
 	.read = sysfs_mbox_read,
 	.write = sysfs_mbox_write,
 };
@@ -1631,6 +1636,8 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	else
 		hs->seconds_since_last_reset = seconds - psli->stats_start;
 
+	mempool_free(pmboxq, phba->mbox_mem_pool);
+
 	return hs;
 }
 
@@ -1699,6 +1706,8 @@ lpfc_reset_stats(struct Scsi_Host *shost
 
 	psli->stats_start = get_seconds();
 
+	mempool_free(pmboxq, phba->mbox_mem_pool);
+
 	return;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-04-24 11:12:40.000000000 -0400
@@ -342,9 +342,10 @@ lpfc_ns_rsp(struct lpfc_hba * phba, stru
 
 		Size -= Cnt;
 
-		if (!ctptr)
+		if (!ctptr) {
+			Cnt = FCELSSIZE;
 			ctptr = (uint32_t *) mlast->virt;
-		else
+		} else
 			Cnt -= 16;	/* subtract length of CT header */
 
 		/* Loop through entire NameServer list of DIDs */
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:40.000000000 -0400
@@ -222,16 +222,16 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 		/* Xmit ELS command <elsCmd> to remote NPORT <did> */
 		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 				"%d:0116 Xmit ELS command x%x to remote "
-				"NPORT x%x Data: x%x x%x\n",
+				"NPORT x%x I/O tag: x%x, HBA state: x%x\n",
 				phba->brd_no, elscmd,
-				did, icmd->ulpIoTag, phba->hba_state);
+				did, elsiocb->iotag, phba->hba_state);
 	} else {
 		/* Xmit ELS response <elsCmd> to remote NPORT <did> */
 		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 				"%d:0117 Xmit ELS response x%x to remote "
-				"NPORT x%x Data: x%x x%x\n",
+				"NPORT x%x I/O tag: x%x, size: x%x\n",
 				phba->brd_no, elscmd,
-				ndlp->nlp_DID, icmd->ulpIoTag, cmdSize);
+				ndlp->nlp_DID, elsiocb->iotag, cmdSize);
 	}
 
 	return elsiocb;
@@ -2017,10 +2017,9 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 
 	/* Xmit ELS ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"%d:0128 Xmit ELS ACC response tag x%x "
-			"Data: x%x x%x x%x x%x x%x\n",
-			phba->brd_no,
-			elsiocb->iocb.ulpIoTag,
+			"%d:0128 Xmit ELS ACC response tag x%x, XRI: x%x, "
+			"DID: x%x, nlp_flag: x%x nlp_state: x%x RPI: x%x\n",
+			phba->brd_no, elsiocb->iotag,
 			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
 			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
 
@@ -3363,7 +3362,7 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 		els_command = *elscmd;
 
 		list_del(&piocb->list);
-		pring->txcmplq_cnt--;
+		pring->txq_cnt--;
 
 		cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
 		cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2007-04-24 11:12:40.000000000 -0400
@@ -387,9 +387,6 @@ struct lpfc_hba {
 
 	mempool_t *mbox_mem_pool;
 	mempool_t *nlp_mem_pool;
-	struct list_head freebufList;
-	struct list_head ctrspbuflist;
-	struct list_head rnidrspbuflist;
 
 	struct fc_host_statistics link_stats;
 };
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:40.000000000 -0400
@@ -147,11 +147,14 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 				ndlp->nlp_state, ndlp->nlp_rpi);
 	}
 
-	ndlp->rport = NULL;
-	rdata->pnode = NULL;
-
-	if (!(phba->fc_flag & FC_UNLOADING))
+	if (!(phba->fc_flag & FC_UNLOADING) &&
+	    !(ndlp->nlp_flag & NLP_DELAY_TMO) &&
+	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC))
 		lpfc_disc_state_machine(phba, ndlp, NULL, NLP_EVT_DEVICE_RM);
+	else {
+		rdata->pnode = NULL;
+		ndlp->rport = NULL;
+	}
 
 	return;
 }
@@ -1569,16 +1572,6 @@ lpfc_freenode(struct lpfc_hba * phba, st
 
 	lpfc_nlp_list(phba, ndlp, NLP_JUST_DQ);
 
-	/*
-	 * if unloading the driver - just leave the remote port in place.
-	 * The driver unload will force the attached devices to detach
-	 * and flush cache's w/o generating flush errors.
-	 */
-	if ((ndlp->rport) && !(phba->fc_flag & FC_UNLOADING)) {
-		lpfc_unregister_remote_port(phba, ndlp);
-		ndlp->nlp_sid = NLP_NO_SID;
-	}
-
 	/* cleanup any ndlp on mbox q waiting for reglogin cmpl */
 	if ((mb = phba->sli.mbox_active)) {
 		if ((mb->mb.mbxCommand == MBX_REG_LOGIN64) &&
@@ -1627,6 +1620,7 @@ lpfc_freenode(struct lpfc_hba * phba, st
 int
 lpfc_nlp_remove(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp)
 {
+	struct lpfc_rport_data *rdata;
 
 	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
 		lpfc_cancel_retry_delay_tmo(phba, ndlp);
@@ -1638,6 +1632,13 @@ lpfc_nlp_remove(struct lpfc_hba * phba, 
 		spin_unlock_irq(phba->host->host_lock);
 	} else {
 		lpfc_freenode(phba, ndlp);
+
+		if ((ndlp->rport) && !(phba->fc_flag & FC_UNLOADING)) {
+			rdata = ndlp->rport->dd_data;
+			rdata->pnode = NULL;
+			ndlp->rport = NULL;
+		}
+
 		mempool_free( ndlp, phba->nlp_mem_pool);
 	}
 	return 0;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-04-12 07:09:03.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:40.000000000 -0400
@@ -386,8 +386,7 @@ lpfc_config_port_post(struct lpfc_hba * 
 	 * Setup the ring 0 (els)  timeout handler
 	 */
 	timeout = phba->fc_ratov << 1;
-	phba->els_tmofunc.expires = jiffies + HZ * timeout;
-	add_timer(&phba->els_tmofunc);
+	mod_timer(&phba->els_tmofunc, jiffies + HZ * timeout);
 
 	lpfc_init_link(phba, pmb, phba->cfg_topology, phba->cfg_link_speed);
 	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
@@ -633,7 +632,7 @@ lpfc_handle_latt_free_mbuf:
 lpfc_handle_latt_free_mp:
 	kfree(mp);
 lpfc_handle_latt_free_pmb:
-	kfree(pmb);
+	mempool_free(pmb, phba->mbox_mem_pool);
 lpfc_handle_latt_err_exit:
 	/* Enable Link attention interrupts */
 	spin_lock_irq(phba->host->host_lock);
@@ -1174,7 +1173,7 @@ lpfc_hba_init(struct lpfc_hba *phba, uin
 }
 
 static void
-lpfc_cleanup(struct lpfc_hba * phba, uint32_t save_bind)
+lpfc_cleanup(struct lpfc_hba * phba)
 {
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 
@@ -1262,21 +1261,6 @@ lpfc_stop_timer(struct lpfc_hba * phba)
 {
 	struct lpfc_sli *psli = &phba->sli;
 
-	/* Instead of a timer, this has been converted to a
-	 * deferred procedding list.
-	 */
-	while (!list_empty(&phba->freebufList)) {
-
-		struct lpfc_dmabuf *mp = NULL;
-
-		list_remove_head((&phba->freebufList), mp,
-				 struct lpfc_dmabuf, list);
-		if (mp) {
-			lpfc_mbuf_free(phba, mp->virt, mp->phys);
-			kfree(mp);
-		}
-	}
-
 	del_timer_sync(&phba->fcp_poll_timer);
 	del_timer_sync(&phba->fc_estabtmo);
 	del_timer_sync(&phba->fc_disctmo);
@@ -1339,7 +1323,7 @@ lpfc_offline(struct lpfc_hba * phba)
 		pring = &psli->ring[i];
 		/* The linkdown event takes 30 seconds to timeout. */
 		while (pring->txcmplq_cnt) {
-			mdelay(10);
+			msleep(10);
 			if (cnt++ > 3000) {
 				lpfc_printf_log(phba,
 					KERN_WARNING, LOG_INIT,
@@ -1366,7 +1350,7 @@ lpfc_offline(struct lpfc_hba * phba)
 	/* Bring down the SLI Layer and cleanup.  The HBA is offline
 	   now.  */
 	lpfc_sli_hba_down(phba);
-	lpfc_cleanup(phba, 1);
+	lpfc_cleanup(phba);
 	spin_lock_irqsave(phba->host->host_lock, iflag);
 	phba->fc_flag |= FC_OFFLINE_MODE;
 	spin_unlock_irqrestore(phba->host->host_lock, iflag);
@@ -1445,9 +1429,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		goto out_put_host;
 
 	host->unique_id = phba->brd_no;
-	INIT_LIST_HEAD(&phba->ctrspbuflist);
-	INIT_LIST_HEAD(&phba->rnidrspbuflist);
-	INIT_LIST_HEAD(&phba->freebufList);
 
 	/* Initialize timers used by driver */
 	init_timer(&phba->fc_estabtmo);
@@ -1773,7 +1754,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	free_irq(phba->pcidev->irq, phba);
 	pci_disable_msi(phba->pcidev);
 
-	lpfc_cleanup(phba, 0);
+	lpfc_cleanup(phba);
 	lpfc_stop_timer(phba);
 	phba->work_hba_events = 0;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2007-04-24 11:12:40.000000000 -0400
@@ -146,6 +146,10 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba
 
 	spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
 	list_remove_head(scsi_buf_list, lpfc_cmd, struct lpfc_scsi_buf, list);
+	if (lpfc_cmd) {
+		lpfc_cmd->seg_cnt = 0;
+		lpfc_cmd->nonsg_phys = 0;
+	}
 	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
 	return  lpfc_cmd;
 }
@@ -466,10 +470,10 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 
 	result = cmd->result;
 	sdev = cmd->device;
+	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 	cmd->scsi_done(cmd);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return;
 	}
@@ -527,7 +531,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		}
 	}
 
-	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-03-12 13:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:40.000000000 -0400
@@ -693,25 +693,8 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 		} else {
 			spin_unlock_irq(phba->host->host_lock);
 			/* Turn on IOCB processing */
-			for (i = 0; i < phba->sli.num_rings; i++) {
+			for (i = 0; i < phba->sli.num_rings; i++)
 				lpfc_sli_turn_on_ring(phba, i);
-			}
-
-			/* Free any lpfc_dmabuf's waiting for mbox cmd cmpls */
-			while (!list_empty(&phba->freebufList)) {
-				struct lpfc_dmabuf *mp;
-
-				mp = NULL;
-				list_remove_head((&phba->freebufList),
-						 mp,
-						 struct lpfc_dmabuf,
-						 list);
-				if (mp) {
-					lpfc_mbuf_free(phba, mp->virt,
-						       mp->phys);
-					kfree(mp);
-				}
-			}
 		}
 
 	} while (process_next);
@@ -1985,42 +1968,6 @@ lpfc_sli_hba_setup_exit:
 	return rc;
 }
 
-static void
-lpfc_mbox_abort(struct lpfc_hba * phba)
-{
-	LPFC_MBOXQ_t *pmbox;
-	MAILBOX_t *mb;
-
-	if (phba->sli.mbox_active) {
-		del_timer_sync(&phba->sli.mbox_tmo);
-		phba->work_hba_events &= ~WORKER_MBOX_TMO;
-		pmbox = phba->sli.mbox_active;
-		mb = &pmbox->mb;
-		phba->sli.mbox_active = NULL;
-		if (pmbox->mbox_cmpl) {
-			mb->mbxStatus = MBX_NOT_FINISHED;
-			(pmbox->mbox_cmpl) (phba, pmbox);
-		}
-		phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
-	}
-
-	/* Abort all the non active mailbox commands. */
-	spin_lock_irq(phba->host->host_lock);
-	pmbox = lpfc_mbox_get(phba);
-	while (pmbox) {
-		mb = &pmbox->mb;
-		if (pmbox->mbox_cmpl) {
-			mb->mbxStatus = MBX_NOT_FINISHED;
-			spin_unlock_irq(phba->host->host_lock);
-			(pmbox->mbox_cmpl) (phba, pmbox);
-			spin_lock_irq(phba->host->host_lock);
-		}
-		pmbox = lpfc_mbox_get(phba);
-	}
-	spin_unlock_irq(phba->host->host_lock);
-	return;
-}
-
 /*! lpfc_mbox_timeout
  *
  * \pre
@@ -2055,6 +2002,8 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 {
 	LPFC_MBOXQ_t *pmbox;
 	MAILBOX_t *mb;
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring *pring;
 
 	spin_lock_irq(phba->host->host_lock);
 	if (!(phba->work_hba_events & WORKER_MBOX_TMO)) {
@@ -2062,8 +2011,6 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 		return;
 	}
 
-	phba->work_hba_events &= ~WORKER_MBOX_TMO;
-
 	pmbox = phba->sli.mbox_active;
 	mb = &pmbox->mb;
 
@@ -2078,17 +2025,32 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 		phba->sli.sli_flag,
 		phba->sli.mbox_active);
 
-	phba->sli.mbox_active = NULL;
-	if (pmbox->mbox_cmpl) {
-		mb->mbxStatus = MBX_NOT_FINISHED;
-		spin_unlock_irq(phba->host->host_lock);
-		(pmbox->mbox_cmpl) (phba, pmbox);
-		spin_lock_irq(phba->host->host_lock);
-	}
-	phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
-
+	/* Setting state unknown so lpfc_sli_abort_iocb_ring
+	 * would get IOCB_ERROR from lpfc_sli_issue_iocb, allowing
+	 * it to fail all oustanding SCSI IO.
+	 */
+	phba->hba_state = LPFC_STATE_UNKNOWN;
+	phba->work_hba_events &= ~WORKER_MBOX_TMO;
+	phba->fc_flag |= FC_ESTABLISH_LINK;
+	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
 	spin_unlock_irq(phba->host->host_lock);
-	lpfc_mbox_abort(phba);
+
+	pring = &psli->ring[psli->fcp_ring];
+	lpfc_sli_abort_iocb_ring(phba, pring);
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
+			"%d:0316 Resetting board due to mailbox timeout\n",
+			phba->brd_no);
+	/*
+	 * lpfc_offline calls lpfc_sli_hba_down which will clean up
+	 * on oustanding mailbox commands.
+	 */
+	lpfc_offline_prep(phba);
+	lpfc_offline(phba);
+	lpfc_sli_brdrestart(phba);
+	if (lpfc_online(phba) == 0)		/* Initialize the HBA */
+		mod_timer(&phba->fc_estabtmo, jiffies + HZ * 60);
+	lpfc_unblock_mgmt_io(phba);
 	return;
 }
 
@@ -2320,9 +2282,7 @@ lpfc_sli_issue_mbox(struct lpfc_hba * ph
 			spin_unlock_irqrestore(phba->host->host_lock,
 					       drvr_flag);
 
-			/* Can be in interrupt context, do not sleep */
-			/* (or might be called with interrupts disabled) */
-			mdelay(1);
+			msleep(1);
 
 			spin_lock_irqsave(phba->host->host_lock, drvr_flag);
 


