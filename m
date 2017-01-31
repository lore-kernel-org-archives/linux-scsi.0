From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/10] mpt3sas: lockless command submission for scsi-mq
Date: Tue, 31 Jan 2017 10:25:58 +0100
Message-ID: <1485854760-122683-9-git-send-email-hare@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46415 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751706AbdAaJ0V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 04:26:21 -0500
In-Reply-To: <1485854760-122683-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Enable lockless command submission for scsi-mq by moving the
command structure into the payload for struct request.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 125 ++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   2 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 111 ++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 246 +++++++++++++++++++++++++++++++++--
 4 files changed, 427 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 942fb7e..29e139f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -867,6 +867,20 @@ struct scsiio_tracker *
 {
 	WARN_ON(!smid);
 	WARN_ON(smid >= ioc->hi_priority_smid);
+	if (shost_use_blk_mq(ioc->shost)) {
+		u16 hwq = (smid - 1) % ioc->shost->nr_hw_queues;
+		u16 tag = (smid - 1) / ioc->shost->nr_hw_queues;
+		struct blk_mq_tag_set *tagset = &ioc->shost->tag_set;
+		struct request *req;
+
+		req = blk_mq_tag_to_rq(tagset->tags[hwq], tag);
+		if (req) {
+			struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+
+			return scsi_cmd_priv(cmd);
+		} else
+			return NULL;
+	}
 	return &ioc->scsi_lookup[smid - 1];
 }
 
@@ -2329,6 +2343,20 @@ struct scsiio_tracker *
 	struct scsiio_tracker *request;
 	u16 smid;
 
+	if (shost_use_blk_mq(ioc->shost)) {
+		unsigned int unique_tag = blk_mq_unique_tag(scmd->request);
+		u16 hwq = blk_mq_unique_tag_to_hwq(unique_tag);
+		u16 tag = blk_mq_unique_tag_to_tag(unique_tag);
+		u16 smid = (tag * ioc->shost->nr_hw_queues) + hwq + 1;
+
+		request = scsi_cmd_priv(scmd);
+		request->scmd = scmd;
+		request->cb_idx = cb_idx;
+		request->msix_io = hwq;
+		request->smid = smid;
+		INIT_LIST_HEAD(&request->chain_list);
+		return request->smid;
+	}
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (list_empty(&ioc->free_list)) {
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
@@ -2403,6 +2431,23 @@ struct scsiio_tracker *
 	}
 }
 
+void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
+			   struct scsiio_tracker *st)
+{
+	if (WARN_ON(st->smid == 0))
+		return;
+	st->cb_idx = 0xFF;
+	st->scmd = NULL;
+	st->direct_io = 0;
+	if (!list_empty(&st->chain_list)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+		_dechain_st(ioc, st);
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	}
+}
+
 /**
  * mpt3sas_base_free_smid - put smid back on free_list
  * @ioc: per adapter object
@@ -2416,6 +2461,19 @@ struct scsiio_tracker *
 	unsigned long flags;
 	int i;
 
+	if (shost_use_blk_mq(ioc->shost) && smid < ioc->hi_priority_smid) {
+		struct scsiio_tracker *st;
+
+		st = mpt3sas_get_st_from_smid(ioc, smid);
+		if (WARN_ON(!st)) {
+			_base_recovery_check(ioc);
+			return;
+		}
+		mpt3sas_base_clear_st(ioc, st);
+		_base_recovery_check(ioc);
+		return;
+	}
+
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (smid < ioc->hi_priority_smid) {
 		/* scsiio queue */
@@ -3559,14 +3617,23 @@ struct scsiio_tracker *
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
+	/*
+	 * Don't need to allocate memory for scsiio_tracker array if we
+	 * are using scsi-mq, we embed it in the scsi_cmnd for that case.
+	 */
+	if (!shost_use_blk_mq(ioc->shost)) {
+		sz = ioc->scsiio_depth * sizeof(struct scsiio_tracker);
+		ioc->scsi_lookup_pages = get_order(sz);
+		ioc->scsi_lookup = (struct scsiio_tracker *)__get_free_pages(
+			GFP_KERNEL, ioc->scsi_lookup_pages);
+		if (!ioc->scsi_lookup) {
+			pr_err(MPT3SAS_FMT "scsi_lookup: get_free_pages "
+			       "failed, sz(%d)\n", ioc->name, (int)sz);
+			goto out;
+		}
+	} else {
+		ioc->scsi_lookup_pages = 0;
+		ioc->scsi_lookup = NULL;
 	}
 
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "scsiio(0x%p): depth(%d)\n",
@@ -5159,15 +5226,17 @@ struct scsiio_tracker *
 	/* initialize the scsi lookup free list */
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	INIT_LIST_HEAD(&ioc->free_list);
-	smid = 1;
-	for (i = 0; i < ioc->scsiio_depth; i++, smid++) {
-		INIT_LIST_HEAD(&ioc->scsi_lookup[i].chain_list);
-		ioc->scsi_lookup[i].cb_idx = 0xFF;
-		ioc->scsi_lookup[i].smid = smid;
-		ioc->scsi_lookup[i].scmd = NULL;
-		ioc->scsi_lookup[i].direct_io = 0;
-		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
-		    &ioc->free_list);
+	if (!shost_use_blk_mq(ioc->shost)) {
+		smid = 1;
+		for (i = 0; i < ioc->scsiio_depth; i++, smid++) {
+			struct scsiio_tracker *st = &ioc->scsi_lookup[i];
+
+			memset(st, 0, sizeof(struct scsiio_tracker));
+			INIT_LIST_HEAD(&st->chain_list);
+			st->cb_idx = 0xFF;
+			st->smid = smid;
+			list_add_tail(&st->tracker_list, &ioc->free_list);
+		}
 	}
 
 	/* hi-priority queue */
@@ -5667,6 +5736,13 @@ struct scsiio_tracker *
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
@@ -5688,11 +5764,16 @@ struct scsiio_tracker *
 		return;
 
 	/* pending command count */
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = 0; i < ioc->scsiio_depth; i++)
-		if (ioc->scsi_lookup[i].cb_idx != 0xFF)
-			ioc->pending_io_count++;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	if (shost_use_blk_mq(ioc->shost))
+		blk_mq_tagset_busy_iter(&ioc->shost->tag_set,
+					_count_pending, ioc);
+	else {
+		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+		for (i = 0; i < ioc->scsiio_depth; i++)
+			if (ioc->scsi_lookup[i].cb_idx != 0xFF)
+				ioc->pending_io_count++;
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	}
 
 	if (!ioc->pending_io_count)
 		return;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 876e7b4..7a3553e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1248,6 +1248,8 @@ u16 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsi_cmnd *scmd);
 struct scsiio_tracker * mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid);
+void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
+			   struct scsiio_tracker *st);
 
 u16 mpt3sas_base_get_smid(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
 void mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index e952175..264e239 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -549,6 +549,86 @@ enum block_state {
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
+_ctl_find_smid_mq(struct MPT3SAS_ADAPTER *ioc, u16 handle, u32 lun)
+{
+	struct smid_match_data smd;
+
+	smd.smid = 0;
+	blk_mq_tagset_busy_iter(&ioc->shost->tag_set, _smid_fn, &smd);
+	return smd.smid;
+}
+
+static u16
+_ctl_find_smid_legacy(struct MPT3SAS_ADAPTER *ioc, u16 handle, u32 lun)
+{
+	struct scsi_cmnd *scmd;
+	unsigned long flags;
+	u16 smid = 0;
+	int i;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	for (i = ioc->scsiio_depth; i; i--) {
+		scmd = ioc->scsi_lookup[i - 1].scmd;
+		if (!_scmd_match(scmd, handle, lun))
+			continue;
+
+		smid = ioc->scsi_lookup[i - 1].smid;
+		break;
+	}
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+
+	return smid;
+}
+
+static u16
+_ctl_find_smid(struct MPT3SAS_ADAPTER *ioc, u16 handle, u32 lun)
+{
+	if (shost_use_blk_mq(ioc->shost))
+		return _ctl_find_smid_mq(ioc, handle, lun);
+	else
+		return _ctl_find_smid_legacy(ioc, handle, lun);
+}
+
 /**
  * _ctl_set_task_mid - assign an active smid to tm request
  * @ioc: per adapter object
@@ -562,12 +642,7 @@ enum block_state {
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
@@ -581,27 +656,11 @@ enum block_state {
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
@@ -621,6 +680,8 @@ enum block_state {
 		return 1;
 	}
 
+	tm_request->TaskMID = cpu_to_le16(smid);
+
 	dctlprintk(ioc, pr_info(MPT3SAS_FMT
 		"%s: handle(0x%04x), lun(%d), task_mid(%d)\n", ioc->name,
 	    desc, le16_to_cpu(tm_request->DevHandle), lun,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ca925ef..bbfbfcc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -147,7 +147,6 @@ static int _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 module_param(prot_mask, int, 0);
 MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=7 ");
 
-
 /* raid transport support */
 struct raid_template *mpt3sas_raid_template;
 struct raid_template *mpt2sas_raid_template;
@@ -1072,8 +1071,19 @@ struct _sas_node *
 _scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	unsigned long flags;
-	struct scsi_cmnd *scmd;
+	struct scsi_cmnd *scmd = NULL;
 
+	if (shost_use_blk_mq(ioc->shost)) {
+		u16 hwq = (smid - 1) % ioc->shost->nr_hw_queues;
+		u16 tag = (smid - 1) / ioc->shost->nr_hw_queues;
+		struct blk_mq_tag_set *tagset = &ioc->shost->tag_set;
+		struct request *req;
+
+		req = blk_mq_tag_to_rq(tagset->tags[hwq], tag);
+		if (!req)
+			return NULL;
+		return blk_mq_rq_to_pdu(req);
+	}
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	scmd = ioc->scsi_lookup[smid - 1].scmd;
 	ioc->scsi_lookup[smid - 1].scmd = NULL;
@@ -1100,6 +1110,11 @@ struct _sas_node *
 	unsigned long	flags;
 	int i;
 
+	if (shost_use_blk_mq(ioc->shost)) {
+		struct scsiio_tracker *st = scsi_cmd_priv(scmd);
+
+		return st->smid;
+	}
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	smid = 0;
 	for (i = 0; i < ioc->scsiio_depth; i++) {
@@ -1113,6 +1128,24 @@ struct _sas_node *
 	return smid;
 }
 
+struct _scsih_scsi_lookup_data {
+	int channel;
+	int id;
+	int lun;
+	int result;
+};
+
+static void
+_scsih_scsi_target_lookup_fn(struct request *req, void *data, bool reserved)
+{
+	struct _scsih_scsi_lookup_data *lookup_data = data;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+
+	if (scmd->device->id == lookup_data->id &&
+	    scmd->device->channel == lookup_data->channel)
+		lookup_data->result++;
+}
+
 /**
  * _scsih_scsi_lookup_find_by_target - search for matching channel:id
  * @ioc: per adapter object
@@ -1131,6 +1164,16 @@ struct _sas_node *
 	unsigned long	flags;
 	int i;
 
+	if (shost_use_blk_mq(ioc->shost)) {
+		struct _scsih_scsi_lookup_data data = {
+			.channel = channel,
+			.id = id,
+			.result = 0,
+		};
+		blk_mq_tagset_busy_iter(&ioc->shost->tag_set,
+					_scsih_scsi_target_lookup_fn, &data);
+		return (data.result > 0);
+	}
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	found = 0;
 	for (i = 0 ; i < ioc->scsiio_depth; i++) {
@@ -1146,6 +1189,18 @@ struct _sas_node *
 	return found;
 }
 
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
+}
+
 /**
  * _scsih_scsi_lookup_find_by_lun - search for matching channel:id:lun
  * @ioc: per adapter object
@@ -1165,6 +1220,17 @@ struct _sas_node *
 	unsigned long	flags;
 	int i;
 
+	if (shost_use_blk_mq(ioc->shost)) {
+		struct _scsih_scsi_lookup_data data = {
+			.channel = channel,
+			.id = id,
+			.lun = lun,
+			.result = 0,
+		};
+		blk_mq_tagset_busy_iter(&ioc->shost->tag_set,
+					_scsih_scsi_lun_lookup_fn, &data);
+		return (data.result > 0);
+	}
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	found = 0;
 	for (i = 0 ; i < ioc->scsiio_depth; i++) {
@@ -2309,7 +2375,7 @@ struct _sas_node *
 	switch (type) {
 	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
 		rc = SUCCESS;
-		if (scsi_lookup->scmd == NULL)
+		if (scsi_lookup->cb_idx == 0xFF)
 			break;
 		rc = FAILED;
 		break;
@@ -3891,6 +3957,26 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
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
@@ -3905,13 +3991,19 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 {
 	struct scsi_cmnd *scmd;
 	u16 smid;
-	u16 count = 0;
+
+	ioc->pending_io_count = 0;
+	if (shost_use_blk_mq(ioc->shost)) {
+		blk_mq_tagset_busy_iter(&ioc->shost->tag_set,
+					_flush_running, ioc);
+		goto out;
+	}
 
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
 		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
 		if (!scmd)
 			continue;
-		count++;
+		ioc->pending_io_count++;
 		if (ata_12_16_cmd(scmd))
 			scsi_internal_device_unblock(scmd->device,
 							SDEV_RUNNING);
@@ -3923,8 +4015,9 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 			scmd->result = DID_RESET << 16;
 		scmd->scsi_done(scmd);
 	}
+out:
 	dtmprintk(ioc, pr_info(MPT3SAS_FMT "completing %d cmds\n",
-	    ioc->name, count));
+	    ioc->name, ioc->pending_io_count));
 }
 
 /**
@@ -4662,9 +4755,11 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	if (mpt3sas_scsi_direct_io_get(ioc, smid) &&
 	     ((ioc_status & MPI2_IOCSTATUS_MASK)
 	      != MPI2_IOCSTATUS_SCSI_TASK_TERMINATED)) {
-		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-		ioc->scsi_lookup[smid - 1].scmd = scmd;
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		if (!shost_use_blk_mq(ioc->shost)) {
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+			ioc->scsi_lookup[smid - 1].scmd = scmd;
+			spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		}
 		mpt3sas_scsi_direct_io_set(ioc, smid, 0);
 		memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
 		mpi_request->DevHandle =
@@ -4835,11 +4930,13 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 		_scsih_scsi_ioc_info(ioc , scmd, mpi_reply, smid);
 
  out:
+	if (shost_use_blk_mq(ioc->shost))
+		mpt3sas_base_clear_st(ioc, scsi_cmd_priv(scmd));
 
 	scsi_dma_unmap(scmd);
 
 	scmd->scsi_done(scmd);
-	return 1;
+	return shost_use_blk_mq(ioc->shost) ? 0 : 1;
 }
 
 /**
@@ -6033,6 +6130,108 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
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
@@ -6070,6 +6269,31 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 
 	_scsih_block_io_all_device(ioc);
 
+	if (shost_use_blk_mq(ioc->shost)) {
+		struct _abort_sas_task_data priv = {
+			.ioc = ioc,
+			.retry = 0,
+			.query_count = 0,
+			.termination_count = 0,
+		};
+
+retry_iter:
+		if (max_retries++ == 5) {
+			dewtprintk(ioc, pr_info(MPT3SAS_FMT "%s: giving up\n",
+				ioc->name, __func__));
+			goto out;
+		} else if (max_retries > 1)
+			dewtprintk(ioc, pr_info(MPT3SAS_FMT "%s: %d retry\n",
+				ioc->name, __func__, max_retries - 1));
+
+		blk_mq_tagset_busy_iter(&ioc->shost->tag_set,
+					_abort_sas_task, &priv);
+		if (priv.retry)
+			goto retry_iter;
+		termination_count = priv.termination_count;
+		query_count = priv.query_count;
+		goto out_no_lock;
+	}
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	mpi_reply = ioc->tm_cmds.reply;
  broadcast_aen_retry:
@@ -8578,6 +8802,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
 	.track_queue_depth		= 1,
+	.cmd_size			= sizeof(struct scsiio_tracker),
 };
 
 /* raid transport support for SAS 2.0 HBA devices */
@@ -8616,6 +8841,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
 	.track_queue_depth		= 1,
+	.cmd_size			= sizeof(struct scsiio_tracker),
 };
 
 /* raid transport support for SAS 3.0 HBA devices */
-- 
1.8.5.6

