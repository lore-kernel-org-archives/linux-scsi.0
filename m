From: <rajinikanth.pandurangan@pmcs.com>
Subject: [PATCH V5 11/11] [SCSI] aacraid: Requests at least 2 MSIx in pci_enable_msix_range()
Date: Wed, 22 Jul 2015 09:49:17 -0700
Message-ID: <1437583757-5449-12-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:37638 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965440AbbGVQu3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 12:50:29 -0400
In-Reply-To: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, mahesh.rajashekhara@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
        In MSIx mode, we need at least 2 vectors.

Changes from V4:
	Newly created for V5 based on review comment.

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/comminit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index a02cfb3..0e954e3 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -366,7 +366,7 @@ void aac_define_int_mode(struct aac_dev *dev)
 
 	if (msi_count > 1 &&
 	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
-		min_msix = 1;
+		min_msix = 2;
 		i = pci_enable_msix_range(dev->pdev,
 				    dev->msixentry,
 				    min_msix,
-- 
1.9.3

