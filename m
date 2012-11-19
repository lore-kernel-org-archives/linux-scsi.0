From: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 368/493] scsi: remove use of __devinitconst
Date: Mon, 19 Nov 2012 13:25:17 -0500
Message-ID: <1353349642-3677-368-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41484 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab2KSSep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2012 13:34:45 -0500
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

CONFIG_HOTPLUG is going away as an option so __devinitconst is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com> 
Cc: linux-scsi@vger.kernel.org 
---
 drivers/scsi/aacraid/linit.c        | 4 +---
 drivers/scsi/aic94xx/aic94xx_init.c | 4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index f821ac9..ac8fcfa 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -90,10 +90,8 @@ char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
  */
 #ifdef DECLARE_PCI_DEVICE_TABLE
 static DECLARE_PCI_DEVICE_TABLE(aac_pci_tbl) = {
-#elif defined(__devinitconst)
-static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
 #else
-static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
+static const struct pci_device_id aac_pci_tbl[] = {
 #endif
 	{ 0x1028, 0x0001, 0x1028, 0x0001, 0, 0, 0 }, /* PERC 2/Si (Iguana/PERC2Si) */
 	{ 0x1028, 0x0002, 0x1028, 0x0002, 0, 0, 1 }, /* PERC 3/Di (Opal/PERC3Di) */
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 99cba69..2dcf914 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -531,7 +531,7 @@ static void asd_remove_dev_attrs(struct asd_ha_struct *asd_ha)
 static const struct asd_pcidev_struct {
 	const char * name;
 	int (*setup)(struct asd_ha_struct *asd_ha);
-} asd_pcidev_data[] __devinitconst = {
+} asd_pcidev_data[] = {
 	/* Id 0 is used for dynamic ids. */
 	{ .name  = "Adaptec AIC-94xx SAS/SATA Host Adapter",
 	  .setup = asd_aic9410_setup
@@ -1012,7 +1012,7 @@ static struct sas_domain_function_template aic94xx_transport_functions = {
 	.lldd_ata_set_dmamode	= asd_set_dmamode,
 };
 
-static const struct pci_device_id aic94xx_pci_table[] __devinitconst = {
+static const struct pci_device_id aic94xx_pci_table[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x410),0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x412),0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x416),0, 0, 1},
-- 
1.8.0

