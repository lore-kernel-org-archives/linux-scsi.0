From: <sreekanth.reddy@lsi.com>
Subject: [RESEND][PATCH][SCSI] mpt2sas: Fix for issue - Unable to boot from
 the drive connected to HBA
Date: Wed, 22 Aug 2012 16:55:13 +0530
Message-ID: <20120822112513.GA4720@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:33337 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608Ab2HVLYX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 07:24:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: stable@vger.kernel.org

Fix for issue - Unable to boot from the SAS drive connected to HBA

This patch checks whether HBA is SAS2008 B0 controller.
if it is a SAS2008 B0 controller then it use IO-APIC interrupt instead of MSIX,
as SAS2008 B0 controller doesn't support MSIX interrupts.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
Cc: <stable@kernel.org>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 2f77f39..4c66a55 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1208,6 +1208,13 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	int base;
 	u16 message_control;
 
+	/* Check whether controller SAS2008 B0 controller,
+           if it is SAS2008 B0 controller use IO-APIC instead of MSIX */
+        if (ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008 &&
+            ioc->pdev->revision == 0x01) {
+                return -EINVAL;
+        }
+
 	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
 	if (!base) {
 		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT "msix not "
