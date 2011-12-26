From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 2/3 v4] mpt2sas: use pci_dev->revision
Date: Mon, 26 Dec 2011 19:29:26 +0300
Message-ID: <201112261929.26333.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:35000 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755621Ab1LZPac (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Dec 2011 10:30:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org

The driver reads PCI revision ID from the PCI configuration register while it's
already stored by PCI subsystem in the 'revision' field of 'struct pci_dev'...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is refreshed against the recent Linus' tree.

 drivers/scsi/mpt2sas/mpt2sas_base.c |    4 +---
 drivers/scsi/mpt2sas/mpt2sas_ctl.c  |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/scsi/mpt2sas/mpt2sas_base.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ linux-2.6/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1992,12 +1992,10 @@ _base_display_ioc_capabilities(struct MP
 {
 	int i = 0;
 	char desc[16];
-	u8 revision;
 	u32 iounit_pg1_flags;
 	u32 bios_version;
 
 	bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
-	pci_read_config_byte(ioc->pdev, PCI_CLASS_REVISION, &revision);
 	strncpy(desc, ioc->manu_pg0.ChipName, 16);
 	printk(MPT2SAS_INFO_FMT "%s: FWVersion(%02d.%02d.%02d.%02d), "
 	   "ChipRevision(0x%02x), BiosVersion(%02d.%02d.%02d.%02d)\n",
@@ -2006,7 +2004,7 @@ _base_display_ioc_capabilities(struct MP
 	   (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
 	   (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
 	   ioc->facts.FWVersion.Word & 0x000000FF,
-	   revision,
+	   ioc->pdev->revision,
 	   (bios_version & 0xFF000000) >> 24,
 	   (bios_version & 0x00FF0000) >> 16,
 	   (bios_version & 0x0000FF00) >> 8,
Index: linux-2.6/drivers/scsi/mpt2sas/mpt2sas_ctl.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ linux-2.6/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -1026,7 +1026,6 @@ _ctl_getiocinfo(void __user *arg)
 {
 	struct mpt2_ioctl_iocinfo karg;
 	struct MPT2SAS_ADAPTER *ioc;
-	u8 revision;
 
 	if (copy_from_user(&karg, arg, sizeof(karg))) {
 		printk(KERN_ERR "failure at %s:%d/%s()!\n",
@@ -1046,8 +1045,7 @@ _ctl_getiocinfo(void __user *arg)
 		karg.adapter_type = MPT2_IOCTL_INTERFACE_SAS2;
 	if (ioc->pfacts)
 		karg.port_number = ioc->pfacts[0].PortNumber;
-	pci_read_config_byte(ioc->pdev, PCI_CLASS_REVISION, &revision);
-	karg.hw_rev = revision;
+	karg.hw_rev = ioc->pdev->revision;
 	karg.pci_id = ioc->pdev->device;
 	karg.subsystem_device = ioc->pdev->subsystem_device;
 	karg.subsystem_vendor = ioc->pdev->subsystem_vendor;
