From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 1/4] scsi: ufs: add support for UFS HCI 2.1
Date: Mon,  5 Dec 2016 19:25:02 -0800
Message-ID: <1480994702-19619-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42208 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbcLFDZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 22:25:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>

From: Yaniv Gardi <ygardi@codeaurora.org>

The UFS HCI v2.1 includes a few additional registers. This change
updates the HCI register, the UFS version register content and
the Interrupt Status register.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 29 +++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshci.h |  7 +++++++
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0c75c75..7af70aa 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -288,10 +288,24 @@ int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
  */
 static inline u32 ufshcd_get_intr_mask(struct ufs_hba *hba)
 {
-	if (hba->ufs_version == UFSHCI_VERSION_10)
-		return INTERRUPT_MASK_ALL_VER_10;
-	else
-		return INTERRUPT_MASK_ALL_VER_11;
+	u32 intr_mask = 0;
+
+	switch (hba->ufs_version) {
+	case UFSHCI_VERSION_10:
+		intr_mask = INTERRUPT_MASK_ALL_VER_10;
+		break;
+	/* allow fall through */
+	case UFSHCI_VERSION_11:
+	case UFSHCI_VERSION_20:
+		intr_mask = INTERRUPT_MASK_ALL_VER_11;
+		break;
+	/* allow fall through */
+	case UFSHCI_VERSION_21:
+	default:
+		intr_mask = INTERRUPT_MASK_ALL_VER_21;
+	}
+
+	return intr_mask;
 }
 
 /**
@@ -6667,6 +6681,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Get UFS version supported by the controller */
 	hba->ufs_version = ufshcd_get_ufs_version(hba);
 
+	if ((hba->ufs_version != UFSHCI_VERSION_10) &&
+	    (hba->ufs_version != UFSHCI_VERSION_11) &&
+	    (hba->ufs_version != UFSHCI_VERSION_20) &&
+	    (hba->ufs_version != UFSHCI_VERSION_21))
+		dev_err(hba->dev, "invalid UFS version 0x%x\n",
+			hba->ufs_version);
+
 	/* Get Interrupt bit mask per version */
 	hba->intr_mask = ufshcd_get_intr_mask(hba);
 
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 5d97886..8c5190e 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -72,6 +72,10 @@ enum {
 	REG_UIC_COMMAND_ARG_1			= 0x94,
 	REG_UIC_COMMAND_ARG_2			= 0x98,
 	REG_UIC_COMMAND_ARG_3			= 0x9C,
+	REG_UFS_CCAP				= 0x100,
+	REG_UFS_CRYPTOCAP			= 0x104,
+
+	UFSHCI_CRYPTO_REG_SPACE_SIZE		= 0x400,
 };
 
 /* Controller capability masks */
@@ -275,6 +279,9 @@ enum {
 
 	/* Interrupt disable mask for UFSHCI v1.1 */
 	INTERRUPT_MASK_ALL_VER_11	= 0x31FFF,
+
+	/* Interrupt disable mask for UFSHCI v2.1 */
+	INTERRUPT_MASK_ALL_VER_21	= 0x71FFF,
 };
 
 /*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

