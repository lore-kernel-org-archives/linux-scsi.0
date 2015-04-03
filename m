From: Jens Axboe <axboe@fb.com>
Subject: [PATCH 6/7] mpt2sas: store scsi io tracker data in the scsi command / request
Date: Fri, 3 Apr 2015 09:58:22 -0600
Message-ID: <1428076703-31014-7-git-send-email-axboe@fb.com>
References: <1428076703-31014-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61104 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbbDCP6f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2015 11:58:35 -0400
In-Reply-To: <1428076703-31014-1-git-send-email-axboe@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@fb.com>

Instead of storing the IO tracker structure in a separate list
that we need to pop/push to on every submit and complete (and
lock), store it in the pdu associated with a request. This is
possible on scsi-mq only, and further cuts the spinlock associated
time for higher IOPS IO workloads. At 100K IOPS, this effectively
cuts the locking time in half.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c  | 194 +++++++++++++++++++++++++----------
 drivers/scsi/mpt2sas/mpt2sas_base.h  |   3 +
 drivers/scsi/mpt2sas/mpt2sas_ctl.c   | 119 ++++++++++++++++-----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |  89 ++++++++++++----
 4 files changed, 307 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 11248de92b3b..b0e4453af64c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -828,6 +828,20 @@ _base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 	return;
 }
 
+struct scsiio_tracker *
+mpt2sas_get_st_from_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
+{
+	if (shost_use_blk_mq(ioc->shost)) {
+		struct scsi_cmnd *scmd;
+
+		scmd = scsi_mq_find_tag(ioc->shost, smid - 1);
+		if (!scmd)
+			return NULL;
+		return scsi_mq_scmd_to_pdu(scmd);
+	} else
+		return &ioc->scsi_lookup[smid - 1];
+}
+
 /**
  * _base_get_cb_idx - obtain the callback index
  * @ioc: per adapter object
@@ -842,8 +856,10 @@ _base_get_cb_idx(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 	u8 cb_idx;
 
 	if (smid < ioc->hi_priority_smid) {
-		i = smid - 1;
-		cb_idx = ioc->scsi_lookup[i].cb_idx;
+		struct scsiio_tracker *st;
+
+		st = mpt2sas_get_st_from_smid(ioc, smid);
+		cb_idx = st->cb_idx;
 	} else if (smid < ioc->internal_smid) {
 		i = smid - ioc->hi_priority_smid;
 		cb_idx = ioc->hpr_lookup[i].cb_idx;
@@ -962,18 +978,17 @@ _base_interrupt(int irq, void *bus_id)
 			goto next;
 		if (smid) {
 			cb_idx = _base_get_cb_idx(ioc, smid);
-		if ((likely(cb_idx < MPT_MAX_CALLBACKS))
+			if ((likely(cb_idx < MPT_MAX_CALLBACKS))
 			    && (likely(mpt_callbacks[cb_idx] != NULL))) {
 				rc = mpt_callbacks[cb_idx](ioc, smid,
 				    msix_index, reply);
-			if (reply)
-				_base_display_reply_info(ioc, smid,
-				    msix_index, reply);
-			if (rc)
-				mpt2sas_base_free_smid(ioc, smid);
+				if (reply)
+					_base_display_reply_info(ioc, smid,
+							msix_index, reply);
+				if (rc)
+					mpt2sas_base_free_smid(ioc, smid);
 			}
-		}
-		if (!smid)
+		} else
 			_base_async_event(ioc, msix_index, reply);
 
 		/* reply free queue handling */
@@ -1724,6 +1739,18 @@ mpt2sas_base_get_smid_scsiio(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsiio_tracker *request;
 	u16 smid;
 
+	if (shost_use_blk_mq(ioc->shost)) {
+		/*
+		 * If we don't have a SCSI command associated with this smid,
+		 * bump it to high-prio
+		 */
+		if (!scmd)
+			return mpt2sas_base_get_smid_hpr(ioc, cb_idx);
+
+		request = scsi_mq_scmd_to_pdu(scmd);
+		return request->smid;
+	}
+
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (list_empty(&ioc->free_list)) {
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
@@ -1771,6 +1798,31 @@ mpt2sas_base_get_smid_hpr(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx)
 	return smid;
 }
 
+static void
+_base_recovery_check(struct MPT2SAS_ADAPTER *ioc)
+{
+	/*
+	 * See _wait_for_commands_to_complete() call with regards to this code.
+	 */
+	if (ioc->shost_recovery && ioc->pending_io_count) {
+		if (ioc->pending_io_count == 1)
+			wake_up(&ioc->reset_wq);
+		ioc->pending_io_count = 0;
+	}
+}
+
+static void
+_dechain_st(struct MPT2SAS_ADAPTER *ioc, struct scsiio_tracker *st)
+{
+	struct chain_tracker *chain_req;
+
+	while (!list_empty(&st->chain_list)) {
+		chain_req = list_first_entry(&st->chain_list,
+						struct chain_tracker,
+						tracker_list);
+		list_move(&chain_req->tracker_list, &ioc->free_chain_list);
+	}
+}
 
 /**
  * mpt2sas_base_free_smid - put smid back on free_list
@@ -1784,20 +1836,32 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
 	unsigned long flags;
 	int i;
-	struct chain_tracker *chain_req, *next;
+
+	if (shost_use_blk_mq(ioc->shost) && smid < ioc->hi_priority_smid) {
+		struct scsiio_tracker *st;
+
+		st = mpt2sas_get_st_from_smid(ioc, smid);
+		if (!st)
+			return;
+
+		st->direct_io = 0;
+
+		if (!list_empty(&st->chain_list)) {
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+			_dechain_st(ioc, st);
+			spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		}
+
+		_base_recovery_check(ioc);
+		return;
+	}
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (smid < ioc->hi_priority_smid) {
 		/* scsiio queue */
 		i = smid - 1;
-		if (!list_empty(&ioc->scsi_lookup[i].chain_list)) {
-			list_for_each_entry_safe(chain_req, next,
-			    &ioc->scsi_lookup[i].chain_list, tracker_list) {
-				list_del_init(&chain_req->tracker_list);
-				list_add(&chain_req->tracker_list,
-				    &ioc->free_chain_list);
-			}
-		}
+		if (!list_empty(&ioc->scsi_lookup[i].chain_list))
+			_dechain_st(ioc, &ioc->scsi_lookup[i]);
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
 		ioc->scsi_lookup[i].scmd = NULL;
 		ioc->scsi_lookup[i].direct_io = 0;
@@ -1805,15 +1869,7 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 		    &ioc->free_list);
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
-		/*
-		 * See _wait_for_commands_to_complete() call with regards
-		 * to this code.
-		 */
-		if (ioc->shost_recovery && ioc->pending_io_count) {
-			if (ioc->pending_io_count == 1)
-				wake_up(&ioc->reset_wq);
-			ioc->pending_io_count--;
-		}
+		_base_recovery_check(ioc);
 		return;
 	} else if (smid < ioc->internal_smid) {
 		/* hi-priority */
@@ -2723,14 +2779,23 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	    ioc->name, (unsigned long long) ioc->request_dma));
 	total_sz += sz;
 
-	sz = ioc->scsiio_depth * sizeof(struct scsiio_tracker);
-	ioc->scsi_lookup_pages = get_order(sz);
-	ioc->scsi_lookup = (struct scsiio_tracker *)__get_free_pages(
-	    GFP_KERNEL, ioc->scsi_lookup_pages);
-	if (!ioc->scsi_lookup) {
-		printk(MPT2SAS_ERR_FMT "scsi_lookup: get_free_pages failed, "
-		    "sz(%d)\n", ioc->name, (int)sz);
-		goto out;
+	/*
+	 * Don't need to allocate memory for scsiio_tracker array if we
+	 * are using scsi-mq, we embed it in the scsi_cmnd for that case.
+	 */
+	if (!shost_use_blk_mq(ioc->shost)) {
+		sz = ioc->scsiio_depth * sizeof(struct scsiio_tracker);
+		ioc->scsi_lookup_pages = get_order(sz);
+		ioc->scsi_lookup = (struct scsiio_tracker *)__get_free_pages(
+				    GFP_KERNEL, ioc->scsi_lookup_pages);
+		if (!ioc->scsi_lookup) {
+			printk(MPT2SAS_ERR_FMT "scsi_lookup: get_free_pages "
+				"failed, sz(%d)\n", ioc->name, (int)sz);
+			goto out;
+		}
+	} else {
+		ioc->scsi_lookup_pages = 0;
+		ioc->scsi_lookup = NULL;
 	}
 
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsiio(0x%p): "
@@ -4299,15 +4364,17 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
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
+			INIT_LIST_HEAD(&ioc->scsi_lookup[i].chain_list);
+			ioc->scsi_lookup[i].cb_idx = 0xFF;
+			ioc->scsi_lookup[i].smid = smid;
+			ioc->scsi_lookup[i].scmd = NULL;
+			ioc->scsi_lookup[i].direct_io = 0;
+			list_add_tail(&ioc->scsi_lookup[i].tracker_list,
+					    &ioc->free_list);
+		}
 	}
 
 	/* hi-priority queue */
@@ -4772,7 +4839,7 @@ _wait_for_commands_to_complete(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 {
 	u32 ioc_state;
 	unsigned long flags;
-	u16 i;
+	u16 i, pending, loops;
 
 	ioc->pending_io_count = 0;
 	if (sleep_flag != CAN_SLEEP)
@@ -4783,17 +4850,34 @@ _wait_for_commands_to_complete(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		return;
 
 	/* pending command count */
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = 0; i < ioc->scsiio_depth; i++)
-		if (ioc->scsi_lookup[i].cb_idx != 0xFF)
-			ioc->pending_io_count++;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	loops = 0;
+	do {
+		pending = 0;
+		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+		for (i = 0; i < ioc->scsiio_depth; i++) {
+			struct scsiio_tracker *st;
+			struct scsi_cmnd *scmd;
+
+			if (shost_use_blk_mq(ioc->shost)) {
+				scmd = scsi_mq_find_tag(ioc->shost,  i);
+				if (scsi_mq_scmd_started(scmd))
+					pending++;
+			} else {
+				st = mpt2sas_get_st_from_smid(ioc, i + 1);
+				if (st->cb_idx != 0xFF)
+					pending++;
+			}
+		}
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
-	if (!ioc->pending_io_count)
-		return;
+		if (!pending)
+			break;
+
+		ioc->pending_io_count = 1;
 
-	/* wait for pending commands to complete */
-	wait_event_timeout(ioc->reset_wq, ioc->pending_io_count == 0, 10 * HZ);
+		/* wait for pending commands to complete */
+		wait_event_timeout(ioc->reset_wq, ioc->pending_io_count == 0, HZ);
+	} while (++loops <= 10);
 }
 
 /**
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index caff8d10cca4..cadb392126e0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -1045,6 +1045,9 @@ u16 mpt2sas_base_get_smid_hpr(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx);
 u16 mpt2sas_base_get_smid_scsiio(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx,
     struct scsi_cmnd *scmd);
 
+
+struct scsiio_tracker *mpt2sas_get_st_from_smid(struct MPT2SAS_ADAPTER *ioc,
+    u16 smid);
 u16 mpt2sas_base_get_smid(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx);
 void mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid);
 void mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 4e509604b571..409480f8381f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -529,6 +529,94 @@ _ctl_poll(struct file *filep, poll_table *wait)
 	return 0;
 }
 
+static bool
+_scmd_match(struct scsi_cmnd *scmd, u16 handle, u32 lun)
+{
+	struct MPT2SAS_DEVICE *priv_data;
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
+static bool
+_smid_fn(struct scsi_cmnd *scmd, void *data)
+{
+	struct smid_match_data *smd = data;
+	struct scsiio_tracker *st;
+
+	if (!_scmd_match(scmd, smd->handle, smd->lun))
+		return false;
+
+	st = scsi_mq_scmd_to_pdu(scmd);
+	smd->smid = st->smid;
+	return true;
+}
+
+static u16
+_ctl_find_smid_mq(struct MPT2SAS_ADAPTER *ioc, u16 handle, u32 lun)
+{
+	struct scsi_device *sdev;
+	struct smid_match_data smd;
+
+	smd.smid = 0;
+	shost_for_each_device(sdev, ioc->shost) {
+		scsi_mq_scmd_busy_iter(sdev, _smid_fn, &smd);
+		if (smd.smid) {
+			scsi_device_put(sdev);
+			break;
+		}
+	}
+
+	return smd.smid;
+}
+
+static u16
+_ctl_find_smid_legacy(struct MPT2SAS_ADAPTER *ioc, u16 handle, u32 lun)
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
+_ctl_find_smid(struct MPT2SAS_ADAPTER *ioc, u16 handle, u32 lun)
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
@@ -542,12 +630,7 @@ static int
 _ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
     Mpi2SCSITaskManagementRequest_t *tm_request)
 {
-	u8 found = 0;
-	u16 i;
-	u16 handle;
-	struct scsi_cmnd *scmd;
-	struct MPT2SAS_DEVICE *priv_data;
-	unsigned long flags;
+	u16 smid, handle;
 	Mpi2SCSITaskManagementReply_t *tm_reply;
 	u32 sz;
 	u32 lun;
@@ -561,27 +644,11 @@ _ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
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
 		dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "handle(0x%04x), lun(%d), no active mid!!\n", ioc->name,
 		    desc, le16_to_cpu(tm_request->DevHandle), lun));
@@ -600,6 +667,8 @@ _ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
 		return 1;
 	}
 
+	tm_request->TaskMID = cpu_to_le16(smid);
+
 	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 	    "handle(0x%04x), lun(%d), task_mid(%d)\n", ioc->name,
 	    desc, le16_to_cpu(tm_request->DevHandle), lun,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 3f26147bbc64..287f2b30f38e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -884,7 +884,10 @@ _scsih_is_end_device(u32 device_info)
 static struct scsi_cmnd *
 _scsih_scsi_lookup_get(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
-	return ioc->scsi_lookup[smid - 1].scmd;
+	if (shost_use_blk_mq(ioc->shost))
+		return scsi_mq_find_tag(ioc->shost, smid - 1);
+	else
+		return ioc->scsi_lookup[smid - 1].scmd;
 }
 
 /**
@@ -901,6 +904,8 @@ _scsih_scsi_lookup_get_clear(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 	unsigned long flags;
 	struct scsi_cmnd *scmd;
 
+	BUG_ON(shost_use_blk_mq(ioc->shost));
+
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	scmd = ioc->scsi_lookup[smid - 1].scmd;
 	ioc->scsi_lookup[smid - 1].scmd = NULL;
@@ -927,6 +932,13 @@ _scsih_scsi_lookup_find_by_scmd(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd
 	unsigned long	flags;
 	int i;
 
+	if (shost_use_blk_mq(ioc->shost)) {
+		struct scsiio_tracker *st;
+
+		st = scsi_mq_scmd_to_pdu(scmd);
+		return st->smid;
+	}
+
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	smid = 0;
 	for (i = 0; i < ioc->scsiio_depth; i++) {
@@ -961,9 +973,14 @@ _scsih_scsi_lookup_find_by_target(struct MPT2SAS_ADAPTER *ioc, int id,
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	found = 0;
 	for (i = 0 ; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd &&
-		    (ioc->scsi_lookup[i].scmd->device->id == id &&
-		    ioc->scsi_lookup[i].scmd->device->channel == channel)) {
+		struct scsiio_tracker *st;
+
+		st = mpt2sas_get_st_from_smid(ioc, i + 1);
+		if (!st)
+			continue;
+		if (st->scmd &&
+		    (st->scmd->device->id == id &&
+		    st->scmd->device->channel == channel)) {
 			found = 1;
 			goto out;
 		}
@@ -995,10 +1012,15 @@ _scsih_scsi_lookup_find_by_lun(struct MPT2SAS_ADAPTER *ioc, int id,
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	found = 0;
 	for (i = 0 ; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd &&
-		    (ioc->scsi_lookup[i].scmd->device->id == id &&
-		    ioc->scsi_lookup[i].scmd->device->channel == channel &&
-		    ioc->scsi_lookup[i].scmd->device->lun == lun)) {
+		struct scsiio_tracker *st;
+
+		st = mpt2sas_get_st_from_smid(ioc, i + 1);
+		if (!st)
+			continue;
+		if (st->scmd &&
+		    (st->scmd->device->id == id &&
+		    st->scmd->device->channel == channel &&
+		    st->scmd->device->lun == lun)) {
 			found = 1;
 			goto out;
 		}
@@ -1019,6 +1041,7 @@ static struct chain_tracker *
 _scsih_get_chain_buffer_tracker(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
 	struct chain_tracker *chain_req;
+	struct scsiio_tracker *st;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
@@ -1031,8 +1054,8 @@ _scsih_get_chain_buffer_tracker(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 	chain_req = list_entry(ioc->free_chain_list.next,
 	    struct chain_tracker, tracker_list);
 	list_del_init(&chain_req->tracker_list);
-	list_add_tail(&chain_req->tracker_list,
-	    &ioc->scsi_lookup[smid - 1].chain_list);
+	st = mpt2sas_get_st_from_smid(ioc, smid);
+	list_add_tail(&chain_req->tracker_list, &st->chain_list);
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 	return chain_req;
 }
@@ -2387,7 +2410,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 	}
 
 	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
-		scsi_lookup = &ioc->scsi_lookup[smid_task - 1];
+		scsi_lookup = mpt2sas_get_st_from_smid(ioc, smid_task);
 
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "sending tm: handle(0x%04x),"
 	    " task_type(0x%02x), smid(%d)\n", ioc->name, handle, type,
@@ -3698,7 +3721,13 @@ _scsih_flush_running_cmds(struct MPT2SAS_ADAPTER *ioc)
 	u16 count = 0;
 
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
-		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+		if (shost_use_blk_mq(ioc->shost)) {
+			scmd = _scsih_scsi_lookup_get(ioc, smid);
+			if (!scsi_mq_scmd_started(scmd))
+				scmd = NULL;
+		} else
+			scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+
 		if (!scmd)
 			continue;
 		count++;
@@ -3809,7 +3838,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 static inline u8
 _scsih_scsi_direct_io_get(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 {
-	return ioc->scsi_lookup[smid - 1].direct_io;
+	return mpt2sas_get_st_from_smid(ioc, smid)->direct_io;
 }
 
 /**
@@ -3823,7 +3852,7 @@ _scsih_scsi_direct_io_get(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 static inline void
 _scsih_scsi_direct_io_set(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 direct_io)
 {
-	ioc->scsi_lookup[smid - 1].direct_io = direct_io;
+	mpt2sas_get_st_from_smid(ioc, smid)->direct_io = direct_io;
 }
 
 
@@ -4443,7 +4472,11 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	unsigned long flags;
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
-	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+	if (shost_use_blk_mq(ioc->shost))
+		scmd = scsi_mq_find_tag(ioc->shost, smid - 1);
+	else
+		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+
 	if (scmd == NULL)
 		return 1;
 
@@ -4468,10 +4501,12 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (_scsih_scsi_direct_io_get(ioc, smid) &&
 	    ((ioc_status & MPI2_IOCSTATUS_MASK)
 	    != MPI2_IOCSTATUS_SCSI_TASK_TERMINATED)) {
-		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-		ioc->scsi_lookup[smid - 1].scmd = scmd;
+		if (ioc->scsi_lookup) {
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+			ioc->scsi_lookup[smid - 1].scmd = scmd;
+			spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		}
 		_scsih_scsi_direct_io_set(ioc, smid, 0);
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 		memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
 		mpi_request->DevHandle =
 		    cpu_to_le16(sas_device_priv_data->sas_target->handle);
@@ -7623,6 +7658,22 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	return;
 }
 
+static int
+_scsih_init_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
+			unsigned int request_idx)
+{
+	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
+	struct scsiio_tracker *st;
+
+	st = (void *) cmd + sizeof(*cmd);
+	INIT_LIST_HEAD(&st->chain_list);
+	st->scmd = cmd;
+	st->cb_idx = ioc->scsi_io_cb_idx;
+	st->smid = request_idx + 1;
+	st->direct_io = 0;
+	return 0;
+}
+
 /* shost template */
 static struct scsi_host_template scsih_driver_template = {
 	.module				= THIS_MODULE,
@@ -7651,6 +7702,8 @@ static struct scsi_host_template scsih_driver_template = {
 	.shost_attrs			= mpt2sas_host_attrs,
 	.sdev_attrs			= mpt2sas_dev_attrs,
 	.track_queue_depth		= 1,
+	.cmd_size			= sizeof(struct scsiio_tracker),
+	.init_command			= _scsih_init_command,
 };
 
 /**
-- 
1.9.1

