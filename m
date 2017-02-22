From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 12/12] mpt3sas: lockless command submission
Date: Wed, 22 Feb 2017 11:31:52 +0100
Message-ID: <1487759512-3873-13-git-send-email-hare@suse.de>
References: <1487759512-3873-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49713 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932183AbdBVKcE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 05:32:04 -0500
In-Reply-To: <1487759512-3873-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Instead of holding 'struct scsiio_tracker' in its own pool we
can embed it into the payload of the scsi command. This allows
us to get rid of the lock when submitting and receiving commands
and streamline operations.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 120 +++++++++++++------------------
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  23 +++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  17 +++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 118 +++++++++---------------------
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  35 +--------
 5 files changed, 105 insertions(+), 208 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 169d185..966a775 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -863,12 +863,19 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 }
 
 struct scsiio_tracker *
-mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
+	struct scsi_cmnd *cmd;
+
 	if (WARN_ON(!smid) ||
 	    WARN_ON(smid >= ioc->hi_priority_smid))
 		return NULL;
-	return &ioc->scsi_lookup[smid - 1];
+
+	cmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
+	if (cmd)
+		return scsi_cmd_priv(cmd);
+
+	return NULL;
 }
 
 /**
@@ -889,7 +896,7 @@ struct scsiio_tracker *
 		struct scsiio_tracker *st;
 
 		if (smid < ctl_smid) {
-			st = mpt3sas_get_st_from_smid(ioc, smid);
+			st = _get_st_from_smid(ioc, smid);
 			if (st)
 				cb_idx = st->cb_idx;
 		} else if (smid == ctl_smid)
@@ -1276,15 +1283,16 @@ struct scsiio_tracker *
 /**
  * _base_get_chain_buffer_tracker - obtain chain tracker
  * @ioc: per adapter object
- * @smid: smid associated to an IO request
+ * @scmd: SCSI commands of the IO request
  *
  * Returns chain tracker(from ioc->free_chain_list)
  */
 static struct chain_tracker *
-_base_get_chain_buffer_tracker(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+_base_get_chain_buffer_tracker(struct MPT3SAS_ADAPTER *ioc,
+			       struct scsi_cmnd *scmd)
 {
 	struct chain_tracker *chain_req;
-	struct scsiio_tracker *st;
+	struct scsiio_tracker *st = scsi_cmd_priv(scmd);
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
@@ -1297,9 +1305,7 @@ struct scsiio_tracker *
 	chain_req = list_entry(ioc->free_chain_list.next,
 	    struct chain_tracker, tracker_list);
 	list_del_init(&chain_req->tracker_list);
-	st = mpt3sas_get_st_from_smid(ioc, smid);
-	if (st)
-		list_add_tail(&chain_req->tracker_list, &st->chain_list);
+	list_add_tail(&chain_req->tracker_list, &st->chain_list);
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 	return chain_req;
 }
@@ -1485,7 +1491,7 @@ struct scsiio_tracker *
 
 	/* initializing the chain flags and pointers */
 	chain_flags = MPI2_SGE_FLAGS_CHAIN_ELEMENT << MPI2_SGE_FLAGS_SHIFT;
-	chain_req = _base_get_chain_buffer_tracker(ioc, smid);
+	chain_req = _base_get_chain_buffer_tracker(ioc, scmd);
 	if (!chain_req)
 		return -1;
 	chain = chain_req->chain_buffer;
@@ -1525,7 +1531,7 @@ struct scsiio_tracker *
 			sges_in_segment--;
 		}
 
-		chain_req = _base_get_chain_buffer_tracker(ioc, smid);
+		chain_req = _base_get_chain_buffer_tracker(ioc, scmd);
 		if (!chain_req)
 			return -1;
 		chain = chain_req->chain_buffer;
@@ -1619,7 +1625,7 @@ struct scsiio_tracker *
 	}
 
 	/* initializing the pointers */
-	chain_req = _base_get_chain_buffer_tracker(ioc, smid);
+	chain_req = _base_get_chain_buffer_tracker(ioc, scmd);
 	if (!chain_req)
 		return -1;
 	chain = chain_req->chain_buffer;
@@ -1650,7 +1656,7 @@ struct scsiio_tracker *
 			sges_in_segment--;
 		}
 
-		chain_req = _base_get_chain_buffer_tracker(ioc, smid);
+		chain_req = _base_get_chain_buffer_tracker(ioc, scmd);
 		if (!chain_req)
 			return -1;
 		chain = chain_req->chain_buffer;
@@ -2349,26 +2355,15 @@ struct scsiio_tracker *
 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsi_cmnd *scmd)
 {
-	unsigned long flags;
-	struct scsiio_tracker *request;
+	struct scsiio_tracker *request = scsi_cmd_priv(scmd);
+	unsigned int tag = scmd->request->tag;
 	u16 smid;
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	if (list_empty(&ioc->free_list)) {
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		pr_err(MPT3SAS_FMT "%s: smid not available\n",
-		    ioc->name, __func__);
-		return 0;
-	}
-
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
 
@@ -2414,6 +2409,22 @@ struct scsiio_tracker *
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
@@ -2427,23 +2438,21 @@ struct scsiio_tracker *
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
 
+		st = _get_st_from_smid(ioc, smid);
+		if (!st) {
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
@@ -3276,10 +3285,6 @@ struct scsiio_tracker *
 		    ioc->config_page, ioc->config_page_dma);
 	}
 
-	if (ioc->scsi_lookup) {
-		free_pages((ulong)ioc->scsi_lookup, ioc->scsi_lookup_pages);
-		ioc->scsi_lookup = NULL;
-	}
 	kfree(ioc->hpr_lookup);
 	kfree(ioc->internal_lookup);
 	if (ioc->chain_lookup) {
@@ -3573,16 +3578,6 @@ struct scsiio_tracker *
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
 
@@ -5170,20 +5165,7 @@ struct scsiio_tracker *
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
-	}
 
 	/* hi-priority queue */
 	INIT_LIST_HEAD(&ioc->hpr_free_list);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4ecc2c1..08ddf08 100644
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
 
@@ -1247,8 +1241,8 @@ __le32 mpt3sas_base_get_sense_buffer_dma(struct MPT3SAS_ADAPTER *ioc,
 u16 mpt3sas_base_get_smid_hpr(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
 u16 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsi_cmnd *scmd);
-struct scsiio_tracker * mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc,
-	u16 smid);
+void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
+			   struct scsiio_tracker *st);
 
 u16 mpt3sas_base_get_smid(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
 void mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid);
@@ -1284,6 +1278,8 @@ void mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
 
 
 /* scsih shared API */
+struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
+	u16 smid);
 u8 mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	u32 reply);
 void mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase);
@@ -1300,6 +1296,8 @@ void mpt3sas_device_remove_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
 	u64 sas_address);
 u8 mpt3sas_check_for_pending_internal_cmds(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid);
+struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
+	u16 smid);
 
 struct _sas_node *mpt3sas_scsih_expander_find_by_handle(
 	struct MPT3SAS_ADAPTER *ioc, u16 handle);
@@ -1451,14 +1449,9 @@ void mpt3sas_trigger_mpi(struct MPT3SAS_ADAPTER *ioc, u16 ioc_status,
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
index dd03d2c..7bbc5b1 100644
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
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index f114ef7..8177519 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1061,74 +1061,31 @@ struct _sas_node *
 }
 
 /**
- * __scsih_scsi_lookup_get_clear - returns scmd entry without
- *						holding any lock.
+ * mpt3sas_scsih_scsi_lookup_get - returns scmd entry
  * @ioc: per adapter object
  * @smid: system request message index
  *
  * Returns the smid stored scmd pointer.
  * Then will dereference the stored scmd pointer.
  */
-static inline struct scsi_cmnd *
-__scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc,
-		u16 smid)
+struct scsi_cmnd *
+mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	struct scsi_cmnd *scmd = NULL;
+	struct scsiio_tracker *st;
 
-	swap(scmd, ioc->scsi_lookup[smid - 1].scmd);
-
-	return scmd;
-}
-
-/**
- * _scsih_scsi_lookup_get_clear - returns scmd entry
- * @ioc: per adapter object
- * @smid: system request message index
- *
- * Returns the smid stored scmd pointer.
- * Then will derefrence the stored scmd pointer.
- */
-static inline struct scsi_cmnd *
-_scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc, u16 smid)
-{
-	unsigned long flags;
-	struct scsi_cmnd *scmd;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	scmd = __scsih_scsi_lookup_get_clear(ioc, smid);
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-
-	return scmd;
-}
-
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
-struct scsiio_tracker *
-_scsih_scsi_lookup_find_by_scmd(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd
-	*scmd)
-{
-	struct scsiio_tracker *st = NULL;
-	unsigned long flags;
-	int i;
+	if (smid > 0  &&
+	    smid <= ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT) {
+		u32 unique_tag = smid - 1;
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = 0; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd == scmd) {
-			st = &ioc->scsi_lookup[i];
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
-	return st;
+	return scmd;
 }
 
 /**
@@ -2341,7 +2298,7 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
-	struct scsiio_tracker *st = NULL;
+	struct scsiio_tracker *st = scsi_cmd_priv(scmd);
 	u16 handle;
 	int r;
 
@@ -2359,9 +2316,8 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out;
 	}
 
-	/* search for the command */
-	st = _scsih_scsi_lookup_find_by_scmd(ioc, scmd);
-	if (!st) {
+	/* check for completed command */
+	if (st->cb_idx == 0xFF); {
 		scmd->result = DID_RESET << 16;
 		r = SUCCESS;
 		goto out;
@@ -2383,7 +2339,7 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
 		st->smid, st->msix_io, 30);
 	/* Command must be cleared after abort */
-	if (r == SUCCESS && st->scmd)
+	if (r == SUCCESS && st->cb_idx != 0xFF)
 		r = FAILED;
  out:
 	sdev_printk(KERN_INFO, scmd->device, "task abort: %s scmd(%p)\n",
@@ -3820,18 +3776,20 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct scsi_cmnd *scmd;
+	struct scsiio_tracker *st;
 	u16 smid;
-	u16 count = 0;
+	int count = 0;
 
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
-		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
 		count++;
 		if (ata_12_16_cmd(scmd))
 			scsi_internal_device_unblock(scmd->device,
 							SDEV_RUNNING);
-		mpt3sas_base_free_smid(ioc, smid);
+		st = scsi_cmd_priv(scmd);
+		mpt3sas_base_clear_st(ioc, st);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
 			scmd->result = DID_NO_CONNECT << 16;
@@ -4074,8 +4032,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 
 	raid_device = sas_target_priv_data->raid_device;
 	if (raid_device && raid_device->direct_io_enabled)
-		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request,
-		    smid);
+		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request);
 
 	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
@@ -4539,6 +4496,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	Mpi2SCSIIORequest_t *mpi_request;
 	Mpi2SCSIIOReply_t *mpi_reply;
 	struct scsi_cmnd *scmd;
+	struct scsiio_tracker *st;
 	u16 ioc_status;
 	u32 xfer_cnt;
 	u8 scsi_state;
@@ -4546,16 +4504,10 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
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
 
@@ -4581,13 +4533,11 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
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
@@ -6011,10 +5961,10 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
 		if (ioc->shost_recovery)
 			goto out;
-		st = &ioc->scsi_lookup[smid - 1];
-		scmd = st->scmd;
+		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
+		st = scsi_cmd_priv(scmd);
 		sdev = scmd->device;
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
@@ -6037,7 +5987,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 		r = mpt3sas_scsih_issue_tm(ioc, handle, lun,
-			MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid,
+			MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, st->smid,
 			st->msix_io, 30);
 		if (r == FAILED) {
 			sdev_printk(KERN_WARNING, sdev,
@@ -6078,9 +6028,9 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 			goto out_no_lock;
 
 		r = mpt3sas_scsih_issue_tm(ioc, handle, sdev->lun,
-			MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid,
+			MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, st->smid,
 			st->msix_io, 30);
-		if (r == FAILED || st->scmd) {
+		if (r == FAILED || st->cb_idx != 0xFF) {
 			sdev_printk(KERN_WARNING, sdev,
 			    "mpt3sas_scsih_issue_tm: ABORT_TASK: FAILED : "
 			    "scmd(%p)\n", scmd);
@@ -8512,6 +8462,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
 	.track_queue_depth		= 1,
+	.cmd_size			= sizeof(struct scsiio_tracker),
 };
 
 /* raid transport support for SAS 2.0 HBA devices */
@@ -8550,6 +8501,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
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
