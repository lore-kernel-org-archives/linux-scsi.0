From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 17/20] mpt2sas: Freeze the sdev IO queue when firmware sends internal dev reset
Date: Wed, 23 Sep 2009 17:35:41 +0530
Message-ID: <20090923120541.GV6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:41694 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbZIWM27 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:28:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


When receiving the MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET event,
the driver will set the tm_busy flag in the sdev private host data, When
tm_busy flag is set, the driver will return SCSI_MLQUEUE_DEVICE_BUSY,
effectly freezing the IO to the device. The tm_busy flag is cleared with the
MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET event.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index f62c75c..a48b70f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4308,11 +4308,43 @@ static void
 _scsih_sas_device_status_change_event(struct MPT2SAS_ADAPTER *ioc,
     struct fw_event_work *fw_event)
 {
+	struct MPT2SAS_TARGET *target_priv_data;
+	struct _sas_device *sas_device;
+	__le64 sas_address;
+	unsigned long flags;
+	Mpi2EventDataSasDeviceStatusChange_t *event_data =
+	    fw_event->event_data;
+
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
 		_scsih_sas_device_status_change_event_debug(ioc,
-		     fw_event->event_data);
+		     event_data);
 #endif
+
+	if (!(event_data->ReasonCode ==
+	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
+	   event_data->ReasonCode ==
+	    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET))
+		return;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_address = le64_to_cpu(event_data->SASAddress);
+	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	    sas_address);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	if (!sas_device || !sas_device->starget)
+		return;
+
+	target_priv_data = sas_device->starget->hostdata;
+	if (!target_priv_data)
+		return;
+
+	if (event_data->ReasonCode ==
+	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET)
+		target_priv_data->tm_busy = 1;
+	else
+		target_priv_data->tm_busy = 0;
 }
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
