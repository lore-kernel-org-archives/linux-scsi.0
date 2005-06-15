From: brking@us.ibm.com
Subject: [PATCH 1/1] ipr: Fix for adapter shutdown issue
Date: Wed, 15 Jun 2005 10:15:22 -0500
Message-ID: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:10734 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261158AbVFOPPg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 11:15:36 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5FFFY3e005968
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 11:15:34 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5FFFXnC242010
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 11:15:33 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5FFFX1d021560
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 11:15:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, haren@us.ibm.com



James,
Haren found this in some recent kexec testing. Without this fix, the
ipr adapter's write cache never gets flushed. I'd like to see this
pushed into 2.6.12 if possible.

Thanks
Brian

From: Haren Myneni <haren@us.ibm.com>
Subject: [PATCH] Fix for IPR shutdown  issue

Hi Brian,
    The ipr_shutdown function will never get called because of changes 
made in the recent kernel. pci_driver->driver->shutdown is reset to 
pci_device_shutdown() when the the IPR driver is registered. Hence, the 
normal kexec boot was not successful. The following patch should fix 
this problem. Please send it to Andrew if you are Ok with this fix.

Thanks
Haren

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_shutdown_fix drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_shutdown_fix	2005-06-15 08:33:02.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-06-15 08:33:18.000000000 -0500
@@ -5991,7 +5991,7 @@ static int __devinit ipr_probe(struct pc
 
 /**
  * ipr_shutdown - Shutdown handler.
- * @dev:	device struct
+ * @pdev:	PCI device struct
  *
  * This function is invoked upon system shutdown/reboot. It will issue
  * an adapter shutdown to the adapter to flush the write cache.
@@ -5999,9 +5999,9 @@ static int __devinit ipr_probe(struct pc
  * Return value:
  * 	none
  **/
-static void ipr_shutdown(struct device *dev)
+static void ipr_shutdown(struct pci_dev *pdev)
 {
-	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(to_pci_dev(dev));
+	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 	unsigned long lock_flags = 0;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -6047,9 +6047,7 @@ static struct pci_driver ipr_driver = {
 	.id_table = ipr_pci_table,
 	.probe = ipr_probe,
 	.remove = ipr_remove,
-	.driver = {
-		.shutdown = ipr_shutdown,
-	},
+	.shutdown = ipr_shutdown
 };
 
 /**
_
