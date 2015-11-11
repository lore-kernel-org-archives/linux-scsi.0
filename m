From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH RESEND 02/25] mpt3sas: Added mpt2sas driver definitions
Date: Wed, 11 Nov 2015 17:30:18 +0530
Message-ID: <1447243241-10912-3-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33912 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbbKKMBQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2015 07:01:16 -0500
Received: by padhx2 with SMTP id hx2so29729638pad.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2015 04:01:14 -0800 (PST)
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

1. Added mpt2sas driver related macro's in mpt3sas header files
2. Made scsi host's, raid class's, pci's, ioctl's call back functions
as a gobal API's, so that both the drivers can use these
call back functions.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |   8 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  58 ++++++++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  40 +++---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 230 +++++++++++++++++------------------
 4 files changed, 191 insertions(+), 145 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index d4f1dcd..302f02a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2855,15 +2855,15 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
 	else
 		sg_tablesize = MPT3SAS_SG_DEPTH;
 
-	if (sg_tablesize < MPT3SAS_MIN_PHYS_SEGMENTS)
-		sg_tablesize = MPT3SAS_MIN_PHYS_SEGMENTS;
-	else if (sg_tablesize > MPT3SAS_MAX_PHYS_SEGMENTS) {
+	if (sg_tablesize < MPT_MIN_PHYS_SEGMENTS)
+		sg_tablesize = MPT_MIN_PHYS_SEGMENTS;
+	else if (sg_tablesize > MPT_MAX_PHYS_SEGMENTS) {
 		sg_tablesize = min_t(unsigned short, sg_tablesize,
 				      SCSI_MAX_SG_CHAIN_SEGMENTS);
 		pr_warn(MPT3SAS_FMT
 		 "sg_tablesize(%u) is bigger than kernel"
 		 " defined SCSI_MAX_SG_SEGMENTS(%u)\n", ioc->name,
-		 sg_tablesize, MPT3SAS_MAX_PHYS_SEGMENTS);
+		 sg_tablesize, MPT_MAX_PHYS_SEGMENTS);
 	}
 	ioc->shost->sg_tablesize = sg_tablesize;
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index f0e462b..699cf72 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -63,15 +63,20 @@
 #include <scsi/scsi_transport_sas.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
+#include <linux/pci.h>
+#include <linux/poll.h>
 
 #include "mpt3sas_debug.h"
 #include "mpt3sas_trigger_diag.h"
 
 /* driver versioning info */
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
+#define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
+#define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
 #define MPT3SAS_DRIVER_VERSION		"09.100.00.00"
+#define MPT2SAS_DRIVER_VERSION		"20.101.00.00"
 #define MPT3SAS_MAJOR_VERSION		9
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
@@ -80,14 +85,20 @@
 /*
  * Set MPT3SAS_SG_DEPTH value based on user input.
  */
-#define MPT3SAS_MAX_PHYS_SEGMENTS	SCSI_MAX_SG_SEGMENTS
-#define MPT3SAS_MIN_PHYS_SEGMENTS	16
+#define MPT_MAX_PHYS_SEGMENTS	SCSI_MAX_SG_SEGMENTS
+#define MPT_MIN_PHYS_SEGMENTS	16
+
 #ifdef CONFIG_SCSI_MPT3SAS_MAX_SGE
 #define MPT3SAS_SG_DEPTH		CONFIG_SCSI_MPT3SAS_MAX_SGE
 #else
-#define MPT3SAS_SG_DEPTH		MPT3SAS_MAX_PHYS_SEGMENTS
+#define MPT3SAS_SG_DEPTH		MPT_MAX_PHYS_SEGMENTS
 #endif
 
+#ifdef CONFIG_SCSI_MPT2SAS_MAX_SGE
+#define MPT2SAS_SG_DEPTH		CONFIG_SCSI_MPT2SAS_MAX_SGE
+#else
+#define MPT2SAS_SG_DEPTH		MPT_MAX_PHYS_SEGMENTS
+#endif
 
 /*
  * Generic Defines
@@ -1095,6 +1106,39 @@ struct _sas_device *mpt3sas_scsih_sas_device_find_by_sas_address(
 
 void mpt3sas_port_enable_complete(struct MPT3SAS_ADAPTER *ioc);
 
+void scsih_exit(void);
+int scsih_init(void);
+int scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id);
+void scsih_remove(struct pci_dev *pdev);
+void scsih_shutdown(struct pci_dev *pdev);
+pci_ers_result_t scsih_pci_error_detected(struct pci_dev *pdev,
+	pci_channel_state_t state);
+pci_ers_result_t scsih_pci_mmio_enabled(struct pci_dev *pdev);
+pci_ers_result_t scsih_pci_slot_reset(struct pci_dev *pdev);
+void scsih_pci_resume(struct pci_dev *pdev);
+int scsih_suspend(struct pci_dev *pdev, pm_message_t state);
+int scsih_resume(struct pci_dev *pdev);
+
+int scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd);
+int scsih_target_alloc(struct scsi_target *starget);
+int scsih_slave_alloc(struct scsi_device *sdev);
+int scsih_slave_configure(struct scsi_device *sdev);
+void scsih_target_destroy(struct scsi_target *starget);
+void scsih_slave_destroy(struct scsi_device *sdev);
+int scsih_scan_finished(struct Scsi_Host *shost, unsigned long time);
+void scsih_scan_start(struct Scsi_Host *shost);
+int scsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
+int scsih_abort(struct scsi_cmnd *scmd);
+int scsih_dev_reset(struct scsi_cmnd *scmd);
+int scsih_target_reset(struct scsi_cmnd *scmd);
+int scsih_host_reset(struct scsi_cmnd *scmd);
+int scsih_bios_param(struct scsi_device *sdev, struct block_device *bdev,
+	sector_t capacity, int params[]);
+
+int scsih_is_raid(struct device *dev);
+void scsih_get_resync(struct device *dev);
+void scsih_get_state(struct device *dev);
+
 /* config shared API */
 u8 mpt3sas_config_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
@@ -1177,8 +1221,12 @@ int mpt3sas_config_get_volume_wwid(struct MPT3SAS_ADAPTER *ioc,
 /* ctl shared API */
 extern struct device_attribute *mpt3sas_host_attrs[];
 extern struct device_attribute *mpt3sas_dev_attrs[];
-void mpt3sas_ctl_init(void);
-void mpt3sas_ctl_exit(void);
+long ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+unsigned int ctl_poll(struct file *filep, poll_table *wait);
+int ctl_fasync(int fd, struct file *filep, int mode);
+long ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg);
+void ctl_init(void);
+void ctl_exit(void);
 u8 mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
 void mpt3sas_ctl_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 080c8a7..e72a16c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -490,27 +490,27 @@ mpt3sas_ctl_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase)
 }
 
 /**
- * _ctl_fasync -
+ * ctl_fasync -
  * @fd -
  * @filep -
  * @mode -
  *
  * Called when application request fasyn callback handler.
  */
-static int
-_ctl_fasync(int fd, struct file *filep, int mode)
+int
+ctl_fasync(int fd, struct file *filep, int mode)
 {
 	return fasync_helper(fd, filep, mode, &async_queue);
 }
 
 /**
- * _ctl_poll -
+ * ctl_poll -
  * @file -
  * @wait -
  *
  */
-static unsigned int
-_ctl_poll(struct file *filep, poll_table *wait)
+unsigned int
+ctl_poll(struct file *filep, poll_table *wait)
 {
 	struct MPT3SAS_ADAPTER *ioc;
 
@@ -2298,13 +2298,13 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 }
 
 /**
- * _ctl_ioctl - main ioctl entry point (unlocked)
+ * ctl_ioctl - main ioctl entry point (unlocked)
  * @file - (struct file)
  * @cmd - ioctl opcode
  * @arg -
  */
-static long
-_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+long
+ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 
@@ -2314,15 +2314,15 @@ _ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 #ifdef CONFIG_COMPAT
 /**
- * _ctl_ioctl_compat - main ioctl entry point (compat)
+ * ctl_ioctl_compat - main ioctl entry point (compat)
  * @file -
  * @cmd -
  * @arg -
  *
  * This routine handles 32 bit applications in 64bit os.
  */
-static long
-_ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
+long
+ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
 {
 	long ret;
 
@@ -3220,11 +3220,11 @@ struct device_attribute *mpt3sas_dev_attrs[] = {
 
 static const struct file_operations ctl_fops = {
 	.owner = THIS_MODULE,
-	.unlocked_ioctl = _ctl_ioctl,
-	.poll = _ctl_poll,
-	.fasync = _ctl_fasync,
+	.unlocked_ioctl = ctl_ioctl,
+	.poll = ctl_poll,
+	.fasync = ctl_fasync,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl = _ctl_ioctl_compat,
+	.compat_ioctl = ctl_ioctl_compat,
 #endif
 };
 
@@ -3235,11 +3235,11 @@ static struct miscdevice ctl_dev = {
 };
 
 /**
- * mpt3sas_ctl_init - main entry point for ctl.
+ * ctl_init - main entry point for ctl.
  *
  */
 void
-mpt3sas_ctl_init(void)
+ctl_init(void)
 {
 	async_queue = NULL;
 	if (misc_register(&ctl_dev) < 0)
@@ -3250,11 +3250,11 @@ mpt3sas_ctl_init(void)
 }
 
 /**
- * mpt3sas_ctl_exit - exit point for ctl
+ * ctl_exit - exit point for ctl
  *
  */
 void
-mpt3sas_ctl_exit(void)
+ctl_exit(void)
 {
 	struct MPT3SAS_ADAPTER *ioc;
 	int i;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8ccef38..3353b48 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -75,8 +75,6 @@ static int _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 
 static u8 _scsih_check_for_pending_tm(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 
-static void _scsih_scan_start(struct Scsi_Host *shost);
-static int _scsih_scan_finished(struct Scsi_Host *shost, unsigned long time);
 
 /* global parameters */
 LIST_HEAD(mpt3sas_ioc_list);
@@ -1095,14 +1093,14 @@ _scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
 }
 
 /**
- * _scsih_change_queue_depth - setting device queue depth
+ * scsih_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
  *
  * Returns queue depth.
  */
-static int
-_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
+int
+scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	struct Scsi_Host *shost = sdev->host;
 	int max_depth;
@@ -1141,14 +1139,14 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 }
 
 /**
- * _scsih_target_alloc - target add routine
+ * scsih_target_alloc - target add routine
  * @starget: scsi target struct
  *
  * Returns 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
-static int
-_scsih_target_alloc(struct scsi_target *starget)
+int
+scsih_target_alloc(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -1206,13 +1204,13 @@ _scsih_target_alloc(struct scsi_target *starget)
 }
 
 /**
- * _scsih_target_destroy - target destroy routine
+ * scsih_target_destroy - target destroy routine
  * @starget: scsi target struct
  *
  * Returns nothing.
  */
-static void
-_scsih_target_destroy(struct scsi_target *starget)
+void
+scsih_target_destroy(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -1255,14 +1253,14 @@ _scsih_target_destroy(struct scsi_target *starget)
 }
 
 /**
- * _scsih_slave_alloc - device add routine
+ * scsih_slave_alloc - device add routine
  * @sdev: scsi device struct
  *
  * Returns 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
-static int
-_scsih_slave_alloc(struct scsi_device *sdev)
+int
+scsih_slave_alloc(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost;
 	struct MPT3SAS_ADAPTER *ioc;
@@ -1317,13 +1315,13 @@ _scsih_slave_alloc(struct scsi_device *sdev)
 }
 
 /**
- * _scsih_slave_destroy - device destroy routine
+ * scsih_slave_destroy - device destroy routine
  * @sdev: scsi device struct
  *
  * Returns nothing.
  */
-static void
-_scsih_slave_destroy(struct scsi_device *sdev)
+void
+scsih_slave_destroy(struct scsi_device *sdev)
 {
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct scsi_target *starget;
@@ -1409,11 +1407,11 @@ _scsih_display_sata_capabilities(struct MPT3SAS_ADAPTER *ioc,
  */
 
 /**
- * _scsih_is_raid - return boolean indicating device is raid volume
+ * scsih_is_raid - return boolean indicating device is raid volume
  * @dev the device struct object
  */
-static int
-_scsih_is_raid(struct device *dev)
+int
+scsih_is_raid(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
@@ -1421,11 +1419,11 @@ _scsih_is_raid(struct device *dev)
 }
 
 /**
- * _scsih_get_resync - get raid volume resync percent complete
+ * scsih_get_resync - get raid volume resync percent complete
  * @dev the device struct object
  */
-static void
-_scsih_get_resync(struct device *dev)
+void
+scsih_get_resync(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(sdev->host);
@@ -1470,11 +1468,11 @@ _scsih_get_resync(struct device *dev)
 }
 
 /**
- * _scsih_get_state - get raid volume level
+ * scsih_get_state - get raid volume level
  * @dev the device struct object
  */
-static void
-_scsih_get_state(struct device *dev)
+void
+scsih_get_state(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(sdev->host);
@@ -1652,14 +1650,14 @@ _scsih_enable_tlr(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev)
 }
 
 /**
- * _scsih_slave_configure - device configure routine.
+ * scsih_slave_configure - device configure routine.
  * @sdev: scsi device struct
  *
  * Returns 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
-static int
-_scsih_slave_configure(struct scsi_device *sdev)
+int
+scsih_slave_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -1757,7 +1755,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 			 raid_device->num_pds, ds);
 
 
-		_scsih_change_queue_depth(sdev, qdepth);
+		scsih_change_queue_depth(sdev, qdepth);
 
 /* raid transport support */
 		_scsih_set_level(sdev, raid_device->volume_type);
@@ -1829,7 +1827,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 		_scsih_display_sata_capabilities(ioc, handle, sdev);
 
 
-	_scsih_change_queue_depth(sdev, qdepth);
+	scsih_change_queue_depth(sdev, qdepth);
 
 	if (ssp_target) {
 		sas_read_port_mode_page(sdev);
@@ -1840,7 +1838,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 }
 
 /**
- * _scsih_bios_param - fetch head, sector, cylinder info for a disk
+ * scsih_bios_param - fetch head, sector, cylinder info for a disk
  * @sdev: scsi device struct
  * @bdev: pointer to block device context
  * @capacity: device size (in 512 byte sectors)
@@ -1851,8 +1849,8 @@ _scsih_slave_configure(struct scsi_device *sdev)
  *
  * Return nothing.
  */
-static int
-_scsih_bios_param(struct scsi_device *sdev, struct block_device *bdev,
+int
+scsih_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 	sector_t capacity, int params[])
 {
 	int		heads;
@@ -2252,13 +2250,13 @@ _scsih_tm_display_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
 }
 
 /**
- * _scsih_abort - eh threads main abort routine
+ * scsih_abort - eh threads main abort routine
  * @scmd: pointer to scsi command object
  *
  * Returns SUCCESS if command aborted else FAILED
  */
-static int
-_scsih_abort(struct scsi_cmnd *scmd)
+int
+scsih_abort(struct scsi_cmnd *scmd)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
@@ -2311,13 +2309,13 @@ _scsih_abort(struct scsi_cmnd *scmd)
 }
 
 /**
- * _scsih_dev_reset - eh threads main device reset routine
+ * scsih_dev_reset - eh threads main device reset routine
  * @scmd: pointer to scsi command object
  *
  * Returns SUCCESS if command aborted else FAILED
  */
-static int
-_scsih_dev_reset(struct scsi_cmnd *scmd)
+int
+scsih_dev_reset(struct scsi_cmnd *scmd)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
@@ -2370,13 +2368,13 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
 }
 
 /**
- * _scsih_target_reset - eh threads main target reset routine
+ * scsih_target_reset - eh threads main target reset routine
  * @scmd: pointer to scsi command object
  *
  * Returns SUCCESS if command aborted else FAILED
  */
-static int
-_scsih_target_reset(struct scsi_cmnd *scmd)
+int
+scsih_target_reset(struct scsi_cmnd *scmd)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
@@ -2431,13 +2429,13 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
 
 
 /**
- * _scsih_host_reset - eh threads main host reset routine
+ * scsih_host_reset - eh threads main host reset routine
  * @scmd: pointer to scsi command object
  *
  * Returns SUCCESS if command aborted else FAILED
  */
-static int
-_scsih_host_reset(struct scsi_cmnd *scmd)
+int
+scsih_host_reset(struct scsi_cmnd *scmd)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	int r, retval;
@@ -3635,7 +3633,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 
 
 /**
- * _scsih_qcmd - main scsi request entry point
+ * scsih_qcmd - main scsi request entry point
  * @scmd: pointer to scsi command object
  * @done: function pointer to be invoked on completion
  *
@@ -3645,8 +3643,8 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
  * SCSI_MLQUEUE_DEVICE_BUSY if the device queue is full, or
  * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
  */
-static int
-_scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
+int
+scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
@@ -7493,20 +7491,20 @@ static struct scsi_host_template scsih_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "Fusion MPT SAS Host",
 	.proc_name			= MPT3SAS_DRIVER_NAME,
-	.queuecommand			= _scsih_qcmd,
-	.target_alloc			= _scsih_target_alloc,
-	.slave_alloc			= _scsih_slave_alloc,
-	.slave_configure		= _scsih_slave_configure,
-	.target_destroy			= _scsih_target_destroy,
-	.slave_destroy			= _scsih_slave_destroy,
-	.scan_finished			= _scsih_scan_finished,
-	.scan_start			= _scsih_scan_start,
-	.change_queue_depth		= _scsih_change_queue_depth,
-	.eh_abort_handler		= _scsih_abort,
-	.eh_device_reset_handler	= _scsih_dev_reset,
-	.eh_target_reset_handler	= _scsih_target_reset,
-	.eh_host_reset_handler		= _scsih_host_reset,
-	.bios_param			= _scsih_bios_param,
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
 	.can_queue			= 1,
 	.this_id			= -1,
 	.sg_tablesize			= MPT3SAS_SG_DEPTH,
@@ -7638,13 +7636,13 @@ _scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * _scsih_remove - detach and remove add host
+ * scsih_remove - detach and remove add host
  * @pdev: PCI device struct
  *
  * Routine called when unloading the driver.
  * Return nothing.
  */
-static void _scsih_remove(struct pci_dev *pdev)
+void scsih_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -7710,13 +7708,13 @@ static void _scsih_remove(struct pci_dev *pdev)
 }
 
 /**
- * _scsih_shutdown - routine call during system shutdown
+ * scsih_shutdown - routine call during system shutdown
  * @pdev: PCI device struct
  *
  * Return nothing.
  */
-static void
-_scsih_shutdown(struct pci_dev *pdev)
+void
+scsih_shutdown(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -7908,15 +7906,15 @@ _scsih_probe_devices(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * _scsih_scan_start - scsi lld callback for .scan_start
+ * scsih_scan_start - scsi lld callback for .scan_start
  * @shost: SCSI host pointer
  *
  * The shost has the ability to discover targets on its own instead
  * of scanning the entire bus.  In our implemention, we will kick off
  * firmware discovery.
  */
-static void
-_scsih_scan_start(struct Scsi_Host *shost)
+void
+scsih_scan_start(struct Scsi_Host *shost)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	int rc;
@@ -7934,7 +7932,7 @@ _scsih_scan_start(struct Scsi_Host *shost)
 }
 
 /**
- * _scsih_scan_finished - scsi lld callback for .scan_finished
+ * scsih_scan_finished - scsi lld callback for .scan_finished
  * @shost: SCSI host pointer
  * @time: elapsed time of the scan in jiffies
  *
@@ -7942,8 +7940,8 @@ _scsih_scan_start(struct Scsi_Host *shost)
  * scsi_host and the elapsed time of the scan in jiffies. In our implemention,
  * we wait for firmware discovery to complete, then return 1.
  */
-static int
-_scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
+int
+scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 
@@ -7988,14 +7986,14 @@ _scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 }
 
 /**
- * _scsih_probe - attach and add scsi host
+ * scsih_probe - attach and add scsi host
  * @pdev: PCI device struct
  * @id: pci device id
  *
  * Returns 0 success, anything else error.
  */
-static int
-_scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+int
+scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct MPT3SAS_ADAPTER *ioc;
 	struct Scsi_Host *shost;
@@ -8124,14 +8122,14 @@ out_add_shost_fail:
 
 #ifdef CONFIG_PM
 /**
- * _scsih_suspend - power management suspend main entry point
+ * scsih_suspend - power management suspend main entry point
  * @pdev: PCI device struct
  * @state: PM state change to (usually PCI_D3)
  *
  * Returns 0 success, anything else error.
  */
-static int
-_scsih_suspend(struct pci_dev *pdev, pm_message_t state)
+int
+scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -8152,13 +8150,13 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 }
 
 /**
- * _scsih_resume - power management resume main entry point
+ * scsih_resume - power management resume main entry point
  * @pdev: PCI device struct
  *
  * Returns 0 success, anything else error.
  */
-static int
-_scsih_resume(struct pci_dev *pdev)
+int
+scsih_resume(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -8185,7 +8183,7 @@ _scsih_resume(struct pci_dev *pdev)
 #endif /* CONFIG_PM */
 
 /**
- * _scsih_pci_error_detected - Called when a PCI error is detected.
+ * scsih_pci_error_detected - Called when a PCI error is detected.
  * @pdev: PCI device struct
  * @state: PCI channel state
  *
@@ -8194,8 +8192,8 @@ _scsih_resume(struct pci_dev *pdev)
  * Return value:
  *      PCI_ERS_RESULT_NEED_RESET or PCI_ERS_RESULT_DISCONNECT
  */
-static pci_ers_result_t
-_scsih_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
+pci_ers_result_t
+scsih_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -8224,15 +8222,15 @@ _scsih_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 }
 
 /**
- * _scsih_pci_slot_reset - Called when PCI slot has been reset.
+ * scsih_pci_slot_reset - Called when PCI slot has been reset.
  * @pdev: PCI device struct
  *
  * Description: This routine is called by the pci error recovery
  * code after the PCI slot has been reset, just before we
  * should resume normal operations.
  */
-static pci_ers_result_t
-_scsih_pci_slot_reset(struct pci_dev *pdev)
+pci_ers_result_t
+scsih_pci_slot_reset(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -8261,15 +8259,15 @@ _scsih_pci_slot_reset(struct pci_dev *pdev)
 }
 
 /**
- * _scsih_pci_resume() - resume normal ops after PCI reset
+ * scsih_pci_resume() - resume normal ops after PCI reset
  * @pdev: pointer to PCI device
  *
  * Called when the error recovery driver tells us that its
  * OK to resume normal operation. Use completion to allow
  * halted scsi ops to resume.
  */
-static void
-_scsih_pci_resume(struct pci_dev *pdev)
+void
+scsih_pci_resume(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -8282,11 +8280,11 @@ _scsih_pci_resume(struct pci_dev *pdev)
 }
 
 /**
- * _scsih_pci_mmio_enabled - Enable MMIO and dump debug registers
+ * scsih_pci_mmio_enabled - Enable MMIO and dump debug registers
  * @pdev: pointer to PCI device
  */
-static pci_ers_result_t
-_scsih_pci_mmio_enabled(struct pci_dev *pdev)
+pci_ers_result_t
+scsih_pci_mmio_enabled(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -8303,39 +8301,39 @@ _scsih_pci_mmio_enabled(struct pci_dev *pdev)
 /* raid transport support */
 static struct raid_function_template mpt3sas_raid_functions = {
 	.cookie		= &scsih_driver_template,
-	.is_raid	= _scsih_is_raid,
-	.get_resync	= _scsih_get_resync,
-	.get_state	= _scsih_get_state,
+	.is_raid	= scsih_is_raid,
+	.get_resync	= scsih_get_resync,
+	.get_state	= scsih_get_state,
 };
 
 static struct pci_error_handlers _scsih_err_handler = {
-	.error_detected = _scsih_pci_error_detected,
-	.mmio_enabled = _scsih_pci_mmio_enabled,
-	.slot_reset =	_scsih_pci_slot_reset,
-	.resume =	_scsih_pci_resume,
+	.error_detected = scsih_pci_error_detected,
+	.mmio_enabled = scsih_pci_mmio_enabled,
+	.slot_reset =	scsih_pci_slot_reset,
+	.resume =	scsih_pci_resume,
 };
 
 static struct pci_driver scsih_driver = {
 	.name		= MPT3SAS_DRIVER_NAME,
 	.id_table	= scsih_pci_table,
-	.probe		= _scsih_probe,
-	.remove		= _scsih_remove,
-	.shutdown	= _scsih_shutdown,
+	.probe		= scsih_probe,
+	.remove		= scsih_remove,
+	.shutdown	= scsih_shutdown,
 	.err_handler	= &_scsih_err_handler,
 #ifdef CONFIG_PM
-	.suspend	= _scsih_suspend,
-	.resume		= _scsih_resume,
+	.suspend	= scsih_suspend,
+	.resume		= scsih_resume,
 #endif
 };
 
 
 /**
- * _scsih_init - main entry point for this driver.
+ * scsih_init - main entry point for this driver.
  *
  * Returns 0 success, anything else error.
  */
-static int __init
-_scsih_init(void)
+int
+scsih_init(void)
 {
 	int error;
 
@@ -8392,7 +8390,7 @@ _scsih_init(void)
 	tm_sas_control_cb_idx = mpt3sas_base_register_callback_handler(
 	    _scsih_sas_control_complete);
 
-	mpt3sas_ctl_init();
+	ctl_init();
 
 	error = pci_register_driver(&scsih_driver);
 	if (error) {
@@ -8409,13 +8407,13 @@ _scsih_init(void)
  *
  * Returns 0 success, anything else error.
  */
-static void __exit
-_scsih_exit(void)
+void
+scsih_exit(void)
 {
 	pr_info("mpt3sas version %s unloading\n",
 	    MPT3SAS_DRIVER_VERSION);
 
-	mpt3sas_ctl_exit();
+	ctl_exit();
 
 	pci_unregister_driver(&scsih_driver);
 
@@ -8438,5 +8436,5 @@ _scsih_exit(void)
 	sas_release_transport(mpt3sas_transport_template);
 }
 
-module_init(_scsih_init);
-module_exit(_scsih_exit);
+module_init(scsih_init);
+module_exit(scsih_exit);
-- 
2.0.2

