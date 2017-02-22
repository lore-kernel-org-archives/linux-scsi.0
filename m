From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 10/12] mpt3sas: simplify mpt3sas_scsi_issue_tm()
Date: Wed, 22 Feb 2017 11:31:50 +0100
Message-ID: <1487759512-3873-11-git-send-email-hare@suse.de>
References: <1487759512-3873-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932192AbdBVKcE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 05:32:04 -0500
In-Reply-To: <1487759512-3873-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Move the check for outstanding commands out of the function
allowing us to simplify the overall code.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 106 ++++++++++++-----------------------
 3 files changed, 41 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 74186e3..4ecc2c1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1289,11 +1289,9 @@ u8 mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 void mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase);
 
 int mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
-	uint channel, uint id, uint lun, u8 type, u16 smid_task,
-	ulong timeout);
+	u64 lun, u8 type, u16 smid_task, u16 msix_task, ulong timeout);
 int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
-	uint channel, uint id, uint lun, u8 type, u16 smid_task,
-	ulong timeout);
+	u64 lun, u8 type, u16 smid_task, u16 msix_task, ulong timeout);
 
 void mpt3sas_scsih_set_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle);
 void mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 4476bba..dd03d2c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1027,8 +1027,8 @@ enum block_state {
 				le16_to_cpu(mpi_request->FunctionDependent1));
 			mpt3sas_halt_firmware(ioc);
 			mpt3sas_scsih_issue_locked_tm(ioc,
-			    le16_to_cpu(mpi_request->FunctionDependent1), 0, 0,
-			    0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0, 30);
+			    le16_to_cpu(mpi_request->FunctionDependent1), 0,
+			    MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0, 0, 30);
 		} else
 			mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e0cb35d..f114ef7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1111,25 +1111,24 @@ struct _sas_node *
  * This will search for a scmd pointer in the scsi_lookup array,
  * returning the revelent smid.  A returned value of zero means invalid.
  */
-static u16
+struct scsiio_tracker *
 _scsih_scsi_lookup_find_by_scmd(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd
 	*scmd)
 {
-	u16 smid;
-	unsigned long	flags;
+	struct scsiio_tracker *st = NULL;
+	unsigned long flags;
 	int i;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	smid = 0;
 	for (i = 0; i < ioc->scsiio_depth; i++) {
 		if (ioc->scsi_lookup[i].scmd == scmd) {
-			smid = ioc->scsi_lookup[i].smid;
+			st = &ioc->scsi_lookup[i];
 			goto out;
 		}
 	}
  out:
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-	return smid;
+	return st;
 }
 
 /**
@@ -2136,32 +2135,30 @@ struct _sas_node *
 /**
  * mpt3sas_scsih_issue_tm - main routine for sending tm requests
  * @ioc: per adapter struct
- * @device_handle: device handle
- * @channel: the channel assigned by the OS
- * @id: the id assigned by the OS
+ * @handle: device handle
  * @lun: lun number
  * @type: MPI2_SCSITASKMGMT_TASKTYPE__XXX (defined in mpi2_init.h)
  * @smid_task: smid assigned to the task
+ * @msix_task: MSIX table index supplied by the OS
  * @timeout: timeout in seconds
  * Context: user
  *
  * A generic API for sending task management requests to firmware.
  *
  * The callback index is set inside `ioc->tm_cb_idx`.
+ * The caller is responsible to check for outstanding commands.
  *
  * Return SUCCESS or FAILED.
  */
 int
-mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
-	uint id, uint lun, u8 type, u16 smid_task, ulong timeout)
+mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
+	u64 lun, u8 type, u16 smid_task, u16 msix_task, ulong timeout)
 {
 	Mpi2SCSITaskManagementRequest_t *mpi_request;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
 	u16 smid = 0;
 	u32 ioc_state;
-	struct scsiio_tracker *scsi_lookup = NULL;
 	int rc;
-	u16 msix_task = 0;
 
 	lockdep_assert_held(&ioc->tm_cmds.mutex);
 
@@ -2193,14 +2190,6 @@ struct _sas_node *
 		return (!rc) ? SUCCESS : FAILED;
 	}
 
-	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
-		scsi_lookup = mpt3sas_get_st_from_smid(ioc, smid_task);
-		if (!scsi_lookup)
-			return FAILED;
-		if (scsi_lookup->cb_idx == 0xFF)
-			return SUCCESS;
-	}
-
 	smid = mpt3sas_base_get_smid_hpr(ioc, ioc->tm_cb_idx);
 	if (!smid) {
 		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
@@ -2223,12 +2212,6 @@ struct _sas_node *
 	int_to_scsilun(lun, (struct scsi_lun *)mpi_request->LUN);
 	mpt3sas_scsih_set_tm_flag(ioc, handle);
 	init_completion(&ioc->tm_cmds.done);
-	if ((type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK) &&
-	    scsi_lookup &&
-	    (scsi_lookup->msix_io < ioc->reply_queue_count))
-		msix_task = scsi_lookup->msix_io;
-	else
-		msix_task = 0;
 	ioc->put_smid_hi_priority(ioc, smid, msix_task);
 	wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
 	if (!(ioc->tm_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -2262,25 +2245,7 @@ struct _sas_node *
 				    sizeof(Mpi2SCSITaskManagementRequest_t)/4);
 		}
 	}
-
-	switch (type) {
-	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
-		rc = SUCCESS;
-		if (scsi_lookup && scsi_lookup->scmd == NULL)
-			break;
-		rc = FAILED;
-		break;
-
-	case MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET:
-	case MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET:
-	case MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
-	case MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK:
-		rc = SUCCESS;
-		break;
-	default:
-		rc = FAILED;
-		break;
-	}
+	rc = SUCCESS;
 
 out:
 	mpt3sas_scsih_clear_tm_flag(ioc, handle);
@@ -2289,13 +2254,13 @@ struct _sas_node *
 }
 
 int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
-	uint channel, uint id, uint lun, u8 type, u16 smid_task, ulong timeout)
+	u64 lun, u8 type, u16 smid_task, u16 msix_task, ulong timeout)
 {
 	int ret;
 
 	mutex_lock(&ioc->tm_cmds.mutex);
-	ret = mpt3sas_scsih_issue_tm(ioc, handle, channel, id, lun, type,
-			smid_task, timeout);
+	ret = mpt3sas_scsih_issue_tm(ioc, handle, lun, type, smid_task,
+			msix_task, timeout);
 	mutex_unlock(&ioc->tm_cmds.mutex);
 
 	return ret;
@@ -2376,7 +2341,7 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
-	u16 smid;
+	struct scsiio_tracker *st = NULL;
 	u16 handle;
 	int r;
 
@@ -2395,8 +2360,8 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	}
 
 	/* search for the command */
-	smid = _scsih_scsi_lookup_find_by_scmd(ioc, scmd);
-	if (!smid) {
+	st = _scsih_scsi_lookup_find_by_scmd(ioc, scmd);
+	if (!st) {
 		scmd->result = DID_RESET << 16;
 		r = SUCCESS;
 		goto out;
@@ -2414,10 +2379,12 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	mpt3sas_halt_firmware(ioc);
 
 	handle = sas_device_priv_data->sas_target->handle;
-	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
-	    scmd->device->id, scmd->device->lun,
-	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30);
-
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->lun,
+		MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
+		st->smid, st->msix_io, 30);
+	/* Command must be cleared after abort */
+	if (r == SUCCESS && st->scmd)
+		r = FAILED;
  out:
 	sdev_printk(KERN_INFO, scmd->device, "task abort: %s scmd(%p)\n",
 	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
@@ -2473,9 +2440,8 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out;
 	}
 
-	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
-	    scmd->device->id, scmd->device->lun,
-	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30);
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->lun,
+		MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 0, 30);
 	/* Check for busy commands after reset */
 	if (r == SUCCESS && atomic_read(&scmd->device->device_busy))
 		r = FAILED;
@@ -2537,9 +2503,8 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out;
 	}
 
-	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
-	    scmd->device->id, 0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
-	    30);
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, 0,
+		MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0, 0, 30);
 	/* Check for busy commands after reset */
 	if (r == SUCCESS && atomic_read(&starget->target_busy))
 		r = FAILED;
@@ -6004,6 +5969,7 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 {
 	struct scsi_cmnd *scmd;
 	struct scsi_device *sdev;
+	struct scsiio_tracker *st;
 	u16 smid, handle;
 	u32 lun;
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
@@ -6045,7 +6011,8 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
 		if (ioc->shost_recovery)
 			goto out;
-		scmd = ioc->scsi_lookup[smid - 1].scmd;
+		st = &ioc->scsi_lookup[smid - 1];
+		scmd = st->scmd;
 		if (!scmd)
 			continue;
 		sdev = scmd->device;
@@ -6069,8 +6036,9 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 			goto out;
 
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		r = mpt3sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
-		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30);
+		r = mpt3sas_scsih_issue_tm(ioc, handle, lun,
+			MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid,
+			st->msix_io, 30);
 		if (r == FAILED) {
 			sdev_printk(KERN_WARNING, sdev,
 			    "mpt3sas_scsih_issue_tm: FAILED when sending "
@@ -6109,10 +6077,10 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 		if (ioc->shost_recovery)
 			goto out_no_lock;
 
-		r = mpt3sas_scsih_issue_tm(ioc, handle, sdev->channel, sdev->id,
-		    sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid,
-		    30);
-		if (r == FAILED) {
+		r = mpt3sas_scsih_issue_tm(ioc, handle, sdev->lun,
+			MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid,
+			st->msix_io, 30);
+		if (r == FAILED || st->scmd) {
 			sdev_printk(KERN_WARNING, sdev,
 			    "mpt3sas_scsih_issue_tm: ABORT_TASK: FAILED : "
 			    "scmd(%p)\n", scmd);
-- 
1.8.5.6
