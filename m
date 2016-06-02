From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/14] lpfc: set LPFC_CMD_ABORTED when a command is put on the aborted list
Date: Thu,  2 Jun 2016 16:39:13 +0200
Message-ID: <1464878356-42407-12-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014AbcFBOjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:25 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 drivers/scsi/lpfc/lpfc_scsi.c | 3 +++
 drivers/scsi/lpfc/lpfc_scsi.h | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b43f7ac..d2a6302 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1028,6 +1028,7 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 
 	list_for_each_entry_safe(psb, psb_next, &aborts, list) {
+		clear_bit(LPFC_CMD_ABORTED, &psb->flags);
 		psb->pCmd = NULL;
 		psb->status = IOSTAT_SUCCESS;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4354713..3111a9d 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -556,6 +556,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
 		&phba->sli4_hba.lpfc_abts_scsi_buf_list, list) {
 		if (psb->cur_iocbq.sli4_xritag == xri) {
 			list_del(&psb->list);
+			clear_bit(LPFC_CMD_ABORTED, &psb->flags);
 			clear_bit(LPFC_CMD_EXCH_BUSY, &psb->flags);
 			psb->status = IOSTAT_SUCCESS;
 			spin_unlock(
@@ -1092,6 +1093,8 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 	psb->prot_seg_cnt = 0;
 
 	if (test_bit(LPFC_CMD_EXCH_BUSY, &psb->flags)) {
+		if (!test_and_set_bit(LPFC_CMD_ABORTED, &psb->flags))
+			return;
 		spin_lock_irqsave(&phba->sli4_hba.abts_scsi_buf_list_lock,
 					iflag);
 		psb->pCmd = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index a3658ce..4e8f0bd 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -145,6 +145,7 @@ struct lpfc_scsi_buf {
 
 	unsigned long flags;
 #define LPFC_CMD_EXCH_BUSY 1
+#define LPFC_CMD_ABORTED   2
 	dma_addr_t nonsg_phys;	/* Non scatter-gather physical address. */
 
 	/*
-- 
1.8.5.6

