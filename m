From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH 1/5] scsi: ufs: move the ufshcd_hba_stop to ufshcd.c
Date: Thu, 25 Apr 2013 01:06:24 +0900
Message-ID: <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:10294 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab3DXQG0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 12:06:26 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MLR003VTOQO8L20@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 25 Apr 2013 01:06:24 +0900 (KST)
In-reply-to: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

Move the ufshcd_hba_stop from header file.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |    9 +++++++++
 drivers/scsi/ufs/ufshcd.h |    9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 60fd40c..41b9639 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -285,6 +285,15 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
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
index 6b99a42..1680394 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -190,13 +190,4 @@ int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
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


