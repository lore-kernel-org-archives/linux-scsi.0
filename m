From: <nagalakshmi.nandigama@lsi.com>
Subject: RESEND [PATCH 09/10] mpt2sas: Fix for Panic when inactive volume
 is tried deleting
Date: Wed, 19 Oct 2011 15:37:43 +0530
Message-ID: <201110191613.p9JGDer7026534@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:39968 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756453Ab1JSQNn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2011 12:13:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Fix for issue - Panic when inactive volume is tried deleting.

The driver was setting the action to MPI2_CONFIG_ACTION_PAGE_READ_CURRENT, 
which only returns active volumes. In order to get info on inactive volumes, 
the driver needs to change the action to 
MPI2_RAID_PGAD_FORM_GET_NEXT_CONFIGNUM, and traverse each config till the
iocstatus is MPI2_IOCSTATUS_CONFIG_INVALID_PAGE returned.    
Added a change in the driver to remove the instance of 
sas_device object when the driver returns "1" from the slave_configure callback.
Also fixed code to report the hot spares to the operating system with a /dev/sg 
assigned.



Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 6861244..bc2b6d2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -1357,6 +1357,9 @@ mpt2sas_config_get_volume_handle(struct MPT2SAS_ADAPTER *ioc, u16 pd_handle,
 	Mpi2ConfigReply_t mpi_reply;
 	int r, i, config_page_sz;
 	u16 ioc_status;
+	int config_num;
+	u16 element_type;
+	u16 phys_disk_dev_handle;
 
 	*volume_handle = 0;
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
@@ -1372,35 +1375,53 @@ mpt2sas_config_get_volume_handle(struct MPT2SAS_ADAPTER *ioc, u16 pd_handle,
 	if (r)
 		goto out;
 
-	mpi_request.PageAddress =
-	    cpu_to_le32(MPI2_RAID_PGAD_FORM_ACTIVE_CONFIG);
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
 	config_page_sz = (le16_to_cpu(mpi_reply.ExtPageLength) * 4);
 	config_page = kmalloc(config_page_sz, GFP_KERNEL);
-	if (!config_page)
-		goto out;
-	r = _config_request(ioc, &mpi_request, &mpi_reply,
-	    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
-	    config_page_sz);
-	if (r)
+	if (!config_page) {
+		r = -1;
 		goto out;
-
-	r = -1;
-	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
-	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
-		goto out;
-	for (i = 0; i < config_page->NumElements; i++) {
-		if ((le16_to_cpu(config_page->ConfigElement[i].ElementFlags) &
-		    MPI2_RAIDCONFIG0_EFLAGS_MASK_ELEMENT_TYPE) !=
-		    MPI2_RAIDCONFIG0_EFLAGS_VOL_PHYS_DISK_ELEMENT)
-			continue;
-		if (le16_to_cpu(config_page->ConfigElement[i].
-		    PhysDiskDevHandle) == pd_handle) {
-			*volume_handle = le16_to_cpu(config_page->
-			    ConfigElement[i].VolDevHandle);
-			r = 0;
+	}
+	config_num = 0xff;
+	while (1) {
+		mpi_request.PageAddress = cpu_to_le32(config_num +
+		    MPI2_RAID_PGAD_FORM_GET_NEXT_CONFIGNUM);
+		r = _config_request(ioc, &mpi_request, &mpi_reply,
+		    MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+		    config_page_sz);
+		if (r)
+			goto out;
+		r = -1;
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			goto out;
+		for (i = 0; i < config_page->NumElements; i++) {
+			element_type = le16_to_cpu(config_page->
+			    ConfigElement[i].ElementFlags) &
+			    MPI2_RAIDCONFIG0_EFLAGS_MASK_ELEMENT_TYPE;
+			if (element_type ==
+			    MPI2_RAIDCONFIG0_EFLAGS_VOL_PHYS_DISK_ELEMENT ||
+			    element_type ==
+			    MPI2_RAIDCONFIG0_EFLAGS_OCE_ELEMENT) {
+				phys_disk_dev_handle =
+				    le16_to_cpu(config_page->ConfigElement[i].
+				    PhysDiskDevHandle);
+				if (phys_disk_dev_handle == pd_handle) {
+					*volume_handle =
+					    le16_to_cpu(config_page->
+					    ConfigElement[i].VolDevHandle);
+					r = 0;
+					goto out;
+				}
+			} else if (element_type ==
+			    MPI2_RAIDCONFIG0_EFLAGS_HOT_SPARE_ELEMENT) {
+				*volume_handle = 0;
+				r = 0;
+				goto out;
+			}
 		}
+		config_num = config_page->ConfigNum;
 	}
  out:
 	kfree(config_page);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index da0254d..341240f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -611,8 +611,15 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
 	if (!mpt2sas_transport_port_add(ioc, sas_device->handle,
-	     sas_device->sas_address_parent))
+	     sas_device->sas_address_parent)) {
 		_scsih_sas_device_remove(ioc, sas_device);
+		} else if (!sas_device->starget) {
+			if (!ioc->is_driver_loading)
+				mpt2sas_transport_port_remove(ioc,
+				sas_device->sas_address,
+			    sas_device->sas_address_parent);
+			_scsih_sas_device_remove(ioc, sas_device);
+		}
 }
 
 /**
@@ -1424,6 +1431,10 @@ _scsih_slave_destroy(struct scsi_device *sdev)
 {
 	struct MPT2SAS_TARGET *sas_target_priv_data;
 	struct scsi_target *starget;
+	struct Scsi_Host *shost;
+	struct MPT2SAS_ADAPTER *ioc;
+	struct _sas_device *sas_device;
+	unsigned long flags;
 
 	if (!sdev->hostdata)
 		return;
@@ -1431,6 +1442,19 @@ _scsih_slave_destroy(struct scsi_device *sdev)
 	starget = scsi_target(sdev);
 	sas_target_priv_data = starget->hostdata;
 	sas_target_priv_data->num_luns--;
+
+	shost = dev_to_shost(&starget->dev);
+	ioc = shost_priv(shost);
+
+	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+		   sas_target_priv_data->sas_address);
+		if (sas_device)
+			sas_device->starget = NULL;
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	}
+
 	kfree(sdev->hostdata);
 	sdev->hostdata = NULL;
 }
@@ -2046,7 +2070,8 @@ _scsih_slave_configure(struct scsi_device *sdev)
 				    __FILE__, __LINE__, __func__));
 				return 1;
 			}
-			if (mpt2sas_config_get_volume_wwid(ioc,
+			if (sas_device->volume_handle &&
+			    mpt2sas_config_get_volume_wwid(ioc,
 			    sas_device->volume_handle,
 			    &sas_device->volume_wwid)) {
 				dfailprintk(ioc, printk(MPT2SAS_WARN_FMT
@@ -5894,8 +5919,11 @@ _scsih_reprobe_lun(struct scsi_device *sdev, void *no_uld_attach)
 static void
 _scsih_reprobe_target(struct scsi_target *starget, int no_uld_attach)
 {
-	struct MPT2SAS_TARGET *sas_target_priv_data = starget->hostdata;
+	struct MPT2SAS_TARGET *sas_target_priv_data;
 
+	if (starget == NULL)
+		return;
+	sas_target_priv_data = starget->hostdata;
 	if (no_uld_attach)
 		sas_target_priv_data->flags |= MPT_TARGET_FLAGS_RAID_COMPONENT;
 	else
@@ -7677,8 +7705,9 @@ _scsih_probe_boot_devices(struct MPT2SAS_ADAPTER *ioc)
 		    sas_device->sas_address_parent)) {
 			_scsih_sas_device_remove(ioc, sas_device);
 		} else if (!sas_device->starget) {
-			mpt2sas_transport_port_remove(ioc, sas_address,
-			    sas_address_parent);
+			if (!ioc->is_driver_loading)
+				mpt2sas_transport_port_remove(ioc, sas_address,
+					sas_address_parent);
 			_scsih_sas_device_remove(ioc, sas_device);
 		}
 	}
@@ -7732,9 +7761,10 @@ _scsih_probe_sas(struct MPT2SAS_ADAPTER *ioc)
 			kfree(sas_device);
 			continue;
 		} else if (!sas_device->starget) {
-			mpt2sas_transport_port_remove(ioc,
-			    sas_device->sas_address,
-			    sas_device->sas_address_parent);
+			if (!ioc->is_driver_loading)
+				mpt2sas_transport_port_remove(ioc,
+					sas_device->sas_address,
+					sas_device->sas_address_parent);
 			list_del(&sas_device->list);
 			kfree(sas_device);
 			continue;
