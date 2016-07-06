From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 18/21] lpfc: Correct issue with ioremap() call on 32bit
 kernel
Date: Wed, 06 Jul 2016 12:36:11 -0700
Message-ID: <577d5dab.uTZuS8TRN82d5m1T%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35110 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbcGFTgR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:17 -0400
Received: by mail-wm0-f44.google.com with SMTP id z126so123515173wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:16 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id r130sm8115477wmf.20.2016.07.06.12.36.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct issue with ioremap() call on 32bit kernel

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 4d9f1b1..b484859 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -785,9 +785,9 @@ struct lpfc_hba {
 
 	atomic_t fcp_qidx;		/* next work queue to post work to */
 
-	unsigned long pci_bar0_map;     /* Physical address for PCI BAR0 */
-	unsigned long pci_bar1_map;     /* Physical address for PCI BAR1 */
-	unsigned long pci_bar2_map;     /* Physical address for PCI BAR2 */
+	phys_addr_t pci_bar0_map;     /* Physical address for PCI BAR0 */
+	phys_addr_t pci_bar1_map;     /* Physical address for PCI BAR1 */
+	phys_addr_t pci_bar2_map;     /* Physical address for PCI BAR2 */
 	void __iomem *slim_memmap_p;	/* Kernel memory mapped address for
 					   PCI BAR0 */
 	void __iomem *ctrl_regs_memmap_p;/* Kernel memory mapped address for
-- 
2.5.0

