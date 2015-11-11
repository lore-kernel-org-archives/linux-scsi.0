From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH RESEND 03/25] mpt3sas: Move Gen3 HBA's device registration with PCI, SML and IOCTL related API's to a separate file
Date: Wed, 11 Nov 2015 17:30:19 +0530
Message-ID: <1447243241-10912-4-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33755 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbbKKMBU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2015 07:01:20 -0500
Received: by pabfh17 with SMTP id fh17so29715894pab.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2015 04:01:20 -0800 (PST)
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

1. Created a mpt3sas_module.c files for mpt3sas driver module,
where it can register SAS3 HBA devices with PCI, SML, IOCTL
subsystems. Also removed the correspanding API's from
mpt3sas_scsih.c file.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/Makefile         |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h   |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c    |  21 ---
 drivers/scsi/mpt3sas/mpt3sas_module.c | 252 ++++++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  | 140 +------------------
 5 files changed, 261 insertions(+), 159 deletions(-)
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_module.c

diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefile
index efb0c4c..188057f 100644
--- a/drivers/scsi/mpt3sas/Makefile
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -5,4 +5,5 @@ mpt3sas-y +=  mpt3sas_base.o     \
 		mpt3sas_scsih.o      \
 		mpt3sas_transport.o     \
 		mpt3sas_ctl.o	\
-		mpt3sas_trigger_diag.o
+		mpt3sas_trigger_diag.o \
+		mpt3sas_module.o
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 699cf72..0f86729 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1084,6 +1084,7 @@ int mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc);
 
 
 /* scsih shared API */
+extern struct raid_template *mpt3sas_raid_template;
 u8 mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	u32 reply);
 void mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase);
@@ -1108,7 +1109,7 @@ void mpt3sas_port_enable_complete(struct MPT3SAS_ADAPTER *ioc);
 
 void scsih_exit(void);
 int scsih_init(void);
-int scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id);
+int scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost);
 void scsih_remove(struct pci_dev *pdev);
 void scsih_shutdown(struct pci_dev *pdev);
 pci_ers_result_t scsih_pci_error_detected(struct pci_dev *pdev,
@@ -1241,6 +1242,7 @@ int mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 	u8 *issue_reset);
 
 /* transport shared API */
+extern struct scsi_transport_template *mpt3sas_transport_template;
 u8 mpt3sas_transport_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
 struct _sas_port *mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index e72a16c..ffe7982 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3218,22 +3218,6 @@ struct device_attribute *mpt3sas_dev_attrs[] = {
 	NULL,
 };
 
-static const struct file_operations ctl_fops = {
-	.owner = THIS_MODULE,
-	.unlocked_ioctl = ctl_ioctl,
-	.poll = ctl_poll,
-	.fasync = ctl_fasync,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = ctl_ioctl_compat,
-#endif
-};
-
-static struct miscdevice ctl_dev = {
-	.minor  = MPT3SAS_MINOR,
-	.name   = MPT3SAS_DEV_NAME,
-	.fops   = &ctl_fops,
-};
-
 /**
  * ctl_init - main entry point for ctl.
  *
@@ -3242,10 +3226,6 @@ void
 ctl_init(void)
 {
 	async_queue = NULL;
-	if (misc_register(&ctl_dev) < 0)
-		pr_err("%s can't register misc device [minor=%d]\n",
-		    MPT3SAS_DRIVER_NAME, MPT3SAS_MINOR);
-
 	init_waitqueue_head(&ctl_poll_wait);
 }
 
@@ -3279,5 +3259,4 @@ ctl_exit(void)
 
 		kfree(ioc->event_log);
 	}
-	misc_deregister(&ctl_dev);
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_module.c b/drivers/scsi/mpt3sas/mpt3sas_module.c
new file mode 100644
index 0000000..e5f43ba
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpt3sas_module.c
@@ -0,0 +1,252 @@
+/*
+ * Scsi Host Layer for MPT (Message Passing Technology) based controllers
+ *
+ * Copyright (C) 2012-2014  LSI Corporation
+ * Copyright (C) 2013-2015 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * NO WARRANTY
+ * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+ * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+ * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+ * solely responsible for determining the appropriateness of using and
+ * distributing the Program and assumes all risks associated with its
+ * exercise of rights under this Agreement, including but not limited to
+ * the risks and costs of program errors, damage to or loss of data,
+ * programs or equipment, and unavailability or interruption of operations.
+
+ * DISCLAIMER OF LIABILITY
+ * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+ * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+ * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program.
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/raid_class.h>
+
+#include "mpt3sas_base.h"
+#include "mpt3sas_ctl.h"
+
+MODULE_AUTHOR(MPT3SAS_AUTHOR);
+MODULE_DESCRIPTION(MPT3SAS_DESCRIPTION);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(MPT3SAS_DRIVER_VERSION);
+
+/* shost template */
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
+/* raid transport support */
+static struct raid_function_template mpt3sas_raid_functions = {
+	.cookie		= &mpt3sas_driver_template,
+	.is_raid	= scsih_is_raid,
+	.get_resync	= scsih_get_resync,
+	.get_state	= scsih_get_state,
+};
+
+/*
+ * The pci device ids are defined in mpi/mpi2_cnfg.h.
+ */
+static const struct pci_device_id mpt3sas_pci_table[] = {
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
+static const struct file_operations mpt3sas_ctl_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = ctl_ioctl,
+	.poll = ctl_poll,
+	.fasync = ctl_fasync,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = ctl_ioctl_compat,
+#endif
+};
+
+static struct miscdevice mpt3sas_ctl_dev = {
+	.minor  = MPT3SAS_MINOR,
+	.name   = MPT3SAS_DEV_NAME,
+	.fops   = &mpt3sas_ctl_fops,
+};
+
+/**
+ * mpt3sas_ctl_init - main entry point for ctl.
+ *
+ */
+void
+mpt3sas_ctl_init(void)
+{
+	ctl_init();
+	if (misc_register(&mpt3sas_ctl_dev) < 0)
+		pr_err("%s can't register misc device [minor=%d]\n",
+		    MPT3SAS_DRIVER_NAME, MPT3SAS_MINOR);
+}
+
+/**
+ * mpt3sas_ctl_exit - exit point for ctl
+ *
+ */
+void
+mpt3sas_ctl_exit(void)
+{
+	ctl_exit();
+	misc_deregister(&mpt3sas_ctl_dev);
+}
+
+/**
+ * _mpt3sas_probe - attach and add scsi host
+ * @pdev: PCI device struct
+ * @id: pci device id
+ *
+ * Returns 0 success, anything else error.
+ */
+static int
+_mpt3sas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct Scsi_Host *shost;
+	int rv;
+
+	shost = scsi_host_alloc(&mpt3sas_driver_template,
+				sizeof(struct MPT3SAS_ADAPTER));
+	if (!shost)
+		return -ENODEV;
+
+	rv = scsih_probe(pdev, shost);
+	return rv;
+}
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
+	.probe		= _mpt3sas_probe,
+	.remove		= scsih_remove,
+	.shutdown	= scsih_shutdown,
+	.err_handler	= &_mpt3sas_err_handler,
+#ifdef CONFIG_PM
+	.suspend	= scsih_suspend,
+	.resume		= scsih_resume,
+#endif
+};
+
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
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 3353b48..56726a0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -57,11 +57,6 @@
 
 #include "mpt3sas_base.h"
 
-MODULE_AUTHOR(MPT3SAS_AUTHOR);
-MODULE_DESCRIPTION(MPT3SAS_DESCRIPTION);
-MODULE_LICENSE("GPL");
-MODULE_VERSION(MPT3SAS_DRIVER_VERSION);
-
 #define RAID_CHANNEL 1
 /* forward proto's */
 static void _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
@@ -141,8 +136,7 @@ MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=7 ");
 
 
 /* raid transport support */
-
-static struct raid_template *mpt3sas_raid_template;
+struct raid_template *mpt3sas_raid_template;
 
 
 /**
@@ -192,9 +186,6 @@ struct fw_event_work {
 	char			event_data[0] __aligned(4);
 };
 
-/* raid transport support */
-static struct raid_template *mpt3sas_raid_template;
-
 /**
  * struct _scsi_io_transfer - scsi io transfer
  * @handle: sas device handle (assigned by firmware)
@@ -243,28 +234,6 @@ struct _scsi_io_transfer {
 	u32	transfer_length;
 };
 
-/*
- * The pci device ids are defined in mpi/mpi2_cnfg.h.
- */
-static const struct pci_device_id scsih_pci_table[] = {
-	/* Fury ~ 3004 and 3008 */
-	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3004,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3008,
-		PCI_ANY_ID, PCI_ANY_ID },
-	/* Invader ~ 3108 */
-	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_1,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_2,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_5,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_6,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{0}	/* Terminating entry */
-};
-MODULE_DEVICE_TABLE(pci, scsih_pci_table);
-
 /**
  * _scsih_set_debug_level - global setting of ioc->logging_level.
  *
@@ -7486,36 +7455,6 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	return 1;
 }
 
-/* shost template */
-static struct scsi_host_template scsih_driver_template = {
-	.module				= THIS_MODULE,
-	.name				= "Fusion MPT SAS Host",
-	.proc_name			= MPT3SAS_DRIVER_NAME,
-	.queuecommand			= scsih_qcmd,
-	.target_alloc			= scsih_target_alloc,
-	.slave_alloc			= scsih_slave_alloc,
-	.slave_configure		= scsih_slave_configure,
-	.target_destroy			= scsih_target_destroy,
-	.slave_destroy			= scsih_slave_destroy,
-	.scan_finished			= scsih_scan_finished,
-	.scan_start			= scsih_scan_start,
-	.change_queue_depth		= scsih_change_queue_depth,
-	.eh_abort_handler		= scsih_abort,
-	.eh_device_reset_handler	= scsih_dev_reset,
-	.eh_target_reset_handler	= scsih_target_reset,
-	.eh_host_reset_handler		= scsih_host_reset,
-	.bios_param			= scsih_bios_param,
-	.can_queue			= 1,
-	.this_id			= -1,
-	.sg_tablesize			= MPT3SAS_SG_DEPTH,
-	.max_sectors			= 32767,
-	.cmd_per_lun			= 7,
-	.use_clustering			= ENABLE_CLUSTERING,
-	.shost_attrs			= mpt3sas_host_attrs,
-	.sdev_attrs			= mpt3sas_dev_attrs,
-	.track_queue_depth		= 1,
-};
-
 /**
  * _scsih_expander_node_remove - removing expander device from list.
  * @ioc: per adapter object
@@ -7993,17 +7932,11 @@ scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
  * Returns 0 success, anything else error.
  */
 int
-scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
 {
 	struct MPT3SAS_ADAPTER *ioc;
-	struct Scsi_Host *shost;
 	int rv;
 
-	shost = scsi_host_alloc(&scsih_driver_template,
-	    sizeof(struct MPT3SAS_ADAPTER));
-	if (!shost)
-		return -ENODEV;
-
 	/* init local params */
 	ioc = shost_priv(shost);
 	memset(ioc, 0, sizeof(struct MPT3SAS_ADAPTER));
@@ -8298,35 +8231,6 @@ scsih_pci_mmio_enabled(struct pci_dev *pdev)
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
-/* raid transport support */
-static struct raid_function_template mpt3sas_raid_functions = {
-	.cookie		= &scsih_driver_template,
-	.is_raid	= scsih_is_raid,
-	.get_resync	= scsih_get_resync,
-	.get_state	= scsih_get_state,
-};
-
-static struct pci_error_handlers _scsih_err_handler = {
-	.error_detected = scsih_pci_error_detected,
-	.mmio_enabled = scsih_pci_mmio_enabled,
-	.slot_reset =	scsih_pci_slot_reset,
-	.resume =	scsih_pci_resume,
-};
-
-static struct pci_driver scsih_driver = {
-	.name		= MPT3SAS_DRIVER_NAME,
-	.id_table	= scsih_pci_table,
-	.probe		= scsih_probe,
-	.remove		= scsih_remove,
-	.shutdown	= scsih_shutdown,
-	.err_handler	= &_scsih_err_handler,
-#ifdef CONFIG_PM
-	.suspend	= scsih_suspend,
-	.resume		= scsih_resume,
-#endif
-};
-
-
 /**
  * scsih_init - main entry point for this driver.
  *
@@ -8335,25 +8239,8 @@ static struct pci_driver scsih_driver = {
 int
 scsih_init(void)
 {
-	int error;
-
 	mpt_ids = 0;
 
-	pr_info("%s version %s loaded\n", MPT3SAS_DRIVER_NAME,
-	    MPT3SAS_DRIVER_VERSION);
-
-	mpt3sas_transport_template =
-	    sas_attach_transport(&mpt3sas_transport_functions);
-	if (!mpt3sas_transport_template)
-		return -ENODEV;
-
-/* raid transport support */
-	mpt3sas_raid_template = raid_class_attach(&mpt3sas_raid_functions);
-	if (!mpt3sas_raid_template) {
-		sas_release_transport(mpt3sas_transport_template);
-		return -ENODEV;
-	}
-
 	mpt3sas_base_initialize_callback_handler();
 
 	 /* queuecommand callback hander */
@@ -8390,33 +8277,17 @@ scsih_init(void)
 	tm_sas_control_cb_idx = mpt3sas_base_register_callback_handler(
 	    _scsih_sas_control_complete);
 
-	ctl_init();
-
-	error = pci_register_driver(&scsih_driver);
-	if (error) {
-		/* raid transport support */
-		raid_class_release(mpt3sas_raid_template);
-		sas_release_transport(mpt3sas_transport_template);
-	}
-
-	return error;
+	return 0;
 }
 
 /**
- * _scsih_exit - exit point for this driver (when it is a module).
+ * scsih_exit - exit point for this driver (when it is a module).
  *
  * Returns 0 success, anything else error.
  */
 void
 scsih_exit(void)
 {
-	pr_info("mpt3sas version %s unloading\n",
-	    MPT3SAS_DRIVER_VERSION);
-
-	ctl_exit();
-
-	pci_unregister_driver(&scsih_driver);
-
 
 	mpt3sas_base_release_callback_handler(scsi_io_cb_idx);
 	mpt3sas_base_release_callback_handler(tm_cb_idx);
@@ -8435,6 +8306,3 @@ scsih_exit(void)
 	raid_class_release(mpt3sas_raid_template);
 	sas_release_transport(mpt3sas_transport_template);
 }
-
-module_init(scsih_init);
-module_exit(scsih_exit);
-- 
2.0.2

