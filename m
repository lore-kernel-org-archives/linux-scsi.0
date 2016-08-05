From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: RE: [PATCH 1/3] mpt3sas: Eliminate conditional locking in mpt3sas_scsih_issue_tm()
Date: Fri, 5 Aug 2016 09:59:10 +0530
Message-ID: <6308c404782f7d295cacb55a64f1ed15@mail.gmail.com>
References: <7afa9136f4edf40e29fddf4fcfbc9694724472f2.1469766027.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7afa9136f4edf40e29fddf4fcfbc9694724472f2.1469766027.git.calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

Hi,
 Please consider this patch as Acked-by: Chaitra P B
<chaitra.basappa@broadcom.com>

Thanks,
 Chaitra

-----Original Message-----
From: Calvin Owens [mailto:calvinowens@fb.com]
Sent: Friday, July 29, 2016 10:08 AM
To: Sathya Prakash; Chaitra P B; Suganath Prabu Subramani; James E.J.
Bottomley; Martin K. Petersen
Cc: MPT-FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; kernel-team@fb.com; Calvin Owens
Subject: [PATCH 1/3] mpt3sas: Eliminate conditional locking in
mpt3sas_scsih_issue_tm()

This flag that conditionally acquires the mutex is confusing and prone to
bugginess: refactor it into two separate function calls, and make the
unlocked one complain if it's called outside the mutex.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 16 +++------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  5 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 66
+++++++++++++++++-------------------
 3 files changed, 38 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h
b/drivers/scsi/mpt3sas/mpt3sas_base.h
index eb7f5b0..f0baafd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -794,16 +794,6 @@ struct reply_post_struct {
 	dma_addr_t			reply_post_free_dma;
 };

-/**
- * enum mutex_type - task management mutex type
- * @TM_MUTEX_OFF: mutex is not required becuase calling function is
acquiring it
- * @TM_MUTEX_ON: mutex is required
- */
-enum mutex_type {
-	TM_MUTEX_OFF = 0,
-	TM_MUTEX_ON = 1,
-};
-
 typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
 /**
  * struct MPT3SAS_ADAPTER - per adapter struct @@ -1291,7 +1281,11 @@
void mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER *ioc, int
reset_phase);

 int mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	uint channel, uint id, uint lun, u8 type, u16 smid_task,
-	ulong timeout, enum mutex_type m_type);
+	ulong timeout);
+int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16
handle,
+	uint channel, uint id, uint lun, u8 type, u16 smid_task,
+	ulong timeout);
+
 void mpt3sas_scsih_set_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle);
void mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle);
void mpt3sas_expander_remove(struct MPT3SAS_ADAPTER *ioc, u64
sas_address); diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 7d00f09..75ae533 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1001,10 +1001,9 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc,
struct mpt3_ioctl_command karg,
 				ioc->name,

le16_to_cpu(mpi_request->FunctionDependent1));
 			mpt3sas_halt_firmware(ioc);
-			mpt3sas_scsih_issue_tm(ioc,
+			mpt3sas_scsih_issue_locked_tm(ioc,
 			    le16_to_cpu(mpi_request->FunctionDependent1),
0, 0,
-			    0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
30,
-			    TM_MUTEX_ON);
+			    0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
30);
 		} else
 			mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 			    FORCE_BIG_HAMMER);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index acabe48..c93a7ba 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2201,7 +2201,6 @@ mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER
*ioc, u16 handle)
  * @type: MPI2_SCSITASKMGMT_TASKTYPE__XXX (defined in mpi2_init.h)
  * @smid_task: smid assigned to the task
  * @timeout: timeout in seconds
- * @m_type: TM_MUTEX_ON or TM_MUTEX_OFF
  * Context: user
  *
  * A generic API for sending task management requests to firmware.
@@ -2212,8 +2211,7 @@ mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER
*ioc, u16 handle)
  */
 int
 mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint
channel,
-	uint id, uint lun, u8 type, u16 smid_task, ulong timeout,
-	enum mutex_type m_type)
+	uint id, uint lun, u8 type, u16 smid_task, ulong timeout)
 {
 	Mpi2SCSITaskManagementRequest_t *mpi_request;
 	Mpi2SCSITaskManagementReply_t *mpi_reply; @@ -2224,21 +2222,19 @@
mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint
channel,
 	int rc;
 	u16 msix_task = 0;

-	if (m_type == TM_MUTEX_ON)
-		mutex_lock(&ioc->tm_cmds.mutex);
+	lockdep_assert_held(&ioc->tm_cmds.mutex);
+
 	if (ioc->tm_cmds.status != MPT3_CMD_NOT_USED) {
 		pr_info(MPT3SAS_FMT "%s: tm_cmd busy!!!\n",
 		    __func__, ioc->name);
-		rc = FAILED;
-		goto err_out;
+		return FAILED;
 	}

 	if (ioc->shost_recovery || ioc->remove_host ||
 	    ioc->pci_error_recovery) {
 		pr_info(MPT3SAS_FMT "%s: host reset in progress!\n",
 		    __func__, ioc->name);
-		rc = FAILED;
-		goto err_out;
+		return FAILED;
 	}

 	ioc_state = mpt3sas_base_get_iocstate(ioc, 0); @@ -2247,8 +2243,7
@@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint
channel,
 			"unexpected doorbell active!\n", ioc->name));
 		rc = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
-		rc = (!rc) ? SUCCESS : FAILED;
-		goto err_out;
+		return (!rc) ? SUCCESS : FAILED;
 	}

 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
@@ -2256,16 +2251,14 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER
*ioc, u16 handle, uint channel,
 		    MPI2_DOORBELL_DATA_MASK);
 		rc = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
-		rc = (!rc) ? SUCCESS : FAILED;
-		goto err_out;
+		return (!rc) ? SUCCESS : FAILED;
 	}

 	smid = mpt3sas_base_get_smid_hpr(ioc, ioc->tm_cb_idx);
 	if (!smid) {
 		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
-		rc = FAILED;
-		goto err_out;
+		return FAILED;
 	}

 	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
@@ -2302,9 +2295,7 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc,
u16 handle, uint channel,
 			rc = mpt3sas_base_hard_reset_handler(ioc,
CAN_SLEEP,
 			    FORCE_BIG_HAMMER);
 			rc = (!rc) ? SUCCESS : FAILED;
-			ioc->tm_cmds.status = MPT3_CMD_NOT_USED;
-			mpt3sas_scsih_clear_tm_flag(ioc, handle);
-			goto err_out;
+			goto out;
 		}
 	}

@@ -2356,17 +2347,23 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER
*ioc, u16 handle, uint channel,
 		break;
 	}

+out:
 	mpt3sas_scsih_clear_tm_flag(ioc, handle);
 	ioc->tm_cmds.status = MPT3_CMD_NOT_USED;
-	if (m_type == TM_MUTEX_ON)
-		mutex_unlock(&ioc->tm_cmds.mutex);
-
 	return rc;
+}

- err_out:
-	if (m_type == TM_MUTEX_ON)
-		mutex_unlock(&ioc->tm_cmds.mutex);
-	return rc;
+int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16
handle,
+	uint channel, uint id, uint lun, u8 type, u16 smid_task, ulong
+timeout) {
+	int ret;
+
+	mutex_lock(&ioc->tm_cmds.mutex);
+	ret = mpt3sas_scsih_issue_tm(ioc, handle, channel, id, lun, type,
+			smid_task, timeout);
+	mutex_unlock(&ioc->tm_cmds.mutex);
+
+	return ret;
 }

 /**
@@ -2482,9 +2479,9 @@ scsih_abort(struct scsi_cmnd *scmd)
 	mpt3sas_halt_firmware(ioc);

 	handle = sas_device_priv_data->sas_target->handle;
-	r = mpt3sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle,
scmd->device->channel,
 	    scmd->device->id, scmd->device->lun,
-	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30, TM_MUTEX_ON);
+	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30);

  out:
 	sdev_printk(KERN_INFO, scmd->device, "task abort: %s scmd(%p)\n",
@@ -2541,9 +2538,9 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 		goto out;
 	}

-	r = mpt3sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle,
scmd->device->channel,
 	    scmd->device->id, scmd->device->lun,
-	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30,
TM_MUTEX_ON);
+	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30);

  out:
 	sdev_printk(KERN_INFO, scmd->device, "device reset: %s
scmd(%p)\n", @@ -2603,9 +2600,9 @@ scsih_target_reset(struct scsi_cmnd
*scmd)
 		goto out;
 	}

-	r = mpt3sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle,
scmd->device->channel,
 	    scmd->device->id, 0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
0,
-	    30, TM_MUTEX_ON);
+	    30);

  out:
 	starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
@@ -6089,8 +6086,7 @@ _scsih_sas_broadcast_primitive_event(struct
MPT3SAS_ADAPTER *ioc,

 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 		r = mpt3sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
-		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30,
-		    TM_MUTEX_OFF);
+		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30);
 		if (r == FAILED) {
 			sdev_printk(KERN_WARNING, sdev,
 			    "mpt3sas_scsih_issue_tm: FAILED when sending "
@@ -6130,8 +6126,8 @@ _scsih_sas_broadcast_primitive_event(struct
MPT3SAS_ADAPTER *ioc,
 			goto out_no_lock;

 		r = mpt3sas_scsih_issue_tm(ioc, handle, sdev->channel,
sdev->id,
-		    sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
smid, 30,
-		    TM_MUTEX_OFF);
+		    sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
smid,
+		    30);
 		if (r == FAILED) {
 			sdev_printk(KERN_WARNING, sdev,
 			    "mpt3sas_scsih_issue_tm: ABORT_TASK: FAILED :
"
--
2.8.0.rc2
