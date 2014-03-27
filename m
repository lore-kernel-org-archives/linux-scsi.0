From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 1/7] mpt3sas: Remove uses of serial_number
Date: Thu, 27 Mar 2014 16:40:30 -0400
Message-ID: <d338e3c08ab5826774d4dc038faa9a3b99347ea9.1395952569.git.matthew.r.wilcox@intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52229 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370AbaC0Ukr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2014 16:40:47 -0400
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com

The mpt3sas_scsih_issue_tm() function does not use the 'serial_number'
argument passed to it.  Removing it removes the last vestiges of the
scsi_cmnd's serial_number field from this driver.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 ++++++---------
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 0ebf5d9..9b90a6f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -993,7 +993,7 @@ void mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase);
 
 int mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	uint channel, uint id, uint lun, u8 type, u16 smid_task,
-	ulong timeout, unsigned long serial_number,  enum mutex_type m_type);
+	ulong timeout, enum mutex_type m_type);
 void mpt3sas_scsih_set_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle);
 void mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle);
 void mpt3sas_expander_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 9b89de1..ba9cbe5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -980,7 +980,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			mpt3sas_scsih_issue_tm(ioc,
 			    le16_to_cpu(mpi_request->FunctionDependent1), 0, 0,
 			    0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0, 30,
-			    0, TM_MUTEX_ON);
+			    TM_MUTEX_ON);
 		} else
 			mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 			    FORCE_BIG_HAMMER);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a961fe1..952f6e0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2029,7 +2029,6 @@ mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle)
  * @type: MPI2_SCSITASKMGMT_TASKTYPE__XXX (defined in mpi2_init.h)
  * @smid_task: smid assigned to the task
  * @timeout: timeout in seconds
- * @serial_number: the serial_number from scmd
  * @m_type: TM_MUTEX_ON or TM_MUTEX_OFF
  * Context: user
  *
@@ -2042,7 +2041,7 @@ mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 int
 mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 	uint id, uint lun, u8 type, u16 smid_task, ulong timeout,
-	unsigned long serial_number, enum mutex_type m_type)
+	enum mutex_type m_type)
 {
 	Mpi2SCSITaskManagementRequest_t *mpi_request;
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
@@ -2293,8 +2292,7 @@ _scsih_abort(struct scsi_cmnd *scmd)
 	handle = sas_device_priv_data->sas_target->handle;
 	r = mpt3sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, scmd->device->lun,
-	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30,
-	    scmd->serial_number, TM_MUTEX_ON);
+	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30, TM_MUTEX_ON);
 
  out:
 	sdev_printk(KERN_INFO, scmd->device, "task abort: %s scmd(%p)\n",
@@ -2353,8 +2351,7 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
 
 	r = mpt3sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, scmd->device->lun,
-	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30, 0,
-	    TM_MUTEX_ON);
+	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30, TM_MUTEX_ON);
 
  out:
 	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
@@ -2414,7 +2411,7 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
 
 	r = mpt3sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
 	    scmd->device->id, 0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
-	    30, 0, TM_MUTEX_ON);
+	    30, TM_MUTEX_ON);
 
  out:
 	starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
@@ -5425,7 +5422,7 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 		r = mpt3sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
-		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30, 0,
+		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30,
 		    TM_MUTEX_OFF);
 		if (r == FAILED) {
 			sdev_printk(KERN_WARNING, sdev,
@@ -5467,7 +5464,7 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 
 		r = mpt3sas_scsih_issue_tm(ioc, handle, sdev->channel, sdev->id,
 		    sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30,
-		    scmd->serial_number, TM_MUTEX_OFF);
+		    TM_MUTEX_OFF);
 		if (r == FAILED) {
 			sdev_printk(KERN_WARNING, sdev,
 			    "mpt3sas_scsih_issue_tm: ABORT_TASK: FAILED : "
-- 
1.9.0

