From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 22/25] mpt3sas: Added a module parameter hbas_to_enumerate
Date: Wed, 11 Nov 2015 17:30:38 +0530
Message-ID: <1447243241-10912-23-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34259 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbbKKMDD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2015 07:03:03 -0500
Received: by padhx2 with SMTP id hx2so29768698pad.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2015 04:03:02 -0800 (PST)
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Added module parameter 'hbas_to_enumerate', which user can
use this merged driver as legacy mpt2sas driver or as a
legacy mpt3sas driver if needed.

Here are the available options for this module parameter
  0 - Merged driver which enumerates both SAS 2.0 & SAS 3.0 HBAs
  1 - Acts as legacy mpt2sas driver, which enumerates only SAS 2.0 HBAs
  2 - Acts as legacy mpt3sas driver, which enumerates only SAS 3.0 HBAs

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  4 +--
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 32 +++++++++++++-------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 58 +++++++++++++++++++++++++++---------
 3 files changed, 68 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 087586e..25c141c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1357,8 +1357,8 @@ int mpt3sas_config_get_volume_wwid(struct MPT3SAS_ADAPTER *ioc,
 /* ctl shared API */
 extern struct device_attribute *mpt3sas_host_attrs[];
 extern struct device_attribute *mpt3sas_dev_attrs[];
-void mpt3sas_ctl_init(void);
-void mpt3sas_ctl_exit(void);
+void mpt3sas_ctl_init(ushort hbas_to_enumerate);
+void mpt3sas_ctl_exit(ushort hbas_to_enumerate);
 u8 mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
 void mpt3sas_ctl_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 05b0733..d8366b0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3404,15 +3404,25 @@ static struct miscdevice gen2_ctl_dev = {
  *
  */
 void
-mpt3sas_ctl_init(void)
+mpt3sas_ctl_init(ushort hbas_to_enumerate)
 {
 	async_queue = NULL;
-	if (misc_register(&ctl_dev) < 0)
-		pr_err("%s can't register misc device [minor=%d]\n",
-		    MPT3SAS_DRIVER_NAME, MPT3SAS_MINOR);
-	if (misc_register(&gen2_ctl_dev) < 0)
-		pr_err("%s can't register misc device [minor=%d]\n",
-		    MPT2SAS_DRIVER_NAME, MPT2SAS_MINOR);
+
+	/* Don't register mpt3ctl ioctl device if
+	 * hbas_to_enumarate is one.
+	 */
+	if (hbas_to_enumerate != 1)
+		if (misc_register(&ctl_dev) < 0)
+			pr_err("%s can't register misc device [minor=%d]\n",
+			    MPT3SAS_DRIVER_NAME, MPT3SAS_MINOR);
+
+	/* Don't register mpt3ctl ioctl device if
+	 * hbas_to_enumarate is two.
+	 */
+	if (hbas_to_enumerate != 2)
+		if (misc_register(&gen2_ctl_dev) < 0)
+			pr_err("%s can't register misc device [minor=%d]\n",
+			    MPT2SAS_DRIVER_NAME, MPT2SAS_MINOR);
 
 	init_waitqueue_head(&ctl_poll_wait);
 }
@@ -3422,7 +3432,7 @@ mpt3sas_ctl_init(void)
  *
  */
 void
-mpt3sas_ctl_exit(void)
+mpt3sas_ctl_exit(ushort hbas_to_enumerate)
 {
 	struct MPT3SAS_ADAPTER *ioc;
 	int i;
@@ -3447,6 +3457,8 @@ mpt3sas_ctl_exit(void)
 
 		kfree(ioc->event_log);
 	}
-	misc_deregister(&ctl_dev);
-	misc_deregister(&gen2_ctl_dev);
+	if (hbas_to_enumerate != 1)
+		misc_deregister(&ctl_dev);
+	if (hbas_to_enumerate != 2)
+		misc_deregister(&gen2_ctl_dev);
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 04570a2..d95206b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -119,8 +119,12 @@ static u64 max_lun = MPT3SAS_MAX_LUN;
 module_param(max_lun, ullong, 0);
 MODULE_PARM_DESC(max_lun, " max lun, default=16895 ");
 
-
-
+static ushort hbas_to_enumerate;
+module_param(hbas_to_enumerate, ushort, 0);
+MODULE_PARM_DESC(hbas_to_enumerate,
+		" 0 - enumerates both SAS 2.0 & SAS 3.0 generation HBAs\n \
+		  1 - enumerates only SAS 2.0 generation HBAs\n \
+		  2 - enumerates only SAS 3.0 generation HBAs (default=0)");
 
 /* diag_buffer_enable is bitwise
  * bit 0 set = TRACE
@@ -8444,6 +8448,18 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (hba_mpi_version == 0)
 		return -ENODEV;
 
+	/* Enumerate only SAS 2.0 HBA's if hbas_to_enumerate is one,
+	 * for other generation HBA's return with -ENODEV
+	 */
+	if ((hbas_to_enumerate == 1) && (hba_mpi_version !=  MPI2_VERSION))
+		return -ENODEV;
+
+	/* Enumerate only SAS 3.0 HBA's if hbas_to_enumerate is two,
+	 * for other generation HBA's return with -ENODEV
+	 */
+	if ((hbas_to_enumerate == 2) && (hba_mpi_version !=  MPI25_VERSION))
+		return -ENODEV;
+
 	switch (hba_mpi_version) {
 	case MPI2_VERSION:
 		/* Use mpt2sas driver host template for SAS 2.0 HBA's */
@@ -8948,8 +8964,10 @@ scsih_exit(void)
 	mpt3sas_base_release_callback_handler(tm_sas_control_cb_idx);
 
 /* raid transport support */
-	raid_class_release(mpt3sas_raid_template);
-	raid_class_release(mpt2sas_raid_template);
+	if (hbas_to_enumerate != 1)
+		raid_class_release(mpt3sas_raid_template);
+	if (hbas_to_enumerate != 2)
+		raid_class_release(mpt2sas_raid_template);
 	sas_release_transport(mpt3sas_transport_template);
 }
 
@@ -8971,16 +8989,28 @@ _mpt3sas_init(void)
 	if (!mpt3sas_transport_template)
 		return -ENODEV;
 
-	mpt3sas_raid_template = raid_class_attach(&mpt3sas_raid_functions);
-	if (!mpt3sas_raid_template) {
-		sas_release_transport(mpt3sas_transport_template);
-		return -ENODEV;
+	/* No need attach mpt3sas raid functions template
+	 * if hbas_to_enumarate value is one.
+	 */
+	if (hbas_to_enumerate != 1) {
+		mpt3sas_raid_template =
+				raid_class_attach(&mpt3sas_raid_functions);
+		if (!mpt3sas_raid_template) {
+			sas_release_transport(mpt3sas_transport_template);
+			return -ENODEV;
+		}
 	}
 
-	mpt2sas_raid_template = raid_class_attach(&mpt2sas_raid_functions);
-	if (!mpt2sas_raid_template) {
-		sas_release_transport(mpt3sas_transport_template);
-		return -ENODEV;
+	/* No need to attach mpt2sas raid functions template
+	 * if hbas_to_enumarate value is two
+	 */
+	if (hbas_to_enumerate != 2) {
+		mpt2sas_raid_template =
+				raid_class_attach(&mpt2sas_raid_functions);
+		if (!mpt2sas_raid_template) {
+			sas_release_transport(mpt3sas_transport_template);
+			return -ENODEV;
+		}
 	}
 
 	error = scsih_init();
@@ -8989,7 +9019,7 @@ _mpt3sas_init(void)
 		return error;
 	}
 
-	mpt3sas_ctl_init();
+	mpt3sas_ctl_init(hbas_to_enumerate);
 
 	error = pci_register_driver(&mpt3sas_driver);
 	if (error)
@@ -9010,7 +9040,7 @@ _mpt3sas_exit(void)
 
 	pci_unregister_driver(&mpt3sas_driver);
 
-	mpt3sas_ctl_exit();
+	mpt3sas_ctl_exit(hbas_to_enumerate);
 
 	scsih_exit();
 }
-- 
2.0.2

