From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH V6 09/10] [SCSI] aacraid: Replace pci_enable_msix() with pci_enable_msix_range()
Date: Tue, 11 Aug 2015 01:58:20 -0400
Message-ID: <1439272701-15344-10-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:48002 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755054AbbHKF75 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2015 01:59:57 -0400
In-Reply-To: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Description:
	As pci_enable_msix() deprecated, replaced with pci_enable_msix_range()

Changes from V5:
Merged 10 and 11 of V5 into this patch.
AAC_MAX_MSIX definition change.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h  |  2 +-
 drivers/scsi/aacraid/comminit.c | 20 ++++++--------------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 7b95227..2de5ebc 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -12,7 +12,7 @@
  *              D E F I N E S
  *----------------------------------------------------------------------------*/
 
-#define AAC_MAX_MSIX		8	/* vectors */
+#define AAC_MAX_MSIX		32	/* vectors */
 #define AAC_PCI_MSI_ENABLE	0x8000
 
 enum {
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index b4b6088..0e954e3 100644
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
+		min_msix = 2;
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

