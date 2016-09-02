From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 2/6] cxlflash: Remove the device cleanly in the system shutdown path
Date: Fri,  2 Sep 2016 15:39:16 -0500
Message-ID: <1472848756-64998-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46489 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752936AbcIBUjc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2016 16:39:32 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82KXTLm052620
        for <linux-scsi@vger.kernel.org>; Fri, 2 Sep 2016 16:39:31 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25753qh4gc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 02 Sep 2016 16:39:31 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Fri, 2 Sep 2016 14:39:30 -0600
In-Reply-To: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Commit 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL Flash
cards") was recently introduced to notify the AFU when a system is going
down. Due to the position of the cxlflash driver in the device stack,
cxlflash devices are _always_ removed during a reboot/shutdown. This can
lead to a crash if the cxlflash shutdown hook is invoked _after_ the
shutdown hook for the owning virtual PHB. Furthermore, the current
implementation of shutdown/remove hooks for cxlflash are not tolerant to
being invoked when the device is not enabled. This can also lead to a
crash in situations where the remove hook is invoked after the device has
been removed via the vPHBs shutdown hook. An example of this scenario
would be an EEH reset failure while a reboot/shutdown is in progress.

To solve both problems, the shutdown hook for cxlflash is updated to
simply remove the device. This path already includes the AFU notification
and thus this solution will continue to perform the original intent. At
the same time, the remove hook is updated to protect against being
called when the device is not enabled.

Fixes: 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL Flash
cards")
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b063c41..4c2559a 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -823,17 +823,6 @@ static void notify_shutdown(struct cxlflash_cfg *cfg, bool wait)
 }
 
 /**
- * cxlflash_shutdown() - shutdown handler
- * @pdev:	PCI device associated with the host.
- */
-static void cxlflash_shutdown(struct pci_dev *pdev)
-{
-	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
-
-	notify_shutdown(cfg, false);
-}
-
-/**
  * cxlflash_remove() - PCI entry point to tear down host
  * @pdev:	PCI device associated with the host.
  *
@@ -844,6 +833,11 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	struct cxlflash_cfg *cfg = pci_get_drvdata(pdev);
 	ulong lock_flags;
 
+	if (!pci_is_enabled(pdev)) {
+		pr_debug("%s: Device is disabled\n", __func__);
+		return;
+	}
+
 	/* If a Task Management Function is active, wait for it to complete
 	 * before continuing with remove.
 	 */
@@ -2685,7 +2679,7 @@ static struct pci_driver cxlflash_driver = {
 	.id_table = cxlflash_pci_table,
 	.probe = cxlflash_probe,
 	.remove = cxlflash_remove,
-	.shutdown = cxlflash_shutdown,
+	.shutdown = cxlflash_remove,
 	.err_handler = &cxlflash_err_handler,
 };
 
-- 
2.1.0

