From: <rajinikanth.pandurangan@pmcs.com>
Subject: [PATCH V5 10/11] [SCSI] aacraid: Replace pci_enable_msix() with pci_enable_msix_range()
Date: Wed, 22 Jul 2015 09:49:16 -0700
Message-ID: <1437583757-5449-11-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:57077 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965440AbbGVQuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 12:50:21 -0400
In-Reply-To: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, mahesh.rajashekhara@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
        As pci_enable_msix() deprecated, replaced with pci_enable_msix_range()

V4 Reviewed/commented by:
	Tomas Henzl <thenzl@redhat.com>

Changes from V4:
	Changed to 1 as minimum msix range in pci_enable_msix_range()
to match with original code.

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/comminit.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index b4b6088..a02cfb3 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -338,7 +338,7 @@ static int aac_comm_init(struct aac_dev * dev)
 
 void aac_define_int_mode(struct aac_dev *dev)
 {
-	int i, msi_count;
+	int i, msi_count, min_msix;
 
 	msi_count = i = 0;
 	/* max. vectors from GET_COMM_PREFERRED_SETTINGS */
@@ -366,22 +366,14 @@ void aac_define_int_mode(struct aac_dev *dev)
 
 	if (msi_count > 1 &&
 	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
-		i = pci_enable_msix(dev->pdev,
+		min_msix = 1;
+		i = pci_enable_msix_range(dev->pdev,
 				    dev->msixentry,
+				    min_msix,
 				    msi_count);
-		 /* Check how many MSIX vectors are allocated */
-		if (i >= 0) {
+		if (i > 0) {
 			dev->msi_enabled = 1;
-			if (i) {
-				msi_count = i;
-				if (pci_enable_msix(dev->pdev,
-				    dev->msixentry,
-				    msi_count)) {
-					dev->msi_enabled = 0;
-					printk(KERN_ERR "%s%d: MSIX not supported!! Will try MSI 0x%x.\n",
-							dev->name, dev->id, i);
-				}
-			}
+			msi_count = i;
 		} else {
 			dev->msi_enabled = 0;
 			printk(KERN_ERR "%s%d: MSIX not supported!! Will try MSI 0x%x.\n",
-- 
1.9.3

