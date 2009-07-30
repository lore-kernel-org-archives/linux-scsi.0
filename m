From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/6]  mpt2sas: Power cycling cascaded expanders causes kernel panic
Date: Thu, 30 Jul 2009 18:21:35 +0530
Message-ID: <20090730125127.GB20582@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:52294 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZG3NMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2009 09:12:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Code cleanup of the host reset handling of the driver, and fix host plug work thread deadlocks, and kernel panics.

Summary of the changes:

(1) removed ioc->ioc_reset_in_progress flag, replaced with ioc->shost_recovery.
(2) removed the spin lock around reading ioc->shost_recovery.
(3) removed changing shost state during host reset handling; such as SHOST_RECOVERY 
(4) moved rescanning the devices, updating handles, and deleting not responding devices to the same contents at the host reset handling.
(5) return SCSI_MLQUEUE_DEVICE_BUSY from _qcmd when sas_target_priv_data->tm_busy is set
(6) set SDEV_RUNNING from contents of the interrupt, instead of work threads
(7) when there is a failure during _scsih_expander_add, need to call mpt2sas_transport_port_remove to properly tear down the port.

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index f3da592..f0ffbf6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -94,7 +94,7 @@ _base_fault_reset_work(struct work_struct *work)
 	int rc;
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	if (ioc->ioc_reset_in_progress)
+	if (ioc->shost_recovery)
 		goto rearm_timer;
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
@@ -3465,20 +3465,13 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	    __func__));
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	if (ioc->ioc_reset_in_progress) {
+	if (ioc->shost_recovery) {
 		spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 		printk(MPT2SAS_ERR_FMT "%s: busy\n",
 		    ioc->name, __func__);
 		return -EBUSY;
 	}
-	ioc->ioc_reset_in_progress = 1;
 	ioc->shost_recovery = 1;
-	if (ioc->shost->shost_state == SHOST_RUNNING) {
-		/* set back to SHOST_RUNNING in mpt2sas_scsih.c */
-		scsi_host_set_state(ioc->shost, SHOST_RECOVERY);
-		printk(MPT2SAS_INFO_FMT "putting controller into "
-		    "SHOST_RECOVERY\n", ioc->name);
-	}
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 	_base_reset_handler(ioc, MPT2_IOC_PRE_RESET);
@@ -3493,12 +3486,16 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 		    sleep_flag);
 	if (!r)
 		_base_reset_handler(ioc, MPT2_IOC_DONE_RESET);
+
  out:
 	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: %s\n",
 	    ioc->name, __func__, ((r == 0) ? "SUCCESS" : "FAILED")));
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	ioc->ioc_reset_in_progress = 0;
+	ioc->shost_recovery = 0;
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+
+	if (!r)
+		_base_reset_handler(ioc, MPT2_IOC_RUNNING);
 	return r;
 }
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 286c185..51962bd 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -119,6 +119,7 @@
 #define MPT2_IOC_PRE_RESET		1 /* prior to host reset */
 #define MPT2_IOC_AFTER_RESET		2 /* just after host reset */
 #define MPT2_IOC_DONE_RESET		3 /* links re-initialized */
+#define MPT2_IOC_RUNNING		4 /* shost running */
 
 /*
  * logging format
@@ -431,7 +432,7 @@ typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
  * @fw_event_list: list of fw events
  * @aen_event_read_flag: event log was read
  * @broadcast_aen_busy: broadcast aen waiting to be serviced
- * @ioc_reset_in_progress: host reset in progress
+ * @shost_recovery: host reset in progress
  * @ioc_reset_in_progress_lock:
  * @ioc_link_reset_in_progress: phy/hard reset in progress
  * @ignore_loginfos: ignore loginfos during task managment
@@ -544,7 +545,6 @@ struct MPT2SAS_ADAPTER {
 	 /* misc flags */
 	int		aen_event_read_flag;
 	u8		broadcast_aen_busy;
-	u8		ioc_reset_in_progress;
 	u8		shost_recovery;
 	spinlock_t 	ioc_reset_in_progress_lock;
 	u8		ioc_link_reset_in_progress;
@@ -796,7 +796,7 @@ int mpt2sas_transport_add_host_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
     *mpt2sas_phy, Mpi2SasPhyPage0_t phy_pg0, struct device *parent_dev);
 int mpt2sas_transport_add_expander_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
     *mpt2sas_phy, Mpi2ExpanderPage1_t expander_pg1, struct device *parent_dev);
-void mpt2sas_transport_update_phy_link_change(struct MPT2SAS_ADAPTER *ioc, u16 handle,
+void mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc, u16 handle,
    u16 attached_handle, u8 phy_number, u8 link_rate);
 extern struct sas_function_template mpt2sas_transport_functions;
 extern struct scsi_transport_template *mpt2sas_transport_template;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 58cfb97..3a03fec 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -236,7 +236,6 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	Mpi2ConfigRequest_t *config_request;
 	int r;
 	u8 retry_count;
-	u8 issue_reset;
 	u16 wait_state_count;
 
 	if (ioc->config_cmds.status != MPT2_CMD_NOT_USED) {
@@ -247,6 +246,12 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	retry_count = 0;
 
  retry_config:
+	if (retry_count) {
+		if (retry_count > 2) /* attempt only 2 retries */
+			return -EFAULT;
+		printk(MPT2SAS_INFO_FMT "%s: attempting retry (%d)\n",
+		    ioc->name, __func__, retry_count);
+	}
 	wait_state_count = 0;
 	ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
@@ -292,31 +297,23 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		    ioc->name, __func__);
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2ConfigRequest_t)/4);
-		if (!(ioc->config_cmds.status & MPT2_CMD_RESET))
-			issue_reset = 1;
-		goto issue_host_reset;
+		retry_count++;
+		if ((ioc->shost_recovery) ||
+		    (ioc->config_cmds.status & MPT2_CMD_RESET))
+			goto retry_config;
+		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+		    FORCE_BIG_HAMMER);
+		goto retry_config;
 	}
+
 	if (ioc->config_cmds.status & MPT2_CMD_REPLY_VALID)
 		memcpy(mpi_reply, ioc->config_cmds.reply,
 		    sizeof(Mpi2ConfigReply_t));
 	if (retry_count)
-		printk(MPT2SAS_INFO_FMT "%s: retry completed!!\n",
-		    ioc->name, __func__);
+		printk(MPT2SAS_INFO_FMT "%s: retry (%d) completed!!\n",
+		    ioc->name, __func__, retry_count);
 	ioc->config_cmds.status = MPT2_CMD_NOT_USED;
 	return r;
-
- issue_host_reset:
-	if (issue_reset)
-		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
-		    FORCE_BIG_HAMMER);
-	ioc->config_cmds.status = MPT2_CMD_NOT_USED;
-	if (!retry_count) {
-		printk(MPT2SAS_INFO_FMT "%s: attempting retry\n",
-		    ioc->name, __func__);
-		retry_count++;
-		goto retry_config;
-	}
-	return -EFAULT;
 }
 
 /**
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 14e473d..c2a5101 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -1963,7 +1963,6 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg)
 {
 	enum block_state state;
 	long ret = -EINVAL;
-	unsigned long flags;
 
 	state = (file->f_flags & O_NONBLOCK) ? NON_BLOCKING :
 	    BLOCKING;
@@ -1989,13 +1988,8 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg)
 		    !ioc)
 			return -ENODEV;
 
-		spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-		if (ioc->shost_recovery) {
-			spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock,
-			    flags);
+		if (ioc->shost_recovery)
 			return -EAGAIN;
-		}
-		spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 		if (_IOC_SIZE(cmd) == sizeof(struct mpt2_ioctl_command)) {
 			uarg = arg;
@@ -2098,7 +2092,6 @@ _ctl_compat_mpt_command(struct file *file, unsigned cmd, unsigned long arg)
 	struct mpt2_ioctl_command karg;
 	struct MPT2SAS_ADAPTER *ioc;
 	enum block_state state;
-	unsigned long flags;
 
 	if (_IOC_SIZE(cmd) != sizeof(struct mpt2_ioctl_command32))
 		return -EINVAL;
@@ -2113,13 +2106,8 @@ _ctl_compat_mpt_command(struct file *file, unsigned cmd, unsigned long arg)
 	if (_ctl_verify_adapter(karg32.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	if (ioc->shost_recovery) {
-		spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock,
-		    flags);
+	if (ioc->shost_recovery)
 		return -EAGAIN;
-	}
-	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 	memset(&karg, 0, sizeof(struct mpt2_ioctl_command));
 	karg.hdr.ioc_number = karg32.hdr.ioc_number;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
diff --git a/drivers/scsi/mpt2sas/mpt2sas_debug.h b/drivers/scsi/mpt2sas/mpt2sas_debug.h
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 2a01a5f..92a90b8 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -103,7 +103,6 @@ struct sense_info {
 };
 
 
-#define MPT2SAS_RESCAN_AFTER_HOST_RESET (0xFFFF)
 /**
  * struct fw_event_work - firmware event struct
  * @list: link list framework
@@ -1786,17 +1785,18 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint lun,
 	u32 ioc_state;
 	unsigned long timeleft;
 	u8 VF_ID = 0;
-	unsigned long flags;
 
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	if (ioc->tm_cmds.status != MPT2_CMD_NOT_USED ||
-	    ioc->shost_recovery) {
-		spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+	if (ioc->tm_cmds.status != MPT2_CMD_NOT_USED) {
+		printk(MPT2SAS_INFO_FMT "%s: tm_cmd busy!!!\n",
+		    __func__, ioc->name);
+		return;
+	}
+
+	if (ioc->shost_recovery) {
 		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
 		    __func__, ioc->name);
 		return;
 	}
-	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 	ioc_state = mpt2sas_base_get_iocstate(ioc, 0);
 	if (ioc_state & MPI2_DOORBELL_USED) {
@@ -2327,6 +2327,7 @@ _scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
 	u16 handle;
 	u16 reason_code;
 	u8 phy_number;
+	u8 link_rate;
 
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
@@ -2337,6 +2338,11 @@ _scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
 		    MPI2_EVENT_SAS_TOPO_RC_MASK;
 		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING)
 			_scsih_block_io_device(ioc, handle);
+		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED) {
+			link_rate = event_data->PHY[i].LinkRate >> 4;
+			if (link_rate >= MPI2_SAS_NEG_LINK_RATE_1_5)
+				_scsih_ublock_io_device(ioc, handle);
+		}
 	}
 }
 
@@ -2405,27 +2411,6 @@ _scsih_check_topo_delete_events(struct MPT2SAS_ADAPTER *ioc,
 }
 
 /**
- * _scsih_queue_rescan - queue a topology rescan from user context
- * @ioc: per adapter object
- *
- * Return nothing.
- */
-static void
-_scsih_queue_rescan(struct MPT2SAS_ADAPTER *ioc)
-{
-	struct fw_event_work *fw_event;
-
-	if (ioc->wait_for_port_enable_to_complete)
-		return;
-	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
-	if (!fw_event)
-		return;
-	fw_event->event = MPT2SAS_RESCAN_AFTER_HOST_RESET;
-	fw_event->ioc = ioc;
-	_scsih_fw_event_add(ioc, fw_event);
-}
-
-/**
  * _scsih_flush_running_cmds - completing outstanding commands.
  * @ioc: per adapter object
  *
@@ -2456,46 +2441,6 @@ _scsih_flush_running_cmds(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
- * mpt2sas_scsih_reset_handler - reset callback handler (for scsih)
- * @ioc: per adapter object
- * @reset_phase: phase
- *
- * The handler for doing any required cleanup or initialization.
- *
- * The reset phase can be MPT2_IOC_PRE_RESET, MPT2_IOC_AFTER_RESET,
- * MPT2_IOC_DONE_RESET
- *
- * Return nothing.
- */
-void
-mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
-{
-	switch (reset_phase) {
-	case MPT2_IOC_PRE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
-		    "MPT2_IOC_PRE_RESET\n", ioc->name, __func__));
-		_scsih_fw_event_off(ioc);
-		break;
-	case MPT2_IOC_AFTER_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
-		    "MPT2_IOC_AFTER_RESET\n", ioc->name, __func__));
-		if (ioc->tm_cmds.status & MPT2_CMD_PENDING) {
-			ioc->tm_cmds.status |= MPT2_CMD_RESET;
-			mpt2sas_base_free_smid(ioc, ioc->tm_cmds.smid);
-			complete(&ioc->tm_cmds.done);
-		}
-		_scsih_fw_event_on(ioc);
-		_scsih_flush_running_cmds(ioc);
-		break;
-	case MPT2_IOC_DONE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
-		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
-		_scsih_queue_rescan(ioc);
-		break;
-	}
-}
-
-/**
  * _scsih_setup_eedp - setup MPI request for EEDP transfer
  * @scmd: pointer to scsi command object
  * @mpi_request: pointer to the SCSI_IO reqest message frame
@@ -2615,7 +2560,6 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	Mpi2SCSIIORequest_t *mpi_request;
 	u32 mpi_control;
 	u16 smid;
-	unsigned long flags;
 
 	scmd->scsi_done = done;
 	sas_device_priv_data = scmd->device->hostdata;
@@ -2634,13 +2578,10 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	}
 
 	/* see if we are busy with task managment stuff */
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	if (sas_target_priv_data->tm_busy ||
-	    ioc->shost_recovery || ioc->ioc_link_reset_in_progress) {
-		spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+	if (sas_target_priv_data->tm_busy)
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+	else if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress)
 		return SCSI_MLQUEUE_HOST_BUSY;
-	}
-	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 	if (scmd->sc_data_direction == DMA_FROM_DEVICE)
 		mpi_control = MPI2_SCSIIO_CONTROL_READ;
@@ -3185,25 +3126,6 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 }
 
 /**
- * _scsih_link_change - process phy link changes
- * @ioc: per adapter object
- * @handle: phy handle
- * @attached_handle: valid for devices attached to link
- * @phy_number: phy number
- * @link_rate: new link rate
- * Context: user.
- *
- * Return nothing.
- */
-static void
-_scsih_link_change(struct MPT2SAS_ADAPTER *ioc, u16 handle, u16 attached_handle,
-   u8 phy_number, u8 link_rate)
-{
-	mpt2sas_transport_update_phy_link_change(ioc, handle, attached_handle,
-	    phy_number, link_rate);
-}
-
-/**
  * _scsih_sas_host_refresh - refreshing sas host object contents
  * @ioc: per adapter object
  * @update: update link information
@@ -3247,7 +3169,8 @@ _scsih_sas_host_refresh(struct MPT2SAS_ADAPTER *ioc, u8 update)
 			    le16_to_cpu(sas_iounit_pg0->PhyData[i].
 				ControllerDevHandle);
 			if (update)
-				_scsih_link_change(ioc,
+				mpt2sas_transport_update_links(
+				    ioc,
 				    ioc->sas_hba.phy[i].handle,
 				    le16_to_cpu(sas_iounit_pg0->PhyData[i].
 				    AttachedDevHandle), i,
@@ -3426,12 +3349,15 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	__le64 sas_address;
 	int i;
 	unsigned long flags;
-	struct _sas_port *mpt2sas_port;
+	struct _sas_port *mpt2sas_port = NULL;
 	int rc = 0;
 
 	if (!handle)
 		return -1;
 
+	if (ioc->shost_recovery)
+		return -1;
+
 	if ((mpt2sas_config_get_expander_pg0(ioc, &mpi_reply, &expander_pg0,
 	    MPI2_SAS_EXPAND_PGAD_FORM_HNDL, handle))) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
@@ -3518,12 +3444,20 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		    &expander_pg1, i, handle))) {
 			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 			    ioc->name, __FILE__, __LINE__, __func__);
-			continue;
+			rc = -1;
+			goto out_fail;
 		}
 		sas_expander->phy[i].handle = handle;
 		sas_expander->phy[i].phy_id = i;
-		mpt2sas_transport_add_expander_phy(ioc, &sas_expander->phy[i],
-		    expander_pg1, sas_expander->parent_dev);
+
+		if ((mpt2sas_transport_add_expander_phy(ioc,
+		    &sas_expander->phy[i], expander_pg1,
+		    sas_expander->parent_dev))) {
+			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			rc = -1;
+			goto out_fail;
+		}
 	}
 
 	if (sas_expander->enclosure_handle) {
@@ -3540,8 +3474,9 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 
  out_fail:
 
-	if (sas_expander)
-		kfree(sas_expander->phy);
+	if (mpt2sas_port)
+		mpt2sas_transport_port_remove(ioc, sas_expander->sas_address,
+		    sas_expander->parent_handle);
 	kfree(sas_expander);
 	return rc;
 }
@@ -3559,6 +3494,9 @@ _scsih_expander_remove(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	struct _sas_node *sas_expander;
 	unsigned long flags;
 
+	if (ioc->shost_recovery)
+		return;
+
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	sas_expander = mpt2sas_scsih_expander_find_by_handle(ioc, handle);
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
@@ -3663,12 +3601,11 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
 	sas_device->hidden_raid_component = is_pd;
 
 	/* get enclosure_logical_id */
-	if (!(mpt2sas_config_get_enclosure_pg0(ioc, &mpi_reply, &enclosure_pg0,
-	   MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
-	   sas_device->enclosure_handle))) {
+	if (sas_device->enclosure_handle && !(mpt2sas_config_get_enclosure_pg0(
+	   ioc, &mpi_reply, &enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
+	   sas_device->enclosure_handle)))
 		sas_device->enclosure_logical_id =
 		    le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
-	}
 
 	/* get device name */
 	sas_device->device_name = le64_to_cpu(sas_device_pg0.DeviceName);
@@ -3731,6 +3668,8 @@ _scsih_remove_device(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		mutex_unlock(&ioc->tm_cmds.mutex);
 		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "issue target reset "
 		    "done: handle(0x%04x)\n", ioc->name, device_handle));
+		if (ioc->shost_recovery)
+			goto out;
 	}
 
 	/* SAS_IO_UNIT_CNTR - send REMOVE_DEVICE */
@@ -3896,6 +3835,8 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 			    "expander event\n", ioc->name));
 			return;
 		}
+		if (ioc->shost_recovery)
+			return;
 		if (event_data->PHY[i].PhyStatus &
 		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT)
 			continue;
@@ -3911,9 +3852,10 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 		case MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED:
 			if (!parent_handle) {
 				if (phy_number < ioc->sas_hba.num_phys)
-					_scsih_link_change(ioc,
-					   ioc->sas_hba.phy[phy_number].handle,
-					   handle, phy_number, link_rate_);
+					mpt2sas_transport_update_links(
+					ioc,
+					ioc->sas_hba.phy[phy_number].handle,
+					handle, phy_number, link_rate_);
 			} else {
 				spin_lock_irqsave(&ioc->sas_node_lock, flags);
 				sas_expander =
@@ -3923,17 +3865,14 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
 				    flags);
 				if (sas_expander) {
 					if (phy_number < sas_expander->num_phys)
-						_scsih_link_change(ioc,
-						   sas_expander->
-						   phy[phy_number].handle,
-						   handle, phy_number,
-						   link_rate_);
+						mpt2sas_transport_update_links(
+						ioc,
+						sas_expander->
+						phy[phy_number].handle,
+						handle, phy_number,
+						link_rate_);
 				}
 			}
-			if (reason_code == MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED) {
-				if (link_rate_ >= MPI2_SAS_NEG_LINK_RATE_1_5)
-					_scsih_ublock_io_device(ioc, handle);
-			}
 			if (reason_code == MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED) {
 				if (link_rate_ < MPI2_SAS_NEG_LINK_RATE_1_5)
 					break;
@@ -5106,22 +5045,9 @@ static void
 _scsih_remove_unresponding_devices(struct MPT2SAS_ADAPTER *ioc)
 {
 	struct _sas_device *sas_device, *sas_device_next;
-	struct _sas_node *sas_expander, *sas_expander_next;
+	struct _sas_node *sas_expander;
 	struct _raid_device *raid_device, *raid_device_next;
-	unsigned long flags;
 
-	_scsih_search_responding_sas_devices(ioc);
-	_scsih_search_responding_raid_devices(ioc);
-	_scsih_search_responding_expanders(ioc);
-
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	ioc->shost_recovery = 0;
-	if (ioc->shost->shost_state == SHOST_RECOVERY) {
-		printk(MPT2SAS_INFO_FMT "putting controller into "
-		    "SHOST_RUNNING\n", ioc->name);
-		scsi_host_set_state(ioc->shost, SHOST_RUNNING);
-	}
-	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 	list_for_each_entry_safe(sas_device, sas_device_next,
 	    &ioc->sas_device_list, list) {
@@ -5157,16 +5083,63 @@ _scsih_remove_unresponding_devices(struct MPT2SAS_ADAPTER *ioc)
 		_scsih_raid_device_remove(ioc, raid_device);
 	}
 
-	list_for_each_entry_safe(sas_expander, sas_expander_next,
-	    &ioc->sas_expander_list, list) {
+ retry_expander_search:
+	sas_expander = NULL;
+	list_for_each_entry(sas_expander, &ioc->sas_expander_list, list) {
 		if (sas_expander->responding) {
 			sas_expander->responding = 0;
 			continue;
 		}
-		printk("\tremoving expander: handle(0x%04x), "
-		    " sas_addr(0x%016llx)\n", sas_expander->handle,
-		    (unsigned long long)sas_expander->sas_address);
 		_scsih_expander_remove(ioc, sas_expander->handle);
+		goto retry_expander_search;
+	}
+}
+
+/**
+ * mpt2sas_scsih_reset_handler - reset callback handler (for scsih)
+ * @ioc: per adapter object
+ * @reset_phase: phase
+ *
+ * The handler for doing any required cleanup or initialization.
+ *
+ * The reset phase can be MPT2_IOC_PRE_RESET, MPT2_IOC_AFTER_RESET,
+ * MPT2_IOC_DONE_RESET
+ *
+ * Return nothing.
+ */
+void
+mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
+{
+	switch (reset_phase) {
+	case MPT2_IOC_PRE_RESET:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_PRE_RESET\n", ioc->name, __func__));
+		_scsih_fw_event_off(ioc);
+		break;
+	case MPT2_IOC_AFTER_RESET:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_AFTER_RESET\n", ioc->name, __func__));
+		if (ioc->tm_cmds.status & MPT2_CMD_PENDING) {
+			ioc->tm_cmds.status |= MPT2_CMD_RESET;
+			mpt2sas_base_free_smid(ioc, ioc->tm_cmds.smid);
+			complete(&ioc->tm_cmds.done);
+		}
+		_scsih_fw_event_on(ioc);
+		_scsih_flush_running_cmds(ioc);
+		break;
+	case MPT2_IOC_DONE_RESET:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
+		_scsih_sas_host_refresh(ioc, 0);
+		_scsih_search_responding_sas_devices(ioc);
+		_scsih_search_responding_raid_devices(ioc);
+		_scsih_search_responding_expanders(ioc);
+		break;
+	case MPT2_IOC_RUNNING:
+		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		    "MPT2_IOC_RUNNING\n", ioc->name, __func__));
+		_scsih_remove_unresponding_devices(ioc);
+		break;
 	}
 }
 
@@ -5186,14 +5159,6 @@ _firmware_event_work(struct work_struct *work)
 	unsigned long flags;
 	struct MPT2SAS_ADAPTER *ioc = fw_event->ioc;
 
-	/* This is invoked by calling _scsih_queue_rescan(). */
-	if (fw_event->event == MPT2SAS_RESCAN_AFTER_HOST_RESET) {
-		_scsih_fw_event_free(ioc, fw_event);
-		_scsih_sas_host_refresh(ioc, 1);
-		_scsih_remove_unresponding_devices(ioc);
-		return;
-	}
-
 	/* the queue is being flushed so ignore this event */
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	if (ioc->fw_events_off || ioc->remove_host) {
@@ -5203,13 +5168,10 @@ _firmware_event_work(struct work_struct *work)
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
 	if (ioc->shost_recovery) {
-		spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 		_scsih_fw_event_requeue(ioc, fw_event, 1000);
 		return;
 	}
-	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 	switch (fw_event->event) {
 	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
@@ -5411,6 +5373,8 @@ _scsih_expander_node_remove(struct MPT2SAS_ADAPTER *ioc,
 			if (!sas_device)
 				continue;
 			_scsih_remove_device(ioc, sas_device->handle);
+			if (ioc->shost_recovery)
+				return;
 			goto retry_device_search;
 		}
 	}
@@ -5432,6 +5396,8 @@ _scsih_expander_node_remove(struct MPT2SAS_ADAPTER *ioc,
 			if (!expander_sibling)
 				continue;
 			_scsih_expander_remove(ioc, expander_sibling->handle);
+			if (ioc->shost_recovery)
+				return;
 			goto retry_expander_search;
 		}
 	}
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 686695b..5e562fc 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -140,11 +140,18 @@ _transport_set_identify(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 	u32 device_info;
 	u32 ioc_status;
 
+	if (ioc->shost_recovery) {
+		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
+		    __func__, ioc->name);
+		return -EFAULT;
+	}
+
 	if ((mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+
 		    ioc->name, __FILE__, __LINE__, __func__);
-		return -1;
+		return -ENXIO;
 	}
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
@@ -153,7 +160,7 @@ _transport_set_identify(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 		printk(MPT2SAS_ERR_FMT "handle(0x%04x), ioc_status(0x%04x)"
 		    "\nfailure at %s:%d/%s()!\n", ioc->name, handle, ioc_status,
 		     __FILE__, __LINE__, __func__);
-		return -1;
+		return -EIO;
 	}
 
 	memset(identify, 0, sizeof(identify));
@@ -288,21 +295,17 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	void *psge;
 	u32 sgl_flags;
 	u8 issue_reset = 0;
-	unsigned long flags;
 	void *data_out = NULL;
 	dma_addr_t data_out_dma;
 	u32 sz;
 	u64 *sas_address_le;
 	u16 wait_state_count;
 
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	if (ioc->ioc_reset_in_progress) {
-		spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+	if (ioc->shost_recovery) {
 		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
 		    __func__, ioc->name);
 		return -EFAULT;
 	}
-	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 	mutex_lock(&ioc->transport_cmds.mutex);
 
@@ -789,7 +792,7 @@ mpt2sas_transport_add_expander_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
 }
 
 /**
- * mpt2sas_transport_update_phy_link_change - refreshing phy link changes and attached devices
+ * mpt2sas_transport_update_links - refreshing phy link changes
  * @ioc: per adapter object
  * @handle: handle to sas_host or expander
  * @attached_handle: attached device handle
@@ -799,13 +802,19 @@ mpt2sas_transport_add_expander_phy(struct MPT2SAS_ADAPTER *ioc, struct _sas_phy
  * Returns nothing.
  */
 void
-mpt2sas_transport_update_phy_link_change(struct MPT2SAS_ADAPTER *ioc,
+mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc,
     u16 handle, u16 attached_handle, u8 phy_number, u8 link_rate)
 {
 	unsigned long flags;
 	struct _sas_node *sas_node;
 	struct _sas_phy *mpt2sas_phy;
 
+	if (ioc->shost_recovery) {
+		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
+		    __func__, ioc->name);
+		return;
+	}
+
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	sas_node = _transport_sas_node_find_by_handle(ioc, handle);
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
@@ -1025,7 +1034,6 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	void *psge;
 	u32 sgl_flags;
 	u8 issue_reset = 0;
-	unsigned long flags;
 	dma_addr_t dma_addr_in = 0;
 	dma_addr_t dma_addr_out = 0;
 	u16 wait_state_count;
@@ -1045,14 +1053,11 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	if (ioc->ioc_reset_in_progress) {
-		spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+	if (ioc->shost_recovery) {
 		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
 		    __func__, ioc->name);
 		return -EFAULT;
 	}
-	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 	rc = mutex_lock_interruptible(&ioc->transport_cmds.mutex);
 	if (rc)
