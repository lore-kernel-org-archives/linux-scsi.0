From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 09/11] mpt3sas: lockless command submission for scsi-mq
Date: Fri, 17 Feb 2017 09:23:08 +0100
Message-ID: <1487319790-97340-10-git-send-email-hare@suse.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34709 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbdBQIXY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:23:24 -0500
In-Reply-To: <1487319790-97340-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Enable lockless command submission for scsi-mq by moving the
command structure into the payload for struct request.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 123 ++++-----
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  13 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  85 ++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 460 ++++++++++++++-----------------
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  20 +-
 5 files changed, 330 insertions(+), 371 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index dec86c4..e9470a3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -865,9 +865,17 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 struct scsiio_tracker *
 mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
+	u32 unique_tag;
+	struct scsi_cmnd *cmd;
+
 	WARN_ON(!smid);
 	WARN_ON(smid >= ioc->hi_priority_smid);
-	return &ioc->scsi_lookup[smid - 1];
+	unique_tag = smid - 1;
+	cmd = scsi_host_find_tag(ioc->shost, unique_tag);
+	if (cmd)
+		return scsi_cmd_priv(cmd);
+
+	return NULL;
 }
 
 /**
@@ -2343,34 +2351,23 @@ struct scsiio_tracker *
 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsi_cmnd *scmd)
 {
-	unsigned long flags;
 	struct scsiio_tracker *request;
 	u16 smid;
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	if (list_empty(&ioc->free_list)) {
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		pr_err(MPT3SAS_FMT "%s: smid not available\n",
-		    ioc->name, __func__);
-		return 0;
-	}
-
 	if (!scmd) {
-		/* ioctl command, always use the first slot */
-		request = ioc->lookup[0];
-		request->scmd = NULL;
+		smid = 1;
+		request = mpt3sas_get_st_from_smid(ioc, smid);
 	} else {
-		request = list_entry(ioc->free_list.next,
-				     struct scsiio_tracker, tracker_list);
-		request->scmd = scmd;
+		u32 unique_tag = blk_mq_unique_tag(scmd->request);
+		u16 tag = blk_mq_unique_tag_to_tag(unique_tag);
+		request = scsi_cmd_priv(scmd);
+		smid = tag + 1;
 	}
 	request->cb_idx = cb_idx;
-	smid = request->smid;
 	request->msix_io = _base_get_msix_index(ioc);
-	if (scmd)
-		list_del(&request->tracker_list);
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return smid;
+	request->smid = smid;
+	INIT_LIST_HEAD(&request->chain_list);
+	return request->smid;
 }
 
 /**
@@ -2415,6 +2412,22 @@ struct scsiio_tracker *
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
@@ -2428,22 +2441,21 @@ struct scsiio_tracker *
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (smid < ioc->hi_priority_smid) {
-		/* scsiio queue */
-		i = smid - 1;
-		list_splice_init(&st->chain_list, &ioc->free_chain_list);
-		ioc->scsi_lookup[i].cb_idx = 0xFF;
-		ioc->scsi_lookup[i].scmd = NULL;
-		ioc->scsi_lookup[i].direct_io = 0;
-		if (i > 0)
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
@@ -3276,10 +3288,6 @@ struct scsiio_tracker *
 		    ioc->config_page, ioc->config_page_dma);
 	}
 
-	if (ioc->scsi_lookup) {
-		free_pages((ulong)ioc->scsi_lookup, ioc->scsi_lookup_pages);
-		ioc->scsi_lookup = NULL;
-	}
 	kfree(ioc->hpr_lookup);
 	kfree(ioc->internal_lookup);
 	if (ioc->chain_lookup) {
@@ -3573,16 +3581,6 @@ struct scsiio_tracker *
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
 
@@ -5170,22 +5168,7 @@ struct scsiio_tracker *
 		kfree(delayed_event_ack);
 	}
 
-	/* initialize the scsi lookup free list */
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	INIT_LIST_HEAD(&ioc->free_list);
-	smid = 1;
-	for (i = 1; i < ioc->scsiio_depth; i++, smid++) {
-		INIT_LIST_HEAD(&ioc->scsi_lookup[i].chain_list);
-		ioc->scsi_lookup[i].cb_idx = 0xFF;
-		ioc->scsi_lookup[i].smid = smid;
-		ioc->scsi_lookup[i].scmd = NULL;
-		ioc->scsi_lookup[i].direct_io = 0;
-		if (i == 1)
-			INIT_LIST_HEAD(&ioc->lookup[i].tracker_list);
-		else
-			list_add_tail(&ioc->scsi_lookup[i].tracker_list,
-				      &ioc->free_list);
-	}
 
 	/* hi-priority queue */
 	INIT_LIST_HEAD(&ioc->hpr_free_list);
@@ -5685,6 +5668,13 @@ struct scsiio_tracker *
 	}
 }
 
+void _count_pending(struct request *req, void *data, bool reserved)
+{
+	struct MPT3SAS_ADAPTER *ioc = data;
+
+	ioc->pending_io_count++;
+}
+
 /**
  * _wait_for_commands_to_complete - reset controller
  * @ioc: Pointer to MPT_ADAPTER structure
@@ -5696,8 +5686,6 @@ struct scsiio_tracker *
 _wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 ioc_state;
-	unsigned long flags;
-	u16 i;
 
 	ioc->pending_io_count = 0;
 
@@ -5706,11 +5694,8 @@ struct scsiio_tracker *
 		return;
 
 	/* pending command count */
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = 0; i < ioc->scsiio_depth; i++)
-		if (ioc->scsi_lookup[i].cb_idx != 0xFF)
-			ioc->pending_io_count++;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	blk_mq_tagset_busy_iter(&ioc->shost->tag_set,
+				_count_pending, ioc);
 
 	if (!ioc->pending_io_count)
 		return;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 74186e3..8b38e49 100644
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
@@ -1459,8 +1455,7 @@ void mpt3sas_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
 mpt3sas_scsi_direct_io_set(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 direct_io);
 void
 mpt3sas_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
-	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
-	u16 smid);
+	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request);
 
 /* NCQ Prio Handling Check */
 bool scsih_ncq_prio_supp(struct scsi_device *sdev);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 02fe1c4..e2a8c5d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -549,6 +549,58 @@ enum block_state {
 	return 0;
 }
 
+static bool
+_scmd_match(struct scsi_cmnd *scmd, u16 handle, u32 lun)
+{
+	struct MPT3SAS_DEVICE *priv_data;
+
+	if (scmd == NULL || scmd->device == NULL ||
+	    scmd->device->hostdata == NULL)
+		return false;
+	if (lun != scmd->device->lun)
+		return false;
+	priv_data = scmd->device->hostdata;
+	if (priv_data->sas_target == NULL)
+		return false;
+	if (priv_data->sas_target->handle != handle)
+		return false;
+
+	return true;
+}
+
+struct smid_match_data {
+	u16 handle;
+	u16 smid;
+	u32 lun;
+};
+
+static void
+_smid_fn(struct request *req, void *data, bool reserved)
+{
+	struct smid_match_data *smd = data;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsiio_tracker *st;
+
+	if (!_scmd_match(scmd, smd->handle, smd->lun))
+		return;
+
+	st = scsi_cmd_priv(scmd);
+	smd->smid = st->smid;
+}
+
+static u16
+_ctl_find_smid(struct MPT3SAS_ADAPTER *ioc, u16 handle, u32 lun)
+{
+	struct smid_match_data smd = {
+		.handle = handle,
+		.lun = lun,
+		.smid =  0,
+	};
+
+	blk_mq_tagset_busy_iter(&ioc->shost->tag_set, _smid_fn, &smd);
+	return smd.smid;
+}
+
 /**
  * _ctl_set_task_mid - assign an active smid to tm request
  * @ioc: per adapter object
@@ -562,12 +614,7 @@ enum block_state {
 _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command *karg,
 	Mpi2SCSITaskManagementRequest_t *tm_request)
 {
-	u8 found = 0;
-	u16 i;
-	u16 handle;
-	struct scsi_cmnd *scmd;
-	struct MPT3SAS_DEVICE *priv_data;
-	unsigned long flags;
+	u16 smid, handle;
 	Mpi2SCSITaskManagementReply_t *tm_reply;
 	u32 sz;
 	u32 lun;
@@ -581,27 +628,11 @@ enum block_state {
 		return 0;
 
 	lun = scsilun_to_int((struct scsi_lun *)tm_request->LUN);
-
 	handle = le16_to_cpu(tm_request->DevHandle);
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = ioc->scsiio_depth; i && !found; i--) {
-		scmd = ioc->scsi_lookup[i - 1].scmd;
-		if (scmd == NULL || scmd->device == NULL ||
-		    scmd->device->hostdata == NULL)
-			continue;
-		if (lun != scmd->device->lun)
-			continue;
-		priv_data = scmd->device->hostdata;
-		if (priv_data->sas_target == NULL)
-			continue;
-		if (priv_data->sas_target->handle != handle)
-			continue;
-		tm_request->TaskMID = cpu_to_le16(ioc->scsi_lookup[i - 1].smid);
-		found = 1;
-	}
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
-	if (!found) {
+	smid = _ctl_find_smid(ioc, handle, lun);
+
+	if (!smid) {
 		dctlprintk(ioc, pr_info(MPT3SAS_FMT
 			"%s: handle(0x%04x), lun(%d), no active mid!!\n",
 			ioc->name,
@@ -621,6 +652,8 @@ enum block_state {
 		return 1;
 	}
 
+	tm_request->TaskMID = cpu_to_le16(smid);
+
 	dctlprintk(ioc, pr_info(MPT3SAS_FMT
 		"%s: handle(0x%04x), lun(%d), task_mid(%d)\n", ioc->name,
 	    desc, le16_to_cpu(tm_request->DevHandle), lun,
@@ -720,7 +753,7 @@ enum block_state {
 		}
 	} else {
 
-		smid = mpt3sas_base_get_smid_scsiio(ioc, ioc->ctl_cb_idx, NULL);
+		smid = mpt3sas_base_get_smid_hpr(ioc, ioc->ctl_cb_idx);
 		if (!smid) {
 			pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
 			    ioc->name, __func__);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 989cdc8..b8e47da 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -147,7 +147,6 @@ static int _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 module_param(prot_mask, int, 0);
 MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=7 ");
 
-
 /* raid transport support */
 struct raid_template *mpt3sas_raid_template;
 struct raid_template *mpt2sas_raid_template;
@@ -1061,7 +1060,7 @@ struct _sas_node *
 }
 
 /**
- * __scsih_scsi_lookup_get_clear - returns scmd entry without
+ * _scsih_scsi_lookup_get_clear - returns scmd entry without
  *						holding any lock.
  * @ioc: per adapter object
  * @smid: system request message index
@@ -1070,66 +1069,32 @@ struct _sas_node *
  * Then will dereference the stored scmd pointer.
  */
 static inline struct scsi_cmnd *
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
- * @ioc: per adapter object
- * @smid: system request message index
- *
- * Returns the smid stored scmd pointer.
- * Then will derefrence the stored scmd pointer.
- */
-static inline struct scsi_cmnd *
 _scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
-	unsigned long flags;
-	struct scsi_cmnd *scmd;
+	if (smid > 0) {
+		u32 unique_tag = smid - 1;
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	scmd = __scsih_scsi_lookup_get_clear(ioc, smid);
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-
-	return scmd;
+		return scsi_host_find_tag(ioc->shost, unique_tag);
+	}
+	return NULL;
 }
 
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
+struct _scsih_scsi_lookup_data {
+	int channel;
+	int id;
+	int lun;
+	int result;
+};
+
+static void
+_scsih_scsi_target_lookup_fn(struct request *req, void *data, bool reserved)
 {
-	u16 smid;
-	unsigned long	flags;
-	int i;
+	struct _scsih_scsi_lookup_data *lookup_data = data;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	smid = 0;
-	for (i = 0; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd == scmd) {
-			smid = ioc->scsi_lookup[i].smid;
-			goto out;
-		}
-	}
- out:
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return smid;
+	if (scmd->device->id == lookup_data->id &&
+	    scmd->device->channel == lookup_data->channel)
+		lookup_data->result++;
 }
 
 /**
@@ -1146,23 +1111,26 @@ struct _sas_node *
 _scsih_scsi_lookup_find_by_target(struct MPT3SAS_ADAPTER *ioc, int id,
 	int channel)
 {
-	u8 found;
-	unsigned long	flags;
-	int i;
+	struct _scsih_scsi_lookup_data data = {
+		.channel = channel,
+		.id = id,
+		.result = 0,
+	};
+	blk_mq_tagset_busy_iter(&ioc->shost->tag_set,
+				_scsih_scsi_target_lookup_fn, &data);
+	return (data.result > 0);
+}
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	found = 0;
-	for (i = 0 ; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd &&
-		    (ioc->scsi_lookup[i].scmd->device->id == id &&
-		    ioc->scsi_lookup[i].scmd->device->channel == channel)) {
-			found = 1;
-			goto out;
-		}
-	}
- out:
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return found;
+static void
+_scsih_scsi_lun_lookup_fn(struct request *req, void *data, bool reserved)
+{
+	struct _scsih_scsi_lookup_data *lookup_data = data;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+
+	if (scmd->device->id == lookup_data->id &&
+	    scmd->device->channel == lookup_data->channel &&
+	    scmd->device->lun == lookup_data->lun)
+		lookup_data->result++;
 }
 
 /**
@@ -1180,24 +1148,15 @@ struct _sas_node *
 _scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
 	unsigned int lun, int channel)
 {
-	u8 found;
-	unsigned long	flags;
-	int i;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	found = 0;
-	for (i = 0 ; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd &&
-		    (ioc->scsi_lookup[i].scmd->device->id == id &&
-		    ioc->scsi_lookup[i].scmd->device->channel == channel &&
-		    ioc->scsi_lookup[i].scmd->device->lun == lun)) {
-			found = 1;
-			goto out;
-		}
-	}
- out:
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return found;
+	struct _scsih_scsi_lookup_data data = {
+		.channel = channel,
+		.id = id,
+		.lun = lun,
+		.result = 0,
+	};
+	blk_mq_tagset_busy_iter(&ioc->shost->tag_set,
+				_scsih_scsi_lun_lookup_fn, &data);
+	return (data.result > 0);
 }
 
 /**
@@ -2263,6 +2222,8 @@ struct _sas_node *
 
 	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
 		scsi_lookup = mpt3sas_get_st_from_smid(ioc, smid_task);
+		if (!scsi_lookup)
+			return FAILED;
 		if (scsi_lookup->cb_idx == 0xFF)
 			return SUCCESS;
 	}
@@ -2331,7 +2292,7 @@ struct _sas_node *
 	switch (type) {
 	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
 		rc = SUCCESS;
-		if (scsi_lookup->scmd == NULL)
+		if (scsi_lookup->cb_idx == 0xFF)
 			break;
 		rc = FAILED;
 		break;
@@ -2451,7 +2412,7 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
-	u16 smid;
+	struct scsiio_tracker *st;
 	u16 handle;
 	int r;
 
@@ -2470,8 +2431,8 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	}
 
 	/* search for the command */
-	smid = _scsih_scsi_lookup_find_by_scmd(ioc, scmd);
-	if (!smid) {
+	st = scsi_cmd_priv(scmd);
+	if (st->cb_idx == 0xff) {
 		scmd->result = DID_RESET << 16;
 		r = SUCCESS;
 		goto out;
@@ -2491,7 +2452,7 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	handle = sas_device_priv_data->sas_target->handle;
 	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, scmd->device->lun,
-	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30);
+	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, st->smid, 30);
 
  out:
 	sdev_printk(KERN_INFO, scmd->device, "task abort: %s scmd(%p)\n",
@@ -3913,6 +3874,29 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
 }
 
+void _flush_running(struct request *req, void *data, bool reserved)
+{
+	struct MPT3SAS_ADAPTER *ioc = data;
+	struct scsi_cmnd *scmd;
+	struct scsiio_tracker *st;
+
+	scmd = blk_mq_rq_to_pdu(req);
+	st = scsi_cmd_priv(scmd);
+	if (ata_12_16_cmd(scmd))
+		scsi_internal_device_unblock(scmd->device,
+					     SDEV_RUNNING);
+	mpt3sas_base_clear_st(ioc, st);
+	scsi_dma_unmap(scmd);
+
+	if (ioc->pci_error_recovery)
+		scmd->result = DID_NO_CONNECT << 16;
+	else
+		scmd->result = DID_RESET << 16;
+	scmd->scsi_done(scmd);
+
+	ioc->pending_io_count++;
+}
+
 /**
  * _scsih_flush_running_cmds - completing outstanding commands.
  * @ioc: per adapter object
@@ -3925,28 +3909,11 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 static void
 _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 {
-	struct scsi_cmnd *scmd;
-	u16 smid;
-	u16 count = 0;
-
-	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
-		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
-		if (!scmd)
-			continue;
-		count++;
-		if (ata_12_16_cmd(scmd))
-			scsi_internal_device_unblock(scmd->device,
-							SDEV_RUNNING);
-		mpt3sas_base_free_smid(ioc, smid);
-		scsi_dma_unmap(scmd);
-		if (ioc->pci_error_recovery)
-			scmd->result = DID_NO_CONNECT << 16;
-		else
-			scmd->result = DID_RESET << 16;
-		scmd->scsi_done(scmd);
-	}
+	ioc->pending_io_count = 0;
+	blk_mq_tagset_busy_iter(&ioc->shost->tag_set,
+				_flush_running, ioc);
 	dtmprintk(ioc, pr_info(MPT3SAS_FMT "completing %d cmds\n",
-	    ioc->name, count));
+	    ioc->name, ioc->pending_io_count));
 }
 
 /**
@@ -4180,8 +4147,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 
 	raid_device = sas_target_priv_data->raid_device;
 	if (raid_device && raid_device->direct_io_enabled)
-		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request,
-		    smid);
+		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request);
 
 	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
@@ -4652,16 +4618,10 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
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
+	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
 	if (scmd == NULL)
 		return 1;
 
@@ -4690,10 +4650,9 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	if (mpt3sas_scsi_direct_io_get(ioc, smid) &&
 	     ((ioc_status & MPI2_IOCSTATUS_MASK)
 	      != MPI2_IOCSTATUS_SCSI_TASK_TERMINATED)) {
-		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-		ioc->scsi_lookup[smid - 1].scmd = scmd;
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		mpt3sas_scsi_direct_io_set(ioc, smid, 0);
+		struct scsiio_tracker *st = scsi_cmd_priv(scmd);
+
+		st->direct_io = 0;
 		memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
 		mpi_request->DevHandle =
 		    cpu_to_le16(sas_device_priv_data->sas_target->handle);
@@ -4863,11 +4822,12 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 		_scsih_scsi_ioc_info(ioc , scmd, mpi_reply, smid);
 
  out:
+	mpt3sas_base_clear_st(ioc, scsi_cmd_priv(scmd));
 
 	scsi_dma_unmap(scmd);
 
 	scmd->scsi_done(scmd);
-	return 1;
+	return 0;
 }
 
 /**
@@ -6061,6 +6021,108 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 		     fw_event->event_data);
 }
 
+struct _abort_sas_task_data {
+	struct MPT3SAS_ADAPTER *ioc;
+	int query_count;
+	int retry;
+	int termination_count;
+};
+
+void _abort_sas_task(struct request *req, void *data, bool reserved)
+{
+	struct _abort_sas_task_data *priv = data;
+	struct scsi_cmnd *scmd;
+	struct scsi_device *sdev;
+	u16 handle;
+	u32 lun;
+	struct scsiio_tracker *st;
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	Mpi2SCSITaskManagementReply_t *mpi_reply;
+	u16 ioc_status;
+	int r;
+	u8 task_abort_retries;
+
+	scmd = blk_mq_rq_to_pdu(req);
+	st = scsi_cmd_priv(scmd);
+
+	sdev = scmd->device;
+	sas_device_priv_data = sdev->hostdata;
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
+		return;
+	/* skip hidden raid components */
+	if (sas_device_priv_data->sas_target->flags &
+	    MPT_TARGET_FLAGS_RAID_COMPONENT)
+		return;
+	/* skip volumes */
+	if (sas_device_priv_data->sas_target->flags &
+	    MPT_TARGET_FLAGS_VOLUME)
+		return;
+
+	handle = sas_device_priv_data->sas_target->handle;
+	lun = sas_device_priv_data->lun;
+	mpi_reply = priv->ioc->tm_cmds.reply;
+	priv->query_count++;
+
+	if (priv->ioc->shost_recovery)
+		return;
+
+	r = mpt3sas_scsih_issue_tm(priv->ioc, handle, 0, 0, lun,
+		MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, st->smid, 30);
+	if (r == FAILED) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "mpt3sas_scsih_issue_tm: FAILED when sending "
+			    "QUERY_TASK: scmd(%p)\n", scmd);
+		priv->retry++;
+		return;
+	}
+	ioc_status = le16_to_cpu(mpi_reply->IOCStatus)
+		& MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		sdev_printk(KERN_WARNING, sdev,
+			"query task: FAILED with IOCSTATUS(0x%04x), scmd(%p)\n",
+			ioc_status, scmd);
+		priv->retry++;
+		return;
+	}
+
+	/* see if IO is still owned by IOC and target */
+	if (mpi_reply->ResponseCode ==
+	    MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED ||
+	    mpi_reply->ResponseCode ==
+	    MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC)
+		return;
+
+	task_abort_retries = 0;
+ tm_retry:
+	if (task_abort_retries++ == 60) {
+		dewtprintk(priv->ioc, pr_info(MPT3SAS_FMT
+			"%s: ABORT_TASK: giving up\n",
+			priv->ioc->name, __func__));
+		priv->retry++;
+		return;
+	}
+
+	if (priv->ioc->shost_recovery)
+		return;
+
+	r = mpt3sas_scsih_issue_tm(priv->ioc, handle, sdev->channel, sdev->id,
+		sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, st->smid, 30);
+	if (r == FAILED) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "mpt3sas_scsih_issue_tm: ABORT_TASK: FAILED : "
+			    "scmd(%p)\n", scmd);
+		goto tm_retry;
+	}
+
+	if (task_abort_retries > 1)
+		sdev_printk(KERN_WARNING, sdev,
+			    "mpt3sas_scsih_issue_tm: ABORT_TASK: RETRIES (%d):"
+			    " scmd(%p)\n",
+			    task_abort_retries - 1, scmd);
+
+	priv->termination_count += le32_to_cpu(mpi_reply->TerminationCount);
+}
+
 /**
  * _scsih_sas_broadcast_primitive_event - handle broadcast events
  * @ioc: per adapter object
@@ -6073,22 +6135,17 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 	struct fw_event_work *fw_event)
 {
-	struct scsi_cmnd *scmd;
-	struct scsi_device *sdev;
-	u16 smid, handle;
-	u32 lun;
-	struct MPT3SAS_DEVICE *sas_device_priv_data;
-	u32 termination_count;
-	u32 query_count;
-	Mpi2SCSITaskManagementReply_t *mpi_reply;
 	Mpi2EventDataSasBroadcastPrimitive_t *event_data =
 		(Mpi2EventDataSasBroadcastPrimitive_t *)
 		fw_event->event_data;
-	u16 ioc_status;
-	unsigned long flags;
-	int r;
 	u8 max_retries = 0;
-	u8 task_abort_retries;
+	struct _abort_sas_task_data priv = {
+		.ioc = ioc,
+		.retry = 0,
+		.query_count = 0,
+		.termination_count = 0,
+	};
+
 
 	mutex_lock(&ioc->tm_cmds.mutex);
 	pr_info(MPT3SAS_FMT
@@ -6098,123 +6155,23 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 
 	_scsih_block_io_all_device(ioc);
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	mpi_reply = ioc->tm_cmds.reply;
- broadcast_aen_retry:
-
-	/* sanity checks for retrying this loop */
+retry_iter:
 	if (max_retries++ == 5) {
 		dewtprintk(ioc, pr_info(MPT3SAS_FMT "%s: giving up\n",
-		    ioc->name, __func__));
+					ioc->name, __func__));
 		goto out;
 	} else if (max_retries > 1)
 		dewtprintk(ioc, pr_info(MPT3SAS_FMT "%s: %d retry\n",
-		    ioc->name, __func__, max_retries - 1));
-
-	termination_count = 0;
-	query_count = 0;
-	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
-		if (ioc->shost_recovery)
-			goto out;
-		scmd = ioc->scsi_lookup[smid - 1].scmd;
-		if (!scmd)
-			continue;
-		sdev = scmd->device;
-		sas_device_priv_data = sdev->hostdata;
-		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
-			continue;
-		 /* skip hidden raid components */
-		if (sas_device_priv_data->sas_target->flags &
-		    MPT_TARGET_FLAGS_RAID_COMPONENT)
-			continue;
-		 /* skip volumes */
-		if (sas_device_priv_data->sas_target->flags &
-		    MPT_TARGET_FLAGS_VOLUME)
-			continue;
-
-		handle = sas_device_priv_data->sas_target->handle;
-		lun = sas_device_priv_data->lun;
-		query_count++;
-
-		if (ioc->shost_recovery)
-			goto out;
-
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		r = mpt3sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
-		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30);
-		if (r == FAILED) {
-			sdev_printk(KERN_WARNING, sdev,
-			    "mpt3sas_scsih_issue_tm: FAILED when sending "
-			    "QUERY_TASK: scmd(%p)\n", scmd);
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			goto broadcast_aen_retry;
-		}
-		ioc_status = le16_to_cpu(mpi_reply->IOCStatus)
-		    & MPI2_IOCSTATUS_MASK;
-		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			sdev_printk(KERN_WARNING, sdev,
-				"query task: FAILED with IOCSTATUS(0x%04x), scmd(%p)\n",
-				ioc_status, scmd);
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			goto broadcast_aen_retry;
-		}
-
-		/* see if IO is still owned by IOC and target */
-		if (mpi_reply->ResponseCode ==
-		     MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED ||
-		     mpi_reply->ResponseCode ==
-		     MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC) {
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			continue;
-		}
-		task_abort_retries = 0;
- tm_retry:
-		if (task_abort_retries++ == 60) {
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			    "%s: ABORT_TASK: giving up\n", ioc->name,
-			    __func__));
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			goto broadcast_aen_retry;
-		}
-
-		if (ioc->shost_recovery)
-			goto out_no_lock;
-
-		r = mpt3sas_scsih_issue_tm(ioc, handle, sdev->channel, sdev->id,
-		    sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid,
-		    30);
-		if (r == FAILED) {
-			sdev_printk(KERN_WARNING, sdev,
-			    "mpt3sas_scsih_issue_tm: ABORT_TASK: FAILED : "
-			    "scmd(%p)\n", scmd);
-			goto tm_retry;
-		}
-
-		if (task_abort_retries > 1)
-			sdev_printk(KERN_WARNING, sdev,
-			    "mpt3sas_scsih_issue_tm: ABORT_TASK: RETRIES (%d):"
-			    " scmd(%p)\n",
-			    task_abort_retries - 1, scmd);
-
-		termination_count += le32_to_cpu(mpi_reply->TerminationCount);
-		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	}
-
-	if (ioc->broadcast_aen_pending) {
-		dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: loop back due to pending AEN\n",
-			ioc->name, __func__));
-		 ioc->broadcast_aen_pending = 0;
-		 goto broadcast_aen_retry;
-	}
-
- out:
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
- out_no_lock:
+				ioc->name, __func__, max_retries - 1));
 
+	blk_mq_tagset_busy_iter(&ioc->shost->tag_set,
+				_abort_sas_task, &priv);
+	if (priv.retry)
+		goto retry_iter;
+out:
 	dewtprintk(ioc, pr_info(MPT3SAS_FMT
 	    "%s - exit, query_count = %d termination_count = %d\n",
-	    ioc->name, __func__, query_count, termination_count));
+	    ioc->name, __func__, priv.query_count, priv.termination_count));
 
 	ioc->broadcast_aen_busy = 0;
 	if (!ioc->shost_recovery)
@@ -8615,6 +8572,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
 	.track_queue_depth		= 1,
+	.cmd_size			= sizeof(struct scsiio_tracker),
 };
 
 /* raid transport support for SAS 2.0 HBA devices */
@@ -8653,6 +8611,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
 	.track_queue_depth		= 1,
+	.cmd_size			= sizeof(struct scsiio_tracker),
 };
 
 /* raid transport support for SAS 3.0 HBA devices */
@@ -8864,6 +8823,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	shost->max_lun = max_lun;
 	shost->transportt = mpt3sas_transport_template;
 	shost->unique_id = ioc->id;
+	shost->use_blk_mq = 1;
 
 	if (max_sectors != 0xFFFF) {
 		if (max_sectors < 64) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
index 06e3f7d..f9fd0bc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
@@ -276,20 +276,6 @@
 }
 
 /**
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
@@ -301,12 +287,12 @@
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
@@ -342,5 +328,5 @@
 	else
 		put_unaligned_be64(p_lba, &mpi_request->CDB.CDB32[2]);
 
-	mpt3sas_scsi_direct_io_set(ioc, smid, 1);
+	st->direct_io = 1;
 }
-- 
1.8.5.6
