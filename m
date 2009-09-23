From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 2/20] mpt2sas: Expander remove fails when it is processing another expander add.
Date: Wed, 23 Sep 2009 17:22:37 +0530
Message-ID: <20090923115237.GG6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:53771 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbZIWMez (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:34:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

This handles the case where driver receives a expander removal event while
it is in the middle of processing an expander add event. The existing
implementation will stop processing futher device adds when a expander
delete arrives on top of add expander add. Due to a sanity check in the
driver, the devices there were not added, were never handshaked to firmware
with the device removal handshake protocal. Since the driver didnt' do the
handshake, the controller never provide further add events.  To fix this
issue, the sanity check was removed so the driver will always do the device
removal handshake protocal.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 3a38943..13e90e3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2386,16 +2386,10 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-	if (!sas_device) {
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		printk(MPT2SAS_ERR_FMT "%s: failed finding sas_device\n",
-		    ioc->name, __func__);
-		return;
-	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
 	/* skip is hidden raid component */
-	if (sas_device->hidden_raid_component)
+	if (sas_device && sas_device->hidden_raid_component)
 		return;
 
 	smid = mpt2sas_base_get_smid_hpr(ioc, ioc->tm_tr_cb_idx);
@@ -2408,18 +2402,31 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		delayed_tr->state = MPT2SAS_REQ_SAS_CNTRL;
 		list_add_tail(&delayed_tr->list,
 		    &ioc->delayed_tr_list);
-		if (sas_device->starget)
+		if (sas_device && sas_device->starget) {
 			dewtprintk(ioc, starget_printk(KERN_INFO,
 			    sas_device->starget, "DELAYED:tr:handle(0x%04x), "
-			    "(open)\n", sas_device->handle));
+			    "(open)\n", handle));
+		} else {
+			dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
+			    "DELAYED:tr:handle(0x%04x), (open)\n",
+			    ioc->name, handle));
+		}
 		return;
 	}
 
-	if (sas_device->starget && sas_device->starget->hostdata) {
-		sas_target_priv_data = sas_device->starget->hostdata;
-		sas_target_priv_data->tm_busy = 1;
-		dewtprintk(ioc, starget_printk(KERN_INFO, sas_device->starget,
-		    "tr:handle(0x%04x), (open)\n", sas_device->handle));
+	if (sas_device) {
+		sas_device->state |= MPTSAS_STATE_TR_SEND;
+		sas_device->state |= MPT2SAS_REQ_SAS_CNTRL;
+		if (sas_device->starget && sas_device->starget->hostdata) {
+			sas_target_priv_data = sas_device->starget->hostdata;
+			sas_target_priv_data->tm_busy = 1;
+			dewtprintk(ioc, starget_printk(KERN_INFO,
+			    sas_device->starget, "tr:handle(0x%04x), (open)\n",
+			    handle));
+		}
+	} else {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
+		    "tr:handle(0x%04x), (open)\n", ioc->name, handle));
 	}
 
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
@@ -2427,8 +2434,6 @@ _scsih_tm_tr_send(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
 	mpi_request->DevHandle = cpu_to_le16(handle);
 	mpi_request->TaskType = MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
-	sas_device->state |= MPTSAS_STATE_TR_SEND;
-	sas_device->state |= MPT2SAS_REQ_SAS_CNTRL;
 	mpt2sas_base_put_smid_hi_priority(ioc, smid);
 }
 
@@ -2463,21 +2468,25 @@ _scsih_sas_control_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-	if (!sas_device) {
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		printk(MPT2SAS_ERR_FMT "%s: failed finding sas_device\n",
-		    ioc->name, __func__);
-		return 1;
-	}
-	sas_device->state |= MPTSAS_STATE_CNTRL_COMPLETE;
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
-	if (sas_device->starget)
-		dewtprintk(ioc, starget_printk(KERN_INFO, sas_device->starget,
+	if (sas_device) {
+		sas_device->state |= MPTSAS_STATE_CNTRL_COMPLETE;
+		if (sas_device->starget)
+			dewtprintk(ioc, starget_printk(KERN_INFO,
+			    sas_device->starget,
+			    "sc_complete:handle(0x%04x), "
+			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
+			    handle, le16_to_cpu(mpi_reply->IOCStatus),
+			    le32_to_cpu(mpi_reply->IOCLogInfo)));
+	} else {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
 		    "sc_complete:handle(0x%04x), "
 		    "ioc_status(0x%04x), loginfo(0x%08x)\n",
-		    handle, le16_to_cpu(mpi_reply->IOCStatus),
+		    ioc->name, handle, le16_to_cpu(mpi_reply->IOCStatus),
 		    le32_to_cpu(mpi_reply->IOCLogInfo)));
+	}
+
 	return 1;
 }
 
@@ -2515,28 +2524,33 @@ _scsih_tm_tr_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	handle = le16_to_cpu(mpi_reply->DevHandle);
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
-	if (!sas_device) {
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		printk(MPT2SAS_ERR_FMT "%s: failed finding sas_device\n",
-		    ioc->name, __func__);
-		return 1;
-	}
-	sas_device->state |= MPTSAS_STATE_TR_COMPLETE;
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
-	if (sas_device->starget)
-		dewtprintk(ioc, starget_printk(KERN_INFO, sas_device->starget,
-		    "tr_complete:handle(0x%04x), (%s) ioc_status(0x%04x), "
-		    "loginfo(0x%08x), completed(%d)\n",
-		    sas_device->handle, (sas_device->state &
-		    MPT2SAS_REQ_SAS_CNTRL) ? "open" : "active",
-		    le16_to_cpu(mpi_reply->IOCStatus),
+	if (sas_device) {
+		sas_device->state |= MPTSAS_STATE_TR_COMPLETE;
+		if (sas_device->starget) {
+			dewtprintk(ioc, starget_printk(KERN_INFO,
+			    sas_device->starget, "tr_complete:handle(0x%04x), "
+			    "(%s) ioc_status(0x%04x), loginfo(0x%08x), "
+			    "completed(%d)\n", sas_device->handle,
+			    (sas_device->state & MPT2SAS_REQ_SAS_CNTRL) ?
+			    "open" : "active",
+			    le16_to_cpu(mpi_reply->IOCStatus),
+			    le32_to_cpu(mpi_reply->IOCLogInfo),
+			    le32_to_cpu(mpi_reply->TerminationCount)));
+			if (sas_device->starget->hostdata) {
+				sas_target_priv_data =
+				    sas_device->starget->hostdata;
+				sas_target_priv_data->tm_busy = 0;
+			}
+		}
+	} else {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
+		    "tr_complete:handle(0x%04x), (open) ioc_status(0x%04x), "
+		    "loginfo(0x%08x), completed(%d)\n", ioc->name,
+		    handle, le16_to_cpu(mpi_reply->IOCStatus),
 		    le32_to_cpu(mpi_reply->IOCLogInfo),
 		    le32_to_cpu(mpi_reply->TerminationCount)));
-
-	if (sas_device->starget && sas_device->starget->hostdata) {
-		sas_target_priv_data = sas_device->starget->hostdata;
-		sas_target_priv_data->tm_busy = 0;
 	}
 
 	if (!list_empty(&ioc->delayed_tr_list)) {
@@ -2551,8 +2565,7 @@ _scsih_tm_tr_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	} else
 		rc = 1;
 
-
-	if (!(sas_device->state & MPT2SAS_REQ_SAS_CNTRL))
+	if (sas_device && !(sas_device->state & MPT2SAS_REQ_SAS_CNTRL))
 		return rc;
 
 	if (ioc->shost_recovery) {
@@ -2568,12 +2581,14 @@ _scsih_tm_tr_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 		return rc;
 	}
 
+	if (sas_device)
+		sas_device->state |= MPTSAS_STATE_CNTRL_SEND;
+
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid_sas_ctrl);
 	memset(mpi_request, 0, sizeof(Mpi2SasIoUnitControlRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SAS_IO_UNIT_CONTROL;
 	mpi_request->Operation = MPI2_SAS_OP_REMOVE_DEVICE;
 	mpi_request->DevHandle = mpi_reply->DevHandle;
-	sas_device->state |= MPTSAS_STATE_CNTRL_SEND;
 	mpt2sas_base_put_smid_default(ioc, smid_sas_ctrl);
 	return rc;
 }
