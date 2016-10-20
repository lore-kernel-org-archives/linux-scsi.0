From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 03/10] mpt3sas: Implement device_remove_in_progress check in  IOCTL path
Date: Thu, 20 Oct 2016 17:50:11 +0530
Message-ID: <1476966018-10457-4-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Sathya Prakash <sathya.prakash@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

When device missing event arrives, device_remove_in_progress bit will be
set and hence driver has to stop sending IOCTL commands.Now the check has
been added in IOCTL path to test device_remove_in_progress bit is set, if
so then IOCTL will be failed printing failure message.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 19 +++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  5 ++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 46 ++++++++++++++++++++++++++++++------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 24 ++++++++++++++++++-
 4 files changed, 86 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 4ea81e1..9ad7f7c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5334,6 +5334,21 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		goto out_free_resources;
 	}
 
+	/* allocate memory for pending OS device add list */
+	ioc->pend_os_device_add_sz = (ioc->facts.MaxDevHandle / 8);
+	if (ioc->facts.MaxDevHandle % 8)
+		ioc->pend_os_device_add_sz++;
+	ioc->pend_os_device_add = kzalloc(ioc->pend_os_device_add_sz,
+	    GFP_KERNEL);
+	if (!ioc->pend_os_device_add)
+		goto out_free_resources;
+
+	ioc->device_remove_in_progress_sz = ioc->pend_os_device_add_sz;
+	ioc->device_remove_in_progress =
+		kzalloc(ioc->device_remove_in_progress_sz, GFP_KERNEL);
+	if (!ioc->device_remove_in_progress)
+		goto out_free_resources;
+
 	ioc->fwfault_debug = mpt3sas_fwfault_debug;
 
 	/* base internal command bits */
@@ -5416,6 +5431,8 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		kfree(ioc->reply_post_host_index);
 	kfree(ioc->pd_handles);
 	kfree(ioc->blocking_handles);
+	kfree(ioc->device_remove_in_progress);
+	kfree(ioc->pend_os_device_add);
 	kfree(ioc->tm_cmds.reply);
 	kfree(ioc->transport_cmds.reply);
 	kfree(ioc->scsih_cmds.reply);
@@ -5457,6 +5474,8 @@ mpt3sas_base_detach(struct MPT3SAS_ADAPTER *ioc)
 		kfree(ioc->reply_post_host_index);
 	kfree(ioc->pd_handles);
 	kfree(ioc->blocking_handles);
+	kfree(ioc->device_remove_in_progress);
+	kfree(ioc->pend_os_device_add);
 	kfree(ioc->pfacts);
 	kfree(ioc->ctl_cmds.reply);
 	kfree(ioc->ctl_cmds.sense);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 3e71bc1..4221a4d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1079,6 +1079,9 @@ struct MPT3SAS_ADAPTER {
 	void		*pd_handles;
 	u16		pd_handles_sz;
 
+	void		*pend_os_device_add;
+	u16		pend_os_device_add_sz;
+
 	/* config page */
 	u16		config_page_sz;
 	void		*config_page;
@@ -1187,6 +1190,8 @@ struct MPT3SAS_ADAPTER {
 	struct SL_WH_EVENT_TRIGGERS_T diag_trigger_event;
 	struct SL_WH_SCSI_TRIGGERS_T diag_trigger_scsi;
 	struct SL_WH_MPI_TRIGGERS_T diag_trigger_mpi;
+	void		*device_remove_in_progress;
+	u16		device_remove_in_progress_sz;
 };
 
 typedef u8 (*MPT_CALLBACK)(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 26cdc12..f204ce1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -654,6 +654,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	size_t data_in_sz = 0;
 	long ret;
 	u16 wait_state_count;
+	u16 device_handle = MPT3SAS_INVALID_DEVICE_HANDLE;
 
 	issue_reset = 0;
 
@@ -738,10 +739,13 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	data_in_sz = karg.data_in_size;
 
 	if (mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST ||
-	    mpi_request->Function == MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH) {
-		if (!le16_to_cpu(mpi_request->FunctionDependent1) ||
-		    le16_to_cpu(mpi_request->FunctionDependent1) >
-		    ioc->facts.MaxDevHandle) {
+	    mpi_request->Function == MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH ||
+	    mpi_request->Function == MPI2_FUNCTION_SCSI_TASK_MGMT ||
+	    mpi_request->Function == MPI2_FUNCTION_SATA_PASSTHROUGH) {
+
+		device_handle = le16_to_cpu(mpi_request->FunctionDependent1);
+		if (!device_handle || (device_handle >
+		    ioc->facts.MaxDevHandle)) {
 			ret = -EINVAL;
 			mpt3sas_base_free_smid(ioc, smid);
 			goto out;
@@ -799,10 +803,16 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		memset(ioc->ctl_cmds.sense, 0, SCSI_SENSE_BUFFERSIZE);
 		ioc->build_sg(ioc, psge, data_out_dma, data_out_sz,
 		    data_in_dma, data_in_sz);
-
+		if (test_bit(device_handle, ioc->device_remove_in_progress)) {
+			dtmprintk(ioc, pr_info(MPT3SAS_FMT
+				"handle(0x%04x) :ioctl failed due to device removal in progress\n",
+				ioc->name, device_handle));
+			mpt3sas_base_free_smid(ioc, smid);
+			ret = -EINVAL;
+			goto out;
+		}
 		if (mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)
-			mpt3sas_base_put_smid_scsi_io(ioc, smid,
-			    le16_to_cpu(mpi_request->FunctionDependent1));
+			mpt3sas_base_put_smid_scsi_io(ioc, smid, device_handle);
 		else
 			mpt3sas_base_put_smid_default(ioc, smid);
 		break;
@@ -827,6 +837,14 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			}
 		}
 
+		if (test_bit(device_handle, ioc->device_remove_in_progress)) {
+			dtmprintk(ioc, pr_info(MPT3SAS_FMT
+				"handle(0x%04x) :ioctl failed due to device removal in progress\n",
+				ioc->name, device_handle));
+			mpt3sas_base_free_smid(ioc, smid);
+			ret = -EINVAL;
+			goto out;
+		}
 		mpt3sas_scsih_set_tm_flag(ioc, le16_to_cpu(
 		    tm_request->DevHandle));
 		ioc->build_sg_mpi(ioc, psge, data_out_dma, data_out_sz,
@@ -866,6 +884,20 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		break;
 	}
 	case MPI2_FUNCTION_SATA_PASSTHROUGH:
+	{
+		ioc->build_sg(ioc, psge, data_out_dma, data_out_sz, data_in_dma,
+		    data_in_sz);
+		if (test_bit(device_handle, ioc->device_remove_in_progress)) {
+			dtmprintk(ioc, pr_info(MPT3SAS_FMT
+				"handle(0x%04x) :ioctl failed due to device removal in progress\n",
+				ioc->name, device_handle));
+			mpt3sas_base_free_smid(ioc, smid);
+			ret = -EINVAL;
+			goto out;
+		}
+		mpt3sas_base_put_smid_default(ioc, smid);
+		break;
+	}
 	case MPI2_FUNCTION_FW_DOWNLOAD:
 	case MPI2_FUNCTION_FW_UPLOAD:
 	{
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 282ca40..9584d6b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -788,6 +788,11 @@ _scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
 	list_add_tail(&sas_device->list, &ioc->sas_device_list);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
+	if (ioc->hide_drives) {
+		clear_bit(sas_device->handle, ioc->pend_os_device_add);
+		return;
+	}
+
 	if (!mpt3sas_transport_port_add(ioc, sas_device->handle,
 	     sas_device->sas_address_parent)) {
 		_scsih_sas_device_remove(ioc, sas_device);
@@ -803,7 +808,8 @@ _scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
 			    sas_device->sas_address_parent);
 			_scsih_sas_device_remove(ioc, sas_device);
 		}
-	}
+	} else
+		clear_bit(sas_device->handle, ioc->pend_os_device_add);
 }
 
 /**
@@ -3138,6 +3144,8 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	if (test_bit(handle, ioc->pd_handles))
 		return;
 
+	clear_bit(handle, ioc->pend_os_device_add);
+
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = __mpt3sas_get_sdev_by_handle(ioc, handle);
 	if (sas_device && sas_device->starget &&
@@ -3192,6 +3200,7 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
 	mpi_request->DevHandle = cpu_to_le16(handle);
 	mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
+	set_bit(handle, ioc->device_remove_in_progress);
 	mpt3sas_base_put_smid_hi_priority(ioc, smid, 0);
 	mpt3sas_trigger_master(ioc, MASTER_TRIGGER_DEVICE_REMOVAL);
 
@@ -3326,6 +3335,11 @@ _scsih_sas_control_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 		ioc->name, le16_to_cpu(mpi_reply->DevHandle), smid,
 		le16_to_cpu(mpi_reply->IOCStatus),
 		le32_to_cpu(mpi_reply->IOCLogInfo)));
+		if (le16_to_cpu(mpi_reply->IOCStatus) ==
+		     MPI2_IOCSTATUS_SUCCESS) {
+			clear_bit(le16_to_cpu(mpi_reply->DevHandle),
+			    ioc->device_remove_in_progress);
+		}
 	} else {
 		pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -5449,6 +5463,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
 	if (!(_scsih_is_end_device(device_info)))
 		return -1;
+	set_bit(handle, ioc->pend_os_device_add);
 	sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
 
 	/* check if device is present */
@@ -5467,6 +5482,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	sas_device = mpt3sas_get_sdev_by_addr(ioc,
 					sas_address);
 	if (sas_device) {
+		clear_bit(handle, ioc->pend_os_device_add);
 		sas_device_put(sas_device);
 		return -1;
 	}
@@ -5790,6 +5806,9 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 			_scsih_check_device(ioc, sas_address, handle,
 			    phy_number, link_rate);
 
+			if (!test_bit(handle, ioc->pend_os_device_add))
+				break;
+
 
 		case MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED:
 
@@ -7707,6 +7726,9 @@ mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase)
 			complete(&ioc->tm_cmds.done);
 		}
 
+		memset(ioc->pend_os_device_add, 0, ioc->pend_os_device_add_sz);
+		memset(ioc->device_remove_in_progress, 0,
+		       ioc->device_remove_in_progress_sz);
 		_scsih_fw_event_cleanup_queue(ioc);
 		_scsih_flush_running_cmds(ioc);
 		break;
-- 
1.8.3.1
