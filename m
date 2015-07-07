From: <rajinikanth.pandurangan@pmcs.com>
Subject: [PATCH V3 10/10] [SCSI] aacraid: Replace pci_enable_msix() with pci_enable_msix_exact()
Date: Tue, 7 Jul 2015 16:16:24 -0700
Message-ID: <1436310984-4519-11-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1436310984-4519-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:50114 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757524AbbGGXRw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2015 19:17:52 -0400
In-Reply-To: <1436310984-4519-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
	As pci_enable_msix() deprecated, replaced with pci_enable_msix_exact()

Changes from V2:
 Newly created for V3 based on review comment.

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/comminit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index b4b6088..e4ff47e 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -366,7 +366,7 @@ void aac_define_int_mode(struct aac_dev *dev)
 
 	if (msi_count > 1 &&
 	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
-		i = pci_enable_msix(dev->pdev,
+		i = pci_enable_msix_exact(dev->pdev,
 				    dev->msixentry,
 				    msi_count);
 		 /* Check how many MSIX vectors are allocated */
@@ -374,7 +374,7 @@ void aac_define_int_mode(struct aac_dev *dev)
 			dev->msi_enabled = 1;
 			if (i) {
 				msi_count = i;
-				if (pci_enable_msix(dev->pdev,
+				if (pci_enable_msix_exact(dev->pdev,
 				    dev->msixentry,
 				    msi_count)) {
 					dev->msi_enabled = 0;
-- 
1.9.3

