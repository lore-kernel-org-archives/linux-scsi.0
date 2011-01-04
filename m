From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 06/10] mpt2sas: Fix the race between broadcast asyn event and scsi
Date: Tue, 4 Jan 2011 11:37:46 +0530
Message-ID: <20110104060736.GG5751@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:41882 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319Ab1ADGwj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 01:52:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Add support for Customer specific branding messages when device driver loads,
False timeout after hard resets, there were two issues which leads
to timeout.
(1) Panic because of invalid memory access in the broadcast asyn
event processing routine due to a race between accessing the scsi command
pointer from broadcast asyn event processing thread and completing
the same scsi command from the interrupt context.
(2)  Broadcast asyn event notifcations are not handled due to events
ignored while the broadcast asyn event is activity being processed
from the event process kernel thread.

In addition, changed the ABRT_TASK_SET to ABORT_TASK in the
broadcast async event processing routine.   This is less disruptive to other
request that generate Broadcast Asyn Primitives besides target
reset. e.g clear reservations, microcode download,and mode select.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index a16f2a0..db287d7 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -819,7 +819,7 @@ _scsih_is_end_device(u32 device_info)
 }
 
 /**
- * mptscsih_get_scsi_lookup - returns scmd entry
+ * _scsih_scsi_lookup_get - returns scmd entry
  * @ioc: per adapter object
  * @smid: system request message index
  *
@@ -832,6 +832,28 @@ _scsih_scsi_lookup_get(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 }
 
 /**
+ * _scsih_scsi_lookup_get_clear - returns scmd entry
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Returns the smid stored scmd pointer.
+ * Then will derefrence the stored scmd pointer.
+ */
+static inline struct scsi_cmnd *
+_scsih_scsi_lookup_get_clear(struct MPT2SAS_ADAPTER *ioc, u16 smid)
+{
+	unsigned long flags;
+	struct scsi_cmnd *scmd;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	scmd = ioc->scsi_lookup[smid - 1].scmd;
+	ioc->scsi_lookup[smid - 1].scmd = NULL;
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+
+	return scmd;
+}
+
+/**
  * _scsih_scsi_lookup_find_by_scmd - scmd lookup
  * @ioc: per adapter object
  * @smid: system request message index
@@ -3207,7 +3229,7 @@ _scsih_flush_running_cmds(struct MPT2SAS_ADAPTER *ioc)
 	u16 count = 0;
 
 	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
-		scmd = _scsih_scsi_lookup_get(ioc, smid);
+		scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
 		if (!scmd)
 			continue;
 		count++;
@@ -3801,7 +3823,7 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	u32 response_code = 0;
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
-	scmd = _scsih_scsi_lookup_get(ioc, smid);
+	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
 	if (scmd == NULL)
 		return 1;
 
@@ -5102,6 +5124,7 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
     struct fw_event_work *fw_event)
 {
 	struct scsi_cmnd *scmd;
+	struct scsi_device *sdev;
 	u16 smid, handle;
 	u32 lun;
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
@@ -5112,12 +5135,17 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
 #endif
 	u16 ioc_status;
+	unsigned long flags;
+	int r;
+
 	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "broadcast primative: "
 	    "phy number(%d), width(%d)\n", ioc->name, event_data->PhyNum,
 	    event_data->PortWidth));
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	ioc->broadcast_aen_busy = 0;
 	termination_count = 0;
 	query_count = 0;
 	mpi_reply = ioc->tm_cmds.reply;
@@ -5125,7 +5153,8 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 		scmd = _scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
 			continue;
-		sas_device_priv_data = scmd->device->hostdata;
+		sdev = scmd->device;
+		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
 			continue;
 		 /* skip hidden raid components */
@@ -5141,6 +5170,7 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 		lun = sas_device_priv_data->lun;
 		query_count++;
 
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 		mpt2sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
 		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30, NULL);
 		ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
@@ -5150,14 +5180,20 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 		    (mpi_reply->ResponseCode ==
 		     MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED ||
 		     mpi_reply->ResponseCode ==
-		     MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC))
+		     MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC)) {
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 			continue;
-
-		mpt2sas_scsih_issue_tm(ioc, handle, 0, 0, lun,
-		    MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET, 0, 30, NULL);
+		}
+		r = mpt2sas_scsih_issue_tm(ioc, handle, sdev->channel, sdev->id,
+		    sdev->lun, MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30,
+		    scmd);
+		if (r == FAILED)
+			sdev_printk(KERN_WARNING, sdev, "task abort: FAILED "
+			    "scmd(%p)\n", scmd);
 		termination_count += le32_to_cpu(mpi_reply->TerminationCount);
+		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 	}
-	ioc->broadcast_aen_busy = 0;
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT
 	    "%s - exit, query_count = %d termination_count = %d\n",
based on specific customer subsystem vendor and device Ids

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index a11ac67..4f1f3f2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1725,6 +1725,31 @@ _base_display_dell_branding(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
+ * _base_display_intel_branding - Display branding string
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_display_intel_branding(struct MPT2SAS_ADAPTER *ioc)
+{
+	if (ioc->pdev->subsystem_vendor == PCI_VENDOR_ID_INTEL &&
+	    ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008) {
+
+		switch (ioc->pdev->subsystem_device) {
+		case MPT2SAS_INTEL_RMS2LL080_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RMS2LL080_BRANDING);
+			break;
+		case MPT2SAS_INTEL_RMS2LL040_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RMS2LL040_BRANDING);
+			break;
+		}
+	}
+}
+
+/**
  * _base_display_ioc_capabilities - Disply IOC's capabilities.
  * @ioc: per adapter object
  *
@@ -1754,6 +1779,7 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
 	    ioc->bios_pg3.BiosVersion & 0x000000FF);
 
 	_base_display_dell_branding(ioc);
+	_base_display_intel_branding(ioc);
 
 	printk(MPT2SAS_INFO_FMT "Protocol=(", ioc->name);
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 283568c..82579fb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -154,6 +154,20 @@
 #define MPT2SAS_DELL_6GBPS_SAS_SSDID               0x1F22
 
 /*
+ * Intel HBA branding
+ */
+#define MPT2SAS_INTEL_RMS2LL080_BRANDING	\
+				"Intel Integrated RAID Module RMS2LL080"
+#define MPT2SAS_INTEL_RMS2LL040_BRANDING	\
+				"Intel Integrated RAID Module RMS2LL040"
+
+/*
+ * Intel HBA SSDIDs
+ */
+#define MPT2SAS_INTEL_RMS2LL080_SSDID          0x350E
+#define MPT2SAS_INTEL_RMS2LL040_SSDID          0x350F
+
+/*
  * per target private data
  */
 #define MPT_TARGET_FLAGS_RAID_COMPONENT	0x01
