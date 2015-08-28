From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH V8 3/9] aacraid: Change interrupt mode to MSI for Series 6
Date: Fri, 28 Aug 2015 06:38:35 -0400
Message-ID: <1440758321-2996-4-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1440758321-2996-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:51972 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204AbbH1Kiz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Aug 2015 06:38:55 -0400
In-Reply-To: <1440758321-2996-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, Murthy.Bhat@pmcs.com, Karthikeya.Sunkesula@pmcs.com, aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com

This change always sets MSI interrupt mode for series-6 controller.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Murthy Bhat <Murthy.Bhat@pmcs.com>
Reviewed-by: Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>
Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
Changes from V2:
aac_msi option description and subject change.
 drivers/scsi/aacraid/aachba.c | 2 +-
 drivers/scsi/aacraid/src.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index fe59b00..05f2a02 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -259,7 +259,7 @@ MODULE_PARM_DESC(commit, "Control whether a COMMIT_CONFIG is issued to the"
 	" 0=off, 1=on");
 module_param_named(msi, aac_msi, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(msi, "IRQ handling."
-	" 0=PIC(default), 1=MSI, 2=MSI-X(unsupported, uses MSI)");
+	" 0=PIC(default), 1=MSI, 2=MSI-X)");
 module_param(startup_timeout, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(startup_timeout, "The duration of time in seconds to wait for"
 	" adapter to have it's kernel up and\n"
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

