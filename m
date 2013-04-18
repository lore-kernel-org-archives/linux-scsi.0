From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/22] lpfc 8.3.39: Reduced spinlock contention on SCSI
 buffer list
Date: Wed, 17 Apr 2013 20:17:40 -0400
Message-ID: <1366244260.1513.12.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:15676 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935849Ab3DRARn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:17:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reduced spinlock contention on SCSI buffer list


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    6 ++-
 lpfc_init.c |   54 ++++++++++++++++++++++++----------
 lpfc_scsi.c |   93 ++++++++++++++++++++++++++++++++++++++----------------------
 3 files changed, 102 insertions(+), 51 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2013-04-15 18:26:32.479041017 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2013-04-15 18:26:40.561041201 -0400
@@ -813,8 +813,10 @@ struct lpfc_hba {
 	uint64_t bg_reftag_err_cnt;
 
 	/* fastpath list. */
-	spinlock_t scsi_buf_list_lock;
-	struct list_head lpfc_scsi_buf_list;
+	spinlock_t scsi_buf_list_get_lock;  /* SCSI buf alloc list lock */
+	spinlock_t scsi_buf_list_put_lock;  /* SCSI buf free list lock */
+	struct list_head lpfc_scsi_buf_list_get;
+	struct list_head lpfc_scsi_buf_list_put;
 	uint32_t total_scsi_bufs;
 	struct list_head lpfc_iocb_list;
 	uint32_t total_iocbq_bufs;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:36.988041120 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:26:40.579041201 -0400
@@ -911,9 +911,9 @@ lpfc_hba_down_post_s4(struct lpfc_hba *p
 		psb->pCmd = NULL;
 		psb->status = IOSTAT_SUCCESS;
 	}
-	spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
-	list_splice(&aborts, &phba->lpfc_scsi_buf_list);
-	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
+	spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
+	list_splice(&aborts, &phba->lpfc_scsi_buf_list_put);
+	spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
 	return 0;
 }
 
@@ -2854,16 +2854,30 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 	struct lpfc_iocbq *io, *io_next;
 
 	spin_lock_irq(&phba->hbalock);
+
 	/* Release all the lpfc_scsi_bufs maintained by this host. */
-	spin_lock(&phba->scsi_buf_list_lock);
-	list_for_each_entry_safe(sb, sb_next, &phba->lpfc_scsi_buf_list, list) {
+
+	spin_lock(&phba->scsi_buf_list_put_lock);
+	list_for_each_entry_safe(sb, sb_next, &phba->lpfc_scsi_buf_list_put,
+				 list) {
+		list_del(&sb->list);
+		pci_pool_free(phba->lpfc_scsi_dma_buf_pool, sb->data,
+			      sb->dma_handle);
+		kfree(sb);
+		phba->total_scsi_bufs--;
+	}
+	spin_unlock(&phba->scsi_buf_list_put_lock);
+
+	spin_lock(&phba->scsi_buf_list_get_lock);
+	list_for_each_entry_safe(sb, sb_next, &phba->lpfc_scsi_buf_list_get,
+				 list) {
 		list_del(&sb->list);
 		pci_pool_free(phba->lpfc_scsi_dma_buf_pool, sb->data,
 			      sb->dma_handle);
 		kfree(sb);
 		phba->total_scsi_bufs--;
 	}
-	spin_unlock(&phba->scsi_buf_list_lock);
+	spin_unlock(&phba->scsi_buf_list_get_lock);
 
 	/* Release all the lpfc_iocbq entries maintained by this host. */
 	list_for_each_entry_safe(io, io_next, &phba->lpfc_iocb_list, list) {
@@ -2999,9 +3013,12 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba
 			phba->sli4_hba.scsi_xri_cnt,
 			phba->sli4_hba.scsi_xri_max);
 
-	spin_lock_irq(&phba->scsi_buf_list_lock);
-	list_splice_init(&phba->lpfc_scsi_buf_list, &scsi_sgl_list);
-	spin_unlock_irq(&phba->scsi_buf_list_lock);
+	spin_lock_irq(&phba->scsi_buf_list_get_lock);
+	spin_lock_irq(&phba->scsi_buf_list_put_lock);
+	list_splice_init(&phba->lpfc_scsi_buf_list_get, &scsi_sgl_list);
+	list_splice(&phba->lpfc_scsi_buf_list_put, &scsi_sgl_list);
+	spin_unlock_irq(&phba->scsi_buf_list_put_lock);
+	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 
 	if (phba->sli4_hba.scsi_xri_cnt > phba->sli4_hba.scsi_xri_max) {
 		/* max scsi xri shrinked below the allocated scsi buffers */
@@ -3015,9 +3032,9 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba
 				      psb->dma_handle);
 			kfree(psb);
 		}
-		spin_lock_irq(&phba->scsi_buf_list_lock);
+		spin_lock_irq(&phba->scsi_buf_list_get_lock);
 		phba->sli4_hba.scsi_xri_cnt -= scsi_xri_cnt;
-		spin_unlock_irq(&phba->scsi_buf_list_lock);
+		spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 	}
 
 	/* update xris associated to remaining allocated scsi buffers */
@@ -3035,9 +3052,12 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba
 		psb->cur_iocbq.sli4_lxritag = lxri;
 		psb->cur_iocbq.sli4_xritag = phba->sli4_hba.xri_ids[lxri];
 	}
-	spin_lock_irq(&phba->scsi_buf_list_lock);
-	list_splice_init(&scsi_sgl_list, &phba->lpfc_scsi_buf_list);
-	spin_unlock_irq(&phba->scsi_buf_list_lock);
+	spin_lock_irq(&phba->scsi_buf_list_get_lock);
+	spin_lock_irq(&phba->scsi_buf_list_put_lock);
+	list_splice_init(&scsi_sgl_list, &phba->lpfc_scsi_buf_list_get);
+	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
+	spin_unlock_irq(&phba->scsi_buf_list_put_lock);
+	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 
 	return 0;
 
@@ -5334,8 +5354,10 @@ lpfc_setup_driver_resource_phase1(struct
 	init_waitqueue_head(&phba->work_waitq);
 
 	/* Initialize the scsi buffer list used by driver for scsi IO */
-	spin_lock_init(&phba->scsi_buf_list_lock);
-	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list);
+	spin_lock_init(&phba->scsi_buf_list_get_lock);
+	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_get);
+	spin_lock_init(&phba->scsi_buf_list_put_lock);
+	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
 
 	/* Initialize the fabric iocb list */
 	INIT_LIST_HEAD(&phba->fabric_iocb_list);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-04-15 18:26:32.493041017 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-04-15 18:26:40.587041201 -0400
@@ -899,9 +899,12 @@ lpfc_sli4_repost_scsi_sgl_list(struct lp
 	int num_posted, rc = 0;
 
 	/* get all SCSI buffers need to repost to a local list */
-	spin_lock_irq(&phba->scsi_buf_list_lock);
-	list_splice_init(&phba->lpfc_scsi_buf_list, &post_sblist);
-	spin_unlock_irq(&phba->scsi_buf_list_lock);
+	spin_lock_irq(&phba->scsi_buf_list_get_lock);
+	spin_lock_irq(&phba->scsi_buf_list_put_lock);
+	list_splice_init(&phba->lpfc_scsi_buf_list_get, &post_sblist);
+	list_splice(&phba->lpfc_scsi_buf_list_put, &post_sblist);
+	spin_unlock_irq(&phba->scsi_buf_list_put_lock);
+	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 
 	/* post the list of scsi buffer sgls to port if available */
 	if (!list_empty(&post_sblist)) {
@@ -1053,9 +1056,9 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 
 		/* add the scsi buffer to a post list */
 		list_add_tail(&psb->list, &post_sblist);
-		spin_lock_irq(&phba->scsi_buf_list_lock);
+		spin_lock_irq(&phba->scsi_buf_list_get_lock);
 		phba->sli4_hba.scsi_xri_cnt++;
-		spin_unlock_irq(&phba->scsi_buf_list_lock);
+		spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 	}
 	lpfc_printf_log(phba, KERN_INFO, LOG_BG,
 			"3021 Allocate %d out of %d requested new SCSI "
@@ -1104,17 +1107,23 @@ static struct lpfc_scsi_buf*
 lpfc_get_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	struct  lpfc_scsi_buf * lpfc_cmd = NULL;
-	struct list_head *scsi_buf_list = &phba->lpfc_scsi_buf_list;
-	unsigned long iflag = 0;
-
-	spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
-	list_remove_head(scsi_buf_list, lpfc_cmd, struct lpfc_scsi_buf, list);
-	if (lpfc_cmd) {
-		lpfc_cmd->seg_cnt = 0;
-		lpfc_cmd->nonsg_phys = 0;
-		lpfc_cmd->prot_seg_cnt = 0;
+	struct list_head *scsi_buf_list_get = &phba->lpfc_scsi_buf_list_get;
+	unsigned long gflag = 0;
+	unsigned long pflag = 0;
+
+	spin_lock_irqsave(&phba->scsi_buf_list_get_lock, gflag);
+	list_remove_head(scsi_buf_list_get, lpfc_cmd, struct lpfc_scsi_buf,
+			 list);
+	if (!lpfc_cmd) {
+		spin_lock_irqsave(&phba->scsi_buf_list_put_lock, pflag);
+		list_splice(&phba->lpfc_scsi_buf_list_put,
+			    &phba->lpfc_scsi_buf_list_get);
+		INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
+		list_remove_head(scsi_buf_list_get, lpfc_cmd,
+				 struct lpfc_scsi_buf, list);
+		spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, pflag);
 	}
-	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
+	spin_unlock_irqrestore(&phba->scsi_buf_list_get_lock, gflag);
 	return  lpfc_cmd;
 }
 /**
@@ -1132,28 +1141,39 @@ static struct lpfc_scsi_buf*
 lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_scsi_buf *lpfc_cmd ;
-	unsigned long iflag = 0;
+	unsigned long gflag = 0;
+	unsigned long pflag = 0;
 	int found = 0;
 
-	spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
-	list_for_each_entry(lpfc_cmd, &phba->lpfc_scsi_buf_list,
-							list) {
+	spin_lock_irqsave(&phba->scsi_buf_list_get_lock, gflag);
+	list_for_each_entry(lpfc_cmd, &phba->lpfc_scsi_buf_list_get, list) {
 		if (lpfc_test_rrq_active(phba, ndlp,
 					 lpfc_cmd->cur_iocbq.sli4_lxritag))
 			continue;
 		list_del(&lpfc_cmd->list);
 		found = 1;
-		lpfc_cmd->seg_cnt = 0;
-		lpfc_cmd->nonsg_phys = 0;
-		lpfc_cmd->prot_seg_cnt = 0;
 		break;
 	}
-	spin_unlock_irqrestore(&phba->scsi_buf_list_lock,
-						 iflag);
+	if (!found) {
+		spin_lock_irqsave(&phba->scsi_buf_list_put_lock, pflag);
+		list_splice(&phba->lpfc_scsi_buf_list_put,
+			    &phba->lpfc_scsi_buf_list_get);
+		INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
+		spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, pflag);
+		list_for_each_entry(lpfc_cmd, &phba->lpfc_scsi_buf_list_get,
+				    list) {
+			if (lpfc_test_rrq_active(
+				phba, ndlp, lpfc_cmd->cur_iocbq.sli4_lxritag))
+				continue;
+			list_del(&lpfc_cmd->list);
+			found = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&phba->scsi_buf_list_get_lock, gflag);
 	if (!found)
 		return NULL;
-	else
-		return  lpfc_cmd;
+	return  lpfc_cmd;
 }
 /**
  * lpfc_get_scsi_buf - Get a scsi buffer from lpfc_scsi_buf_list of the HBA
@@ -1185,10 +1205,14 @@ lpfc_release_scsi_buf_s3(struct lpfc_hba
 {
 	unsigned long iflag = 0;
 
-	spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
+	psb->seg_cnt = 0;
+	psb->nonsg_phys = 0;
+	psb->prot_seg_cnt = 0;
+
+	spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
 	psb->pCmd = NULL;
-	list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list);
-	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
+	list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list_put);
+	spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
 }
 
 /**
@@ -1206,6 +1230,10 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba
 {
 	unsigned long iflag = 0;
 
+	psb->seg_cnt = 0;
+	psb->nonsg_phys = 0;
+	psb->prot_seg_cnt = 0;
+
 	if (psb->exch_busy) {
 		spin_lock_irqsave(&phba->sli4_hba.abts_scsi_buf_list_lock,
 					iflag);
@@ -1215,11 +1243,10 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba
 		spin_unlock_irqrestore(&phba->sli4_hba.abts_scsi_buf_list_lock,
 					iflag);
 	} else {
-
-		spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
 		psb->pCmd = NULL;
-		list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list);
-		spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
+		spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
+		list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list_put);
+		spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
 	}
 }
 



