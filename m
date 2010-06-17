From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 10/17] mpt2sas: Tie a log info message to a specific PHY.
Date: Thu, 17 Jun 2010 13:45:17 +0530
Message-ID: <20100617081517.GK28921@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:39411 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369Ab0FQIux (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 04:50:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com

Add support to display additional debug info for SCSI_IO and
RAID_SCSI_IO_PASSTHROUGH sent from the normal entry queued entry
point, as well as internal generated commands, and IOCTLS.  The
additional debug info included the phy number, as well as the
sas address, enclosure logical id, and slot number.  This debug info
has to be enabled thru the logging_level command line option, by
default this will not be displayed.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 08404b3..e2c5cee 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -275,6 +275,7 @@ struct _internal_cmd {
  * @id: target id
  * @channel: target channel
  * @slot: number number
+ * @phy: phy identifier provided in sas device page 0
  * @hidden_raid_component: set to 1 when this is a raid member
  * @responding: used in _scsih_sas_device_mark_responding
  */
@@ -293,6 +294,7 @@ struct _sas_device {
 	int	id;
 	int	channel;
 	u16	slot;
+	u8	phy;
 	u8	hidden_raid_component;
 	u8	responding;
 };
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 55fbd5b..ce63a4a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -80,6 +80,32 @@ enum block_state {
 	BLOCKING,
 };
 
+/**
+ * _ctl_sas_device_find_by_handle - sas device search
+ * @ioc: per adapter object
+ * @handle: sas device handle (assigned by firmware)
+ * Context: Calling function should acquire ioc->sas_device_lock
+ *
+ * This searches for sas_device based on sas_address, then return sas_device
+ * object.
+ */
+static struct _sas_device *
+_ctl_sas_device_find_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 handle)
+{
+	struct _sas_device *sas_device, *r;
+
+	r = NULL;
+	list_for_each_entry(sas_device, &ioc->sas_device_list, list) {
+		if (sas_device->handle != handle)
+			continue;
+		r = sas_device;
+		goto out;
+	}
+
+ out:
+	return r;
+}
+
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 /**
  * _ctl_display_some_debug - debug routine
@@ -205,6 +231,22 @@ _ctl_display_some_debug(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 	    MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH) {
 		Mpi2SCSIIOReply_t *scsi_reply =
 		    (Mpi2SCSIIOReply_t *)mpi_reply;
+		struct _sas_device *sas_device = NULL;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = _ctl_sas_device_find_by_handle(ioc,
+		    le16_to_cpu(scsi_reply->DevHandle));
+		if (sas_device) {
+			printk(MPT2SAS_WARN_FMT "\tsas_address(0x%016llx), "
+			    "phy(%d)\n", ioc->name, (unsigned long long)
+			    sas_device->sas_address, sas_device->phy);
+			printk(MPT2SAS_WARN_FMT
+			    "\tenclosure_logical_id(0x%016llx), slot(%d)\n",
+			    ioc->name, sas_device->enclosure_logical_id,
+			    sas_device->slot);
+		}
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 		if (scsi_reply->SCSIState || scsi_reply->SCSIStatus)
 			printk(MPT2SAS_INFO_FMT
 			    "\tscsi_state(0x%02x), scsi_status"
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 82c2d4c..db12e18 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1749,9 +1749,10 @@ _scsih_slave_configure(struct scsi_device *sdev)
 		}
 
 		sdev_printk(KERN_INFO, sdev, "%s: handle(0x%04x), "
-		    "sas_addr(0x%016llx), device_name(0x%016llx)\n",
+		    "sas_addr(0x%016llx), phy(%d), device_name(0x%016llx)\n",
 		    ds, sas_device->handle,
 		    (unsigned long long)sas_device->sas_address,
+		    sas_device->phy,
 		    (unsigned long long)sas_device->device_name);
 		sdev_printk(KERN_INFO, sdev, "%s: "
 		    "enclosure_logical_id(0x%016llx), slot(%d)\n", ds,
@@ -3128,6 +3129,8 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	char *desc_scsi_status = NULL;
 	char *desc_scsi_state = ioc->tmp_string;
 	u32 log_info = le32_to_cpu(mpi_reply->IOCLogInfo);
+	struct _sas_device *sas_device = NULL;
+	unsigned long flags;
 
 	if (log_info == 0x31170000)
 		return;
@@ -3243,6 +3246,19 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		strcat(desc_scsi_state, "autosense valid ");
 
 	scsi_print_command(scmd);
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc,
+	    le16_to_cpu(mpi_reply->DevHandle));
+	if (sas_device) {
+		printk(MPT2SAS_WARN_FMT "\tsas_address(0x%016llx), phy(%d)\n",
+		    ioc->name, sas_device->sas_address, sas_device->phy);
+		printk(MPT2SAS_WARN_FMT "\tenclosure_logical_id(0x%016llx), "
+		   "slot(%d)\n", ioc->name, sas_device->enclosure_logical_id,
+		    sas_device->slot);
+	}
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
 	printk(MPT2SAS_WARN_FMT "\tdev handle(0x%04x), "
 	    "ioc_status(%s)(0x%04x), smid(%d)\n", ioc->name,
 	    le16_to_cpu(mpi_reply->DevHandle), desc_ioc_state,
@@ -4187,6 +4203,7 @@ _scsih_add_device(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 phy_num, u8 is_pd)
 	    le16_to_cpu(sas_device_pg0.Slot);
 	sas_device->device_info = device_info;
 	sas_device->sas_address = sas_address;
+	sas_device->phy = sas_device_pg0.PhyNum;
 	sas_device->hidden_raid_component = is_pd;
 
 	/* get enclosure_logical_id */
