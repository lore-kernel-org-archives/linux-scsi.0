From: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH]: Fix section mismatch in mpt2sas
Date: Wed, 7 Jul 2010 19:09:23 -0400
Message-ID: <20100707230819.31455.6553.sendpatchset@prarit.bos.redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0GGXJY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2010 19:09:24 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o67N9Ogk028120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jul 2010 19:09:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, revers@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>

Fix section mismatch:

WARNING: drivers/scsi/mpt2sas/mpt2sas.o(.text+0xe3d4): Section mismatch in reference from the function _scsih_pci_error_detected() to the function .devexit.text:_scsih_remove()
The function _scsih_pci_error_detected() references a function in an exit section.
Often the function _scsih_remove() has valid usage outside the exit section
and the fix is to remove the __devexit annotation of _scsih_remove.

by removing __devexit from _scsih_remove()

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c5ff26a..c630aa7 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -6290,7 +6290,7 @@ _scsih_shutdown(struct pci_dev *pdev)
  * Routine called when unloading the driver.
  * Return nothing.
  */
-static void __devexit
+static void
 _scsih_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
@@ -6798,7 +6798,7 @@ static struct pci_driver scsih_driver = {
 	.name		= MPT2SAS_DRIVER_NAME,
 	.id_table	= scsih_pci_table,
 	.probe		= _scsih_probe,
-	.remove		= __devexit_p(_scsih_remove),
+	.remove		= _scsih_remove,
 	.shutdown	= _scsih_shutdown,
 	.err_handler	= &_scsih_err_handler,
 #ifdef CONFIG_PM
