From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 2/7] cxlflash: Unmap problem state area before detaching master context
Date: Fri,  4 Mar 2016 15:55:15 -0600
Message-ID: <1457128520-53056-2-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:49507 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759073AbcCDV5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2016 16:57:33 -0500
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Fri, 4 Mar 2016 16:57:32 -0500
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 7AB15C90027
	for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2016 16:57:27 -0500 (EST)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u24LvU4S35979332
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 21:57:30 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u24LrCKJ028934
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 16:53:13 -0500
In-Reply-To: <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

When operating in the PowerVM environment, the cxlflash module can
receive an error from the hypervisor indicating that there are
existing mappings in the page table for the process MMIO space.

This issue exists because term_afu() currently invokes term_mc()
before stop_afu(), allowing for the master context to be detached
first and the problem state area to be unmapped second.

To resolve this issue, stop_afu() should be called before term_mc().

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 3dbb9fa..ca702d8 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -726,11 +726,11 @@ static void term_mc(struct cxlflash_cfg *cfg, enum undo_level level)
  */
 static void term_afu(struct cxlflash_cfg *cfg)
 {
-	term_mc(cfg, UNDO_START);
-
 	if (cfg->afu)
 		stop_afu(cfg);
 
+	term_mc(cfg, UNDO_START);
+
 	pr_debug("%s: returning\n", __func__);
 }
 
@@ -2492,8 +2492,8 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 		if (unlikely(rc))
 			dev_err(dev, "%s: Failed to mark user contexts!(%d)\n",
 				__func__, rc);
-		term_mc(cfg, UNDO_START);
 		stop_afu(cfg);
+		term_mc(cfg, UNDO_START);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		cfg->state = STATE_FAILTERM;
-- 
2.1.0

