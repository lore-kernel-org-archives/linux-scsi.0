From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] mpt2sas : Enable TLR for SSP TAPE drives
Date: Fri, 13 Nov 2009 13:56:20 +0530
Message-ID: <20091113082620.GB18271@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:38895 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754707AbZKMIwB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Nov 2009 03:52:01 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

The driver is sending vpd page 0, to get a list of supported pages. Then it
will traverse the list searching for page 0x90. when page 0x90 is present,
the driver will enable the TLR logic for Tape devices only.  The TLR logic
will enable the TLR bits in the SCSI_IO for every request. If there is a
response with MPI2_SCSITASKMGMT_RSP_INVALID_FRAME, the driver will turn off
the TLR logic.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <Eric.moore@lsi.com>
---
diff -Naurp mpt2sas_orig/mpt2sas_scsih.c mpt2sas/mpt2sas_scsih.c
--- mpt2sas_orig/mpt2sas_scsih.c	2009-11-10 01:28:44.000000000 +0530
+++ mpt2sas/mpt2sas_scsih.c	2009-11-13 14:06:47.000000000 +0530
@@ -1301,7 +1301,6 @@ _scsih_slave_alloc(struct scsi_device *s
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
 	struct scsi_target *starget;
 	struct _raid_device *raid_device;
-	struct _sas_device *sas_device;
 	unsigned long flags;
 
 	sas_device_priv_data = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
@@ -1328,21 +1327,8 @@ _scsih_slave_alloc(struct scsi_device *s
 		if (raid_device)
 			raid_device->sdev = sdev; /* raid is single lun */
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
-	} else {
-		/* set TLR bit for SSP devices */
-		if (!(ioc->facts.IOCCapabilities &
-		     MPI2_IOCFACTS_CAPABILITY_TLR))
-			goto out;
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
-		   sas_device_priv_data->sas_target->sas_address);
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-		if (sas_device && sas_device->device_info &
-		    MPI2_SAS_DEVICE_INFO_SSP_TARGET)
-			sas_device_priv_data->flags |= MPT_DEVICE_TLR_ON;
 	}
 
- out:
 	return 0;
 }
 
@@ -1475,6 +1461,51 @@ _scsih_get_volume_capabilities(struct MP
 }
 
 /**
+ * _scsih_enable_tlr - setting TLR flags
+ * @ioc: per adapter object
+ * @sdev: scsi device struct
+ *
+ * Enabling Transaction Layer Retries for tape devices when
+ * vpd page 0x90 is present
+ *
+ */
+static void
+_scsih_enable_tlr(struct MPT2SAS_ADAPTER *ioc, struct scsi_device *sdev)
+{
+	struct MPT2SAS_DEVICE *sas_device_priv_data;
+	struct MPT2SAS_TARGET *sas_target_priv_data;
+	char *buffer;
+
+	/* only for TAPE */
+	if (sdev->type != TYPE_TAPE)
+		return;
+
+	if (!(ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_TLR))
+		return;
+
+	sas_device_priv_data = sdev->hostdata;
+	if (!sas_device_priv_data)
+		return;
+	sas_target_priv_data = sas_device_priv_data->sas_target;
+	if (!sas_target_priv_data)
+		return;
+
+	buffer = scsi_get_vpd_page(sdev, 0x90);
+	if (buffer == NULL) {
+		dprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: VPD page 0x90 is not"
+			"supported\n", ioc->name, __func__));
+                return;
+	}
+
+	dprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: VPD page 0x90 is "
+		"supported\n", ioc->name, __func__));
+	sas_device_priv_data->flags |= MPT_DEVICE_TLR_ON;
+	kfree(buffer);
+	return;
+
+}
+
+/**
  * _scsih_slave_configure - device configure routine.
  * @sdev: scsi device struct
  *
@@ -1617,8 +1648,10 @@ _scsih_slave_configure(struct scsi_devic
 
 	_scsih_change_queue_depth(sdev, qdepth);
 
-	if (ssp_target)
+	if (ssp_target) {
 		sas_read_port_mode_page(sdev);
+		_scsih_enable_tlr(ioc, sdev);
+	}
 	return 0;
 }
 
