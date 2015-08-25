From: Murthy Bhat <Murthy.Bhat@pmcs.com>
Subject: RE: [PATCH V6 03/10] [SCSI] aacraid: Change interrupt mode to MSI
 for series-6  controller
Date: Tue, 25 Aug 2015 07:06:36 +0000
Message-ID: <13272BDD18A5F44CB23C497D29A37252DAB0F79C@BBYEXM02.pmc-sierra.internal>
References: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1439272701-15344-4-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <E4E5FF3C42893646A5934D219F9C8A514CA3A4DB@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60733 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbbHYHGh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2015 03:06:37 -0400
In-Reply-To: <E4E5FF3C42893646A5934D219F9C8A514CA3A4DB@BBYEXM02.pmc-sierra.internal>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Tomas Henzl <thenzl@redhat.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>

Reviewed-by: Murthy Bhat <Murthy.Bhat@pmcs.com>


-----Original Message-----
From: Karthikeya Sunkesula 
Sent: Tuesday, August 25, 2015 11:57 AM
To: Mahesh Rajashekhara; Tomas Henzl; JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Murthy Bhat
Subject: RE: [PATCH V6 03/10] [SCSI] aacraid: Change interrupt mode to MSI for series-6 controller

Reviewed-by: Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>


-----Original Message-----
From: Mahesh Rajashekhara 
Sent: Tuesday, August 11, 2015 11:28 AM
To: Tomas Henzl; JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Mahesh Rajashekhara
Subject: [PATCH V6 03/10] [SCSI] aacraid: Change interrupt mode to MSI for series-6 controller

Description:
	This change always sets MSI interrupt mode for series-6 controller.

Changes from V2:
aac_msi option description and subject change.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aachba.c | 2 +-
 drivers/scsi/aacraid/src.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c index fe59b00..05f2a02 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -259,7 +259,7 @@ MODULE_PARM_DESC(commit, "Control whether a COMMIT_CONFIG is issued to the"
 	" 0=off, 1=on");
 module_param_named(msi, aac_msi, int, S_IRUGO|S_IWUSR);  MODULE_PARM_DESC(msi, "IRQ handling."
-	" 0=PIC(default), 1=MSI, 2=MSI-X(unsupported, uses MSI)");
+	" 0=PIC(default), 1=MSI, 2=MSI-X)");
 module_param(startup_timeout, int, S_IRUGO|S_IWUSR);  MODULE_PARM_DESC(startup_timeout, "The duration of time in seconds to wait for"
 	" adapter to have it's kernel up and\n"
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c index b147341..eb07b3d 100644
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

