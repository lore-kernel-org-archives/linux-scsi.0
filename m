From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 3/7] mpt2sas: Remove uses of serial_number
Date: Thu, 27 Mar 2014 16:40:32 -0400
Message-ID: <d2179d139bce2da3d26a8787c35e26045f2efac9.1395952569.git.matthew.r.wilcox@intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52229 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372AbaC0Uks (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2014 16:40:48 -0400
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com

The mpt2sas_scsih_issue_tm() function does not use the 'serial_number'
argument passed to it.  Removing it removes the last vestiges of the
scsi_cmnd's serial_number field from this driver.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.h  |  2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c   |  2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 15 ++++++---------
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 1f2ac3a..fd3b998 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -1065,7 +1065,7 @@ void mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
     u32 reply);
 int mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 	uint channel, uint id, uint lun, u8 type, u16 smid_task,
-	ulong timeout, unsigned long serial_number, enum mutex_type m_type);
+	ulong timeout, enum mutex_type m_type);
 void mpt2sas_scsih_set_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle);
 void mpt2sas_scsih_clear_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle);
 void mpt2sas_expander_remove(struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index b7f887c..62df8f9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -987,7 +987,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command karg,
 			mpt2sas_scsih_issue_tm(ioc,
 			    le16_to_cpu(mpi_request->FunctionDependent1), 0, 0,
 			    0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0, 10,
-			    0, TM_MUTEX_ON);
+			    TM_MUTEX_ON);
 			ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 		} else
 			mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 7f0af4f..33586a3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2368,7 +2368,6 @@ mpt2sas_scsih_clear_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle)
  * @type: MPI2_SCSITASKMGMT_TASKTYPE__XXX (defined in mpi2_init.h)
  * @smid_task: smid assigned to the task
  * @timeout: timeout in seconds
- * @serial_number: the serial_number from scmd
  * @m_type: TM_MUTEX_ON or TM_MUTEX_OFF
  * Context: user
  *
@@ -2381,7 +2380,7 @@ mpt2sas_scsih_clear_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 int
 mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
     uint id, uint lun, u8 type, u16 smid_task, ulong timeout,
-	unsigned long serial_number, enum mutex_type m_type)
+	enum mutex_type m_type)
 {
 	Mpi2SCSITaskManagementRequest_t *mpi_request;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
@@ -2634,8 +2633,7 @@ _scsih_abort(struct scsi_cmnd *scmd)
 	handle = sas_device_priv_data->sas_target->handle;
 	r = mpt2sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, scmd->device->lun,
-	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30,
-	    scmd->serial_number, TM_MUTEX_ON);
+	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30, TM_MUTEX_ON);
 
  out:
 	sdev_printk(KERN_INFO, scmd->device, "task abort: %s scmd(%p)\n",
@@ -2696,8 +2694,7 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
 
 	r = mpt2sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, scmd->device->lun,
-	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30, 0,
-	    TM_MUTEX_ON);
+	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30, TM_MUTEX_ON);
 
  out:
 	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
@@ -2757,7 +2754,7 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
 
 	r = mpt2sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, 0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
-	    30, 0, TM_MUTEX_ON);
+	    30, TM_MUTEX_ON);
 
  out:
 	starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
@@ -5880,7 +5877,7 @@ broadcast_aen_retry:
 
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 		r = mpt2sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
-		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30, 0,
+		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30,
 		    TM_MUTEX_OFF);
 		if (r == FAILED) {
 			sdev_printk(KERN_WARNING, sdev,
@@ -5922,7 +5919,7 @@ broadcast_aen_retry:
 
 		r = mpt2sas_scsih_issue_tm(ioc, handle, sdev->channel, sdev->id,
 		    sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30,
-		    scmd->serial_number, TM_MUTEX_OFF);
+		    TM_MUTEX_OFF);
 		if (r == FAILED) {
 			sdev_printk(KERN_WARNING, sdev,
 			    "mpt2sas_scsih_issue_tm: ABORT_TASK: FAILED : "
-- 
1.9.0

