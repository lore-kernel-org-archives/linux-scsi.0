From: <rajinikanth.pandurangan@pmcs.com>
Subject: [PATCH V4 03/10] [SCSI] aacraid: Change interrupt mode to MSI for series-6  controller
Date: Tue, 21 Jul 2015 10:59:24 -0700
Message-ID: <1437501571-2475-4-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1437501571-2475-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:33823 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933005AbbGUSAE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jul 2015 14:00:04 -0400
In-Reply-To: <1437501571-2475-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, mahesh.rajashekhara@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
        This change always sets MSI interrupt mode for series-6 controller.
Note: For series 6 family, MSIx is not supported.

Changes from V2:
Only Subject & description change.

Reviewed by:
 Tomas Henzl <thenzl@redhat.com>,
 Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>,
 Johannes Thumshirn <jthumshirn@suse.de>

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/src.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index b147341..eb07b3d 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -742,7 +742,7 @@ int aac_src_init(struct aac_dev *dev)
 	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE1)
 		goto error_iounmap;
 
-	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
+	dev->msi = !pci_enable_msi(dev->pdev);
 
 	dev->aac_msix[0].vector_no = 0;
 	dev->aac_msix[0].dev = dev;
-- 
1.9.3

