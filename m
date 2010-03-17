From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 06/11] mpt2sas: Fix for little endian
Date: Wed, 17 Mar 2010 16:24:52 +0530
Message-ID: <20100317105440.GG21264@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:42933 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839Ab0CQLZu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 07:25:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


1. Fixes for little endian issues.
2. Now Debug info for Discovery event is more readable.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 4c62ee9..d3326e7 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -285,6 +285,9 @@ _base_sas_ioc_info(struct MPT2SAS_ADAPTER *ioc, MPI2DefaultReply_t *mpi_reply,
 	    request_hdr->Function == MPI2_FUNCTION_EVENT_NOTIFICATION)
 		return;
 
+	if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		return;
+
 	switch (ioc_status) {
 
 /****************************************************************************
@@ -517,8 +520,18 @@ _base_display_event_data(struct MPT2SAS_ADAPTER *ioc,
 		desc = "IR Operation Status";
 		break;
 	case MPI2_EVENT_SAS_DISCOVERY:
-		desc =  "Discovery";
-		break;
+	{
+		Mpi2EventDataSasDiscovery_t *event_data =
+		    (Mpi2EventDataSasDiscovery_t *)mpi_reply->EventData;
+		printk(MPT2SAS_INFO_FMT "Discovery: (%s)", ioc->name,
+		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
+		    "start" : "stop");
+		if (event_data->DiscoveryStatus)
+			printk("discovery_status(0x%08x)",
+			    le32_to_cpu(event_data->DiscoveryStatus));
+			printk("\n");
+		return;
+	}
 	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
 		desc = "SAS Broadcast Primitive";
 		break;
@@ -3181,7 +3194,7 @@ _base_event_notification(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	mpi_request->VP_ID = 0;
 	for (i = 0; i < MPI2_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
 		mpi_request->EventMasks[i] =
-		    le32_to_cpu(ioc->event_masks[i]);
+		    cpu_to_le32(ioc->event_masks[i]);
 	mpt2sas_base_put_smid_default(ioc, smid);
 	init_completion(&ioc->base_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done, 30*HZ);
@@ -3645,6 +3658,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	pci_set_drvdata(ioc->pdev, NULL);
 	kfree(ioc->tm_cmds.reply);
 	kfree(ioc->transport_cmds.reply);
+	kfree(ioc->scsih_cmds.reply);
 	kfree(ioc->config_cmds.reply);
 	kfree(ioc->base_cmds.reply);
 	kfree(ioc->ctl_cmds.reply);
@@ -3652,6 +3666,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	ioc->ctl_cmds.reply = NULL;
 	ioc->base_cmds.reply = NULL;
 	ioc->tm_cmds.reply = NULL;
+	ioc->scsih_cmds.reply = NULL;
 	ioc->transport_cmds.reply = NULL;
 	ioc->config_cmds.reply = NULL;
 	ioc->pfacts = NULL;
@@ -3681,6 +3696,7 @@ mpt2sas_base_detach(struct MPT2SAS_ADAPTER *ioc)
 	kfree(ioc->base_cmds.reply);
 	kfree(ioc->tm_cmds.reply);
 	kfree(ioc->transport_cmds.reply);
+	kfree(ioc->scsih_cmds.reply);
 	kfree(ioc->config_cmds.reply);
 }
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 411c27d..360f64b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -1389,12 +1389,12 @@ mpt2sas_config_get_volume_handle(struct MPT2SAS_ADAPTER *ioc, u16 pd_handle,
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 		goto out;
 	for (i = 0; i < config_page->NumElements; i++) {
-		if ((config_page->ConfigElement[i].ElementFlags &
+		if ((le16_to_cpu(config_page->ConfigElement[i].ElementFlags) &
 		    MPI2_RAIDCONFIG0_EFLAGS_MASK_ELEMENT_TYPE) !=
 		    MPI2_RAIDCONFIG0_EFLAGS_VOL_PHYS_DISK_ELEMENT)
 			continue;
-		if (config_page->ConfigElement[i].PhysDiskDevHandle ==
-		    pd_handle) {
+		if (le16_to_cpu(config_page->ConfigElement[i].
+		    PhysDiskDevHandle) == pd_handle) {
 			*volume_handle = le16_to_cpu(config_page->
 			    ConfigElement[i].VolDevHandle);
 			r = 0;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index fa9bf83..ae55a91 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -533,7 +533,7 @@ _ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
 	if (!found) {
 		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
 		    "handle(0x%04x), lun(%d), no active mid!!\n", ioc->name,
-		    desc, tm_request->DevHandle, lun));
+		    desc, le16_to_cpu(tm_request->DevHandle), lun));
 		tm_reply = ioc->ctl_cmds.reply;
 		tm_reply->DevHandle = tm_request->DevHandle;
 		tm_reply->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
@@ -551,7 +551,8 @@ _ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
 
 	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
 	    "handle(0x%04x), lun(%d), task_mid(%d)\n", ioc->name,
-	    desc, tm_request->DevHandle, lun, tm_request->TaskMID));
+	    desc, le16_to_cpu(tm_request->DevHandle), lun,
+	     le16_to_cpu(tm_request->TaskMID)));
 	return 0;
 }
 
@@ -647,9 +648,9 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 
 	if (mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST ||
 	    mpi_request->Function == MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH) {
-		if (!mpi_request->FunctionDependent1 ||
-		    mpi_request->FunctionDependent1 >
-		    cpu_to_le16(ioc->facts.MaxDevHandle)) {
+		if (!le16_to_cpu(mpi_request->FunctionDependent1) ||
+		    le16_to_cpu(mpi_request->FunctionDependent1) >
+		    ioc->facts.MaxDevHandle) {
 			ret = -EINVAL;
 			mpt2sas_base_free_smid(ioc, smid);
 			goto out;
@@ -897,11 +898,11 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		    MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) {
 			printk(MPT2SAS_INFO_FMT "issue target reset: handle "
 			    "= (0x%04x)\n", ioc->name,
-			    mpi_request->FunctionDependent1);
+			    le16_to_cpu(mpi_request->FunctionDependent1));
 			mpt2sas_halt_firmware(ioc);
 			mutex_lock(&ioc->tm_cmds.mutex);
 			mpt2sas_scsih_issue_tm(ioc,
-			    mpi_request->FunctionDependent1, 0,
+			    le16_to_cpu(mpi_request->FunctionDependent1), 0,
 			    MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0, 10);
 			ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 			mutex_unlock(&ioc->tm_cmds.mutex);
@@ -1373,7 +1374,8 @@ _ctl_diag_register_2(struct MPT2SAS_ADAPTER *ioc,
 
 	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: diag_buffer(0x%p), "
 	    "dma(0x%llx), sz(%d)\n", ioc->name, __func__, request_data,
-	    (unsigned long long)request_data_dma, mpi_request->BufferLength));
+	    (unsigned long long)request_data_dma,
+	    le32_to_cpu(mpi_request->BufferLength)));
 
 	for (i = 0; i < MPT2_PRODUCT_SPECIFIC_DWORDS; i++)
 		mpi_request->ProductSpecific[i] =
@@ -2334,8 +2336,8 @@ _ctl_version_nvdata_persistent_show(struct device *cdev,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%02xh\n",
-	    le16_to_cpu(ioc->iounit_pg0.NvdataVersionPersistent.Word));
+	return snprintf(buf, PAGE_SIZE, "%08xh\n",
+	    le32_to_cpu(ioc->iounit_pg0.NvdataVersionPersistent.Word));
 }
 static DEVICE_ATTR(version_nvdata_persistent, S_IRUGO,
     _ctl_version_nvdata_persistent_show, NULL);
@@ -2354,8 +2356,8 @@ _ctl_version_nvdata_default_show(struct device *cdev,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%02xh\n",
-	    le16_to_cpu(ioc->iounit_pg0.NvdataVersionDefault.Word));
+	return snprintf(buf, PAGE_SIZE, "%08xh\n",
+	    le32_to_cpu(ioc->iounit_pg0.NvdataVersionDefault.Word));
 }
 static DEVICE_ATTR(version_nvdata_default, S_IRUGO,
     _ctl_version_nvdata_default_show, NULL);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 7c01485..698ef37 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1375,7 +1375,7 @@ _scsih_display_sata_capabilities(struct MPT2SAS_ADAPTER *ioc,
 	}
 
 	flags = le16_to_cpu(sas_device_pg0.Flags);
-	device_info = le16_to_cpu(sas_device_pg0.DeviceInfo);
+	device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
 
 	sdev_printk(KERN_INFO, sdev,
 	    "atapi(%s), ncq(%s), asyn_notify(%s), smart(%s), fua(%s), "
@@ -3209,8 +3209,8 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		struct sense_info data;
 		_scsih_normalize_sense(scmd->sense_buffer, &data);
 		printk(MPT2SAS_WARN_FMT "\t[sense_key,asc,ascq]: "
-		    "[0x%02x,0x%02x,0x%02x]\n", ioc->name, data.skey,
-		    data.asc, data.ascq);
+		    "[0x%02x,0x%02x,0x%02x], count(%d)\n", ioc->name, data.skey,
+		    data.asc, data.ascq, le32_to_cpu(mpi_reply->SenseCount));
 	}
 
 	if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID) {
@@ -3264,7 +3264,7 @@ _scsih_smart_predicted_fault(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		mpi_request.Function = MPI2_FUNCTION_SCSI_ENCLOSURE_PROCESSOR;
 		mpi_request.Action = MPI2_SEP_REQ_ACTION_WRITE_STATUS;
 		mpi_request.SlotStatus =
-		    MPI2_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT;
+		    cpu_to_le32(MPI2_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT);
 		mpi_request.DevHandle = cpu_to_le16(handle);
 		mpi_request.Flags = MPI2_SEP_REQ_FLAGS_DEVHANDLE_ADDRESS;
 		if ((mpt2sas_base_scsi_enclosure_processor(ioc, &mpi_reply,
@@ -5933,6 +5933,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	struct fw_event_work *fw_event;
 	Mpi2EventNotificationReply_t *mpi_reply;
 	u16 event;
+	u16 sz;
 
 	/* events turned off due to host reset or driver unloading */
 	if (ioc->remove_host)
@@ -5983,8 +5984,8 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 		    ioc->name, __FILE__, __LINE__, __func__);
 		return 1;
 	}
-	fw_event->event_data =
-	    kzalloc(mpi_reply->EventDataLength*4, GFP_ATOMIC);
+	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
+	fw_event->event_data = kzalloc(sz, GFP_ATOMIC);
 	if (!fw_event->event_data) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -5993,7 +5994,7 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 	}
 
 	memcpy(fw_event->event_data, mpi_reply->EventData,
-	    mpi_reply->EventDataLength*4);
+	    sz);
 	fw_event->ioc = ioc;
 	fw_event->VF_ID = mpi_reply->VF_ID;
 	fw_event->VP_ID = mpi_reply->VP_ID;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 789f9ee..9523130 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1340,7 +1340,8 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
 		req->sense_len = sizeof(*mpi_reply);
 		req->resid_len = 0;
-		rsp->resid_len -= mpi_reply->ResponseDataLength;
+		rsp->resid_len -=
+		    le16_to_cpu(mpi_reply->ResponseDataLength);
 	} else {
 		dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT
 		    "%s - no reply\n", ioc->name, __func__));
