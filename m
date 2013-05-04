From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH v2 1/7] scsi: ufs: move the ufshcd_hba_stop to ufshcd.c
Date: Sat, 04 May 2013 17:45:06 +0900
Message-ID: <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34333 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3EDIpJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 May 2013 04:45:09 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MM900MMZMZ360E0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Sat, 04 May 2013 17:45:07 +0900 (KST)
In-reply-to: <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

Move the ufshcd_hba_stop from header file.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Tested-by: Maya Erez <merez@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |    9 +++++++++
 drivers/scsi/ufs/ufshcd.h |    9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f244812..d932239 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -280,6 +280,15 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_hba_stop - Send controller to reset state
+ * @hba: per adapter instance
+ */
+static inline void ufshcd_hba_stop(struct ufs_hba *hba)
+{
+	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
+}
+
+/**
  * ufshcd_is_hba_active - Get controller state
  * @hba: per adapter instance
  *
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 336980b..3a1052d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -208,13 +208,4 @@ int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
 			unsigned int);
 void ufshcd_remove(struct ufs_hba *);
 
-/**
- * ufshcd_hba_stop - Send controller to reset state
- * @hba: per adapter instance
- */
-static inline void ufshcd_hba_stop(struct ufs_hba *hba)
-{
-	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
-}
-
 #endif /* End of Header */
-- 
1.7.0.4


