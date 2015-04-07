From: Jens Axboe <axboe@fb.com>
Subject: [PATCH 5/6] mpt3sas: get rid of MPI2_FUNCTION_SCSI_TASK_MGMT
Date: Tue, 7 Apr 2015 11:18:39 -0600
Message-ID: <1428427120-20971-6-git-send-email-axboe@fb.com>
References: <1428427120-20971-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428427120-20971-1-git-send-email-axboe@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

This involves a lot of nasty lookup of a specific running command,
across the host. If anybody is using this code, it should be moved
to proper error handling instead.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 130 +++----------------------------------
 1 file changed, 10 insertions(+), 120 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 080c8a76d23d..2cdcff321d7b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -524,85 +524,6 @@ _ctl_poll(struct file *filep, poll_table *wait)
 }
 
 /**
- * _ctl_set_task_mid - assign an active smid to tm request
- * @ioc: per adapter object
- * @karg - (struct mpt3_ioctl_command)
- * @tm_request - pointer to mf from user space
- *
- * Returns 0 when an smid if found, else fail.
- * during failure, the reply frame is filled.
- */
-static int
-_ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command *karg,
-	Mpi2SCSITaskManagementRequest_t *tm_request)
-{
-	u8 found = 0;
-	u16 i;
-	u16 handle;
-	struct scsi_cmnd *scmd;
-	struct MPT3SAS_DEVICE *priv_data;
-	unsigned long flags;
-	Mpi2SCSITaskManagementReply_t *tm_reply;
-	u32 sz;
-	u32 lun;
-	char *desc = NULL;
-
-	if (tm_request->TaskType == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
-		desc = "abort_task";
-	else if (tm_request->TaskType == MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK)
-		desc = "query_task";
-	else
-		return 0;
-
-	lun = scsilun_to_int((struct scsi_lun *)tm_request->LUN);
-
-	handle = le16_to_cpu(tm_request->DevHandle);
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
-
-	if (!found) {
-		dctlprintk(ioc, pr_info(MPT3SAS_FMT
-			"%s: handle(0x%04x), lun(%d), no active mid!!\n",
-			ioc->name,
-		    desc, le16_to_cpu(tm_request->DevHandle), lun));
-		tm_reply = ioc->ctl_cmds.reply;
-		tm_reply->DevHandle = tm_request->DevHandle;
-		tm_reply->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
-		tm_reply->TaskType = tm_request->TaskType;
-		tm_reply->MsgLength = sizeof(Mpi2SCSITaskManagementReply_t)/4;
-		tm_reply->VP_ID = tm_request->VP_ID;
-		tm_reply->VF_ID = tm_request->VF_ID;
-		sz = min_t(u32, karg->max_reply_bytes, ioc->reply_sz);
-		if (copy_to_user(karg->reply_frame_buf_ptr, ioc->ctl_cmds.reply,
-		    sz))
-			pr_err("failure at %s:%d/%s()!\n", __FILE__,
-			    __LINE__, __func__);
-		return 1;
-	}
-
-	dctlprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: handle(0x%04x), lun(%d), task_mid(%d)\n", ioc->name,
-	    desc, le16_to_cpu(tm_request->DevHandle), lun,
-	     le16_to_cpu(tm_request->TaskMID)));
-	return 0;
-}
-
-/**
  * _ctl_do_mpt_command - main handler for MPT3COMMAND opcode
  * @ioc: per adapter object
  * @karg - (struct mpt3_ioctl_command)
@@ -685,22 +606,18 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	}
 
 	if (mpi_request->Function == MPI2_FUNCTION_SCSI_TASK_MGMT) {
-		smid = mpt3sas_base_get_smid_hpr(ioc, ioc->ctl_cb_idx);
-		if (!smid) {
-			pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-			    ioc->name, __func__);
-			ret = -EAGAIN;
-			goto out;
-		}
-	} else {
+		printk(MPT3SAS_FMT "%s: ignoring "
+			"MPI2_FUNCTION_SCSI_TASK_MGMT\n", ioc->name, __func__);
+		ret = -EINVAL;
+		goto out;
+	}
 
-		smid = mpt3sas_base_get_smid_scsiio(ioc, ioc->ctl_cb_idx, NULL);
-		if (!smid) {
-			pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
+	smid = mpt3sas_base_get_smid_hpr(ioc, ioc->ctl_cb_idx);
+	if (!smid) {
+		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
 			    ioc->name, __func__);
-			ret = -EAGAIN;
-			goto out;
-		}
+		ret = -EAGAIN;
+		goto out;
 	}
 
 	ret = 0;
@@ -784,33 +701,6 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			mpt3sas_base_put_smid_default(ioc, smid);
 		break;
 	}
-	case MPI2_FUNCTION_SCSI_TASK_MGMT:
-	{
-		Mpi2SCSITaskManagementRequest_t *tm_request =
-		    (Mpi2SCSITaskManagementRequest_t *)request;
-
-		dtmprintk(ioc, pr_info(MPT3SAS_FMT
-			"TASK_MGMT: handle(0x%04x), task_type(0x%02x)\n",
-			ioc->name,
-		    le16_to_cpu(tm_request->DevHandle), tm_request->TaskType));
-
-		if (tm_request->TaskType ==
-		    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK ||
-		    tm_request->TaskType ==
-		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK) {
-			if (_ctl_set_task_mid(ioc, &karg, tm_request)) {
-				mpt3sas_base_free_smid(ioc, smid);
-				goto out;
-			}
-		}
-
-		mpt3sas_scsih_set_tm_flag(ioc, le16_to_cpu(
-		    tm_request->DevHandle));
-		ioc->build_sg_mpi(ioc, psge, data_out_dma, data_out_sz,
-		    data_in_dma, data_in_sz);
-		mpt3sas_base_put_smid_hi_priority(ioc, smid);
-		break;
-	}
 	case MPI2_FUNCTION_SMP_PASSTHROUGH:
 	{
 		Mpi2SmpPassthroughRequest_t *smp_request =
-- 
1.9.1
