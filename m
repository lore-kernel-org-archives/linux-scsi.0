From: akpm@linux-foundation.org
Subject: [patch 10/30] MPT fusion: handle PCI layer error on resume
Date: Fri, 16 Feb 2007 01:46:28 -0800
Message-ID: <200702160946.l1G9kSnF026645@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36820 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423504AbXBPJqk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:46:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org, Eric.Moore@lsil.com

From: Jeff Garzik <jeff@garzik.org>

In the unlikely event of pci_enable_device() failure during resume, we do
the minimalist solution and simply exit, rather than continuing to enable
the hardware.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~mpt-fusion-handle-pci-layer-error-on-resume drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~mpt-fusion-handle-pci-layer-error-on-resume
+++ a/drivers/message/fusion/mptbase.c
@@ -1530,7 +1530,7 @@ mpt_resume(struct pci_dev *pdev)
 {
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	u32 device_state = pdev->current_state;
-	int recovery_state;
+	int recovery_state, rc;
 
 	printk(MYIOC_s_INFO_FMT
 	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
@@ -1538,7 +1538,13 @@ mpt_resume(struct pci_dev *pdev)
 
 	pci_set_power_state(pdev, 0);
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		printk(MYIOC_s_INFO_FMT
+			"pci-resume: device enable failed\n", ioc->name);
+		return rc;
+	}
 
 	/* enable interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
_
