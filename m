From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/7] lpfc: remove queue_depth events
Date: Thu, 13 Nov 2014 18:59:00 +0100
Message-ID: <1415901546-8006-2-git-send-email-hch@lst.de>
References: <1415901546-8006-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54656 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933561AbaKMR7I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 12:59:08 -0500
In-Reply-To: <1415901546-8006-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

James Smart said the userspace to consume these events never emerged.  Given
that these get in the way of the following patches remove support for them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 66 -------------------------------------------
 1 file changed, 66 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 8533ee9..80351ff 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -243,60 +243,6 @@ lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
 }
 
 /**
- * lpfc_send_sdev_queuedepth_change_event - Posts a queuedepth change event
- * @phba: Pointer to HBA context object.
- * @vport: Pointer to vport object.
- * @ndlp: Pointer to FC node associated with the target.
- * @lun: Lun number of the scsi device.
- * @old_val: Old value of the queue depth.
- * @new_val: New value of the queue depth.
- *
- * This function sends an event to the mgmt application indicating
- * there is a change in the scsi device queue depth.
- **/
-static void
-lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
-		struct lpfc_vport  *vport,
-		struct lpfc_nodelist *ndlp,
-		uint64_t lun,
-		uint32_t old_val,
-		uint32_t new_val)
-{
-	struct lpfc_fast_path_event *fast_path_evt;
-	unsigned long flags;
-
-	fast_path_evt = lpfc_alloc_fast_evt(phba);
-	if (!fast_path_evt)
-		return;
-
-	fast_path_evt->un.queue_depth_evt.scsi_event.event_type =
-		FC_REG_SCSI_EVENT;
-	fast_path_evt->un.queue_depth_evt.scsi_event.subcategory =
-		LPFC_EVENT_VARQUEDEPTH;
-
-	/* Report all luns with change in queue depth */
-	fast_path_evt->un.queue_depth_evt.scsi_event.lun = lun;
-	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
-		memcpy(&fast_path_evt->un.queue_depth_evt.scsi_event.wwpn,
-			&ndlp->nlp_portname, sizeof(struct lpfc_name));
-		memcpy(&fast_path_evt->un.queue_depth_evt.scsi_event.wwnn,
-			&ndlp->nlp_nodename, sizeof(struct lpfc_name));
-	}
-
-	fast_path_evt->un.queue_depth_evt.oldval = old_val;
-	fast_path_evt->un.queue_depth_evt.newval = new_val;
-	fast_path_evt->vport = vport;
-
-	fast_path_evt->work_evt.evt = LPFC_EVT_FASTPATH_MGMT_EVT;
-	spin_lock_irqsave(&phba->hbalock, flags);
-	list_add_tail(&fast_path_evt->work_evt.evt_listp, &phba->work_list);
-	spin_unlock_irqrestore(&phba->hbalock, flags);
-	lpfc_worker_wake_up(phba);
-
-	return;
-}
-
-/**
  * lpfc_change_queue_depth - Alter scsi device queue depth
  * @sdev: Pointer the scsi device on which to change the queue depth.
  * @qdepth: New queue depth to set the sdev to.
@@ -310,11 +256,6 @@ static int
 lpfc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_rport_data *rdata;
-	unsigned long new_queue_depth, old_queue_depth;
-
-	old_queue_depth = sdev->queue_depth;
 
 	switch (reason) {
 	case SCSI_QDEPTH_DEFAULT:
@@ -334,13 +275,6 @@ lpfc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 		return -EOPNOTSUPP;
 	}
 
-	new_queue_depth = sdev->queue_depth;
-	rdata = lpfc_rport_data_from_scsi_device(sdev);
-	if (rdata)
-		lpfc_send_sdev_queuedepth_change_event(phba, vport,
-						       rdata->pnode, sdev->lun,
-						       old_queue_depth,
-						       new_queue_depth);
 	return sdev->queue_depth;
 }
 
-- 
1.9.1

