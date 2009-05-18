From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 4/5] mpt2sas: using the same naming convention for all static function
Date: Mon, 18 May 2009 13:02:08 -0600
Message-ID: <20090518190206.GE26609@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:56573 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZERS4T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2009 14:56:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

This fix's is for all local function so their name has the "_" preceeding
the module name, then function name.  Most the code is already is using this
naming convention.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-05-18 12:23:24.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-05-18 12:23:24.000000000 -0600
@@ -197,12 +197,12 @@ static struct pci_device_id scsih_pci_ta
 MODULE_DEVICE_TABLE(pci, scsih_pci_table);
 
 /**
- * scsih_set_debug_level - global setting of ioc->logging_level.
+ * _scsih_set_debug_level - global setting of ioc->logging_level.
  *
  * Note: The logging levels are defined in mpt2sas_debug.h.
  */
 static int
-scsih_set_debug_level(const char *val, struct kernel_param *kp)
+_scsih_set_debug_level(const char *val, struct kernel_param *kp)
 {
 	int ret = param_set_int(val, kp);
 	struct MPT2SAS_ADAPTER *ioc;
@@ -215,7 +215,7 @@ scsih_set_debug_level(const char *val, s
 		ioc->logging_level = logging_level;
 	return 0;
 }
-module_param_call(logging_level, scsih_set_debug_level, param_get_int,
+module_param_call(logging_level, _scsih_set_debug_level, param_get_int,
     &logging_level, 0644);
 
 /**
@@ -1082,14 +1082,14 @@ _scsih_build_scatter_gather(struct MPT2S
 }
 
 /**
- * scsih_change_queue_depth - setting device queue depth
+ * _scsih_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
  *
  * Returns queue depth.
  */
 static int
-scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
+_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	struct Scsi_Host *shost = sdev->host;
 	int max_depth;
@@ -1114,14 +1114,14 @@ scsih_change_queue_depth(struct scsi_dev
 }
 
 /**
- * scsih_change_queue_depth - changing device queue tag type
+ * _scsih_change_queue_depth - changing device queue tag type
  * @sdev: scsi device struct
  * @tag_type: requested tag type
  *
  * Returns queue tag type.
  */
 static int
-scsih_change_queue_type(struct scsi_device *sdev, int tag_type)
+_scsih_change_queue_type(struct scsi_device *sdev, int tag_type)
 {
 	if (sdev->tagged_supported) {
 		scsi_set_tag_type(sdev, tag_type);
@@ -1136,14 +1136,14 @@ scsih_change_queue_type(struct scsi_devi
 }
 
 /**
- * scsih_target_alloc - target add routine
+ * _scsih_target_alloc - target add routine
  * @starget: scsi target struct
  *
  * Returns 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
 static int
-scsih_target_alloc(struct scsi_target *starget)
+_scsih_target_alloc(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
@@ -1198,13 +1198,13 @@ scsih_target_alloc(struct scsi_target *s
 }
 
 /**
- * scsih_target_destroy - target destroy routine
+ * _scsih_target_destroy - target destroy routine
  * @starget: scsi target struct
  *
  * Returns nothing.
  */
 static void
-scsih_target_destroy(struct scsi_target *starget)
+_scsih_target_destroy(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
@@ -1247,14 +1247,14 @@ scsih_target_destroy(struct scsi_target
 }
 
 /**
- * scsih_slave_alloc - device add routine
+ * _scsih_slave_alloc - device add routine
  * @sdev: scsi device struct
  *
  * Returns 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
 static int
-scsih_slave_alloc(struct scsi_device *sdev)
+_scsih_slave_alloc(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost;
 	struct MPT2SAS_ADAPTER *ioc;
@@ -1308,13 +1308,13 @@ scsih_slave_alloc(struct scsi_device *sd
 }
 
 /**
- * scsih_slave_destroy - device destroy routine
+ * _scsih_slave_destroy - device destroy routine
  * @sdev: scsi device struct
  *
  * Returns nothing.
  */
 static void
-scsih_slave_destroy(struct scsi_device *sdev)
+_scsih_slave_destroy(struct scsi_device *sdev)
 {
 	struct MPT2SAS_TARGET *sas_target_priv_data;
 	struct scsi_target *starget;
@@ -1330,13 +1330,13 @@ scsih_slave_destroy(struct scsi_device *
 }
 
 /**
- * scsih_display_sata_capabilities - sata capabilities
+ * _scsih_display_sata_capabilities - sata capabilities
  * @ioc: per adapter object
  * @sas_device: the sas_device object
  * @sdev: scsi device struct
  */
 static void
-scsih_display_sata_capabilities(struct MPT2SAS_ADAPTER *ioc,
+_scsih_display_sata_capabilities(struct MPT2SAS_ADAPTER *ioc,
     struct _sas_device *sas_device, struct scsi_device *sdev)
 {
 	Mpi2ConfigReply_t mpi_reply;
@@ -1436,14 +1436,14 @@ _scsih_get_volume_capabilities(struct MP
 }
 
 /**
- * scsih_slave_configure - device configure routine.
+ * _scsih_slave_configure - device configure routine.
  * @sdev: scsi device struct
  *
  * Returns 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
 static int
-scsih_slave_configure(struct scsi_device *sdev)
+_scsih_slave_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
@@ -1524,7 +1524,7 @@ scsih_slave_configure(struct scsi_device
 		    r_level, raid_device->handle,
 		    (unsigned long long)raid_device->wwid,
 		    raid_device->num_pds, ds);
-		scsih_change_queue_depth(sdev, qdepth);
+		_scsih_change_queue_depth(sdev, qdepth);
 		return 0;
 	}
 
@@ -1567,10 +1567,10 @@ scsih_slave_configure(struct scsi_device
 		    sas_device->slot);
 
 		if (!ssp_target)
-			scsih_display_sata_capabilities(ioc, sas_device, sdev);
+			_scsih_display_sata_capabilities(ioc, sas_device, sdev);
 	}
 
-	scsih_change_queue_depth(sdev, qdepth);
+	_scsih_change_queue_depth(sdev, qdepth);
 
 	if (ssp_target)
 		sas_read_port_mode_page(sdev);
@@ -1578,7 +1578,7 @@ scsih_slave_configure(struct scsi_device
 }
 
 /**
- * scsih_bios_param - fetch head, sector, cylinder info for a disk
+ * _scsih_bios_param - fetch head, sector, cylinder info for a disk
  * @sdev: scsi device struct
  * @bdev: pointer to block device context
  * @capacity: device size (in 512 byte sectors)
@@ -1590,7 +1590,7 @@ scsih_slave_configure(struct scsi_device
  * Return nothing.
  */
 static int
-scsih_bios_param(struct scsi_device *sdev, struct block_device *bdev,
+_scsih_bios_param(struct scsi_device *sdev, struct block_device *bdev,
     sector_t capacity, int params[])
 {
 	int		heads;
@@ -1671,7 +1671,7 @@ _scsih_response_code(struct MPT2SAS_ADAP
 }
 
 /**
- * scsih_tm_done - tm completion routine
+ * _scsih_tm_done - tm completion routine
  * @ioc: per adapter object
  * @smid: system request message index
  * @VF_ID: virtual function id
@@ -1683,7 +1683,7 @@ _scsih_response_code(struct MPT2SAS_ADAP
  * Return nothing.
  */
 static void
-scsih_tm_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+_scsih_tm_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 {
 	MPI2DefaultReply_t *mpi_reply;
 
@@ -1858,13 +1858,13 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_AD
 }
 
 /**
- * scsih_abort - eh threads main abort routine
+ * _scsih_abort - eh threads main abort routine
  * @sdev: scsi device struct
  *
  * Returns SUCCESS if command aborted else FAILED
  */
 static int
-scsih_abort(struct scsi_cmnd *scmd)
+_scsih_abort(struct scsi_cmnd *scmd)
 {
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
@@ -1925,13 +1925,13 @@ scsih_abort(struct scsi_cmnd *scmd)
 }
 
 /**
- * scsih_dev_reset - eh threads main device reset routine
+ * _scsih_dev_reset - eh threads main device reset routine
  * @sdev: scsi device struct
  *
  * Returns SUCCESS if command aborted else FAILED
  */
 static int
-scsih_dev_reset(struct scsi_cmnd *scmd)
+_scsih_dev_reset(struct scsi_cmnd *scmd)
 {
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
@@ -1997,13 +1997,13 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 }
 
 /**
- * scsih_target_reset - eh threads main target reset routine
+ * _scsih_target_reset - eh threads main target reset routine
  * @sdev: scsi device struct
  *
  * Returns SUCCESS if command aborted else FAILED
  */
 static int
-scsih_target_reset(struct scsi_cmnd *scmd)
+_scsih_target_reset(struct scsi_cmnd *scmd)
 {
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
@@ -2068,13 +2068,13 @@ scsih_target_reset(struct scsi_cmnd *scm
 }
 
 /**
- * scsih_abort - eh threads main host reset routine
+ * _scsih_abort - eh threads main host reset routine
  * @sdev: scsi device struct
  *
  * Returns SUCCESS if command aborted else FAILED
  */
 static int
-scsih_host_reset(struct scsi_cmnd *scmd)
+_scsih_host_reset(struct scsi_cmnd *scmd)
 {
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	int r, retval;
@@ -2596,7 +2596,7 @@ _scsih_eedp_error_handling(struct scsi_c
 }
 
 /**
- * scsih_qcmd - main scsi request entry point
+ * _scsih_qcmd - main scsi request entry point
  * @scmd: pointer to scsi command object
  * @done: function pointer to be invoked on completion
  *
@@ -2607,7 +2607,7 @@ _scsih_eedp_error_handling(struct scsi_c
  * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
  */
 static int
-scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
+_scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 {
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
@@ -2999,7 +2999,7 @@ _scsih_smart_predicted_fault(struct MPT2
 }
 
 /**
- * scsih_io_done - scsi request callback
+ * _scsih_io_done - scsi request callback
  * @ioc: per adapter object
  * @smid: system request message index
  * @VF_ID: virtual function id
@@ -3010,7 +3010,7 @@ _scsih_smart_predicted_fault(struct MPT2
  * Return nothing.
  */
 static void
-scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
+_scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply)
 {
 	Mpi2SCSIIORequest_t *mpi_request;
 	Mpi2SCSIIOReply_t *mpi_reply;
@@ -5351,19 +5351,19 @@ static struct scsi_host_template scsih_d
 	.module				= THIS_MODULE,
 	.name				= "Fusion MPT SAS Host",
 	.proc_name			= MPT2SAS_DRIVER_NAME,
-	.queuecommand			= scsih_qcmd,
-	.target_alloc			= scsih_target_alloc,
-	.slave_alloc			= scsih_slave_alloc,
-	.slave_configure		= scsih_slave_configure,
-	.target_destroy			= scsih_target_destroy,
-	.slave_destroy			= scsih_slave_destroy,
-	.change_queue_depth 		= scsih_change_queue_depth,
-	.change_queue_type		= scsih_change_queue_type,
-	.eh_abort_handler		= scsih_abort,
-	.eh_device_reset_handler	= scsih_dev_reset,
-	.eh_target_reset_handler	= scsih_target_reset,
-	.eh_host_reset_handler		= scsih_host_reset,
-	.bios_param			= scsih_bios_param,
+	.queuecommand			= _scsih_qcmd,
+	.target_alloc			= _scsih_target_alloc,
+	.slave_alloc			= _scsih_slave_alloc,
+	.slave_configure		= _scsih_slave_configure,
+	.target_destroy			= _scsih_target_destroy,
+	.slave_destroy			= _scsih_slave_destroy,
+	.change_queue_depth 		= _scsih_change_queue_depth,
+	.change_queue_type		= _scsih_change_queue_type,
+	.eh_abort_handler		= _scsih_abort,
+	.eh_device_reset_handler	= _scsih_dev_reset,
+	.eh_target_reset_handler	= _scsih_target_reset,
+	.eh_host_reset_handler		= _scsih_host_reset,
+	.bios_param			= _scsih_bios_param,
 	.can_queue			= 1,
 	.this_id			= -1,
 	.sg_tablesize			= MPT2SAS_SG_DEPTH,
@@ -5450,13 +5450,13 @@ _scsih_expander_node_remove(struct MPT2S
 }
 
 /**
- * scsih_remove - detach and remove add host
+ * _scsih_remove - detach and remove add host
  * @pdev: PCI device struct
  *
  * Return nothing.
  */
 static void __devexit
-scsih_remove(struct pci_dev *pdev)
+_scsih_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
@@ -5664,14 +5664,14 @@ _scsih_probe_devices(struct MPT2SAS_ADAP
 }
 
 /**
- * scsih_probe - attach and add scsi host
+ * _scsih_probe - attach and add scsi host
  * @pdev: PCI device struct
  * @id: pci device id
  *
  * Returns 0 success, anything else error.
  */
 static int
-scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+_scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct MPT2SAS_ADAPTER *ioc;
 	struct Scsi_Host *shost;
@@ -5761,14 +5761,14 @@ scsih_probe(struct pci_dev *pdev, const
 
 #ifdef CONFIG_PM
 /**
- * scsih_suspend - power management suspend main entry point
+ * _scsih_suspend - power management suspend main entry point
  * @pdev: PCI device struct
  * @state: PM state change to (usually PCI_D3)
  *
  * Returns 0 success, anything else error.
  */
 static int
-scsih_suspend(struct pci_dev *pdev, pm_message_t state)
+_scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
@@ -5789,13 +5789,13 @@ scsih_suspend(struct pci_dev *pdev, pm_m
 }
 
 /**
- * scsih_resume - power management resume main entry point
+ * _scsih_resume - power management resume main entry point
  * @pdev: PCI device struct
  *
  * Returns 0 success, anything else error.
  */
 static int
-scsih_resume(struct pci_dev *pdev)
+_scsih_resume(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
@@ -5824,22 +5824,22 @@ scsih_resume(struct pci_dev *pdev)
 static struct pci_driver scsih_driver = {
 	.name		= MPT2SAS_DRIVER_NAME,
 	.id_table	= scsih_pci_table,
-	.probe		= scsih_probe,
-	.remove		= __devexit_p(scsih_remove),
+	.probe		= _scsih_probe,
+	.remove		= __devexit_p(_scsih_remove),
 #ifdef CONFIG_PM
-	.suspend	= scsih_suspend,
-	.resume		= scsih_resume,
+	.suspend	= _scsih_suspend,
+	.resume		= _scsih_resume,
 #endif
 };
 
 
 /**
- * scsih_init - main entry point for this driver.
+ * _scsih_init - main entry point for this driver.
  *
  * Returns 0 success, anything else error.
  */
 static int __init
-scsih_init(void)
+_scsih_init(void)
 {
 	int error;
 
@@ -5855,10 +5855,10 @@ scsih_init(void)
 	mpt2sas_base_initialize_callback_handler();
 
 	 /* queuecommand callback hander */
-	scsi_io_cb_idx = mpt2sas_base_register_callback_handler(scsih_io_done);
+	scsi_io_cb_idx = mpt2sas_base_register_callback_handler(_scsih_io_done);
 
 	/* task managment callback handler */
-	tm_cb_idx = mpt2sas_base_register_callback_handler(scsih_tm_done);
+	tm_cb_idx = mpt2sas_base_register_callback_handler(_scsih_tm_done);
 
 	/* base internal commands callback handler */
 	base_cb_idx = mpt2sas_base_register_callback_handler(mpt2sas_base_done);
@@ -5884,12 +5884,12 @@ scsih_init(void)
 }
 
 /**
- * scsih_exit - exit point for this driver (when it is a module).
+ * _scsih_exit - exit point for this driver (when it is a module).
  *
  * Returns 0 success, anything else error.
  */
 static void __exit
-scsih_exit(void)
+_scsih_exit(void)
 {
 	printk(KERN_INFO "mpt2sas version %s unloading\n",
 	    MPT2SAS_DRIVER_VERSION);
@@ -5907,5 +5907,5 @@ scsih_exit(void)
 	mpt2sas_ctl_exit();
 }
 
-module_init(scsih_init);
-module_exit(scsih_exit);
+module_init(_scsih_init);
+module_exit(_scsih_exit);
diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c	2009-05-18 12:23:24.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c	2009-05-18 12:23:24.000000000 -0600
@@ -264,7 +264,7 @@ struct rep_manu_reply{
 };
 
 /**
- * transport_expander_report_manufacture - obtain SMP report_manufacture
+ * _transport_expander_report_manufacture - obtain SMP report_manufacture
  * @ioc: per adapter object
  * @sas_address: expander sas address
  * @edev: the sas_expander_device object
@@ -274,7 +274,7 @@ struct rep_manu_reply{
  * Returns 0 for success, non-zero for failure.
  */
 static int
-transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
+_transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
     u64 sas_address, struct sas_expander_device *edev)
 {
 	Mpi2SmpPassthroughRequest_t *mpi_request;
@@ -578,7 +578,7 @@ mpt2sas_transport_port_add(struct MPT2SA
 	    MPI2_SAS_DEVICE_INFO_EDGE_EXPANDER ||
 	    mpt2sas_port->remote_identify.device_type ==
 	    MPI2_SAS_DEVICE_INFO_FANOUT_EXPANDER)
-		transport_expander_report_manufacture(ioc,
+		_transport_expander_report_manufacture(ioc,
 		    mpt2sas_port->remote_identify.sas_address,
 		    rphy_to_expander_device(rphy));
 
@@ -852,7 +852,7 @@ rphy_to_ioc(struct sas_rphy *rphy)
 }
 
 /**
- * transport_get_linkerrors -
+ * _transport_get_linkerrors -
  * @phy: The sas phy object
  *
  * Only support sas_host direct attached phys.
@@ -860,7 +860,7 @@ rphy_to_ioc(struct sas_rphy *rphy)
  *
  */
 static int
-transport_get_linkerrors(struct sas_phy *phy)
+_transport_get_linkerrors(struct sas_phy *phy)
 {
 	struct MPT2SAS_ADAPTER *ioc = phy_to_ioc(phy);
 	struct _sas_phy *mpt2sas_phy;
@@ -903,14 +903,14 @@ transport_get_linkerrors(struct sas_phy
 }
 
 /**
- * transport_get_enclosure_identifier -
+ * _transport_get_enclosure_identifier -
  * @phy: The sas phy object
  *
  * Obtain the enclosure logical id for an expander.
  * Returns 0 for success, non-zero for failure.
  */
 static int
-transport_get_enclosure_identifier(struct sas_rphy *rphy, u64 *identifier)
+_transport_get_enclosure_identifier(struct sas_rphy *rphy, u64 *identifier)
 {
 	struct MPT2SAS_ADAPTER *ioc = rphy_to_ioc(rphy);
 	struct _sas_node *sas_expander;
@@ -929,13 +929,13 @@ transport_get_enclosure_identifier(struc
 }
 
 /**
- * transport_get_bay_identifier -
+ * _transport_get_bay_identifier -
  * @phy: The sas phy object
  *
  * Returns the slot id for a device that resides inside an enclosure.
  */
 static int
-transport_get_bay_identifier(struct sas_rphy *rphy)
+_transport_get_bay_identifier(struct sas_rphy *rphy)
 {
 	struct MPT2SAS_ADAPTER *ioc = rphy_to_ioc(rphy);
 	struct _sas_device *sas_device;
@@ -953,7 +953,7 @@ transport_get_bay_identifier(struct sas_
 }
 
 /**
- * transport_phy_reset -
+ * _transport_phy_reset -
  * @phy: The sas phy object
  * @hard_reset:
  *
@@ -961,7 +961,7 @@ transport_get_bay_identifier(struct sas_
  * Returns 0 for success, non-zero for failure.
  */
 static int
-transport_phy_reset(struct sas_phy *phy, int hard_reset)
+_transport_phy_reset(struct sas_phy *phy, int hard_reset)
 {
 	struct MPT2SAS_ADAPTER *ioc = phy_to_ioc(phy);
 	struct _sas_phy *mpt2sas_phy;
@@ -1002,7 +1002,7 @@ transport_phy_reset(struct sas_phy *phy,
 }
 
 /**
- * transport_smp_handler - transport portal for smp passthru
+ * _transport_smp_handler - transport portal for smp passthru
  * @shost: shost object
  * @rphy: sas transport rphy object
  * @req:
@@ -1012,7 +1012,7 @@ transport_phy_reset(struct sas_phy *phy,
  *           smp_rep_general /sys/class/bsg/expander-5:0
  */
 static int
-transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
+_transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
     struct request *req)
 {
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
@@ -1201,11 +1201,11 @@ transport_smp_handler(struct Scsi_Host *
 }
 
 struct sas_function_template mpt2sas_transport_functions = {
-	.get_linkerrors		= transport_get_linkerrors,
-	.get_enclosure_identifier = transport_get_enclosure_identifier,
-	.get_bay_identifier	= transport_get_bay_identifier,
-	.phy_reset		= transport_phy_reset,
-	.smp_handler		= transport_smp_handler,
+	.get_linkerrors		= _transport_get_linkerrors,
+	.get_enclosure_identifier = _transport_get_enclosure_identifier,
+	.get_bay_identifier	= _transport_get_bay_identifier,
+	.phy_reset		= _transport_phy_reset,
+	.smp_handler		= _transport_smp_handler,
 };
 
 struct scsi_transport_template *mpt2sas_transport_template;
