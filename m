From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 3/5] lpfc 8.3.3 : Fix a couple of spin_lock and memory
	issues and a crash
Date: Wed, 10 Jun 2009 17:23:06 -0400
Message-ID: <1244668986.9571.19.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37939 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861AbZFJVXG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 17:23:06 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n5ALN99T001389
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 14:23:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Fix a couple of spin_lock and memory issues and a crash

Contains the following changes:
- Fixed error paths retaking a spin lock which they already hold
- Added code to free memory in a couple of error paths
- Added code to free RPI bit map while unloading driver
- Added code to write zero to memory object allocated through dma_alloc_coherent
- Fixed crash/hang with target or LUN resets

Signed-off-by: James Smart <James.Smart@emulex.com>
---

 drivers/scsi/lpfc/lpfc_init.c |    1 +
 drivers/scsi/lpfc/lpfc_mbox.c |    1 +
 drivers/scsi/lpfc/lpfc_sli.c  |   42 ++++++++++++++++++++++++++++++++---------
 3 files changed, 35 insertions(+), 9 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3540,6 +3540,7 @@ lpfc_sli4_driver_resource_unset(struct lpfc_hba *phba)
 
 	/* Free the allocated rpi headers. */
 	lpfc_sli4_remove_rpi_hdrs(phba);
+	lpfc_sli4_remove_rpis(phba);
 
 	/* Free the ELS sgl list */
 	lpfc_free_active_sgl(phba);
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1631,6 +1631,7 @@ lpfc_sli4_config(struct lpfc_hba *phba, struct lpfcMboxq *mbox,
 		/* In case of malloc fails, proceed with whatever we have */
 		if (!viraddr)
 			break;
+		memset(viraddr, 0, PAGE_SIZE);
 		mbox->sge_array->addr[pagen] = viraddr;
 		/* Keep the first page for later sub-header construction */
 		if (pagen == 0)
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4139,8 +4139,11 @@ lpfc_sli4_read_fcoe_params(struct lpfc_hba *phba,
 		return -EIO;
 	}
 	data_length = mqe->un.mb_words[5];
-	if (data_length > DMP_FCOEPARAM_RGN_SIZE)
+	if (data_length > DMP_FCOEPARAM_RGN_SIZE) {
+		lpfc_mbuf_free(phba, mp->virt, mp->phys);
+		kfree(mp);
 		return -EIO;
+	}
 
 	lpfc_parse_fcoe_conf(phba, mp->virt, data_length);
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
@@ -7351,6 +7354,32 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 }
 
 /**
+ * lpfc_chk_iocb_flg - Test IOCB flag with lock held.
+ * @phba: Pointer to HBA context object..
+ * @piocbq: Pointer to command iocb.
+ * @flag: Flag to test.
+ *
+ * This routine grabs the hbalock and then test the iocb_flag to
+ * see if the passed in flag is set.
+ * Returns:
+ * 1 if flag is set.
+ * 0 if flag is not set.
+ **/
+static int
+lpfc_chk_iocb_flg(struct lpfc_hba *phba,
+		 struct lpfc_iocbq *piocbq, uint32_t flag)
+{
+	unsigned long iflags;
+	int ret;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	ret = piocbq->iocb_flag & flag;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	return ret;
+
+}
+
+/**
  * lpfc_sli_issue_iocb_wait - Synchronous function to issue iocb commands
  * @phba: Pointer to HBA context object..
  * @pring: Pointer to sli ring.
@@ -7417,7 +7446,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba *phba,
 	if (retval == IOCB_SUCCESS) {
 		timeout_req = timeout * HZ;
 		timeleft = wait_event_timeout(done_q,
-				piocb->iocb_flag & LPFC_IO_WAKE,
+				lpfc_chk_iocb_flg(phba, piocb, LPFC_IO_WAKE),
 				timeout_req);
 
 		if (piocb->iocb_flag & LPFC_IO_WAKE) {
@@ -7602,20 +7631,16 @@ lpfc_sli_eratt_read(struct lpfc_hba *phba)
 		if ((HS_FFER1 & phba->work_hs) &&
 		    ((HS_FFER2 | HS_FFER3 | HS_FFER4 | HS_FFER5 |
 		     HS_FFER6 | HS_FFER7) & phba->work_hs)) {
-			spin_lock_irq(&phba->hbalock);
 			phba->hba_flag |= DEFER_ERATT;
-			spin_unlock_irq(&phba->hbalock);
 			/* Clear all interrupt enable conditions */
 			writel(0, phba->HCregaddr);
 			readl(phba->HCregaddr);
 		}
 
 		/* Set the driver HA work bitmap */
-		spin_lock_irq(&phba->hbalock);
 		phba->work_ha |= HA_ERATT;
 		/* Indicate polling handles this ERATT */
 		phba->hba_flag |= HBA_ERATT_HANDLED;
-		spin_unlock_irq(&phba->hbalock);
 		return 1;
 	}
 	return 0;
@@ -7661,12 +7686,10 @@ lpfc_sli4_eratt_read(struct lpfc_hba *phba)
 			return 0;
 			phba->work_status[0] = uerr_sta_lo;
 			phba->work_status[1] = uerr_sta_hi;
-			spin_lock_irq(&phba->hbalock);
 			/* Set the driver HA work bitmap */
 			phba->work_ha |= HA_ERATT;
 			/* Indicate polling handles this ERATT */
 			phba->hba_flag |= HBA_ERATT_HANDLED;
-			spin_unlock_irq(&phba->hbalock);
 			return 1;
 		}
 	}
@@ -9349,6 +9372,7 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t entry_size,
 			kfree(dmabuf);
 			goto out_fail;
 		}
+		memset(dmabuf->virt, 0, PAGE_SIZE);
 		dmabuf->buffer_tag = x;
 		list_add_tail(&dmabuf->list, &queue->page_list);
 		/* initialize queue's entry array */
@@ -9771,7 +9795,7 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
 	/* link the wq onto the parent cq child list */
 	list_add_tail(&wq->list, &cq->child_list);
 out:
-	if (rc == MBX_TIMEOUT)
+	if (rc != MBX_TIMEOUT)
 		mempool_free(mbox, phba->mbox_mem_pool);
 	return status;
 }


