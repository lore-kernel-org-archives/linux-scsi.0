From: Jens Axboe <axboe@fb.com>
Subject: [PATCH 6/6] mpt3sas: store scsi io tracker data in the scsi request
Date: Tue, 7 Apr 2015 11:18:40 -0600
Message-ID: <1428427120-20971-7-git-send-email-axboe@fb.com>
References: <1428427120-20971-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428427120-20971-1-git-send-email-axboe@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

Instead of storing the IO tracker structure in a separate list
that we need to pop/push to on every submit and complete (and
lock), store it in the pdu associated with a request. This is
possible on scsi-mq only, and further cuts the spinlock associated
time for higher IOPS IO workloads. At 100K IOPS, this effectively
cuts the locking time in half.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 173 +++++++++++++++++++++++++----------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   2 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  69 +++++++++++---
 3 files changed, 185 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 14a781b6b88d..4c67b685e1f5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -815,6 +815,20 @@ _base_async_event(struct MPT3SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 	return 1;
 }
 
+struct scsiio_tracker *
+mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	if (shost_use_blk_mq(ioc->shost)) {
+		struct scsi_cmnd *scmd;
+
+		scmd = scsi_mq_find_tag(ioc->shost, smid - 1);
+		if (!scmd)
+			return NULL;
+		return scsi_cmd_priv(scmd);
+	} else
+		return &ioc->scsi_lookup[smid - 1];
+}
+
 /**
  * _base_get_cb_idx - obtain the callback index
  * @ioc: per adapter object
@@ -829,8 +843,10 @@ _base_get_cb_idx(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 	u8 cb_idx;
 
 	if (smid < ioc->hi_priority_smid) {
-		i = smid - 1;
-		cb_idx = ioc->scsi_lookup[i].cb_idx;
+		struct scsiio_tracker *st;
+
+		st = mpt3sas_get_st_from_smid(ioc, smid);
+		cb_idx = st->cb_idx;
 	} else if (smid < ioc->internal_smid) {
 		i = smid - ioc->hi_priority_smid;
 		cb_idx = ioc->hpr_lookup[i].cb_idx;
@@ -1176,6 +1192,7 @@ static struct chain_tracker *
 _base_get_chain_buffer_tracker(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	struct chain_tracker *chain_req;
+	struct scsiio_tracker *st;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
@@ -1188,8 +1205,8 @@ _base_get_chain_buffer_tracker(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 	chain_req = list_entry(ioc->free_chain_list.next,
 	    struct chain_tracker, tracker_list);
 	list_del_init(&chain_req->tracker_list);
-	list_add_tail(&chain_req->tracker_list,
-	    &ioc->scsi_lookup[smid - 1].chain_list);
+	st = mpt3sas_get_st_from_smid(ioc, smid);
+	list_add_tail(&chain_req->tracker_list, &st->chain_list);
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 	return chain_req;
 }
@@ -2006,6 +2023,11 @@ mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsiio_tracker *request;
 	u16 smid;
 
+	if (shost_use_blk_mq(ioc->shost)) {
+		request = scsi_cmd_priv(scmd);
+		return request->smid;
+	}
+
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	if (list_empty(&ioc->free_list)) {
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
@@ -2053,6 +2075,32 @@ mpt3sas_base_get_smid_hpr(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx)
 	return smid;
 }
 
+static void
+_base_recovery_check(struct MPT3SAS_ADAPTER *ioc)
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
+_dechain_st(struct MPT3SAS_ADAPTER *ioc, struct scsiio_tracker *st)
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
+
 /**
  * mpt3sas_base_free_smid - put smid back on free_list
  * @ioc: per adapter object
@@ -2065,34 +2113,36 @@ mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	unsigned long flags;
 	int i;
-	struct chain_tracker *chain_req, *next;
+
+	if (shost_use_blk_mq(ioc->shost) && smid < ioc->hi_priority_smid) {
+		struct scsiio_tracker *st;
+
+		st = mpt3sas_get_st_from_smid(ioc, smid);
+		if (!st)
+			return;
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
 		list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
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
@@ -2896,14 +2946,23 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
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
+				    GFP_KERNEL, ioc->scsi_lookup_pages);
+		if (!ioc->scsi_lookup) {
+			pr_err(MPT3SAS_FMT "scsi_lookup: get_free_pages "
+					"failed, sz(%d)\n", ioc->name, (int)sz);
+			goto out;
+		}
+	} else {
+		ioc->scsi_lookup_pages = 0;
+		ioc->scsi_lookup = NULL;
 	}
 
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "scsiio(0x%p): depth(%d)\n",
@@ -4439,14 +4498,17 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 	/* initialize the scsi lookup free list */
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	INIT_LIST_HEAD(&ioc->free_list);
-	smid = 1;
-	for (i = 0; i < ioc->scsiio_depth; i++, smid++) {
-		INIT_LIST_HEAD(&ioc->scsi_lookup[i].chain_list);
-		ioc->scsi_lookup[i].cb_idx = 0xFF;
-		ioc->scsi_lookup[i].smid = smid;
-		ioc->scsi_lookup[i].scmd = NULL;
-		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
-		    &ioc->free_list);
+
+	if (!shost_use_blk_mq(ioc->shost)) {
+		smid = 1;
+		for (i = 0; i < ioc->scsiio_depth; i++, smid++) {
+			INIT_LIST_HEAD(&ioc->scsi_lookup[i].chain_list);
+			ioc->scsi_lookup[i].cb_idx = 0xFF;
+			ioc->scsi_lookup[i].smid = smid;
+			ioc->scsi_lookup[i].scmd = NULL;
+			list_add_tail(&ioc->scsi_lookup[i].tracker_list,
+					    &ioc->free_list);
+		}
 	}
 
 	/* hi-priority queue */
@@ -4895,7 +4957,7 @@ _wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 {
 	u32 ioc_state;
 	unsigned long flags;
-	u16 i;
+	u16 i, pending, loops;
 
 	ioc->pending_io_count = 0;
 	if (sleep_flag != CAN_SLEEP)
@@ -4906,17 +4968,32 @@ _wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
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
+				scmd = scsi_mq_find_tag(ioc->shost, i);
+				if (scmd)
+					pending++;
+			} else {
+				st = mpt3sas_get_st_from_smid(ioc, i + 1);
+				if (st->cb_idx != 0xFF)
+					pending++;
+			}
+		}
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
-	if (!ioc->pending_io_count)
-		return;
+		if (!pending)
+			break;
 
-	/* wait for pending commands to complete */
-	wait_event_timeout(ioc->reset_wq, ioc->pending_io_count == 0, 10 * HZ);
+		/* wait for pending commands to complete */
+		wait_event_timeout(ioc->reset_wq, ioc->pending_io_count == 0, HZ);
+	} while (++loops <= 10);
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index afa881682bef..1a94791dbfe8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -986,6 +986,8 @@ u16 mpt3sas_base_get_smid_hpr(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
 u16 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsi_cmnd *scmd);
 
+struct scsiio_tracker *mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc,
+    u16 smid);
 u16 mpt3sas_base_get_smid(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
 void mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 void mpt3sas_base_put_smid_scsi_io(struct MPT3SAS_ADAPTER *ioc, u16 smid,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5a97e3286719..6b478ae0b680 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -930,7 +930,10 @@ _scsih_is_end_device(u32 device_info)
 static struct scsi_cmnd *
 _scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
-	return ioc->scsi_lookup[smid - 1].scmd;
+	if (shost_use_blk_mq(ioc->shost))
+		return scsi_mq_find_tag(ioc->shost, smid - 1);
+	else
+		return ioc->scsi_lookup[smid - 1].scmd;
 }
 
 /**
@@ -947,6 +950,8 @@ _scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 	unsigned long flags;
 	struct scsi_cmnd *scmd;
 
+	BUG_ON(shost_use_blk_mq(ioc->shost));
+
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	scmd = ioc->scsi_lookup[smid - 1].scmd;
 	ioc->scsi_lookup[smid - 1].scmd = NULL;
@@ -973,6 +978,13 @@ _scsih_scsi_lookup_find_by_scmd(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd
 	unsigned long	flags;
 	int i;
 
+	if (shost_use_blk_mq(ioc->shost)) {
+		struct scsiio_tracker *st;
+
+		st = scsi_cmd_priv(scmd);
+		return st->smid;
+	}
+
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	smid = 0;
 	for (i = 0; i < ioc->scsiio_depth; i++) {
@@ -1007,9 +1019,14 @@ _scsih_scsi_lookup_find_by_target(struct MPT3SAS_ADAPTER *ioc, int id,
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	found = 0;
 	for (i = 0 ; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd &&
-		    (ioc->scsi_lookup[i].scmd->device->id == id &&
-		    ioc->scsi_lookup[i].scmd->device->channel == channel)) {
+		struct scsiio_tracker *st;
+
+		st = mpt3sas_get_st_from_smid(ioc, i + 1);
+		if (!st)
+			continue;
+		if (st->scmd &&
+		    (st->scmd->device->id == id &&
+		    st->scmd->device->channel == channel)) {
 			found = 1;
 			goto out;
 		}
@@ -1041,10 +1058,15 @@ _scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	found = 0;
 	for (i = 0 ; i < ioc->scsiio_depth; i++) {
-		if (ioc->scsi_lookup[i].scmd &&
-		    (ioc->scsi_lookup[i].scmd->device->id == id &&
-		    ioc->scsi_lookup[i].scmd->device->channel == channel &&
-		    ioc->scsi_lookup[i].scmd->device->lun == lun)) {
+		struct scsiio_tracker *st;
+
+		st = mpt3sas_get_st_from_smid(ioc, i + 1);
+		if (!st)
+			continue;
+		if (st->scmd &&
+		    (st->scmd->device->id == id &&
+		    st->scmd->device->channel == channel &&
+		    st->scmd->device->lun == lun)) {
 			found = 1;
 			goto out;
 		}
@@ -2053,7 +2075,7 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 	}
 
 	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
-		scsi_lookup = &ioc->scsi_lookup[smid_task - 1];
+		scsi_lookup = mpt3sas_get_st_from_smid(ioc, smid_task);
 
 	dtmprintk(ioc, pr_info(MPT3SAS_FMT
 		"sending tm: handle(0x%04x), task_type(0x%02x), smid(%d)\n",
@@ -3392,7 +3414,11 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 	u16 count = 0;
 
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
-		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+		if (shost_use_blk_mq(ioc->shost))
+			scmd = _scsih_scsi_lookup_get(ioc, smid);
+		else
+			scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+
 		if (!scmd)
 			continue;
 		count++;
@@ -4058,7 +4084,11 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	u32 response_code = 0;
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
-	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+	if (shost_use_blk_mq(ioc->shost))
+		scmd = scsi_mq_find_tag(ioc->shost, smid - 1);
+	else
+		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
+
 	if (scmd == NULL)
 		return 1;
 
@@ -7255,6 +7285,21 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	return 1;
 }
 
+static int
+_scsih_init_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
+			unsigned int request_idx)
+{
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct scsiio_tracker *st;
+
+	st = (void *) cmd + sizeof(*cmd);
+	INIT_LIST_HEAD(&st->chain_list);
+	st->scmd = cmd;
+	st->cb_idx = ioc->scsi_io_cb_idx;
+	st->smid = request_idx + 1;
+	return 0;
+}
+
 /* shost template */
 static struct scsi_host_template scsih_driver_template = {
 	.module				= THIS_MODULE,
@@ -7283,6 +7328,8 @@ static struct scsi_host_template scsih_driver_template = {
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
 	.track_queue_depth		= 1,
+	.cmd_size			= sizeof(struct scsiio_tracker),
+	.init_command			= _scsih_init_command,
 };
 
 /**
-- 
1.9.1
