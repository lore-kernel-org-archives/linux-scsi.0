From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 10/10] mpt3sas: lockless command submission for scsi-mq
Date: Tue, 21 Feb 2017 13:27:09 +0100
Message-ID: <1487680029-3701-11-git-send-email-hare@suse.de>
References: <1487680029-3701-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58977 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752493AbdBUM1r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 07:27:47 -0500
In-Reply-To: <1487680029-3701-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Enable lockless command submission for scsi-mq by moving the
command structure into the payload for struct request.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 123 ++++++++++++-------------
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  19 ++--
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  22 +++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 153 ++++++++++---------------------
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  35 +------
 5 files changed, 128 insertions(+), 224 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0875e58..0177d37 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -865,10 +865,19 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 struct scsiio_tracker *
 mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
+	u32 unique_tag;
+	struct scsi_cmnd *cmd;
+
 	if (WARN_ON(!smid) ||
 	    WARN_ON(smid >= ioc->hi_priority_smid))
 		return NULL;
-	return &ioc->scsi_lookup[smid - 1];
+
+	unique_tag = smid - 1;
+	cmd = scsi_host_find_tag(ioc->shost, unique_tag);
+	if (cmd)
+		return scsi_cmd_priv(cmd);
+
+	return NULL;
 }
 
 /**
@@ -2345,26 +2354,22 @@ struct scsiio_tracker *
 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsi_cmnd *scmd)
 {
-	unsigned long flags;
-	struct scsiio_tracker *request;
+	struct scsiio_tracker *request = scsi_cmd_priv(scmd);
+	unsigned int tag;
 	u16 smid;
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	if (list_empty(&ioc->free_list)) {
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		pr_err(MPT3SAS_FMT "%s: smid not available\n",
-		    ioc->name, __func__);
-		return 0;
-	}
+	if (ioc->shost->use_blk_mq) {
+		u32 unique_tag = blk_mq_unique_tag(scmd->request);
+
+		tag = blk_mq_unique_tag_to_tag(unique_tag);
+	} else
+		tag = scmd->request->tag;
 
-	request = list_entry(ioc->free_list.next,
-	    struct scsiio_tracker, tracker_list);
-	request->scmd = scmd;
+	smid = tag + 1;
 	request->cb_idx = cb_idx;
-	smid = request->smid;
 	request->msix_io = _base_get_msix_index(ioc);
-	list_del(&request->tracker_list);
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	request->smid = smid;
+	INIT_LIST_HEAD(&request->chain_list);
 	return smid;
 }
 
@@ -2410,6 +2415,22 @@ struct scsiio_tracker *
 	}
 }
 
+void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
+			   struct scsiio_tracker *st)
+{
+	if (WARN_ON(st->smid == 0))
+		return;
+	st->cb_idx = 0xFF;
+	st->direct_io = 0;
+	if (!list_empty(&st->chain_list)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+		list_splice_init(&st->chain_list, &ioc->free_chain_list);
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	}
+}
+
 /**
  * mpt3sas_base_free_smid - put smid back on free_list
  * @ioc: per adapter object
@@ -2423,23 +2444,21 @@ struct scsiio_tracker *
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (smid < ioc->hi_priority_smid) {
-		/* scsiio queue */
-		i = smid - 1;
-		list_splice_init(&ioc->scsi_lookup[i].chain_list,
-				 &ioc->free_chain_list);
-		ioc->scsi_lookup[i].cb_idx = 0xFF;
-		ioc->scsi_lookup[i].scmd = NULL;
-		ioc->scsi_lookup[i].direct_io = 0;
-		if (i < ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT)
-			list_add(&ioc->scsi_lookup[i].tracker_list,
-				 &ioc->free_list);
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		struct scsiio_tracker *st;
 
+		st = mpt3sas_get_st_from_smid(ioc, smid);
+		if (WARN_ON(!st)) {
+			_base_recovery_check(ioc);
+			return;
+		}
+		mpt3sas_base_clear_st(ioc, st);
 		_base_recovery_check(ioc);
 		return;
-	} else if (smid < ioc->internal_smid) {
+	}
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	if (smid < ioc->internal_smid) {
 		/* hi-priority */
 		i = smid - ioc->hi_priority_smid;
 		ioc->hpr_lookup[i].cb_idx = 0xFF;
@@ -3272,10 +3291,6 @@ struct scsiio_tracker *
 		    ioc->config_page, ioc->config_page_dma);
 	}
 
-	if (ioc->scsi_lookup) {
-		free_pages((ulong)ioc->scsi_lookup, ioc->scsi_lookup_pages);
-		ioc->scsi_lookup = NULL;
-	}
 	kfree(ioc->hpr_lookup);
 	kfree(ioc->internal_lookup);
 	if (ioc->chain_lookup) {
@@ -3509,7 +3524,8 @@ struct scsiio_tracker *
 	/* set the scsi host can_queue depth
 	 * with some internal commands that could be outstanding
 	 */
-	ioc->shost->can_queue = ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT;
+	ioc->shost->reserved_cmds = INTERNAL_SCSIIO_CMDS_COUNT;
+	ioc->shost->can_queue = ioc->scsiio_depth - ioc->shost->reserved_cmds;
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT
 		"scsi host: can_queue depth (%d)\n",
 		ioc->name, ioc->shost->can_queue));
@@ -3569,16 +3585,6 @@ struct scsiio_tracker *
 	    ioc->name, (unsigned long long) ioc->request_dma));
 	total_sz += sz;
 
-	sz = ioc->scsiio_depth * sizeof(struct scsiio_tracker);
-	ioc->scsi_lookup_pages = get_order(sz);
-	ioc->scsi_lookup = (struct scsiio_tracker *)__get_free_pages(
-	    GFP_KERNEL, ioc->scsi_lookup_pages);
-	if (!ioc->scsi_lookup) {
-		pr_err(MPT3SAS_FMT "scsi_lookup: get_free_pages failed, sz(%d)\n",
-			ioc->name, (int)sz);
-		goto out;
-	}
-
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "scsiio(0x%p): depth(%d)\n",
 		ioc->name, ioc->request, ioc->scsiio_depth));
 
@@ -5166,22 +5172,7 @@ struct scsiio_tracker *
 		kfree(delayed_event_ack);
 	}
 
-	/* initialize the scsi lookup free list */
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	INIT_LIST_HEAD(&ioc->free_list);
-	smid = 1;
-	for (i = 0; i < ioc->scsiio_depth; i++, smid++) {
-		INIT_LIST_HEAD(&ioc->scsi_lookup[i].chain_list);
-		ioc->scsi_lookup[i].cb_idx = 0xFF;
-		ioc->scsi_lookup[i].smid = smid;
-		ioc->scsi_lookup[i].scmd = NULL;
-		ioc->scsi_lookup[i].direct_io = 0;
-		if (i < ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT)
-			list_add_tail(&ioc->scsi_lookup[i].tracker_list,
-				      &ioc->free_list);
-		else
-			INIT_LIST_HEAD(&ioc->lookup[i].tracker_list);
-	}
 
 	/* hi-priority queue */
 	INIT_LIST_HEAD(&ioc->hpr_free_list);
@@ -5692,8 +5683,7 @@ struct scsiio_tracker *
 _wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 ioc_state;
-	unsigned long flags;
-	u16 i;
+	u16 smid;
 
 	ioc->pending_io_count = 0;
 
@@ -5702,12 +5692,13 @@ struct scsiio_tracker *
 		return;
 
 	/* pending command count */
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = 0; i < ioc->scsiio_depth; i++)
-		if (ioc->scsi_lookup[i].cb_idx != 0xFF)
-			ioc->pending_io_count++;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
+		struct scsiio_tracker *st;
 
+		st = mpt3sas_get_st_from_smid(ioc, smid);
+		if (st->cb_idx != 0xFF)
+			ioc->pending_io_count++;
+	}
 	if (!ioc->pending_io_count)
 		return;
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 74186e3..71b438e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -646,19 +646,16 @@ struct chain_tracker {
 /**
  * struct scsiio_tracker - scsi mf request tracker
  * @smid: system message id
- * @scmd: scsi request pointer
  * @cb_idx: callback index
  * @direct_io: To indicate whether I/O is direct (WARPDRIVE)
- * @tracker_list: list of free request (ioc->free_list)
+ * @chain_list: list of associated firmware chain tracker
  * @msix_io: IO's msix
  */
 struct scsiio_tracker {
 	u16	smid;
-	struct scsi_cmnd *scmd;
 	u8	cb_idx;
 	u8	direct_io;
 	struct list_head chain_list;
-	struct list_head tracker_list;
 	u16     msix_io;
 };
 
@@ -1100,10 +1097,7 @@ struct MPT3SAS_ADAPTER {
 	u8		*request;
 	dma_addr_t	request_dma;
 	u32		request_dma_sz;
-	struct scsiio_tracker *scsi_lookup;
-	ulong		scsi_lookup_pages;
 	spinlock_t	scsi_lookup_lock;
-	struct list_head free_list;
 	int		pending_io_count;
 	wait_queue_head_t reset_wq;
 
@@ -1249,6 +1243,8 @@ u16 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsi_cmnd *scmd);
 struct scsiio_tracker * mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid);
+void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
+			   struct scsiio_tracker *st);
 
 u16 mpt3sas_base_get_smid(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
 void mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid);
@@ -1302,6 +1298,8 @@ void mpt3sas_device_remove_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
 	u64 sas_address);
 u8 mpt3sas_check_for_pending_internal_cmds(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid);
+struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
+	u16 smid);
 
 struct _sas_node *mpt3sas_scsih_expander_find_by_handle(
 	struct MPT3SAS_ADAPTER *ioc, u16 handle);
@@ -1453,14 +1451,9 @@ void mpt3sas_trigger_mpi(struct MPT3SAS_ADAPTER *ioc, u16 ioc_status,
 u8 mpt3sas_get_num_volumes(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
 	struct _raid_device *raid_device);
-u8
-mpt3sas_scsi_direct_io_get(struct MPT3SAS_ADAPTER *ioc, u16 smid);
-void
-mpt3sas_scsi_direct_io_set(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 direct_io);
 void
 mpt3sas_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
-	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
-	u16 smid);
+	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request);
 
 /* NCQ Prio Handling Check */
 bool scsih_ncq_prio_supp(struct scsi_device *sdev);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 23e0ef1..bcc6a51 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -563,11 +563,10 @@ enum block_state {
 	Mpi2SCSITaskManagementRequest_t *tm_request)
 {
 	u8 found = 0;
-	u16 i;
+	u16 smid;
 	u16 handle;
 	struct scsi_cmnd *scmd;
 	struct MPT3SAS_DEVICE *priv_data;
-	unsigned long flags;
 	Mpi2SCSITaskManagementReply_t *tm_reply;
 	u32 sz;
 	u32 lun;
@@ -583,11 +582,11 @@ enum block_state {
 	lun = scsilun_to_int((struct scsi_lun *)tm_request->LUN);
 
 	handle = le16_to_cpu(tm_request->DevHandle);
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = ioc->scsiio_depth; i && !found; i--) {
-		scmd = ioc->scsi_lookup[i - 1].scmd;
-		if (scmd == NULL || scmd->device == NULL ||
-		    scmd->device->hostdata == NULL)
+	for (smid = ioc->scsiio_depth; smid && !found; smid--) {
+		struct scsiio_tracker *st;
+
+		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
+		if (!scmd)
 			continue;
 		if (lun != scmd->device->lun)
 			continue;
@@ -596,10 +595,10 @@ enum block_state {
 			continue;
 		if (priv_data->sas_target->handle != handle)
 			continue;
-		tm_request->TaskMID = cpu_to_le16(ioc->scsi_lookup[i - 1].smid);
+		st = scsi_cmd_priv(scmd);
+		tm_request->TaskMID = cpu_to_le16(st->smid);
 		found = 1;
 	}
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 	if (!found) {
 		dctlprintk(ioc, pr_info(MPT3SAS_FMT
@@ -720,7 +719,10 @@ enum block_state {
 		}
 	} else {
 		/* Use first reserved smid for passthrough ioctls */
-		smid = ioc->scsiio_depth - ioc->host->reserved_cmds;
+		if (ioc->shost->use_blk_mq)
+			smid = 1;
+		else
+			smid = ioc->scsiio_depth - ioc->shost->reserved_cmds;
 	}
 
 	ret = 0;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 1c45fb3..55d062a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1061,75 +1061,30 @@ struct _sas_node *
 }
 
 /**
- * __scsih_scsi_lookup_get_clear - returns scmd entry without
- *						holding any lock.
- * @ioc: per adapter object
- * @smid: system request message index
- *
- * Returns the smid stored scmd pointer.
- * Then will dereference the stored scmd pointer.
- */
-static inline struct scsi_cmnd *
-__scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc,
-		u16 smid)
-{
-	struct scsi_cmnd *scmd = NULL;
-
-	swap(scmd, ioc->scsi_lookup[smid - 1].scmd);
-
-	return scmd;
-}
-
-/**
- * _scsih_scsi_lookup_get_clear - returns scmd entry
+ * mpt3sas_scsih_scsi_lookup_get - returns scmd entry
  * @ioc: per adapter object
  * @smid: system request message index
  *
  * Returns the smid stored scmd pointer.
  * Then will derefrence the stored scmd pointer.
  */
-static inline struct scsi_cmnd *
-_scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+struct scsi_cmnd *
+mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
-	unsigned long flags;
-	struct scsi_cmnd *scmd;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	scmd = __scsih_scsi_lookup_get_clear(ioc, smid);
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-
-	return scmd;
-}
+	struct scsi_cmnd *scmd = NULL;
+	struct scsiio_tracker *st;
 
-/**
- * _scsih_scsi_lookup_find_by_scmd - scmd lookup
- * @ioc: per adapter object
- * @smid: system request message index
- * @scmd: pointer to scsi command object
- * Context: This function will acquire ioc->scsi_lookup_lock.
- *
- * This will search for a scmd pointer in the scsi_lookup array,
- * returning the revelent smid.  A returned value of zero means invalid.
- */
-static u16
-_scsih_scsi_lookup_find_by_scmd(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd
-	*scmd)
-{
-	u16 smid;
-	unsigned long	flags;
-	int i;
+	if (smid > 0) {
+		u32 unique_tag = smid - 1;
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	smid = 0;
-	for (i = 0; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd == scmd) {
-			smid = ioc->scsi_lookup[i].smid;
-			goto out;
+		scmd = scsi_host_find_tag(ioc->shost, unique_tag);
+		if (scmd) {
+			st = scsi_cmd_priv(scmd);
+			if (st->cb_idx == 0xFF)
+				scmd = NULL;
 		}
 	}
- out:
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return smid;
+	return scmd;
 }
 
 /**
@@ -1146,22 +1101,21 @@ struct _sas_node *
 _scsih_scsi_lookup_find_by_target(struct MPT3SAS_ADAPTER *ioc, int id,
 	int channel)
 {
-	u8 found;
-	unsigned long	flags;
-	int i;
+	u8 found = 0;
+	u16 smid;
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	found = 0;
-	for (i = 0 ; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd &&
-		    (ioc->scsi_lookup[i].scmd->device->id == id &&
-		    ioc->scsi_lookup[i].scmd->device->channel == channel)) {
+	for (smid = 1; smid  <= ioc->scsiio_depth; smid++) {
+		struct scsi_cmnd *scmd;
+
+		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
+		if (!scmd)
+			continue;
+		if (scmd->device->id == id &&
+		    scmd->device->channel == channel) {
 			found = 1;
-			goto out;
+			break;
 		}
 	}
- out:
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 	return found;
 }
 
@@ -1180,23 +1134,22 @@ struct _sas_node *
 _scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
 	unsigned int lun, int channel)
 {
-	u8 found;
-	unsigned long	flags;
-	int i;
+	u8 found = 0;
+	u16 smid;
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	found = 0;
-	for (i = 0 ; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd &&
-		    (ioc->scsi_lookup[i].scmd->device->id == id &&
-		    ioc->scsi_lookup[i].scmd->device->channel == channel &&
-		    ioc->scsi_lookup[i].scmd->device->lun == lun)) {
+	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
+		struct scsi_cmnd *scmd;
+
+		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
+		if (!scmd)
+			continue;
+		if (scmd->device->id == id &&
+		    scmd->device->channel == channel &&
+		    scmd->device->lun == lun) {
 			found = 1;
-			goto out;
+			break;
 		}
 	}
- out:
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 	return found;
 }
 
@@ -2334,7 +2287,7 @@ struct _sas_node *
 	switch (type) {
 	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
 		rc = SUCCESS;
-		if (scsi_lookup && scsi_lookup->scmd == NULL)
+		if (scsi_lookup && scsi_lookup->cb_idx == 0xFF)
 			break;
 		rc = FAILED;
 		break;
@@ -2454,6 +2407,7 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct scsiio_tracker *st = scsi_cmd_priv(scmd);
 	u16 smid;
 	u16 handle;
 	int r;
@@ -2473,8 +2427,7 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	}
 
 	/* search for the command */
-	smid = _scsih_scsi_lookup_find_by_scmd(ioc, scmd);
-	if (!smid) {
+	if (st->cb_idx == 0xFF); {
 		scmd->result = DID_RESET << 16;
 		r = SUCCESS;
 		goto out;
@@ -3930,10 +3883,10 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 {
 	struct scsi_cmnd *scmd;
 	u16 smid;
-	u16 count = 0;
+	int count = 0;
 
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
-		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
 		count++;
@@ -4183,8 +4136,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 
 	raid_device = sas_target_priv_data->raid_device;
 	if (raid_device && raid_device->direct_io_enabled)
-		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request,
-		    smid);
+		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request);
 
 	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
@@ -4648,6 +4600,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	Mpi2SCSIIORequest_t *mpi_request;
 	Mpi2SCSIIOReply_t *mpi_reply;
 	struct scsi_cmnd *scmd;
+	struct scsiio_tracker *st;
 	u16 ioc_status;
 	u32 xfer_cnt;
 	u8 scsi_state;
@@ -4655,16 +4608,10 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	u32 log_info;
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	u32 response_code = 0;
-	unsigned long flags;
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 
-	if (ioc->broadcast_aen_busy || ioc->pci_error_recovery ||
-			ioc->got_task_abort_from_ioctl)
-		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
-	else
-		scmd = __scsih_scsi_lookup_get_clear(ioc, smid);
-
+	scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 	if (scmd == NULL)
 		return 1;
 
@@ -4690,13 +4637,11 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	 * WARPDRIVE: If direct_io is set then it is directIO,
 	 * the failed direct I/O should be redirected to volume
 	 */
-	if (mpt3sas_scsi_direct_io_get(ioc, smid) &&
+	st = scsi_cmd_priv(scmd);
+	if (st->direct_io &&
 	     ((ioc_status & MPI2_IOCSTATUS_MASK)
 	      != MPI2_IOCSTATUS_SCSI_TASK_TERMINATED)) {
-		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-		ioc->scsi_lookup[smid - 1].scmd = scmd;
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		mpt3sas_scsi_direct_io_set(ioc, smid, 0);
+		st->direct_io = 0;
 		memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
 		mpi_request->DevHandle =
 		    cpu_to_le16(sas_device_priv_data->sas_target->handle);
@@ -6119,7 +6064,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
 		if (ioc->shost_recovery)
 			goto out;
-		scmd = ioc->scsi_lookup[smid - 1].scmd;
+		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
 		sdev = scmd->device;
@@ -8618,6 +8563,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
 	.track_queue_depth		= 1,
+	.cmd_size			= sizeof(struct scsiio_tracker),
 };
 
 /* raid transport support for SAS 2.0 HBA devices */
@@ -8656,6 +8602,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
 	.track_queue_depth		= 1,
+	.cmd_size			= sizeof(struct scsiio_tracker),
 };
 
 /* raid transport support for SAS 3.0 HBA devices */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
index 06e3f7d..9e5309d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
@@ -261,35 +261,6 @@
 }
 
 /**
- * mpt3sas_scsi_direct_io_get - returns direct io flag
- * @ioc: per adapter object
- * @smid: system request message index
- *
- * Returns the smid stored scmd pointer.
- */
-inline u8
-mpt3sas_scsi_direct_io_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
-{
-	struct scsiio_tracker *st = mpt3sas_get_st_from_smid(ioc, smid);
-
-	return st ? st->direct_io : 0;
-}
-
-/**
- * mpt3sas_scsi_direct_io_set - sets direct io flag
- * @ioc: per adapter object
- * @smid: system request message index
- * @direct_io: Zero or non-zero value to set in the direct_io flag
- *
- * Returns Nothing.
- */
-inline void
-mpt3sas_scsi_direct_io_set(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 direct_io)
-{
-	ioc->scsi_lookup[smid - 1].direct_io = direct_io;
-}
-
-/**
  * mpt3sas_setup_direct_io - setup MPI request for WARPDRIVE Direct I/O
  * @ioc: per adapter object
  * @scmd: pointer to scsi command object
@@ -301,12 +272,12 @@
  */
 void
 mpt3sas_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
-	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
-	u16 smid)
+	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request)
 {
 	sector_t v_lba, p_lba, stripe_off, column, io_size;
 	u32 stripe_sz, stripe_exp;
 	u8 num_pds, cmd = scmd->cmnd[0];
+	struct scsiio_tracker *st = scsi_cmd_priv(scmd);
 
 	if (cmd != READ_10 && cmd != WRITE_10 &&
 	    cmd != READ_16 && cmd != WRITE_16)
@@ -342,5 +313,5 @@
 	else
 		put_unaligned_be64(p_lba, &mpi_request->CDB.CDB32[2]);
 
-	mpt3sas_scsi_direct_io_set(ioc, smid, 1);
+	st->direct_io = 1;
 }
-- 
1.8.5.6
