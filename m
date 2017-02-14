From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 05/16] aacraid: Fix memory leak in fib init path
Date: Tue, 14 Feb 2017 12:44:35 -0800
Message-ID: <20170214204446.14808-6-RaghavaAditya.Renukunta@microsemi.com>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0065.outbound.protection.outlook.com ([104.47.33.65]:10688
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751617AbdBODWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 22:22:35 -0500
In-Reply-To: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

aac_fib_map_free frees misaligned fib dma memory, additionally it does not
free up the whole memory.

Fixed by changing the  code to free up the correct and full memory
allocation.

Cc: stable@vger.kernel.org
Fixes: e8b12f0fb835223 ([SCSI] aacraid: Add new code for PMC-Sierra's SRC based controller family)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index f7a3bcb..863c98d 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -97,8 +97,8 @@ void aac_fib_map_free(struct aac_dev *dev)
 {
 	if (dev->hw_fib_va && dev->max_cmd_size) {
 		pci_free_consistent(dev->pdev,
-		(dev->max_cmd_size *
-		(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB)),
+		(dev->max_cmd_size + sizeof(struct aac_fib_xporthdr))
+		* (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) + 31,
 		dev->hw_fib_va, dev->hw_fib_pa);
 	}
 	dev->hw_fib_va = NULL;
@@ -153,22 +153,20 @@ int aac_fib_setup(struct aac_dev * dev)
 	if (i<0)
 		return -ENOMEM;
 
-	/* 32 byte alignment for PMC */
-	hw_fib_pa = (dev->hw_fib_pa + (ALIGN32 - 1)) & ~(ALIGN32 - 1);
-	dev->hw_fib_va = (struct hw_fib *)((unsigned char *)dev->hw_fib_va +
-		(hw_fib_pa - dev->hw_fib_pa));
-	dev->hw_fib_pa = hw_fib_pa;
 	memset(dev->hw_fib_va, 0,
 		(dev->max_cmd_size + sizeof(struct aac_fib_xporthdr)) *
 		(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB));
 
+	/* 32 byte alignment for PMC */
+	hw_fib_pa = (dev->hw_fib_pa + (ALIGN32 - 1)) & ~(ALIGN32 - 1);
+	hw_fib    = (struct hw_fib *)((unsigned char *)dev->hw_fib_va +
+					(hw_fib_pa - dev->hw_fib_pa));
+
 	/* add Xport header */
-	dev->hw_fib_va = (struct hw_fib *)((unsigned char *)dev->hw_fib_va +
+	hw_fib = (struct hw_fib *)((unsigned char *)hw_fib +
 		sizeof(struct aac_fib_xporthdr));
-	dev->hw_fib_pa += sizeof(struct aac_fib_xporthdr);
+	hw_fib_pa += sizeof(struct aac_fib_xporthdr);
 
-	hw_fib = dev->hw_fib_va;
-	hw_fib_pa = dev->hw_fib_pa;
 	/*
 	 *	Initialise the fibs
 	 */
-- 
2.7.4
