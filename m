From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1] mpt3sas: Use driver scsi lookup to track outstanding IOs
Date: Thu, 21 Feb 2019 07:11:45 -0500
Message-ID: <1550751105-46065-1-git-send-email-sreekanth.reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

During expander reset handling, the driver invokes kernel function
scsi_host_find_tag() to obtain outstanding requests associated with
the scsi host managed by the driver. Kernel’s block layer may return
stale entry for one or more outstanding requests if blk-mq is enabled.
This may lead to Kernel panic if the returned value is inaccessible or
the memory pointed by the returned value is reused.
 
Reference of upstream discussion -
https://patchwork.kernel.org/patch/10734933/

So to fix this issue, driver will use scsi lookup table to track
outstanding IOs at driver level and it avoids using scsi_host_find_tag().

Have done following changes in this patch,
* Allocated & initialized scsi_lookup table of type
  (struct scsiio_tracker) and of depth host's can_queue at driver load time
  and it will be deallocated at driver unload time.

* Once scmd is received, driver will take scsiio_tracker at entry
  corresponding to scmd's tag value from scsi_lookup table. Then this
  scsiio_tracker entry is initialized with proper smid, scmd, cb_idx etc.
  And this scsiio_tracker entry contents are cleared before driver
  calling scsi_done callback function.

* scmd's host_scribble variable is used to save the corresponding
  scsiio_tracker address, later at any time driver can easily retrieve the
  scmd's corresponding scsiio_tacker using this host_scribble variable.

* Whenever driver wants to get the outstanding IOs at the driver level
  then driver can go through this scsi_lookup table and if it observe
  any entry with non-null scmd then it means that scmd is outstanding
  at the driver level.

v1 change set:
Updated the patch description.

Cc: <stable@vger.kernel.org>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 45 +++++++++++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h      | 10 +++++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 16 +++++-------
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  2 +-
 5 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0a6cb8f..8e3d0d5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1301,7 +1301,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 
 	cmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 	if (cmd)
-		return scsi_cmd_priv(cmd);
+		return mpt3sas_get_st_from_scmd(cmd);
 
 	return NULL;
 }
@@ -1709,7 +1709,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 			       struct scsi_cmnd *scmd)
 {
 	struct chain_tracker *chain_req;
-	struct scsiio_tracker *st = scsi_cmd_priv(scmd);
+	struct scsiio_tracker *st = mpt3sas_get_st_from_scmd(scmd);
 	u16 smid = st->smid;
 	u8 chain_offset =
 	   atomic_read(&ioc->chain_lookup[smid - 1].chain_offset);
@@ -3203,14 +3203,18 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsi_cmnd *scmd)
 {
-	struct scsiio_tracker *request = scsi_cmd_priv(scmd);
+	struct scsiio_tracker *request;
 	unsigned int tag = scmd->request->tag;
 	u16 smid;
 
+	scmd->host_scribble = (unsigned char *)(&ioc->scsi_lookup[tag]);
+	request = mpt3sas_get_st_from_scmd(scmd);
+
 	smid = tag + 1;
 	request->cb_idx = cb_idx;
 	request->msix_io = _base_get_msix_index(ioc);
 	request->smid = smid;
+	request->scmd = scmd;
 	INIT_LIST_HEAD(&request->chain_list);
 	return smid;
 }
@@ -3264,6 +3268,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 		return;
 	st->cb_idx = 0xFF;
 	st->direct_io = 0;
+	st->scmd = NULL;
 	atomic_set(&ioc->chain_lookup[st->smid - 1].chain_offset, 0);
 	st->smid = 0;
 }
@@ -4252,6 +4257,11 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 		    ioc->config_page, ioc->config_page_dma);
 	}
 
+	if (ioc->scsi_lookup) {
+		free_pages((ulong)ioc->scsi_lookup, ioc->scsi_lookup_pages);
+		ioc->scsi_lookup = NULL;
+	}
+
 	kfree(ioc->hpr_lookup);
 	kfree(ioc->internal_lookup);
 	if (ioc->chain_lookup) {
@@ -4377,6 +4387,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 		max_request_credit = min_t(u16, facts->RequestCredit,
 		    MAX_HBA_QUEUE_DEPTH);
 
+retry:
 	/* Firmware maintains additional facts->HighPriorityCredit number of
 	 * credits for HiPriprity Request messages, so hba queue depth will be
 	 * sum of max_request_credit and high priority queue depth.
@@ -4581,9 +4592,29 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 			     (unsigned long long)ioc->request_dma));
 	total_sz += sz;
 
+	sz = ioc->shost->can_queue * sizeof(struct scsiio_tracker);
+	ioc->scsi_lookup_pages = get_order(sz);
+	ioc->scsi_lookup = (struct scsiio_tracker *)__get_free_pages(
+	    GFP_KERNEL, ioc->scsi_lookup_pages);
+	if (!ioc->scsi_lookup) {
+		/* Retry allocating memory by reducing the queue depth */
+		if ((max_request_credit - 64) >
+		    (ioc->internal_depth + INTERNAL_SCSIIO_CMDS_COUNT)) {
+			max_request_credit -= 64;
+			_base_release_memory_pools(ioc);
+			goto retry;
+		} else {
+			ioc_err(ioc,
+			    "scsi_lookup: get_free_pages failed, sz(%d)\n",
+			    (int)sz);
+			goto out;
+		}
+	}
+
 	dinitprintk(ioc,
 		    ioc_info(ioc, "scsiio(0x%p): depth(%d)\n",
 			     ioc->request, ioc->scsiio_depth));
+	total_sz += sz;
 
 	ioc->chain_depth = min_t(u32, ioc->chain_depth, MAX_CHAIN_DEPTH);
 	sz = ioc->scsiio_depth * sizeof(struct chain_lookup);
@@ -6239,6 +6270,14 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 
+	smid = 1;
+	for (i = 0; i < ioc->shost->can_queue; i++, smid++) {
+		ioc->scsi_lookup[i].cb_idx = 0xFF;
+		ioc->scsi_lookup[i].smid = smid;
+		ioc->scsi_lookup[i].scmd = NULL;
+		ioc->scsi_lookup[i].direct_io = 0;
+	}
+
 	/* hi-priority queue */
 	INIT_LIST_HEAD(&ioc->hpr_free_list);
 	smid = ioc->hi_priority_smid;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 19158cb..f8c82f6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -816,6 +816,7 @@ struct chain_lookup {
 /**
  * struct scsiio_tracker - scsi mf request tracker
  * @smid: system message id
+ * @scmd: scsi request pointer
  * @cb_idx: callback index
  * @direct_io: To indicate whether I/O is direct (WARPDRIVE)
  * @chain_list: list of associated firmware chain tracker
@@ -823,6 +824,7 @@ struct chain_lookup {
  */
 struct scsiio_tracker {
 	u16	smid;
+	struct scsi_cmnd *scmd;
 	u8	cb_idx;
 	u8	direct_io;
 	struct pcie_sg_list pcie_sg_list;
@@ -830,6 +832,12 @@ struct scsiio_tracker {
 	u16     msix_io;
 };
 
+static inline struct scsiio_tracker *
+mpt3sas_get_st_from_scmd(struct scsi_cmnd *scmd)
+{
+	return (struct scsiio_tracker *)scmd->host_scribble;
+}
+
 /**
  * struct request_tracker - firmware request tracker
  * @smid: system message id
@@ -1296,6 +1304,8 @@ struct MPT3SAS_ADAPTER {
 	u8		*request;
 	dma_addr_t	request_dma;
 	u32		request_dma_sz;
+	struct scsiio_tracker *scsi_lookup;
+	ulong           scsi_lookup_pages;
 	struct pcie_sg_list *pcie_sg_lookup;
 	spinlock_t	scsi_lookup_lock;
 	int		pending_io_count;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index b2bb47c..ad43e60 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -595,7 +595,7 @@ void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 			continue;
 		if (priv_data->sas_target->handle != handle)
 			continue;
-		st = scsi_cmd_priv(scmd);
+		st = mpt3sas_get_st_from_scmd(scmd);
 		tm_request->TaskMID = cpu_to_le16(st->smid);
 		found = 1;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8bb5b8f..86d0e3c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1465,11 +1465,9 @@ struct scsi_cmnd *
 
 	if (smid > 0  &&
 	    smid <= ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT) {
-		u32 unique_tag = smid - 1;
-
-		scmd = scsi_host_find_tag(ioc->shost, unique_tag);
+		scmd = ioc->scsi_lookup[smid - 1].scmd;
 		if (scmd) {
-			st = scsi_cmd_priv(scmd);
+			st = mpt3sas_get_st_from_scmd(scmd);
 			if (st->cb_idx == 0xFF || st->smid == 0)
 				scmd = NULL;
 		}
@@ -2819,7 +2817,7 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
-	struct scsiio_tracker *st = scsi_cmd_priv(scmd);
+	struct scsiio_tracker *st = mpt3sas_get_st_from_scmd(scmd);
 	u16 handle;
 	int r;
 
@@ -4466,7 +4464,7 @@ static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 			continue;
 		count++;
 		_scsih_set_satl_pending(scmd, false);
-		st = scsi_cmd_priv(scmd);
+		st = mpt3sas_get_st_from_scmd(scmd);
 		mpt3sas_base_clear_st(ioc, st);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery || ioc->remove_host)
@@ -5193,7 +5191,7 @@ static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 	 * WARPDRIVE: If direct_io is set then it is directIO,
 	 * the failed direct I/O should be redirected to volume
 	 */
-	st = scsi_cmd_priv(scmd);
+	st = mpt3sas_get_st_from_scmd(scmd);
 	if (st->direct_io &&
 	     ((ioc_status & MPI2_IOCSTATUS_MASK)
 	      != MPI2_IOCSTATUS_SCSI_TASK_TERMINATED)) {
@@ -7335,7 +7333,7 @@ static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
-		st = scsi_cmd_priv(scmd);
+		st = mpt3sas_get_st_from_scmd(scmd);
 		sdev = scmd->device;
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
@@ -10176,7 +10174,6 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
 	.track_queue_depth		= 1,
-	.cmd_size			= sizeof(struct scsiio_tracker),
 };
 
 /* raid transport support for SAS 2.0 HBA devices */
@@ -10214,7 +10211,6 @@ static void pcie_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
 	.track_queue_depth		= 1,
-	.cmd_size			= sizeof(struct scsiio_tracker),
 };
 
 /* raid transport support for SAS 3.0 HBA devices */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
index cc07ba4..2a05bf3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
@@ -259,7 +259,7 @@
 	sector_t v_lba, p_lba, stripe_off, column, io_size;
 	u32 stripe_sz, stripe_exp;
 	u8 num_pds, cmd = scmd->cmnd[0];
-	struct scsiio_tracker *st = scsi_cmd_priv(scmd);
+	struct scsiio_tracker *st = mpt3sas_get_st_from_scmd(scmd);
 
 	if (cmd != READ_10 && cmd != WRITE_10 &&
 	    cmd != READ_16 && cmd != WRITE_16)
-- 
1.8.3.1
