From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 9/10] mpt2sas: Enable TLR for SSP TAPE drives (Added SAS Transport APIs)
Date: Wed, 16 Dec 2009 18:56:28 +0530
Message-ID: <20091216132620.GJ31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:49447 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759231AbZLPNxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:53:52 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Added tlr_enabled bit in sas_device structure, which will have boolean
value 0 for disabled and 1 for enabled.

As suggested by James B, I have added sas_tlr_supported(),sas_enable_tlr(),
sas_disable_tlr() functions at SAS transport layer so that any other
Low layer driver can use those APIs.

SAS transport API sas_tlr_supported() will send vpd page 0x90,
to check the TLR support. If TLR is supported for end device, MPT2SAS driver
will enable the TLR bit in the SCSI_IO for every request. If there is a
response with MPI2_SCSITASKMGMT_RSP_INVALID_FRAME, the driver will turn off
the TLR logic.

Signed-off-by: Kashyap Desai <kashyap.desai@xxxxxxx>
Reviewed-by: Eric Moore <Eric.moore@xxxxxxx>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index b748893..d9492a9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1309,7 +1309,6 @@ _scsih_slave_alloc(struct scsi_device *sdev)
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
 	struct scsi_target *starget;
 	struct _raid_device *raid_device;
-	struct _sas_device *sas_device;
 	unsigned long flags;
 
 	sas_device_priv_data = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
@@ -1336,21 +1335,8 @@ _scsih_slave_alloc(struct scsi_device *sdev)
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
 
@@ -1617,6 +1603,32 @@ _scsih_get_volume_capabilities(struct MPT2SAS_ADAPTER *ioc,
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
+	/* only for TAPE */
+	if (sdev->type != TYPE_TAPE)
+		return;
+
+	if (!(ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_TLR))
+		return;
+
+	sas_enable_tlr(sdev);
+	sdev_printk(KERN_INFO, sdev, "TLR %s\n",
+	    sdev->tlr_enabled ? "Enabled" : "Disabled");
+	return;
+
+}
+
+/**
  * _scsih_slave_configure - device configure routine.
  * @sdev: scsi device struct
  *
@@ -1761,8 +1773,10 @@ _scsih_slave_configure(struct scsi_device *sdev)
 
 	_scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_DEFAULT);
 
-	if (ssp_target)
+	if (ssp_target) {
 		sas_read_port_mode_page(sdev);
+		_scsih_enable_tlr(ioc, sdev);
+	}
 	return 0;
 }
 
@@ -3049,7 +3063,7 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	} else
 		mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
 
-	if ((sas_device_priv_data->flags & MPT_DEVICE_TLR_ON))
+	if (scmd->device->tlr_enabled)
 		mpi_control |= MPI2_SCSIIO_CONTROL_TLR_ON;
 
 	smid = mpt2sas_base_get_smid_scsiio(ioc, ioc->scsi_io_cb_idx, scmd);
@@ -3438,10 +3452,11 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		    le32_to_cpu(mpi_reply->ResponseInfo) & 0xFF;
 	if (!sas_device_priv_data->tlr_snoop_check) {
 		sas_device_priv_data->tlr_snoop_check++;
-		if ((sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
-		    response_code == MPI2_SCSITASKMGMT_RSP_INVALID_FRAME)
-			sas_device_priv_data->flags &=
-			    ~MPT_DEVICE_TLR_ON;
+		if ((scmd->device->tlr_enabled) &&
+		    response_code == MPI2_SCSITASKMGMT_RSP_INVALID_FRAME) {
+			sas_disable_tlr(scmd->device);
+			sdev_printk(KERN_INFO, scmd->device, "TLR disabled\n");
+		}
 	}
 
 	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index fd47cb1..41b8eab 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -358,6 +358,61 @@ void sas_remove_host(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(sas_remove_host);
 
+/**
+ * sas_tlr_supported - checking TLR bit in vpd 0x90
+ * @sdev: scsi device struct
+ *
+ * Check Transport Layer Retries are supported or not.
+ * If vpd page 0x90 is present, TRL is supported.
+ *
+ */
+unsigned int
+sas_tlr_supported(struct scsi_device *sdev)
+{
+	char *buffer;
+
+	buffer = scsi_get_vpd_page(sdev, 0x90);
+	if (buffer == NULL)
+		return 0;
+
+	kfree(buffer);
+	return 1;
+
+}
+EXPORT_SYMBOL(sas_tlr_supported);
+
+/**
+ * sas_disable_tlr - setting TLR flags
+ * @sdev: scsi device struct
+ *
+ * Seting tlr_enabled flag to 0.
+ *
+ */
+void
+sas_disable_tlr(struct scsi_device *sdev)
+{
+	sdev->tlr_enabled = 0;
+}
+EXPORT_SYMBOL(sas_disable_tlr);
+
+/**
+ * sas_enable_tlr - setting TLR flags
+ * @sdev: scsi device struct
+ *
+ * Seting tlr_enabled flag 1.
+ *
+ */
+void sas_enable_tlr(struct scsi_device *sdev)
+{
+	unsigned int tlr_supported = 0;
+	tlr_supported  = sas_tlr_supported(sdev);
+
+	if (tlr_supported)
+		sdev->tlr_enabled = 1;
+
+	return;
+}
+EXPORT_SYMBOL(sas_enable_tlr);
 
 /*
  * SAS Phy attributes
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 68d185c..7c1361b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -112,6 +112,7 @@ struct scsi_device {
 				 * scsi_devinfo.[hc]. For now used only to
 				 * pass settings from slave_alloc to scsi
 				 * core. */
+	unsigned tlr_enabled:1;	/* set tlr flags */
 	unsigned writeable:1;
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 61ad359..2fb099f 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -181,6 +181,10 @@ extern int sas_phy_add(struct sas_phy *);
 extern void sas_phy_delete(struct sas_phy *);
 extern int scsi_is_sas_phy(const struct device *);
 
+unsigned int sas_tlr_supported(struct scsi_device *);
+void sas_disable_tlr(struct scsi_device *);
+void sas_enable_tlr(struct scsi_device *);
+
 extern struct sas_rphy *sas_end_device_alloc(struct sas_port *);
 extern struct sas_rphy *sas_expander_alloc(struct sas_port *, enum sas_device_type);
 void sas_rphy_free(struct sas_rphy *);
