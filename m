From: <sreekanth.reddy@lsi.com>
Subject: [RESEND][PATCH][SCSI] mpt2sas: Fix for issue - Unable to boot from
 the SAS drive connected to HBA
Date: Tue, 21 Aug 2012 21:53:15 +0530
Message-ID: <20120821162315.GA5135@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:33267 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932135Ab2HUQW0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Aug 2012 12:22:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, jejb@kernel.org, stable@vger.kernel.org
Cc: sreekanth.reddy@lsi.com

Fix for issue - Unable to boot from the SAS drive connected to HBA

This patch checks whether HBA is SAS2008 B0 controller.
if it is a SAS2008 B0 controller then it use IO-APIC interrupt instead of MSIX,
as SAS2008 B0 controller doesn't support MSIX interrupts.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
Cc: <stable@kernel.org>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 6102ef2..fd2f4ad 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1207,6 +1207,15 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 {
 	int base;
 	u16 message_control;
+	u8 revision;
+
+	/* Check whether controller SAS2008 B0 controller,
+	   if it is a SAS2008 B0 controller use IO-APIC instead of MSIX */
+	pci_read_config_byte(ioc->pdev, PCI_CLASS_REVISION, &revision);
+	if (ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008 &&
+	    revision == 0x01) {
+		return -EINVAL;
+	}
 
 
 	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
