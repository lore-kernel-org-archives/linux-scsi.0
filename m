From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH] [SCSI] ufs: Assign UTRLBAU = upper_32_ bits(UTRLD base address)
Date: Mon, 23 Apr 2012 18:52:11 +0530
Message-ID: <1335187331-2672-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39668 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab2DWNWY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2012 09:22:24 -0400
Received: by pbcun15 with SMTP id un15so3884594pbc.19
        for <linux-scsi@vger.kernel.org>; Mon, 23 Apr 2012 06:22:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, rene.dejong@arm.com, vinholikatti@gmail.com, Santosh Yaraganavi <santoshsy@gmail.com>

From: Santosh Yaraganavi <santoshsy@gmail.com>

UTP Transfer request list base registers UTRLBA and UTRLBAU
must be assigned, lower-32 and upper-32 bits of UTRLD list
physical base addresses respectively.

Currently UTRLBAU is being assigned lower-32 bits of UTRLD
physical base address. This will cause an issue with
controllers that can support 64-bit addressing.

This patch correctly assigns upper-32 bits of UTRLD physical
base address to UTRLBAU.

Reported-by: Rene De Jong <rene.dejong@arm.com>
Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52b96e8..ea32ade 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1032,11 +1032,11 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
 		return -EIO;
 
 	/* Configure UTRL and UTMRL base address registers */
-	writel(hba->utrdl_dma_addr,
-	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_L));
 	writel(lower_32_bits(hba->utrdl_dma_addr),
+	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_L));
+	writel(upper_32_bits(hba->utrdl_dma_addr),
 	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_H));
-	writel(hba->utmrdl_dma_addr,
+	writel(lower_32_bits(hba->utmrdl_dma_addr),
 	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_L));
 	writel(upper_32_bits(hba->utmrdl_dma_addr),
 	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_H));
-- 
1.7.5.4

