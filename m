From: akpm@linux-foundation.org
Subject: [patch 06/17] scsi: fix section mismatch in aic94xx
Date: Fri, 28 Mar 2008 14:48:36 -0700
Message-ID: <200803282148.m2SLma9o012231@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034AbYC1VtK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 17:49:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org, James.Bottomley@SteelEye.com, gilbert_wu@adaptec.com

From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: vmlinux.o(.data+0x17aa88): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
WARNING: vmlinux.o(.data+0x17aa98): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
WARNING: vmlinux.o(.data+0x17aaa8): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9405_setup()

asd_pcidev_data is only used by __devinit asd_pci_probe.  So mark is const and
annotate it __devinitconst to fix the warnings.

[akpm@linux-foundation.org: fix warning]
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gilbert Wu <gilbert_wu@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_init.c~scsi-fix-section-mismatch-in-aic94xx drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~scsi-fix-section-mismatch-in-aic94xx
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -529,10 +529,10 @@ static void asd_remove_dev_attrs(struct 
 /* The first entry, 0, is used for dynamic ids, the rest for devices
  * we know about.
  */
-static struct asd_pcidev_struct {
+static const struct asd_pcidev_struct {
 	const char * name;
 	int (*setup)(struct asd_ha_struct *asd_ha);
-} asd_pcidev_data[] = {
+} asd_pcidev_data[] __devinitconst = {
 	/* Id 0 is used for dynamic ids. */
 	{ .name  = "Adaptec AIC-94xx SAS/SATA Host Adapter",
 	  .setup = asd_aic9410_setup
@@ -735,7 +735,7 @@ static int asd_unregister_sas_ha(struct 
 static int __devinit asd_pci_probe(struct pci_dev *dev,
 				   const struct pci_device_id *id)
 {
-	struct asd_pcidev_struct *asd_dev;
+	const struct asd_pcidev_struct *asd_dev;
 	unsigned asd_id = (unsigned) id->driver_data;
 	struct asd_ha_struct *asd_ha;
 	struct Scsi_Host *shost;
_
