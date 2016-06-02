From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/14] lpfc: move to array based command allocation for SLI-4
Date: Thu,  2 Jun 2016 16:39:14 +0200
Message-ID: <1464878356-42407-13-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161121AbcFBOjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:25 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

On high-end arrays the list-based command allocation becomes a
bottleneck as the lock needs to be taken for each command allocation.
On the other hand the current blk-mq/scsi-mq infrastructure ensures
that a tag is never being reused. So this patch moves the command
allocation to an array-based structure, indexed by the command tag.
With this we can avoid taking a lock during command allocation, and
just mark the command as 'in-use' by setting a flag.
This allows for proper house-keeping in case the HBA needs to be
resetted.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_init.c | 53 +++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_scsi.c | 84 +++++++++++++++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_scsi.h |  7 ++--
 4 files changed, 128 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index bb53b81..289cc50 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -840,6 +840,7 @@ struct lpfc_hba {
 	uint64_t bg_reftag_err_cnt;
 
 	/* fastpath list. */
+	struct lpfc_scsi_buf **lpfc_scsi_buf_arr;
 	spinlock_t scsi_buf_list_get_lock;  /* SCSI buf alloc list lock */
 	spinlock_t scsi_buf_list_put_lock;  /* SCSI buf free list lock */
 	struct list_head lpfc_scsi_buf_list_get;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d2a6302..55ed075 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3071,6 +3071,20 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 	}
 	spin_unlock(&phba->scsi_buf_list_get_lock);
 
+	if (phba->lpfc_scsi_buf_arr) {
+		int idx;
+		for (idx = 0; idx < phba->cfg_hba_queue_depth; idx++) {
+			sb = phba->lpfc_scsi_buf_arr[idx];
+			if (!sb)
+				continue;
+			clear_bit(LPFC_CMD_QUEUED, &sb->flags);
+			list_del(&sb->list);
+			pci_pool_free(phba->lpfc_scsi_dma_buf_pool, sb->data,
+				      sb->dma_handle);
+			kfree(sb);
+			phba->total_scsi_bufs--;
+		}
+	}
 	/* Release all the lpfc_iocbq entries maintained by this host. */
 	list_for_each_entry_safe(io, io_next, &phba->lpfc_iocb_list, list) {
 		list_del(&io->list);
@@ -3212,6 +3226,18 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 			phba->sli4_hba.scsi_xri_cnt,
 			phba->sli4_hba.scsi_xri_max);
 
+	if (phba->lpfc_scsi_buf_arr) {
+		for (i = 0; i < phba->cfg_hba_queue_depth; i++) {
+			psb = phba->lpfc_scsi_buf_arr[i];
+			if (psb) {
+				if (test_and_set_bit(LPFC_CMD_QUEUED,
+						     &psb->flags))
+					continue;
+				list_add_tail(&psb->list, &scsi_sgl_list);
+			}
+		}
+	}
+
 	spin_lock_irq(&phba->scsi_buf_list_get_lock);
 	spin_lock(&phba->scsi_buf_list_put_lock);
 	list_splice_init(&phba->lpfc_scsi_buf_list_get, &scsi_sgl_list);
@@ -3228,6 +3254,9 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 			list_remove_head(&scsi_sgl_list, psb,
 					 struct lpfc_scsi_buf, list);
 			if (psb) {
+				clear_bit(LPFC_CMD_QUEUED, &psb->flags);
+				if (phba->lpfc_scsi_buf_arr)
+					phba->lpfc_scsi_buf_arr[psb->iotag] = NULL;
 				pci_pool_free(phba->lpfc_scsi_dma_buf_pool,
 					      psb->data, psb->dma_handle);
 				kfree(psb);
@@ -3258,8 +3287,17 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba *phba)
 	list_splice_init(&scsi_sgl_list, &phba->lpfc_scsi_buf_list_get);
 	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
 	spin_unlock(&phba->scsi_buf_list_put_lock);
-	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 
+	if (phba->lpfc_scsi_buf_arr) {
+		for (i = 0; i < phba->cfg_hba_queue_depth; i++) {
+			psb = phba->lpfc_scsi_buf_arr[i];
+			if (psb) {
+				clear_bit(LPFC_CMD_QUEUED, &psb->flags);
+				list_del_init(&psb->list);
+			}
+		}
+	}
+	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 	return 0;
 
 out_free_mem:
@@ -3329,7 +3367,8 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	 * scsi_add_host will fail. This will be adjusted later based on the
 	 * max xri value determined in hba setup.
 	 */
-	shost->can_queue = phba->cfg_hba_queue_depth - 10;
+	shost->can_queue = (phba->cfg_hba_queue_depth - 10) /
+		phba->cfg_fcp_io_channel;
 	if (dev != &phba->pcidev->dev) {
 		shost->transportt = lpfc_vport_transport_template;
 		vport->port_type = LPFC_NPIV_PORT;
@@ -3338,6 +3377,13 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 		vport->port_type = LPFC_PHYSICAL_PORT;
 	}
 
+	if (shost_use_blk_mq(shost) && phba->sli_rev == LPFC_SLI_REV4) {
+		phba->lpfc_scsi_buf_arr = kzalloc(sizeof(struct lpfc_scsi_buf *) *
+						  phba->cfg_hba_queue_depth, GFP_KERNEL);
+		if (!phba->lpfc_scsi_buf_arr)
+			goto out_put_shost;
+	}
+
 	/* Initialize all internally managed lists. */
 	INIT_LIST_HEAD(&vport->fc_nodes);
 	INIT_LIST_HEAD(&vport->rcv_buffer_list);
@@ -6312,7 +6358,8 @@ lpfc_post_init_setup(struct lpfc_hba *phba)
 	 * adjust the value of can_queue.
 	 */
 	shost = pci_get_drvdata(phba->pcidev);
-	shost->can_queue = phba->cfg_hba_queue_depth - 10;
+	shost->can_queue = (phba->cfg_hba_queue_depth - 10) /
+		phba->cfg_fcp_io_channel;
 	if (phba->sli3_options & LPFC_SLI3_BG_ENABLED)
 		lpfc_setup_bg(phba, shost);
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3111a9d..a3eb5ff 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -746,9 +746,19 @@ int
 lpfc_sli4_repost_scsi_sgl_list(struct lpfc_hba *phba)
 {
 	LIST_HEAD(post_sblist);
-	int num_posted, rc = 0;
+	int i, num_posted, rc = 0;
 
 	/* get all SCSI buffers need to repost to a local list */
+	if (phba->lpfc_scsi_buf_arr) {
+		struct lpfc_scsi_buf *psb;
+
+		for (i = 0; i < phba->cfg_hba_queue_depth; i++) {
+			psb = phba->lpfc_scsi_buf_arr[i];
+			if (psb &&
+			    !test_and_set_bit(LPFC_CMD_QUEUED, &psb->flags))
+				list_add(&psb->list, &post_sblist);
+		}
+	}
 	spin_lock_irq(&phba->scsi_buf_list_get_lock);
 	spin_lock(&phba->scsi_buf_list_put_lock);
 	list_splice_init(&phba->lpfc_scsi_buf_list_get, &post_sblist);
@@ -913,6 +923,12 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 		psb->dma_phys_bpl = pdma_phys_bpl;
 
 		/* add the scsi buffer to a post list */
+		if (phba->lpfc_scsi_buf_arr) {
+			int idx = phba->total_scsi_bufs + bcnt;
+			psb->iotag = idx;
+			phba->lpfc_scsi_buf_arr[idx] = psb;
+			set_bit(LPFC_CMD_QUEUED, &psb->flags);
+		}
 		list_add_tail(&psb->list, &post_sblist);
 		spin_lock_irq(&phba->scsi_buf_list_get_lock);
 		phba->sli4_hba.scsi_xri_cnt++;
@@ -1105,9 +1121,13 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 	} else {
 		psb->pCmd = NULL;
 		psb->cur_iocbq.iocb_flag = LPFC_IO_FCP;
-		spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
-		list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list_put);
-		spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
+		if (phba->lpfc_scsi_buf_arr)
+			clear_bit(LPFC_CMD_QUEUED, &psb->flags);
+		else {
+			spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
+			list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list_put);
+			spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
+		}
 	}
 }
 
@@ -4533,7 +4553,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *ndlp;
-	struct lpfc_scsi_buf *lpfc_cmd;
+	struct lpfc_scsi_buf *lpfc_cmd = NULL;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int err;
 
@@ -4566,7 +4586,28 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	if (atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth)
 		goto out_tgt_busy;
 
-	lpfc_cmd = lpfc_get_scsi_buf(phba, ndlp);
+	if (phba->lpfc_scsi_buf_arr) {
+		u32 tag = blk_mq_unique_tag(cmnd->request);
+		u16 hwq = blk_mq_unique_tag_to_hwq(tag);
+		u16 idx = blk_mq_unique_tag_to_tag(tag);
+
+		idx = idx * phba->cfg_fcp_io_channel + hwq;
+		if (idx >= phba->cfg_hba_queue_depth) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_SCSI_CMD,
+					 "9034 iotag %x too large\n", idx);
+		} else
+			lpfc_cmd = phba->lpfc_scsi_buf_arr[idx];
+		if (!lpfc_cmd)
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_SCSI_CMD,
+					 "9035 iotag %x invalid\n", idx);
+		else if (test_and_set_bit(LPFC_CMD_QUEUED, &lpfc_cmd->flags)) {
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_SCSI_CMD,
+					 "9036 iotag %x hwq %x busy\n",
+					 lpfc_cmd->iotag, hwq);
+			lpfc_cmd = NULL;
+		}
+	} else
+		lpfc_cmd = lpfc_get_scsi_buf(phba, ndlp);
 	if (lpfc_cmd == NULL) {
 		lpfc_rampdown_queue_depth(phba);
 
@@ -4962,7 +5003,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
 		    uint8_t task_mgmt_cmd)
 {
 	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_scsi_buf *lpfc_cmd;
+	struct lpfc_scsi_buf *lpfc_cmd = NULL;
 	struct lpfc_iocbq *iocbq;
 	struct lpfc_iocbq *iocbqrsp;
 	struct lpfc_nodelist *pnode = rdata->pnode;
@@ -4972,7 +5013,21 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
 	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
 		return FAILED;
 
-	lpfc_cmd = lpfc_get_scsi_buf(phba, rdata->pnode);
+	if (phba->lpfc_scsi_buf_arr) {
+		int idx;
+		for (idx = 0; idx < phba->cfg_hba_queue_depth; idx++) {
+			lpfc_cmd = phba->lpfc_scsi_buf_arr[idx];
+			if (test_and_set_bit(LPFC_CMD_QUEUED,
+					     &lpfc_cmd->flags)) {
+				ret = 0;
+				break;
+			}
+			ret = -EBUSY;
+		}
+		if (ret < 0)
+			lpfc_cmd = NULL;
+	} else
+		lpfc_cmd = lpfc_get_scsi_buf(phba, rdata->pnode);
 	if (lpfc_cmd == NULL)
 		return FAILED;
 	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
@@ -5483,10 +5538,12 @@ lpfc_slave_alloc(struct scsi_device *sdev)
 	 * extra.  This list of scsi bufs exists for the lifetime of the driver.
 	 */
 	total = phba->total_scsi_bufs;
-	num_to_alloc = vport->cfg_lun_queue_depth + 2;
+	num_to_alloc = (vport->cfg_lun_queue_depth + 2) *
+		phba->cfg_fcp_io_channel;
 
 	/* If allocated buffers are enough do nothing */
-	if ((sdev_cnt * (vport->cfg_lun_queue_depth + 2)) < total)
+	if (!shost_use_blk_mq(sdev->host) &&
+	    (sdev_cnt * (vport->cfg_lun_queue_depth + 2)) < total)
 		return 0;
 
 	/* Allow some exchanges to be available always to complete discovery */
@@ -5514,8 +5571,13 @@ lpfc_slave_alloc(struct scsi_device *sdev)
 					 "Allocated %d buffers.\n",
 					 num_to_alloc, num_allocated);
 	}
-	if (num_allocated > 0)
+	if (num_allocated > 0) {
 		phba->total_scsi_bufs += num_allocated;
+		if (shost_use_blk_mq(sdev->host)) {
+			int num_tags = num_allocated / phba->cfg_fcp_io_channel;
+			scsi_mq_resize_tags(sdev->host, num_tags);
+		}
+	}
 	return 0;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 4e8f0bd..a07341e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -134,7 +134,7 @@ struct lpfc_scsi_buf {
 
 	uint32_t timeout;
 
-	uint16_t xx_exch_busy;     /* SLI4 hba reported XB on complete WCQE */
+	uint16_t iotag;
 	uint16_t status;	/* From IOCB Word 7- ulpStatus */
 	uint32_t result;	/* From IOCB Word 4. */
 
@@ -144,8 +144,9 @@ struct lpfc_scsi_buf {
 	uint32_t prot_seg_cnt;  /* seg_cnt's counterpart for protection data */
 
 	unsigned long flags;
-#define LPFC_CMD_EXCH_BUSY 1
-#define LPFC_CMD_ABORTED   2
+#define LPFC_CMD_EXCH_BUSY 0
+#define LPFC_CMD_ABORTED   1
+#define LPFC_CMD_QUEUED    2
 	dma_addr_t nonsg_phys;	/* Non scatter-gather physical address. */
 
 	/*
-- 
1.8.5.6

