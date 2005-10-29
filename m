From: James.Smart@Emulex.Com
Subject: [PATCH 9/15]  lpfc 8.1.0 : Fix for "command completion for iotax x?? not found"
Date: Fri, 28 Oct 2005 20:29:41 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A58@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:5585 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1750921AbVJ2A3o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:29:44 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0TgDp018537
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:29:43 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix for "command completion for iotax x?? not found" messages

Fix: There were scenarios where the error handlers could reuse an iotag
  value of an active io.  Remove all possibility of this by pre-assigning
  iotag resources to command resources.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -33,6 +33,9 @@ typedef enum _lpfc_ctx_cmd {
 struct lpfc_iocbq {
 	/* lpfc_iocbqs are used in double linked lists */
 	struct list_head list;
+	uint16_t iotag;         /* pre-assigned IO tag */
+	uint16_t rsvd1;
+
 	IOCB_t iocb;		/* IOCB cmd */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
 	uint8_t iocb_flag;
@@ -200,6 +203,11 @@ struct lpfc_sli {
 					   cmd */
 
 	uint32_t *MBhostaddr;	/* virtual address for mbox cmds */
+
+#define LPFC_IOCBQ_LOOKUP_INCREMENT  1024
+	struct lpfc_iocbq ** iocbq_lookup; /* array to lookup IOCB by IOTAG */
+	size_t iocbq_lookup_len;           /* current lengs of the array */
+	uint16_t  last_iotag;              /* last allocated IOTAG */
 };
 
 /* Given a pointer to the start of the ring, and the slot number of
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1448,10 +1448,9 @@ lpfc_no_rpi(struct lpfc_hba * phba, stru
 								   iocb, iocb);
 						spin_lock_irq(phba->host->
 							      host_lock);
-					} else {
-						list_add_tail(&iocb->list,
-							&phba->lpfc_iocb_list);
-					}
+					} else
+						lpfc_sli_release_iocbq(phba,
+								       iocb);
 				}
 			}
 			spin_unlock_irq(phba->host->host_lock);
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -56,6 +56,7 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba
 	struct ulp_bde64 *bpl;
 	IOCB_t *iocb;
 	dma_addr_t pdma_phys;
+	uint16_t iotag;
 
 	psb = kmalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
 	if (!psb)
@@ -79,6 +80,15 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba
 	/* Initialize virtual ptrs to dma_buf region. */
 	memset(psb->data, 0, phba->cfg_sg_dma_buf_size);
 
+	/* Allocate iotag for psb->cur_iocbq. */
+	iotag = lpfc_sli_next_iotag(phba, &psb->cur_iocbq);
+	if (iotag == 0) {
+		pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
+			      psb->data, psb->dma_handle);
+		kfree (psb);
+		return NULL;
+	}
+
 	psb->fcp_cmnd = psb->data;
 	psb->fcp_rsp = psb->data + sizeof(struct fcp_cmnd);
 	psb->fcp_bpl = psb->data + sizeof(struct fcp_cmnd) +
@@ -626,7 +636,6 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 	list_remove_head(lpfc_iocb_list, iocbqrsp, struct lpfc_iocbq, list);
 	if (!iocbqrsp)
 		return FAILED;
-	memset(iocbqrsp, 0, sizeof (struct lpfc_iocbq));
 
 	iocbq->iocb_flag |= LPFC_IO_POLL;
 	ret = lpfc_sli_issue_iocb_wait_high_priority(phba,
@@ -655,8 +664,7 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 			    lpfc_cmd->pCmd->device->id,
 			    lpfc_cmd->pCmd->device->lun, 0, LPFC_CTX_TGT);
 
-	/* Return response IOCB to free list. */
-	list_add_tail(&iocbqrsp->list, lpfc_iocb_list);
+	lpfc_sli_release_iocbq(phba, iocbqrsp);
 	return ret;
 }
 
@@ -818,9 +826,8 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 
 		list_del_init(&iocb->list);
 		pring->txq_cnt--;
-		if (!iocb->iocb_cmpl) {
-			list_add_tail(&iocb->list, lpfc_iocb_list);
-		}
+		if (!iocb->iocb_cmpl)
+			lpfc_sli_release_iocbq(phba, iocb);
 		else {
 			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
 			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
@@ -834,8 +841,6 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 	if (abtsiocb == NULL)
 		return FAILED;
 
-	memset(abtsiocb, 0, sizeof (struct lpfc_iocbq));
-
 	/*
 	 * The scsi command was not in the txq.  Check the txcmplq and if it is
 	 * found, send an abort to the FW.
@@ -861,7 +866,7 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 		abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 		if (lpfc_sli_issue_iocb(phba, pring, abtsiocb, 0) ==
 								IOCB_ERROR) {
-			list_add_tail(&abtsiocb->list, lpfc_iocb_list);
+			lpfc_sli_release_iocbq(phba, abtsiocb);
 			ret = IOCB_ERROR;
 			break;
 		}
@@ -964,8 +969,6 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 	if (iocbqrsp == NULL)
 		goto out_free_scsi_buf;
 
-	memset(iocbqrsp, 0, sizeof (struct lpfc_iocbq));
-
 	iocbq->iocb_flag |= LPFC_IO_POLL;
 	iocbq->iocb_cmpl = lpfc_sli_wake_iocb_high_priority;
 
@@ -1011,7 +1014,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 			phba->brd_no, cnt);
 	}
 
-	list_add_tail(&iocbqrsp->list, lpfc_iocb_list);
+	lpfc_sli_release_iocbq(phba, iocbqrsp);
 
 out_free_scsi_buf:
 	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -886,7 +886,6 @@ lpfc_post_buffer(struct lpfc_hba * phba,
 			pring->missbufcnt = cnt;
 			return cnt;
 		}
-		memset(iocb, 0, sizeof (struct lpfc_iocbq));
 		icmd = &iocb->iocb;
 
 		/* 2 buffers can be posted per command */
@@ -899,7 +898,7 @@ lpfc_post_buffer(struct lpfc_hba * phba,
 			if (mp1)
 				kfree(mp1);
 			spin_lock_irq(phba->host->host_lock);
-			list_add_tail(&iocb->list, lpfc_iocb_list);
+			lpfc_sli_release_iocbq(phba, iocb);
 			spin_unlock_irq(phba->host->host_lock);
 			pring->missbufcnt = cnt;
 			return cnt;
@@ -918,7 +917,7 @@ lpfc_post_buffer(struct lpfc_hba * phba,
 				lpfc_mbuf_free(phba, mp1->virt, mp1->phys);
 				kfree(mp1);
 				spin_lock_irq(phba->host->host_lock);
-				list_add_tail(&iocb->list, lpfc_iocb_list);
+				lpfc_sli_release_iocbq(phba, iocb);
 				spin_unlock_irq(phba->host->host_lock);
 				pring->missbufcnt = cnt;
 				return cnt;
@@ -955,7 +954,7 @@ lpfc_post_buffer(struct lpfc_hba * phba,
 				kfree(mp2);
 				cnt++;
 			}
-			list_add_tail(&iocb->list, lpfc_iocb_list);
+			lpfc_sli_release_iocbq(phba, iocb);
 			pring->missbufcnt = cnt;
 			spin_unlock_irq(phba->host->host_lock);
 			return cnt;
@@ -1329,6 +1328,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	int error = -ENODEV, retval;
 	int i;
 	u64 wwname;
+	uint16_t iotag;
 
 	if (pci_enable_device(pdev))
 		goto out;
@@ -1453,6 +1453,15 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 		}
 
 		memset(iocbq_entry, 0, sizeof(struct lpfc_iocbq));
+		iotag = lpfc_sli_next_iotag(phba, iocbq_entry);
+		if (iotag == 0) {
+			kfree (iocbq_entry);
+			printk(KERN_ERR "%s: failed to allocate IOTAG. "
+			       "Unloading driver.\n",
+				__FUNCTION__);
+			error = -ENOMEM;
+			goto out_free_iocbq;
+		}
 		spin_lock_irq(phba->host->host_lock);
 		list_add(&iocbq_entry->list, &phba->lpfc_iocb_list);
 		phba->total_iocbq_bufs++;
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -187,10 +187,8 @@ lpfc_els_abort(struct lpfc_hba * phba, s
 					spin_unlock_irq(phba->host->host_lock);
 					(iocb->iocb_cmpl) (phba, iocb, iocb);
 					spin_lock_irq(phba->host->host_lock);
-				} else {
-					list_add_tail(&iocb->list,
-							&phba->lpfc_iocb_list);
-				}
+				} else
+					lpfc_sli_release_iocbq(phba, iocb);
 				break;
 			}
 		}
@@ -232,10 +230,8 @@ lpfc_els_abort(struct lpfc_hba * phba, s
 					spin_unlock_irq(phba->host->host_lock);
 					(iocb->iocb_cmpl) (phba, iocb, iocb);
 					spin_lock_irq(phba->host->host_lock);
-				} else {
-					list_add_tail(&iocb->list,
-							&phba->lpfc_iocb_list);
-				}
+				} else
+					lpfc_sli_release_iocbq(phba, iocb);
 				break;
 			}
 		}
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -235,7 +235,6 @@ lpfc_gen_req(struct lpfc_hba *phba, stru
 
 	if (geniocb == NULL)
 		return 1;
-	memset(geniocb, 0, sizeof (struct lpfc_iocbq));
 
 	icmd = &geniocb->iocb;
 	icmd->un.genreq64.bdl.ulpIoTag32 = 0;
@@ -279,7 +278,7 @@ lpfc_gen_req(struct lpfc_hba *phba, stru
 	geniocb->drvrTimeout = icmd->ulpTimeout + LPFC_DRVR_TIMEOUT;
 	spin_lock_irq(phba->host->host_lock);
 	if (lpfc_sli_issue_iocb(phba, pring, geniocb, 0) == IOCB_ERROR) {
-		list_add_tail(&geniocb->list, lpfc_iocb_list);
+		lpfc_sli_release_iocbq(phba, geniocb);
 		spin_unlock_irq(phba->host->host_lock);
 		return 1;
 	}
@@ -487,7 +486,7 @@ out:
 	kfree(inp);
 	kfree(bmp);
 	spin_lock_irq(phba->host->host_lock);
-	list_add_tail(&cmdiocb->list, &phba->lpfc_iocb_list);
+	lpfc_sli_release_iocbq(phba, cmdiocb);
 	spin_unlock_irq(phba->host->host_lock);
 	return;
 }
@@ -526,7 +525,7 @@ lpfc_cmpl_ct_cmd_rft_id(struct lpfc_hba 
 	kfree(inp);
 	kfree(bmp);
 	spin_lock_irq(phba->host->host_lock);
-	list_add_tail(&cmdiocb->list, &phba->lpfc_iocb_list);
+	lpfc_sli_release_iocbq(phba, cmdiocb);
 	spin_unlock_irq(phba->host->host_lock);
 	return;
 }
@@ -735,7 +734,7 @@ lpfc_cmpl_ct_cmd_fdmi(struct lpfc_hba * 
 	kfree(inp);
 	kfree(bmp);
 	spin_lock_irq(phba->host->host_lock);
-	list_add_tail(&cmdiocb->list, &phba->lpfc_iocb_list);
+	lpfc_sli_release_iocbq(phba, cmdiocb);
 	spin_unlock_irq(phba->host->host_lock);
 	return;
 }
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -143,6 +143,8 @@ LPFC_MBOXQ_t *lpfc_mbox_get(struct lpfc_
 int lpfc_mem_alloc(struct lpfc_hba *);
 void lpfc_mem_free(struct lpfc_hba *);
 
+void lpfc_sli_release_iocbq(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
+uint16_t lpfc_sli_next_iotag(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
 int lpfc_sli_hba_setup(struct lpfc_hba *);
 int lpfc_sli_hba_down(struct lpfc_hba *);
 int lpfc_sli_issue_mbox(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -122,7 +122,6 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 
 	if (elsiocb == NULL)
 		return NULL;
-	memset(elsiocb, 0, sizeof (struct lpfc_iocbq));
 	icmd = &elsiocb->iocb;
 
 	/* fill in BDEs for command */
@@ -133,7 +132,9 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 		if (pcmd)
 			kfree(pcmd);
 
-		list_add_tail(&elsiocb->list, lpfc_iocb_list);
+		spin_lock_irq(phba->host->host_lock);
+		lpfc_sli_release_iocbq(phba, elsiocb);
+		spin_unlock_irq(phba->host->host_lock);
 		return NULL;
 	}
 
@@ -150,7 +151,9 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 				kfree(prsp);
 			lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
 			kfree(pcmd);
-			list_add_tail(&elsiocb->list, lpfc_iocb_list);
+			spin_lock_irq(phba->host->host_lock);
+			lpfc_sli_release_iocbq(phba, elsiocb);
+			spin_unlock_irq(phba->host->host_lock);
 			return NULL;
 		}
 		INIT_LIST_HEAD(&prsp->list);
@@ -164,7 +167,9 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 	    pbuflist->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
 					     &pbuflist->phys);
 	if (pbuflist == 0 || pbuflist->virt == 0) {
-		list_add_tail(&elsiocb->list, lpfc_iocb_list);
+		spin_lock_irq(phba->host->host_lock);
+		lpfc_sli_release_iocbq(phba, elsiocb);
+		spin_unlock_irq(phba->host->host_lock);
 		lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
 		lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
 		kfree(pcmd);
@@ -596,10 +601,8 @@ lpfc_els_abort_flogi(struct lpfc_hba * p
 					spin_unlock_irq(phba->host->host_lock);
 					(iocb->iocb_cmpl) (phba, iocb, iocb);
 					spin_lock_irq(phba->host->host_lock);
-				} else {
-					list_add_tail(&iocb->list,
-						      &phba->lpfc_iocb_list);
-				}
+				} else
+					lpfc_sli_release_iocbq(phba, iocb);
 			}
 		}
 	}
@@ -1713,7 +1716,7 @@ lpfc_els_free_iocb(struct lpfc_hba * phb
 		kfree(buf_ptr);
 	}
 	spin_lock_irq(phba->host->host_lock);
-	list_add_tail(&elsiocb->list, &phba->lpfc_iocb_list);
+	lpfc_sli_release_iocbq(phba, elsiocb);
 	spin_unlock_irq(phba->host->host_lock);
 	return 0;
 }
@@ -2929,9 +2932,8 @@ lpfc_els_timeout_handler(struct lpfc_hba
 			spin_unlock_irq(phba->host->host_lock);
 			(piocb->iocb_cmpl) (phba, piocb, piocb);
 			spin_lock_irq(phba->host->host_lock);
-		} else {
-			list_add_tail(&piocb->list, &phba->lpfc_iocb_list);
-		}
+		} else
+			lpfc_sli_release_iocbq(phba, piocb);
 	}
 	if (phba->sli.ring[LPFC_ELS_RING].txcmplq_cnt) {
 		phba->els_tmofunc.expires = jiffies + HZ * timeout;
@@ -2996,7 +2998,7 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 			spin_lock_irq(phba->host->host_lock);
 		}
 		else
-			list_add_tail(&piocb->list, &phba->lpfc_iocb_list);
+			lpfc_sli_release_iocbq(phba, piocb);
 	}
 
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
@@ -3033,7 +3035,7 @@ lpfc_els_flush_cmd(struct lpfc_hba * phb
 			spin_lock_irq(phba->host->host_lock);
 		}
 		else
-			list_add_tail(&piocb->list, &phba->lpfc_iocb_list);
+			lpfc_sli_release_iocbq(phba, piocb);
 	}
 	spin_unlock_irq(phba->host->host_lock);
 	return;
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -65,6 +65,18 @@ typedef enum _lpfc_iocb_type {
 	LPFC_ABORT_IOCB
 } lpfc_iocb_type;
 
+void
+lpfc_sli_release_iocbq(struct lpfc_hba * phba, struct lpfc_iocbq * iocbq)
+{
+	size_t start_clean = (size_t)(&((struct lpfc_iocbq *)NULL)->iocb);
+
+	/*
+	 * Clean all volatile data fields, preserve iotag and node struct.
+	 */
+	memset((char*)iocbq + start_clean, 0, sizeof(*iocbq) - start_clean);
+	list_add_tail(&iocbq->list, &phba->lpfc_iocb_list);
+}
+
 /*
  * Translate the iocb command to an iocb command type used to decide the final
  * disposition of each completed IOCB.
@@ -265,41 +277,69 @@ lpfc_sli_next_iocb_slot (struct lpfc_hba
 	return iocb;
 }
 
-static uint32_t
-lpfc_sli_next_iotag(struct lpfc_hba * phba, struct lpfc_sli_ring * pring)
+uint16_t
+lpfc_sli_next_iotag(struct lpfc_hba * phba, struct lpfc_iocbq * iocbq)
 {
-	uint32_t search_start;
+	struct lpfc_iocbq ** new_arr;
+	struct lpfc_iocbq ** old_arr;
+	size_t new_len;
+	struct lpfc_sli *psli = &phba->sli;
+	uint16_t iotag;
 
-	if (pring->fast_lookup == NULL) {
-		pring->iotag_ctr++;
-		if (pring->iotag_ctr >= pring->iotag_max)
-			pring->iotag_ctr = 1;
-		return pring->iotag_ctr;
+	spin_lock_irq(phba->host->host_lock);
+	iotag = psli->last_iotag;
+	if(++iotag < psli->iocbq_lookup_len) {
+		psli->last_iotag = iotag;
+		psli->iocbq_lookup[iotag] = iocbq;
+		spin_unlock_irq(phba->host->host_lock);
+		iocbq->iotag = iotag;
+		return iotag;
+	}
+	else if (psli->iocbq_lookup_len < (0xffff
+					   - LPFC_IOCBQ_LOOKUP_INCREMENT)) {
+		new_len = psli->iocbq_lookup_len + LPFC_IOCBQ_LOOKUP_INCREMENT;
+		spin_unlock_irq(phba->host->host_lock);
+		new_arr = kmalloc(new_len * sizeof (struct lpfc_iocbq *),
+				  GFP_KERNEL);
+		if (new_arr) {
+			memset((char *)new_arr, 0,
+			       new_len * sizeof (struct lpfc_iocbq *));
+			spin_lock_irq(phba->host->host_lock);
+			old_arr = psli->iocbq_lookup;
+			if (new_len <= psli->iocbq_lookup_len) {
+				/* highly unprobable case */
+				kfree(new_arr);
+				iotag = psli->last_iotag;
+				if(++iotag < psli->iocbq_lookup_len) {
+					psli->last_iotag = iotag;
+					psli->iocbq_lookup[iotag] = iocbq;
+					spin_unlock_irq(phba->host->host_lock);
+					iocbq->iotag = iotag;
+					return iotag;
+				}
+				spin_unlock_irq(phba->host->host_lock);
+				return 0;
+			}
+			if (psli->iocbq_lookup)
+				memcpy(new_arr, old_arr,
+				       ((psli->last_iotag  + 1) *
+	 				sizeof (struct lpfc_iocbq *)));
+			psli->iocbq_lookup = new_arr;
+			psli->iocbq_lookup_len = new_len;
+			psli->last_iotag = iotag;
+			psli->iocbq_lookup[iotag] = iocbq;
+			spin_unlock_irq(phba->host->host_lock);
+			iocbq->iotag = iotag;
+			kfree(old_arr);
+			return iotag;
+		}
 	}
 
-	search_start = pring->iotag_ctr;
-
-	do {
-		pring->iotag_ctr++;
-		if (pring->iotag_ctr >= pring->fast_iotag)
-			pring->iotag_ctr = 1;
-
-		if (*(pring->fast_lookup + pring->iotag_ctr) == NULL)
-			return pring->iotag_ctr;
-
-	} while (pring->iotag_ctr != search_start);
+	lpfc_printf_log(phba, KERN_ERR,LOG_SLI,
+			"%d:0318 Failed to allocate IOTAG.last IOTAG is %d\n",
+			phba->brd_no, psli->last_iotag);
 
-	/*
-	 * Outstanding I/O count for ring <ringno> is at max <fast_iotag>
-	 */
-	lpfc_printf_log(phba,
-		KERN_ERR,
-		LOG_SLI,
-		"%d:0318 Outstanding I/O count for ring %d is at max x%x\n",
-		phba->brd_no,
-		pring->ringno,
-		pring->fast_iotag);
-	return (0);
+	return 0;
 }
 
 static void
@@ -307,10 +347,9 @@ lpfc_sli_submit_iocb(struct lpfc_hba *ph
 		IOCB_t *iocb, struct lpfc_iocbq *nextiocb)
 {
 	/*
-	 * Allocate and set up an iotag
+	 * Set up an iotag
 	 */
-	nextiocb->iocb.ulpIoTag =
-		lpfc_sli_next_iotag(phba, &phba->sli.ring[phba->sli.fcp_ring]);
+	nextiocb->iocb.ulpIoTag = (nextiocb->iocb_cmpl) ? nextiocb->iotag : 0;
 
 	/*
 	 * Issue iocb command to adapter
@@ -326,9 +365,8 @@ lpfc_sli_submit_iocb(struct lpfc_hba *ph
 	 */
 	if (nextiocb->iocb_cmpl)
 		lpfc_sli_ringtxcmpl_put(phba, pring, nextiocb);
-	else {
-		list_add_tail(&nextiocb->list, &phba->lpfc_iocb_list);
-	}
+	else
+		lpfc_sli_release_iocbq(phba, nextiocb);
 
 	/*
 	 * Let the HBA know what IOCB slot will be the next one the
@@ -752,80 +790,28 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 }
 
 static struct lpfc_iocbq *
-lpfc_sli_txcmpl_ring_search_slow(struct lpfc_sli_ring * pring,
-				 struct lpfc_iocbq * prspiocb)
-{
-	IOCB_t *icmd = NULL;
-	IOCB_t *irsp = NULL;
-	struct lpfc_iocbq *cmd_iocb;
-	struct lpfc_iocbq *iocb, *next_iocb;
-	uint16_t iotag;
-
-	irsp = &prspiocb->iocb;
-	iotag = irsp->ulpIoTag;
-	cmd_iocb = NULL;
-
-	/* Search through txcmpl from the begining */
-	list_for_each_entry_safe(iocb, next_iocb, &(pring->txcmplq), list) {
-		icmd = &iocb->iocb;
-		if (iotag == icmd->ulpIoTag) {
-			/* Found a match.  */
-			cmd_iocb = iocb;
-			list_del(&iocb->list);
-			pring->txcmplq_cnt--;
-			break;
-		}
-	}
-
-	return (cmd_iocb);
-}
-
-static struct lpfc_iocbq *
-lpfc_sli_txcmpl_ring_iotag_lookup(struct lpfc_hba * phba,
-			struct lpfc_sli_ring * pring,
-			struct lpfc_iocbq * prspiocb)
+lpfc_sli_iocbq_lookup(struct lpfc_hba * phba,
+		      struct lpfc_sli_ring * pring,
+		      struct lpfc_iocbq * prspiocb)
 {
-	IOCB_t *irsp = NULL;
 	struct lpfc_iocbq *cmd_iocb = NULL;
 	uint16_t iotag;
 
-	if (unlikely(pring->fast_lookup == NULL))
-		return NULL;
+	iotag = prspiocb->iocb.ulpIoTag;
 
-	/* Use fast lookup based on iotag for completion */
-	irsp = &prspiocb->iocb;
-	iotag = irsp->ulpIoTag;
-	if (iotag < pring->fast_iotag) {
-		cmd_iocb = *(pring->fast_lookup + iotag);
-		*(pring->fast_lookup + iotag) = NULL;
-		if (cmd_iocb) {
-			list_del(&cmd_iocb->list);
-			pring->txcmplq_cnt--;
-			return cmd_iocb;
-		} else {
-			/*
-			 * This is clearly an error.  A ring that uses iotags
-			 * should never have a interrupt for a completion that
-			 * is not on the ring.  Return NULL and log a error.
-			 */
-			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"%d:0327 Rsp ring %d error -  command "
-				"completion for iotag x%x not found\n",
-				phba->brd_no, pring->ringno, iotag);
-			return NULL;
-		}
+	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
+		cmd_iocb = phba->sli.iocbq_lookup[iotag];
+		list_del(&cmd_iocb->list);
+		pring->txcmplq_cnt--;
+		return cmd_iocb;
 	}
 
-	/*
-	 * Rsp ring <ringno> get: iotag <iotag> greater then
-	 * configured max <fast_iotag> wd0 <irsp>.  This is an
-	 * error.  Just return NULL.
-	 */
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-			"%d:0317 Rsp ring %d get: iotag x%x greater then "
-			"configured max x%x wd0 x%x\n",
-			phba->brd_no, pring->ringno, iotag, pring->fast_iotag,
-			*(((uint32_t *) irsp) + 7));
+			"%d:0317 iotag x%x is out off "
+			"range: max iotag x%x wd0 x%x\n",
+			phba->brd_no, iotag,
+			phba->sli.last_iotag,
+			*(((uint32_t *) &prspiocb->iocb) + 7));
 	return NULL;
 }
 
@@ -839,7 +825,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 
 	/* Based on the iotag field, get the cmd IOCB from the txcmplq */
 	spin_lock_irqsave(phba->host->host_lock, iflag);
-	cmdiocbp = lpfc_sli_txcmpl_ring_search_slow(pring, saveq);
+	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
 	if (cmdiocbp) {
 		if (cmdiocbp->iocb_cmpl) {
 			/*
@@ -861,9 +847,8 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 				(cmdiocbp->iocb_cmpl) (phba, cmdiocbp, saveq);
 				spin_lock_irqsave(phba->host->host_lock, iflag);
 			}
-		} else {
-			list_add_tail(&cmdiocbp->list, &phba->lpfc_iocb_list);
-		}
+		} else
+			lpfc_sli_release_iocbq(phba, cmdiocbp);
 	} else {
 		/*
 		 * Unknown initiating command based on the response iotag.
@@ -990,9 +975,8 @@ lpfc_sli_handle_fast_ring_event(struct l
 				break;
 			}
 
-			cmdiocbq = lpfc_sli_txcmpl_ring_iotag_lookup(phba,
-								pring,
-								&rspiocbq);
+			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
+							 &rspiocbq);
 			if ((cmdiocbq) && (cmdiocbq->iocb_cmpl)) {
 				spin_unlock_irqrestore(
 				       phba->host->host_lock, iflag);
@@ -1213,8 +1197,8 @@ lpfc_sli_handle_slow_ring_event(struct l
 			} else if (type == LPFC_ABORT_IOCB) {
 				if ((irsp->ulpCommand != CMD_XRI_ABORTED_CX) &&
 				    ((cmdiocbp =
-				      lpfc_sli_txcmpl_ring_search_slow(pring,
-						saveq)))) {
+				      lpfc_sli_iocbq_lookup(phba, pring,
+							    saveq)))) {
 					/* Call the specified completion
 					   routine */
 					if (cmdiocbp->iocb_cmpl) {
@@ -1226,10 +1210,9 @@ lpfc_sli_handle_slow_ring_event(struct l
 						spin_lock_irqsave(
 							  phba->host->host_lock,
 							  iflag);
-					} else {
-						list_add_tail(&cmdiocbp->list,
-								lpfc_iocb_list);
-					}
+					} else
+						lpfc_sli_release_iocbq(phba,
+								      cmdiocbp);
 				}
 			} else if (type == LPFC_UNKNOWN_IOCB) {
 				if (irsp->ulpCommand == CMD_ADAPTER_MSG) {
@@ -1264,12 +1247,12 @@ lpfc_sli_handle_slow_ring_event(struct l
 								 next_iocb,
 								 &saveq->list,
 								 list) {
-						list_add_tail(&rspiocbp->list,
-							      lpfc_iocb_list);
+						lpfc_sli_release_iocbq(phba,
+								     rspiocbp);
 					}
 				}
 
-				list_add_tail(&saveq->list, lpfc_iocb_list);
+				lpfc_sli_release_iocbq(phba, saveq);
 			}
 		}
 
@@ -1314,7 +1297,6 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 	struct lpfc_iocbq *iocb, *next_iocb;
 	IOCB_t *icmd = NULL, *cmd = NULL;
 	int errcnt;
-	uint16_t iotag;
 
 	errcnt = 0;
 
@@ -1331,9 +1313,8 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 			spin_unlock_irq(phba->host->host_lock);
 			(iocb->iocb_cmpl) (phba, iocb, iocb);
 			spin_lock_irq(phba->host->host_lock);
-		} else {
-			list_add_tail(&iocb->list, &phba->lpfc_iocb_list);
-		}
+		} else
+			lpfc_sli_release_iocbq(phba, iocb);
 	}
 	pring->txq_cnt = 0;
 	INIT_LIST_HEAD(&(pring->txq));
@@ -1343,13 +1324,8 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 		cmd = &iocb->iocb;
 
 		/*
-		 * Imediate abort of IOCB, clear fast_lookup entry,
-		 * if any, deque and call compl
+		 * Imediate abort of IOCB, deque and call compl
 		 */
-		iotag = cmd->ulpIoTag;
-		if (iotag && pring->fast_lookup &&
-		    (iotag < pring->fast_iotag))
-			pring->fast_lookup[iotag] = NULL;
 
 		list_del_init(&iocb->list);
 		pring->txcmplq_cnt--;
@@ -1360,9 +1336,8 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 			spin_unlock_irq(phba->host->host_lock);
 			(iocb->iocb_cmpl) (phba, iocb, iocb);
 			spin_lock_irq(phba->host->host_lock);
-		} else {
-			list_add_tail(&iocb->list, &phba->lpfc_iocb_list);
-		}
+		} else
+			lpfc_sli_release_iocbq(phba, iocb);
 	}
 
 	INIT_LIST_HEAD(&pring->txcmplq);
@@ -2147,6 +2122,10 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 	psli->next_ring = LPFC_FCP_NEXT_RING;
 	psli->ip_ring = LPFC_IP_RING;
 
+	psli->iocbq_lookup = NULL;
+	psli->iocbq_lookup_len = 0;
+	psli->last_iotag = 0;
+
 	for (i = 0; i < psli->num_rings; i++) {
 		pring = &psli->ring[i];
 		switch (i) {
@@ -2222,7 +2201,7 @@ lpfc_sli_queue_setup(struct lpfc_hba * p
 {
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
-	int i, cnt;
+	int i;
 
 	psli = &phba->sli;
 	spin_lock_irq(phba->host->host_lock);
@@ -2238,19 +2217,6 @@ lpfc_sli_queue_setup(struct lpfc_hba * p
 		INIT_LIST_HEAD(&pring->txcmplq);
 		INIT_LIST_HEAD(&pring->iocb_continueq);
 		INIT_LIST_HEAD(&pring->postbufq);
-		cnt = pring->fast_iotag;
-		spin_unlock_irq(phba->host->host_lock);
-		if (cnt) {
-			pring->fast_lookup =
-				kmalloc(cnt * sizeof (struct lpfc_iocbq *),
-					GFP_KERNEL);
-			if (pring->fast_lookup == 0) {
-				return (0);
-			}
-			memset((char *)pring->fast_lookup, 0,
-			       cnt * sizeof (struct lpfc_iocbq *));
-		}
-		spin_lock_irq(phba->host->host_lock);
 	}
 	spin_unlock_irq(phba->host->host_lock);
 	return (1);
@@ -2292,10 +2258,8 @@ lpfc_sli_hba_down(struct lpfc_hba * phba
 						       flags);
 				(iocb->iocb_cmpl) (phba, iocb, iocb);
 				spin_lock_irqsave(phba->host->host_lock, flags);
-			} else {
-				list_add_tail(&iocb->list,
-					      &phba->lpfc_iocb_list);
-			}
+			} else
+				lpfc_sli_release_iocbq(phba, iocb);
 		}
 
 		INIT_LIST_HEAD(&(pring->txq));
@@ -2436,7 +2400,7 @@ lpfc_sli_abort_elsreq_cmpl(struct lpfc_h
 		kfree(buf_ptr);
 	}
 
-	list_add_tail(&cmdiocb->list, &phba->lpfc_iocb_list);
+	lpfc_sli_release_iocbq(phba, cmdiocb);
 	return;
 }
 
@@ -2454,7 +2418,6 @@ lpfc_sli_issue_abort_iotag32(struct lpfc
 	list_remove_head(lpfc_iocb_list, abtsiocbp, struct lpfc_iocbq, list);
 	if (abtsiocbp == NULL)
 		return 0;
-	memset(abtsiocbp, 0, sizeof (struct lpfc_iocbq));
 
 	iabt = &abtsiocbp->iocb;
 	icmd = &cmdiocb->iocb;
@@ -2473,7 +2436,7 @@ lpfc_sli_issue_abort_iotag32(struct lpfc
 		abtsiocbp->iocb_cmpl = lpfc_sli_abort_elsreq_cmpl;
 		break;
 	default:
-		list_add_tail(&abtsiocbp->list, lpfc_iocb_list);
+		lpfc_sli_release_iocbq(phba, abtsiocbp);
 		return 0;
 	}
 
@@ -2485,7 +2448,7 @@ lpfc_sli_issue_abort_iotag32(struct lpfc
 	iabt->ulpCommand = CMD_ABORT_MXRI64_CN;
 
 	if (lpfc_sli_issue_iocb(phba, pring, abtsiocbp, 0) == IOCB_ERROR) {
-		list_add_tail(&abtsiocbp->list, lpfc_iocb_list);
+		lpfc_sli_release_iocbq(phba, abtsiocbp);
 		return 0;
 	}
 
@@ -2563,7 +2526,7 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba 
 			   struct lpfc_iocbq * rspiocb)
 {
 	spin_lock_irq(phba->host->host_lock);
-	list_add_tail(&cmdiocb->list, &phba->lpfc_iocb_list);
+	lpfc_sli_release_iocbq(phba, cmdiocb);
 	spin_unlock_irq(phba->host->host_lock);
 	return;
 }
@@ -2604,7 +2567,6 @@ lpfc_sli_abort_iocb(struct lpfc_hba *phb
 			errcnt++;
 			continue;
 		}
-		memset(abtsiocb, 0, sizeof (struct lpfc_iocbq));
 
 		abtsiocb->iocb.un.acxri.abortType = ABORT_TYPE_ABTS;
 		abtsiocb->iocb.un.acxri.abortContextTag = cmd->ulpContext;
@@ -2621,7 +2583,7 @@ lpfc_sli_abort_iocb(struct lpfc_hba *phb
 		abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 		ret_val = lpfc_sli_issue_iocb(phba, pring, abtsiocb, 0);
 		if (ret_val == IOCB_ERROR) {
-			list_add_tail(&abtsiocb->list, lpfc_iocb_list);
+			lpfc_sli_release_iocbq(phba, abtsiocb);
 			errcnt++;
 			continue;
 		}
@@ -2635,8 +2597,9 @@ lpfc_sli_wake_iocb_high_priority(struct 
 				 struct lpfc_iocbq * queue1,
 				 struct lpfc_iocbq * queue2)
 {
-	if (queue1->context2 && queue2)
-		memcpy(queue1->context2, queue2, sizeof (struct lpfc_iocbq));
+	struct lpfc_iocbq *save_iocbq = queue1->context2;
+	if (save_iocbq && queue2)
+		memcpy(&save_iocbq->iocb, &queue2->iocb, sizeof(queue2->iocb));
 
 	/* The waiter is looking for LPFC_IO_HIPRI bit to be set
 	   as a signal to wake up */
