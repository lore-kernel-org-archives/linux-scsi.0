From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH resend] mpt2sas: use pci_dev->revision
Date: Fri, 13 May 2011 19:07:06 +0400
Message-ID: <201105131907.06187.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:57651 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752984Ab1EMPIf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2011 11:08:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

The driver reads PCI revision ID from the PCI configuration register while it's
already stored by PCI subsystem in the 'revision' field of 'struct pci_dev'...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.
It wasn't merged in 2.6.39 time, I hope it can be merged to 2.6.40...

 drivers/scsi/mpt2sas/mpt2sas_base.c |    4 +---
 drivers/scsi/mpt2sas/mpt2sas_ctl.c  |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/scsi/mpt2sas/mpt2sas_base.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ linux-2.6/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1806,10 +1806,8 @@ _base_display_ioc_capabilities(struct MP
 {
 	int i = 0;
 	char desc[16];
-	u8 revision;
 	u32 iounit_pg1_flags;
 
-	pci_read_config_byte(ioc->pdev, PCI_CLASS_REVISION, &revision);
 	strncpy(desc, ioc->manu_pg0.ChipName, 16);
 	printk(MPT2SAS_INFO_FMT "%s: FWVersion(%02d.%02d.%02d.%02d), "
 	   "ChipRevision(0x%02x), BiosVersion(%02d.%02d.%02d.%02d)\n",
@@ -1818,7 +1816,7 @@ _base_display_ioc_capabilities(struct MP
 	   (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
 	   (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
 	   ioc->facts.FWVersion.Word & 0x000000FF,
-	   revision,
+	   ioc->pdev->revision,
 	   (ioc->bios_pg3.BiosVersion & 0xFF000000) >> 24,
 	   (ioc->bios_pg3.BiosVersion & 0x00FF0000) >> 16,
 	   (ioc->bios_pg3.BiosVersion & 0x0000FF00) >> 8,
Index: linux-2.6/drivers/scsi/mpt2sas/mpt2sas_ctl.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ linux-2.6/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -1027,7 +1027,6 @@ _ctl_getiocinfo(void __user *arg)
 {
 	struct mpt2_ioctl_iocinfo karg;
 	struct MPT2SAS_ADAPTER *ioc;
-	u8 revision;
 
 	if (copy_from_user(&karg, arg, sizeof(karg))) {
 		printk(KERN_ERR "failure at %s:%d/%s()!\n",
@@ -1044,8 +1043,7 @@ _ctl_getiocinfo(void __user *arg)
 	karg.adapter_type = MPT2_IOCTL_INTERFACE_SAS2;
 	if (ioc->pfacts)
 		karg.port_number = ioc->pfacts[0].PortNumber;
-	pci_read_config_byte(ioc->pdev, PCI_CLASS_REVISION, &revision);
-	karg.hw_rev = revision;
+	karg.hw_rev = ioc->pdev->revision;
 	karg.pci_id = ioc->pdev->device;
 	karg.subsystem_device = ioc->pdev->subsystem_device;
 	karg.subsystem_vendor = ioc->pdev->subsystem_vendor;
