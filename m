From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 19/25] mpt3sas: Single driver module which supports both SAS 2.0 & SAS 3.0 HBA's
Date: Wed, 11 Nov 2015 17:30:35 +0530
Message-ID: <1447243241-10912-20-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Modified the mpt3sas driver to have a single driver module which
support both SAS 2.0 & SAS 3.0 HBA devices,

Change List:
* Added SAS 2.0 HBA device IDs to the mpt3sas_pci_table pci table.
* Created two separate SCSI host templates for SAS2 and SAS3 HBAs.
  so that, during the driver load time driver can use
  corresponding host template(based the pci device ID) while
  registering a scsi host adapter instance for that pci device.
* Registered two IOCTL devices, mpt2ctl is for SAS2 HBAs & mpt3ctl
  for SAS3 HBAs. Also updated the code to make sure that mpt2ctl
  device to process only those ioctl cmds issued for the SAS2 HBAs
  and mpt3ctl device to process only those ioctl cmds issued for
  the SAS3 HBAs.
* Added two separate indexing for SAS2 and SAS3 HBAs.
* Replaced compile time check 'MPT2SAS_SCSI' to run time check
  'hba_mpi_version_belonged' whereever needed.
* Aliased this merged driver to mpt2sas using MODULE_ALIAS.
* Moved global varaible 'driver_name' to per adapter instance variable.
* Created two raid function template and used corresponding
  raid function templates based on the run time check
  'hba_mpi_version_belonged'.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/Kconfig          |  16 +-
 drivers/scsi/mpt3sas/Makefile         |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c   |  11 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  45 +---
 drivers/scsi/mpt3sas/mpt3sas_config.c |   2 -
 drivers/scsi/mpt3sas/mpt3sas_ctl.c    | 139 +++++++++---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  | 405 +++++++++++++++++++++++++++-------
 7 files changed, 462 insertions(+), 159 deletions(-)

diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
index 18b64bc..2906146 100644
--- a/drivers/scsi/mpt3sas/Kconfig
+++ b/drivers/scsi/mpt3sas/Kconfig
@@ -41,15 +41,27 @@
 # USA.
 
 config SCSI_MPT3SAS
-	tristate "LSI MPT Fusion SAS 3.0 Device Driver"
+	tristate "LSI MPT Fusion SAS 3.0 & SAS 2.0 Device Driver"
 	depends on PCI && SCSI
 	select SCSI_SAS_ATTRS
 	select RAID_ATTRS
 	---help---
 	This driver supports PCI-Express SAS 12Gb/s Host Adapters.
 
+config SCSI_MPT2SAS_MAX_SGE
+	int "LSI MPT Fusion SAS 2.0 Max number of SG Entries (16 - 256)"
+	depends on PCI && SCSI && SCSI_MPT3SAS
+	default "128"
+	range 16 256
+	---help---
+	This option allows you to specify the maximum number of scatter-
+	gather entries per I/O. The driver default is 128, which matches
+	MAX_PHYS_SEGMENTS in most kernels.  However in SuSE kernels this
+	can be 256. However, it may decreased down to 16.  Decreasing this
+	parameter will reduce memory requirements on a per controller instance.
+
 config SCSI_MPT3SAS_MAX_SGE
-	int "LSI MPT Fusion Max number of SG Entries (16 - 256)"
+	int "LSI MPT Fusion SAS 3.0 Max number of SG Entries (16 - 256)"
 	depends on PCI && SCSI && SCSI_MPT3SAS
 	default "128"
 	range 16 256
diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefile
index 188057f..efb0c4c 100644
--- a/drivers/scsi/mpt3sas/Makefile
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -5,5 +5,4 @@ mpt3sas-y +=  mpt3sas_base.o     \
 		mpt3sas_scsih.o      \
 		mpt3sas_transport.o     \
 		mpt3sas_ctl.o	\
-		mpt3sas_trigger_diag.o \
-		mpt3sas_module.o
+		mpt3sas_trigger_diag.o
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f5d589e..11393eb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -198,7 +198,7 @@ _base_fault_reset_work(struct work_struct *work)
 		ioc->remove_host = 1;
 		/*Remove the Dead Host */
 		p = kthread_run(mpt3sas_remove_dead_ioc_func, ioc,
-		    "mpt3sas_dead_ioc_%d", ioc->id);
+		    "%s_dead_ioc_%d", ioc->driver_name, ioc->id);
 		if (IS_ERR(p))
 			pr_err(MPT3SAS_FMT
 			"%s: Running mpt3sas_dead_ioc thread failed !!!!\n",
@@ -254,7 +254,8 @@ mpt3sas_base_start_watchdog(struct MPT3SAS_ADAPTER *ioc)
 
 	INIT_DELAYED_WORK(&ioc->fault_reset_work, _base_fault_reset_work);
 	snprintf(ioc->fault_reset_work_q_name,
-	    sizeof(ioc->fault_reset_work_q_name), "poll_%d_status", ioc->id);
+	    sizeof(ioc->fault_reset_work_q_name), "poll_%s%d_status",
+	    ioc->driver_name, ioc->id);
 	ioc->fault_reset_work_q =
 		create_singlethread_workqueue(ioc->fault_reset_work_q_name);
 	if (!ioc->fault_reset_work_q) {
@@ -1835,10 +1836,10 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
 	atomic_set(&reply_q->busy, 0);
 	if (ioc->msix_enable)
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
-		    driver_name, ioc->id, index);
+		    ioc->driver_name, ioc->id, index);
 	else
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d",
-		    driver_name, ioc->id);
+		    ioc->driver_name, ioc->id);
 	r = request_irq(vector, _base_interrupt, IRQF_SHARED, reply_q->name,
 	    reply_q);
 	if (r) {
@@ -2064,7 +2065,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 
 
 	if (pci_request_selected_regions(pdev, ioc->bars,
-	    driver_name)) {
+	    ioc->driver_name)) {
 		pr_warn(MPT3SAS_FMT "pci_request_selected_regions: failed\n",
 			ioc->name);
 		ioc->bars = 0;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 213d7f8..08bedb6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -935,6 +935,7 @@ struct MPT3SAS_ADAPTER {
 	u8		id;
 	int		cpu_count;
 	char		name[MPT_NAME_LENGTH];
+	char		driver_name[MPT_NAME_LENGTH];
 	char		tmp_string[MPT_STRING_LENGTH];
 	struct pci_dev	*pdev;
 	Mpi2SystemInterfaceRegs_t __iomem *chip;
@@ -1246,7 +1247,6 @@ int mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc);
 
 
 /* scsih shared API */
-extern struct raid_template *mpt3sas_raid_template;
 u8 mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	u32 reply);
 void mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase);
@@ -1271,39 +1271,6 @@ struct _sas_device *__mpt3sas_get_sdev_by_addr(
 
 void mpt3sas_port_enable_complete(struct MPT3SAS_ADAPTER *ioc);
 
-void scsih_exit(void);
-int scsih_init(void);
-int scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost);
-void scsih_remove(struct pci_dev *pdev);
-void scsih_shutdown(struct pci_dev *pdev);
-pci_ers_result_t scsih_pci_error_detected(struct pci_dev *pdev,
-	pci_channel_state_t state);
-pci_ers_result_t scsih_pci_mmio_enabled(struct pci_dev *pdev);
-pci_ers_result_t scsih_pci_slot_reset(struct pci_dev *pdev);
-void scsih_pci_resume(struct pci_dev *pdev);
-int scsih_suspend(struct pci_dev *pdev, pm_message_t state);
-int scsih_resume(struct pci_dev *pdev);
-
-int scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd);
-int scsih_target_alloc(struct scsi_target *starget);
-int scsih_slave_alloc(struct scsi_device *sdev);
-int scsih_slave_configure(struct scsi_device *sdev);
-void scsih_target_destroy(struct scsi_target *starget);
-void scsih_slave_destroy(struct scsi_device *sdev);
-int scsih_scan_finished(struct Scsi_Host *shost, unsigned long time);
-void scsih_scan_start(struct Scsi_Host *shost);
-int scsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
-int scsih_abort(struct scsi_cmnd *scmd);
-int scsih_dev_reset(struct scsi_cmnd *scmd);
-int scsih_target_reset(struct scsi_cmnd *scmd);
-int scsih_host_reset(struct scsi_cmnd *scmd);
-int scsih_bios_param(struct scsi_device *sdev, struct block_device *bdev,
-	sector_t capacity, int params[]);
-
-int scsih_is_raid(struct device *dev);
-void scsih_get_resync(struct device *dev);
-void scsih_get_state(struct device *dev);
-
 /* config shared API */
 u8 mpt3sas_config_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
@@ -1342,10 +1309,8 @@ int mpt3sas_config_get_sas_iounit_pg0(struct MPT3SAS_ADAPTER *ioc,
 	u16 sz);
 int mpt3sas_config_get_iounit_pg1(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	*mpi_reply, Mpi2IOUnitPage1_t *config_page);
-#ifdef SCSI_MPT2SAS
 int mpt3sas_config_get_iounit_pg3(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage3_t *config_page, u16 sz);
-#endif
 int mpt3sas_config_set_iounit_pg1(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
 	*mpi_reply, Mpi2IOUnitPage1_t *config_page);
 int mpt3sas_config_get_iounit_pg8(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
@@ -1390,12 +1355,8 @@ int mpt3sas_config_get_volume_wwid(struct MPT3SAS_ADAPTER *ioc,
 /* ctl shared API */
 extern struct device_attribute *mpt3sas_host_attrs[];
 extern struct device_attribute *mpt3sas_dev_attrs[];
-long ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
-unsigned int ctl_poll(struct file *filep, poll_table *wait);
-int ctl_fasync(int fd, struct file *filep, int mode);
-long ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg);
-void ctl_init(void);
-void ctl_exit(void);
+void mpt3sas_ctl_init(void);
+void mpt3sas_ctl_exit(void);
 u8 mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
 void mpt3sas_ctl_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 2bbb034..a6914ec 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -865,7 +865,6 @@ mpt3sas_config_set_iounit_pg1(struct MPT3SAS_ADAPTER *ioc,
 	return r;
 }
 
-#ifdef SCSI_MPT2SAS
 /**
  * mpt3sas_config_get_iounit_pg3 - obtain iounit page 3
  * @ioc: per adapter object
@@ -901,7 +900,6 @@ mpt3sas_config_get_iounit_pg3(struct MPT3SAS_ADAPTER *ioc,
  out:
 	return r;
 }
-#endif
 
 /**
  * mpt3sas_config_get_iounit_pg8 - obtain iounit page 8
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index f257c96..05b0733 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -409,11 +409,14 @@ mpt3sas_ctl_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
  * _ctl_verify_adapter - validates ioc_number passed from application
  * @ioc: per adapter object
  * @iocpp: The ioc pointer is returned in this.
+ * @mpi_version: will be MPI2_VERSION for mpt2ctl ioctl device &
+ *		MPI25_VERSION for mpt3ctl ioctl device.
  *
  * Return (-1) means error, else ioc_number.
  */
 static int
-_ctl_verify_adapter(int ioc_number, struct MPT3SAS_ADAPTER **iocpp)
+_ctl_verify_adapter(int ioc_number, struct MPT3SAS_ADAPTER **iocpp,
+							int mpi_version)
 {
 	struct MPT3SAS_ADAPTER *ioc;
 	/* global ioc lock to protect controller on list operations */
@@ -421,6 +424,11 @@ _ctl_verify_adapter(int ioc_number, struct MPT3SAS_ADAPTER **iocpp)
 	list_for_each_entry(ioc, &mpt3sas_ioc_list, list) {
 		if (ioc->id != ioc_number)
 			continue;
+		/* Check whether this ioctl command is from right
+		 * ioctl device or not, if not continue the search.
+		 */
+		if (ioc->hba_mpi_version_belonged != mpi_version)
+			continue;
 		spin_unlock(&gioc_lock);
 		*iocpp = ioc;
 		return ioc_number;
@@ -488,7 +496,7 @@ mpt3sas_ctl_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase)
 }
 
 /**
- * ctl_fasync -
+ * _ctl_fasync -
  * @fd -
  * @filep -
  * @mode -
@@ -496,19 +504,19 @@ mpt3sas_ctl_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase)
  * Called when application request fasyn callback handler.
  */
 int
-ctl_fasync(int fd, struct file *filep, int mode)
+_ctl_fasync(int fd, struct file *filep, int mode)
 {
 	return fasync_helper(fd, filep, mode, &async_queue);
 }
 
 /**
- * ctl_poll -
+ * _ctl_poll -
  * @file -
  * @wait -
  *
  */
 unsigned int
-ctl_poll(struct file *filep, poll_table *wait)
+_ctl_poll(struct file *filep, poll_table *wait)
 {
 	struct MPT3SAS_ADAPTER *ioc;
 
@@ -1034,7 +1042,7 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	karg.pci_information.u.bits.function = PCI_FUNC(ioc->pdev->devfn);
 	karg.pci_information.segment_id = pci_domain_nr(ioc->pdev->bus);
 	karg.firmware_version = ioc->facts.FWVersion.Word;
-	strcpy(karg.driver_version, driver_name);
+	strcpy(karg.driver_version, ioc->driver_name);
 	strcat(karg.driver_version, "-");
 	switch  (ioc->hba_mpi_version_belonged) {
 	case MPI2_VERSION:
@@ -1049,10 +1057,6 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		strcat(karg.driver_version, MPT3SAS_DRIVER_VERSION);
 		break;
 	}
-	if (ioc->hba_mpi_version_belonged == MPI2_VERSION)
-		strcat(karg.driver_version, MPT2SAS_DRIVER_VERSION);
-	else
-		strcat(karg.driver_version, MPT3SAS_DRIVER_VERSION);
 	karg.bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
 
 	if (copy_to_user(arg, &karg, sizeof(karg))) {
@@ -2196,12 +2200,14 @@ _ctl_compat_mpt_command(struct MPT3SAS_ADAPTER *ioc, unsigned cmd,
  * _ctl_ioctl_main - main ioctl entry point
  * @file - (struct file)
  * @cmd - ioctl opcode
- * @arg -
- * compat - handles 32 bit applications in 64bit os
+ * @arg - user space data buffer
+ * @compat - handles 32 bit applications in 64bit os
+ * @mpi_version: will be MPI2_VERSION for mpt2ctl ioctl device &
+ *		MPI25_VERSION for mpt3ctl ioctl device.
  */
 static long
 _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
-	u8 compat)
+	u8 compat, u16 mpi_version)
 {
 	struct MPT3SAS_ADAPTER *ioc;
 	struct mpt3_ioctl_header ioctl_header;
@@ -2216,7 +2222,8 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 		return -EFAULT;
 	}
 
-	if (_ctl_verify_adapter(ioctl_header.ioc_number, &ioc) == -1 || !ioc)
+	if (_ctl_verify_adapter(ioctl_header.ioc_number,
+				&ioc, mpi_version) == -1 || !ioc)
 		return -ENODEV;
 
 	/* pci_access_mutex lock acquired by ioctl path */
@@ -2324,23 +2331,43 @@ out_unlock_pciaccess:
 }
 
 /**
- * ctl_ioctl - main ioctl entry point (unlocked)
+ * _ctl_ioctl - mpt3ctl main ioctl entry point (unlocked)
  * @file - (struct file)
  * @cmd - ioctl opcode
  * @arg -
  */
 long
-ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 
-	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg, 0);
+	/* pass MPI25_VERSION value, to indicate that this ioctl cmd
+	 * came from mpt3ctl ioctl device.
+	 */
+	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg, 0, MPI25_VERSION);
 	return ret;
 }
 
+/**
+ * _ctl_mpt2_ioctl - mpt2ctl main ioctl entry point (unlocked)
+ * @file - (struct file)
+ * @cmd - ioctl opcode
+ * @arg -
+ */
+long
+_ctl_mpt2_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	/* pass MPI2_VERSION value, to indicate that this ioctl cmd
+	 * came from mpt2ctl ioctl device.
+	 */
+	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg, 0, MPI2_VERSION);
+	return ret;
+}
 #ifdef CONFIG_COMPAT
 /**
- * ctl_ioctl_compat - main ioctl entry point (compat)
+ *_ ctl_ioctl_compat - main ioctl entry point (compat)
  * @file -
  * @cmd -
  * @arg -
@@ -2348,11 +2375,28 @@ ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
  * This routine handles 32 bit applications in 64bit os.
  */
 long
-ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
+_ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
 {
 	long ret;
 
-	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg, 1);
+	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg, 1, MPI25_VERSION);
+	return ret;
+}
+
+/**
+ *_ ctl_mpt2_ioctl_compat - main ioctl entry point (compat)
+ * @file -
+ * @cmd -
+ * @arg -
+ *
+ * This routine handles 32 bit applications in 64bit os.
+ */
+long
+_ctl_mpt2_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
+{
+	long ret;
+
+	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg, 1, MPI2_VERSION);
 	return ret;
 }
 #endif
@@ -2739,7 +2783,6 @@ _ctl_ioc_reply_queue_count_show(struct device *cdev,
 static DEVICE_ATTR(reply_queue_count, S_IRUGO, _ctl_ioc_reply_queue_count_show,
 	NULL);
 
-#ifdef SCSI_MPT2SAS
 /**
  * _ctl_BRM_status_show - Backup Rail Monitor Status
  * @cdev - pointer to embedded class device
@@ -2815,7 +2858,6 @@ _ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	return rc;
 }
 static DEVICE_ATTR(BRM_status, S_IRUGO, _ctl_BRM_status_show, NULL);
-#endif
 
 struct DIAG_BUFFER_START {
 	__le32	Size;
@@ -3269,9 +3311,7 @@ struct device_attribute *mpt3sas_host_attrs[] = {
 	&dev_attr_diag_trigger_event,
 	&dev_attr_diag_trigger_scsi,
 	&dev_attr_diag_trigger_mpi,
-#ifdef SCSI_MPT2SAS
 	&dev_attr_BRM_status,
-#endif
 	NULL,
 };
 
@@ -3325,23 +3365,64 @@ struct device_attribute *mpt3sas_dev_attrs[] = {
 	NULL,
 };
 
+/* file operations table for mpt3ctl device */
+static const struct file_operations ctl_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = _ctl_ioctl,
+	.poll = _ctl_poll,
+	.fasync = _ctl_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = _ctl_ioctl_compat,
+#endif
+};
+
+/* file operations table for mpt2ctl device */
+static const struct file_operations ctl_gen2_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = _ctl_mpt2_ioctl,
+	.poll = _ctl_poll,
+	.fasync = _ctl_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = _ctl_mpt2_ioctl_compat,
+#endif
+};
+
+static struct miscdevice ctl_dev = {
+	.minor  = MPT3SAS_MINOR,
+	.name   = MPT3SAS_DEV_NAME,
+	.fops   = &ctl_fops,
+};
+
+static struct miscdevice gen2_ctl_dev = {
+	.minor  = MPT2SAS_MINOR,
+	.name   = MPT2SAS_DEV_NAME,
+	.fops   = &ctl_gen2_fops,
+};
+
 /**
- * ctl_init - main entry point for ctl.
+ * mpt3sas_ctl_init - main entry point for ctl.
  *
  */
 void
-ctl_init(void)
+mpt3sas_ctl_init(void)
 {
 	async_queue = NULL;
+	if (misc_register(&ctl_dev) < 0)
+		pr_err("%s can't register misc device [minor=%d]\n",
+		    MPT3SAS_DRIVER_NAME, MPT3SAS_MINOR);
+	if (misc_register(&gen2_ctl_dev) < 0)
+		pr_err("%s can't register misc device [minor=%d]\n",
+		    MPT2SAS_DRIVER_NAME, MPT2SAS_MINOR);
+
 	init_waitqueue_head(&ctl_poll_wait);
 }
 
 /**
- * ctl_exit - exit point for ctl
+ * mpt3sas_ctl_exit - exit point for ctl
  *
  */
 void
-ctl_exit(void)
+mpt3sas_ctl_exit(void)
 {
 	struct MPT3SAS_ADAPTER *ioc;
 	int i;
@@ -3366,4 +3447,6 @@ ctl_exit(void)
 
 		kfree(ioc->event_log);
 	}
+	misc_deregister(&ctl_dev);
+	misc_deregister(&gen2_ctl_dev);
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d0ab002..efbce3f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -71,7 +71,6 @@ static int _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 
 static u8 _scsih_check_for_pending_tm(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 
-#ifdef SCSI_MPT2SAS
 static void _scsih_disable_ddio(struct MPT3SAS_ADAPTER *ioc);
 static u8 _scsih_get_num_volumes(struct MPT3SAS_ADAPTER *ioc);
 static void
@@ -85,14 +84,18 @@ static void
 _scsih_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
 	u16 smid);
-#endif
 
 /* global parameters */
 LIST_HEAD(mpt3sas_ioc_list);
-char    driver_name[MPT_NAME_LENGTH];
 /* global ioc lock for list operations */
 DEFINE_SPINLOCK(gioc_lock);
 
+MODULE_AUTHOR(MPT3SAS_AUTHOR);
+MODULE_DESCRIPTION(MPT3SAS_DESCRIPTION);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(MPT3SAS_DRIVER_VERSION);
+MODULE_ALIAS("mpt2sas");
+
 /* local parameters */
 static u8 scsi_io_cb_idx = -1;
 static u8 tm_cb_idx = -1;
@@ -102,7 +105,8 @@ static u8 port_enable_cb_idx = -1;
 static u8 transport_cb_idx = -1;
 static u8 scsih_cb_idx = -1;
 static u8 config_cb_idx = -1;
-static int mpt_ids;
+static int mpt2_ids;
+static int mpt3_ids;
 
 static u8 tm_tr_cb_idx = -1 ;
 static u8 tm_tr_volume_cb_idx = -1 ;
@@ -156,6 +160,7 @@ MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=7 ");
 
 /* raid transport support */
 struct raid_template *mpt3sas_raid_template;
+struct raid_template *mpt2sas_raid_template;
 
 
 /**
@@ -1304,10 +1309,8 @@ scsih_target_alloc(struct scsi_target *starget)
 		if (test_bit(sas_device->handle, ioc->pd_handles))
 			sas_target_priv_data->flags |=
 			    MPT_TARGET_FLAGS_RAID_COMPONENT;
-#ifndef SCSI_MPT2SAS
 		if (sas_device->fast_path)
 			sas_target_priv_data->flags |= MPT_TARGET_FASTPATH_IO;
-#endif
 	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
@@ -1596,7 +1599,10 @@ scsih_get_resync(struct device *dev)
 		percent_complete = 0;
 
  out:
-	raid_set_resync(mpt3sas_raid_template, dev, percent_complete);
+	if (ioc->hba_mpi_version_belonged == MPI2_VERSION)
+		raid_set_resync(mpt2sas_raid_template, dev, percent_complete);
+	if (ioc->hba_mpi_version_belonged == MPI25_VERSION)
+		raid_set_resync(mpt3sas_raid_template, dev, percent_complete);
 }
 
 /**
@@ -1654,7 +1660,10 @@ scsih_get_state(struct device *dev)
 		break;
 	}
  out:
-	raid_set_state(mpt3sas_raid_template, dev, state);
+	if (ioc->hba_mpi_version_belonged == MPI2_VERSION)
+		raid_set_state(mpt2sas_raid_template, dev, state);
+	if (ioc->hba_mpi_version_belonged == MPI25_VERSION)
+		raid_set_state(mpt3sas_raid_template, dev, state);
 }
 
 /**
@@ -1663,7 +1672,8 @@ scsih_get_state(struct device *dev)
  * @volume_type: volume type
  */
 static void
-_scsih_set_level(struct scsi_device *sdev, u8 volume_type)
+_scsih_set_level(struct MPT3SAS_ADAPTER *ioc,
+	struct scsi_device *sdev, u8 volume_type)
 {
 	enum raid_level level = RAID_LEVEL_UNKNOWN;
 
@@ -1682,7 +1692,12 @@ _scsih_set_level(struct scsi_device *sdev, u8 volume_type)
 		break;
 	}
 
-	raid_set_level(mpt3sas_raid_template, &sdev->sdev_gendev, level);
+	if (ioc->hba_mpi_version_belonged == MPI2_VERSION)
+		raid_set_level(mpt2sas_raid_template,
+			       &sdev->sdev_gendev, level);
+	if (ioc->hba_mpi_version_belonged == MPI25_VERSION)
+		raid_set_level(mpt3sas_raid_template,
+			       &sdev->sdev_gendev, level);
 }
 
 
@@ -1830,12 +1845,10 @@ scsih_slave_configure(struct scsi_device *sdev)
 			return 1;
 		}
 
-#ifdef SCSI_MPT2SAS
 		/*
 		 * WARPDRIVE: Initialize the required data for Direct IO
 		 */
 		_scsih_init_warpdrive_properties(ioc, raid_device);
-#endif
 
 		/* RAID Queue Depth Support
 		 * IS volume = underlying qdepth of drive type, either
@@ -1896,7 +1909,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 
 		/* raid transport support */
 		if (!ioc->is_warpdrive)
-			_scsih_set_level(sdev, raid_device->volume_type);
+			_scsih_set_level(ioc, sdev, raid_device->volume_type);
 		return 0;
 	}
 
@@ -3841,9 +3854,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
-#ifdef SCSI_MPT2SAS
 	struct _raid_device *raid_device;
-#endif
 	Mpi2SCSIIORequest_t *mpi_request;
 	u32 mpi_control;
 	u16 smid;
@@ -3947,21 +3958,17 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	} else
 		ioc->build_zero_len_sge(ioc, &mpi_request->SGL);
 
-#ifdef SCSI_MPT2SAS
 	raid_device = sas_target_priv_data->raid_device;
 	if (raid_device && raid_device->direct_io_enabled)
 		_scsih_setup_direct_io(ioc, scmd, raid_device, mpi_request,
 		    smid);
-#endif
 
 	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
-#ifndef SCSI_MPT2SAS
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
 			mpi_request->IoFlags = cpu_to_le16(scmd->cmd_len |
 			    MPI25_SCSIIO_IOFLAGS_FAST_PATH);
 			mpt3sas_base_put_smid_fast_path(ioc, smid, handle);
 		} else
-#endif
 			mpt3sas_base_put_smid_scsi_io(ioc, smid,
 			    le16_to_cpu(mpi_request->DevHandle));
 	} else
@@ -4422,9 +4429,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	u32 log_info;
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	u32 response_code = 0;
-#ifdef SCSI_MPT2SAS
 	unsigned long flags;
-#endif
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
@@ -4446,7 +4451,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	}
 	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
 
-#ifdef SCSI_MPT2SAS
 	/*
 	 * WARPDRIVE: If direct_io is set then it is directIO,
 	 * the failed direct I/O should be redirected to volume
@@ -4465,7 +4469,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		    sas_device_priv_data->sas_target->handle);
 		return 0;
 	}
-#endif
 	/* turning off TLR */
 	scsi_state = mpi_reply->SCSIState;
 	if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID)
@@ -4475,10 +4478,11 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		sas_device_priv_data->tlr_snoop_check++;
 		if (!ioc->is_warpdrive &&
 		    !scsih_is_raid(&scmd->device->sdev_gendev) &&
-		    (sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
-		    response_code == MPI2_SCSITASKMGMT_RSP_INVALID_FRAME)
-			sas_device_priv_data->flags &=
-			    ~MPT_DEVICE_TLR_ON;
+		    sas_is_tlr_enabled(scmd->device) &&
+		    response_code == MPI2_SCSITASKMGMT_RSP_INVALID_FRAME) {
+			sas_disable_tlr(scmd->device);
+			sdev_printk(KERN_INFO, scmd->device, "TLR disabled\n");
+		}
 	}
 
 	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
@@ -5309,10 +5313,8 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	sas_device->device_info = device_info;
 	sas_device->sas_address = sas_address;
 	sas_device->phy = sas_device_pg0.PhyNum;
-#ifndef SCSI_MPT2SAS
 	sas_device->fast_path = (le16_to_cpu(sas_device_pg0.Flags) &
 	    MPI25_SAS_DEVICE0_FLAGS_FAST_PATH_CAPABLE) ? 1 : 0;
-#endif
 
 	if (sas_device_pg0.Flags & MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
 		sas_device->enclosure_level =
@@ -6014,7 +6016,6 @@ _scsih_sas_discovery_event(struct MPT3SAS_ADAPTER *ioc,
 	}
 }
 
-#ifndef SCSI_MPT2SAS
 /**
  * _scsih_ir_fastpath - turn on fastpath for IR physdisk
  * @ioc: per adapter object
@@ -6034,6 +6035,9 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phys_disk_num)
 	u16 ioc_status;
 	u32 log_info;
 
+	if (ioc->hba_mpi_version_belonged == MPI2_VERSION)
+		return rc;
+
 	mutex_lock(&ioc->scsih_cmds.mutex);
 
 	if (ioc->scsih_cmds.status != MPT3_CMD_NOT_USED) {
@@ -6108,8 +6112,6 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phys_disk_num)
 		    FORCE_BIG_HAMMER);
 	return rc;
 }
-/* End of not defined SCSI_MPT2SAS */
-#endif
 
 /**
  * _scsih_reprobe_lun - reprobing lun
@@ -6304,10 +6306,9 @@ _scsih_sas_pd_hide(struct MPT3SAS_ADAPTER *ioc,
 	if (!sas_device)
 		return;
 
-#ifndef SCSI_MPT2SAS
 	/* hiding raid component */
 	_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
-#endif
+
 	if (starget)
 		starget_for_each_device(starget, (void *)1, _scsih_reprobe_lun);
 
@@ -6355,9 +6356,7 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
 
 	sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
 	if (sas_device) {
-#ifndef SCSI_MPT2SAS
 		_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
-#endif
 		sas_device_put(sas_device);
 		return;
 	}
@@ -6382,9 +6381,7 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
 		mpt3sas_transport_update_links(ioc, sas_address, handle,
 		    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
 
-#ifndef SCSI_MPT2SAS
 	_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
-#endif
 	_scsih_add_device(ioc, handle, 0, 1);
 }
 
@@ -6495,15 +6492,14 @@ _scsih_sas_ir_config_change_event(struct MPT3SAS_ADAPTER *ioc,
 	    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG) ? 1 : 0;
 
 	element = (Mpi2EventIrConfigElement_t *)&event_data->ConfigElement[0];
-	if (ioc->shost_recovery) {
-#ifndef SCSI_MPT2SAS
+	if (ioc->shost_recovery &&
+	    ioc->hba_mpi_version_belonged != MPI2_VERSION) {
 		for (i = 0; i < event_data->NumElements; i++, element++) {
 			if (element->ReasonCode == MPI2_EVENT_IR_CHANGE_RC_HIDE)
 				_scsih_ir_fastpath(ioc,
 					le16_to_cpu(element->PhysDiskDevHandle),
 					element->PhysDiskNum);
 		}
-#endif
 		return;
 	}
 
@@ -6964,14 +6960,12 @@ _scsih_mark_responding_raid_device(struct MPT3SAS_ADAPTER *ioc, u64 wwid,
 			    "handle(0x%04x), wwid(0x%016llx)\n", handle,
 			    (unsigned long long)raid_device->wwid);
 
-#ifdef SCSI_MPT2SAS
 			/*
 			 * WARPDRIVE: The handles of the PDs might have changed
 			 * across the host reset so re-initialize the
 			 * required data for Direct IO
 			 */
 			_scsih_init_warpdrive_properties(ioc, raid_device);
-#endif
 			spin_lock_irqsave(&ioc->raid_device_lock, flags);
 			if (raid_device->handle == handle) {
 				spin_unlock_irqrestore(&ioc->raid_device_lock,
@@ -8326,13 +8320,96 @@ scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	return 1;
 }
 
-void
-_scsih_determine_hba_mpi_version(struct MPT3SAS_ADAPTER *ioc) {
+/* shost template for SAS 2.0 HBA devices */
+static struct scsi_host_template mpt2sas_driver_template = {
+	.module				= THIS_MODULE,
+	.name				= "Fusion MPT SAS Host",
+	.proc_name			= MPT2SAS_DRIVER_NAME,
+	.queuecommand			= scsih_qcmd,
+	.target_alloc			= scsih_target_alloc,
+	.slave_alloc			= scsih_slave_alloc,
+	.slave_configure		= scsih_slave_configure,
+	.target_destroy			= scsih_target_destroy,
+	.slave_destroy			= scsih_slave_destroy,
+	.scan_finished			= scsih_scan_finished,
+	.scan_start			= scsih_scan_start,
+	.change_queue_depth		= scsih_change_queue_depth,
+	.eh_abort_handler		= scsih_abort,
+	.eh_device_reset_handler	= scsih_dev_reset,
+	.eh_target_reset_handler	= scsih_target_reset,
+	.eh_host_reset_handler		= scsih_host_reset,
+	.bios_param			= scsih_bios_param,
+	.can_queue			= 1,
+	.this_id			= -1,
+	.sg_tablesize			= MPT2SAS_SG_DEPTH,
+	.max_sectors			= 32767,
+	.cmd_per_lun			= 7,
+	.use_clustering			= ENABLE_CLUSTERING,
+	.shost_attrs			= mpt3sas_host_attrs,
+	.sdev_attrs			= mpt3sas_dev_attrs,
+	.track_queue_depth		= 1,
+};
 
-	switch (ioc->pdev->device) {
+/* raid transport support for SAS 2.0 HBA devices */
+static struct raid_function_template mpt2sas_raid_functions = {
+	.cookie		= &mpt2sas_driver_template,
+	.is_raid	= scsih_is_raid,
+	.get_resync	= scsih_get_resync,
+	.get_state	= scsih_get_state,
+};
+
+/* shost template for SAS 3.0 HBA devices */
+static struct scsi_host_template mpt3sas_driver_template = {
+	.module				= THIS_MODULE,
+	.name				= "Fusion MPT SAS Host",
+	.proc_name			= MPT3SAS_DRIVER_NAME,
+	.queuecommand			= scsih_qcmd,
+	.target_alloc			= scsih_target_alloc,
+	.slave_alloc			= scsih_slave_alloc,
+	.slave_configure		= scsih_slave_configure,
+	.target_destroy			= scsih_target_destroy,
+	.slave_destroy			= scsih_slave_destroy,
+	.scan_finished			= scsih_scan_finished,
+	.scan_start			= scsih_scan_start,
+	.change_queue_depth		= scsih_change_queue_depth,
+	.eh_abort_handler		= scsih_abort,
+	.eh_device_reset_handler	= scsih_dev_reset,
+	.eh_target_reset_handler	= scsih_target_reset,
+	.eh_host_reset_handler		= scsih_host_reset,
+	.bios_param			= scsih_bios_param,
+	.can_queue			= 1,
+	.this_id			= -1,
+	.sg_tablesize			= MPT3SAS_SG_DEPTH,
+	.max_sectors			= 32767,
+	.cmd_per_lun			= 7,
+	.use_clustering			= ENABLE_CLUSTERING,
+	.shost_attrs			= mpt3sas_host_attrs,
+	.sdev_attrs			= mpt3sas_dev_attrs,
+	.track_queue_depth		= 1,
+};
+
+/* raid transport support for SAS 3.0 HBA devices */
+static struct raid_function_template mpt3sas_raid_functions = {
+	.cookie		= &mpt3sas_driver_template,
+	.is_raid	= scsih_is_raid,
+	.get_resync	= scsih_get_resync,
+	.get_state	= scsih_get_state,
+};
+
+/**
+ * _scsih_determine_hba_mpi_version - determine in which MPI version class
+ *					this device belongs to.
+ * @pdev: PCI device struct
+ *
+ * return MPI2_VERSION for SAS 2.0 HBA devices,
+ *	MPI25_VERSION for SAS 3.0 HBA devices.
+ */
+u16
+_scsih_determine_hba_mpi_version(struct pci_dev *pdev)
+{
+
+	switch (pdev->device) {
 	case MPI2_MFGPAGE_DEVID_SSS6200:
-		ioc->is_warpdrive = 1;
-		ioc->hide_ir_msg = 1;
 	case MPI2_MFGPAGE_DEVID_SAS2004:
 	case MPI2_MFGPAGE_DEVID_SAS2008:
 	case MPI2_MFGPAGE_DEVID_SAS2108_1:
@@ -8349,52 +8426,79 @@ _scsih_determine_hba_mpi_version(struct MPT3SAS_ADAPTER *ioc) {
 	case MPI2_MFGPAGE_DEVID_SAS2308_1:
 	case MPI2_MFGPAGE_DEVID_SAS2308_2:
 	case MPI2_MFGPAGE_DEVID_SAS2308_3:
-		ioc->hba_mpi_version_belonged = MPI2_VERSION;
-		break;
+		return MPI2_VERSION;
 	case MPI25_MFGPAGE_DEVID_SAS3004:
 	case MPI25_MFGPAGE_DEVID_SAS3008:
 	case MPI25_MFGPAGE_DEVID_SAS3108_1:
 	case MPI25_MFGPAGE_DEVID_SAS3108_2:
 	case MPI25_MFGPAGE_DEVID_SAS3108_5:
 	case MPI25_MFGPAGE_DEVID_SAS3108_6:
-		ioc->hba_mpi_version_belonged = MPI25_VERSION;
-
-		/* Check whether the controller revision is C0 or above.
-		 * only C0 and above revision controllers support 96 MSI-X
-		 * vectors.
-		 */
-		if (ioc->pdev->revision >= SAS3_PCI_DEVICE_C0_REVISION)
-			ioc->msix96_vector = 1;
-		break;
+		return MPI25_VERSION;
 	}
-
-	if ((ioc->pdev->device != MPI2_MFGPAGE_DEVID_SSS6200) &&
-	    (ioc->hba_mpi_version_belonged == MPI2_VERSION))
-		ioc->mfg_pg10_hide_flag = MFG_PAGE10_EXPOSE_ALL_DISKS;
+	return 0;
 }
 
 /**
- * scsih_probe - attach and add scsi host
+ * _scsih_probe - attach and add scsi host
  * @pdev: PCI device struct
  * @id: pci device id
  *
  * Returns 0 success, anything else error.
  */
 int
-scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
+_scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct MPT3SAS_ADAPTER *ioc;
+	struct Scsi_Host *shost = NULL;
 	int rv;
+	u16 hba_mpi_version;
+
+	/* Determine in which MPI version class this pci device belongs */
+	hba_mpi_version = _scsih_determine_hba_mpi_version(pdev);
+	if (hba_mpi_version == 0)
+		return -ENODEV;
+
+	switch (hba_mpi_version) {
+	case MPI2_VERSION:
+		/* Use mpt2sas driver host template for SAS 2.0 HBA's */
+		shost = scsi_host_alloc(&mpt2sas_driver_template,
+		  sizeof(struct MPT3SAS_ADAPTER));
+		if (!shost)
+			return -ENODEV;
+		ioc = shost_priv(shost);
+		memset(ioc, 0, sizeof(struct MPT3SAS_ADAPTER));
+		ioc->hba_mpi_version_belonged = hba_mpi_version;
+		ioc->id = mpt2_ids++;
+		sprintf(ioc->driver_name, "%s", MPT2SAS_DRIVER_NAME);
+		if (pdev->device == MPI2_MFGPAGE_DEVID_SSS6200) {
+			ioc->is_warpdrive = 1;
+			ioc->hide_ir_msg = 1;
+		} else
+			ioc->mfg_pg10_hide_flag = MFG_PAGE10_EXPOSE_ALL_DISKS;
+		break;
+	case MPI25_VERSION:
+		/* Use mpt3sas driver host template for SAS 3.0 HBA's */
+		shost = scsi_host_alloc(&mpt3sas_driver_template,
+		  sizeof(struct MPT3SAS_ADAPTER));
+		if (!shost)
+			return -ENODEV;
+		ioc = shost_priv(shost);
+		memset(ioc, 0, sizeof(struct MPT3SAS_ADAPTER));
+		ioc->hba_mpi_version_belonged = hba_mpi_version;
+		ioc->id = mpt3_ids++;
+		sprintf(ioc->driver_name, "%s", MPT3SAS_DRIVER_NAME);
+		if (pdev->revision >= SAS3_PCI_DEVICE_C0_REVISION)
+			ioc->msix96_vector = 1;
+		break;
+	default:
+		return -ENODEV;
+	}
 
-	/* init local params */
-	ioc = shost_priv(shost);
-	memset(ioc, 0, sizeof(struct MPT3SAS_ADAPTER));
 	INIT_LIST_HEAD(&ioc->list);
 	spin_lock(&gioc_lock);
 	list_add_tail(&ioc->list, &mpt3sas_ioc_list);
 	spin_unlock(&gioc_lock);
 	ioc->shost = shost;
-	ioc->id = mpt_ids++;
 	ioc->pdev = pdev;
 	ioc->scsi_io_cb_idx = scsi_io_cb_idx;
 	ioc->tm_cb_idx = tm_cb_idx;
@@ -8431,8 +8535,7 @@ scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
 	INIT_LIST_HEAD(&ioc->delayed_tr_volume_list);
 	INIT_LIST_HEAD(&ioc->reply_queue_list);
 
-	_scsih_determine_hba_mpi_version(ioc);
-	sprintf(ioc->name, "%s_cm%d", driver_name, ioc->id);
+	sprintf(ioc->name, "%s_cm%d", ioc->driver_name, ioc->id);
 
 	/* init shost parameters */
 	shost->max_cmd_len = 32;
@@ -8472,7 +8575,7 @@ scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
 
 	/* event thread */
 	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
-	    "fw_event%d", ioc->id);
+	    "fw_event_%s%d", ioc->driver_name, ioc->id);
 	ioc->firmware_event_thread = alloc_ordered_workqueue(
 	    ioc->firmware_event_name, WQ_MEM_RECLAIM);
 	if (!ioc->firmware_event_thread) {
@@ -8490,7 +8593,6 @@ scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
 		goto out_attach_fail;
 	}
 
-#ifdef SCSI_MPT2SAS
 	if (ioc->is_warpdrive) {
 		if (ioc->mfg_pg10_hide_flag ==  MFG_PAGE10_EXPOSE_ALL_DISKS)
 			ioc->hide_drives = 0;
@@ -8504,7 +8606,6 @@ scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
 		}
 	} else
 		ioc->hide_drives = 0;
-#endif
 
 	rv = scsi_add_host(shost, &pdev->dev);
 	if (rv) {
@@ -8705,6 +8806,89 @@ scsih_pci_mmio_enabled(struct pci_dev *pdev)
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
+/*
+ * The pci device ids are defined in mpi/mpi2_cnfg.h.
+ */
+static const struct pci_device_id mpt3sas_pci_table[] = {
+	/* Spitfire ~ 2004 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2004,
+		PCI_ANY_ID, PCI_ANY_ID },
+	/* Falcon ~ 2008 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2008,
+		PCI_ANY_ID, PCI_ANY_ID },
+	/* Liberator ~ 2108 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_1,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_2,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_3,
+		PCI_ANY_ID, PCI_ANY_ID },
+	/* Meteor ~ 2116 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2116_1,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2116_2,
+		PCI_ANY_ID, PCI_ANY_ID },
+	/* Thunderbolt ~ 2208 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_1,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_2,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_3,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_4,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_5,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2208_6,
+		PCI_ANY_ID, PCI_ANY_ID },
+	/* Mustang ~ 2308 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2308_1,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2308_2,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2308_3,
+		PCI_ANY_ID, PCI_ANY_ID },
+	/* SSS6200 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SSS6200,
+		PCI_ANY_ID, PCI_ANY_ID },
+	/* Fury ~ 3004 and 3008 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3004,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3008,
+		PCI_ANY_ID, PCI_ANY_ID },
+	/* Invader ~ 3108 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_1,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_2,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_5,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_6,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{0}     /* Terminating entry */
+};
+MODULE_DEVICE_TABLE(pci, mpt3sas_pci_table);
+
+static struct pci_error_handlers _mpt3sas_err_handler = {
+	.error_detected	= scsih_pci_error_detected,
+	.mmio_enabled	= scsih_pci_mmio_enabled,
+	.slot_reset	= scsih_pci_slot_reset,
+	.resume		= scsih_pci_resume,
+};
+
+static struct pci_driver mpt3sas_driver = {
+	.name		= MPT3SAS_DRIVER_NAME,
+	.id_table	= mpt3sas_pci_table,
+	.probe		= _scsih_probe,
+	.remove		= scsih_remove,
+	.shutdown	= scsih_shutdown,
+	.err_handler	= &_mpt3sas_err_handler,
+#ifdef CONFIG_PM
+	.suspend	= scsih_suspend,
+	.resume		= scsih_resume,
+#endif
+};
+
 /**
  * scsih_init - main entry point for this driver.
  *
@@ -8713,7 +8897,8 @@ scsih_pci_mmio_enabled(struct pci_dev *pdev)
 int
 scsih_init(void)
 {
-	mpt_ids = 0;
+	mpt2_ids = 0;
+	mpt3_ids = 0;
 
 	mpt3sas_base_initialize_callback_handler();
 
@@ -8778,9 +8963,73 @@ scsih_exit(void)
 
 /* raid transport support */
 	raid_class_release(mpt3sas_raid_template);
+	raid_class_release(mpt2sas_raid_template);
 	sas_release_transport(mpt3sas_transport_template);
 }
 
-#ifdef SCSI_MPT2SAS
-#include "../mpt2sas/mpt2sas_warpdrive.c"
-#endif
+/**
+ * _mpt3sas_init - main entry point for this driver.
+ *
+ * Returns 0 success, anything else error.
+ */
+static int __init
+_mpt3sas_init(void)
+{
+	int error;
+
+	pr_info("%s version %s loaded\n", MPT3SAS_DRIVER_NAME,
+					MPT3SAS_DRIVER_VERSION);
+
+	mpt3sas_transport_template =
+	    sas_attach_transport(&mpt3sas_transport_functions);
+	if (!mpt3sas_transport_template)
+		return -ENODEV;
+
+	mpt3sas_raid_template = raid_class_attach(&mpt3sas_raid_functions);
+	if (!mpt3sas_raid_template) {
+		sas_release_transport(mpt3sas_transport_template);
+		return -ENODEV;
+	}
+
+	mpt2sas_raid_template = raid_class_attach(&mpt2sas_raid_functions);
+	if (!mpt2sas_raid_template) {
+		sas_release_transport(mpt3sas_transport_template);
+		return -ENODEV;
+	}
+
+	error = scsih_init();
+	if (error) {
+		scsih_exit();
+		return error;
+	}
+
+	mpt3sas_ctl_init();
+
+	error = pci_register_driver(&mpt3sas_driver);
+	if (error)
+		scsih_exit();
+
+	return error;
+}
+
+/**
+ * _mpt3sas_exit - exit point for this driver (when it is a module).
+ *
+ */
+static void __exit
+_mpt3sas_exit(void)
+{
+	pr_info("mpt3sas version %s unloading\n",
+				MPT3SAS_DRIVER_VERSION);
+
+	pci_unregister_driver(&mpt3sas_driver);
+
+	mpt3sas_ctl_exit();
+
+	scsih_exit();
+}
+
+module_init(_mpt3sas_init);
+module_exit(_mpt3sas_exit);
+
+#include "mpt2sas_warpdrive.c"
-- 
2.0.2
