From: akpm@linux-foundation.org
Subject: [patch 6/7] scsi: fix section mismatch in aic94xx
Date: Tue, 04 Mar 2008 15:24:25 -0800
Message-ID: <200803042324.m24NOQpN003098@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751015AbYCDX3l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 18:29:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org, James.Bottomley@steeleye.com, gilbert_wu@adaptec.com

From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: vmlinux.o(.data+0x17aa88): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
WARNING: vmlinux.o(.data+0x17aa98): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
WARNING: vmlinux.o(.data+0x17aaa8): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9405_setup()

asd_pcidev_data is only used by __devinit asd_pci_probe.  So mark is const and
annotate it __devinitconst to fix the warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gilbert Wu <gilbert_wu@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_init.c~scsi-fix-section-mismatch-in-aic94xx drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~scsi-fix-section-mismatch-in-aic94xx
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -531,10 +531,10 @@ static void asd_remove_dev_attrs(struct 
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
_
