From: kusumi.tomohiro@gmail.com
Subject: [PATCH v2] scsi: ufs: make ufshcd_get_lists_status() register operation obvious
Date: Wed, 26 Apr 2017 20:28:58 +0300
Message-ID: <20170426172858.56224-1-tkusumi@tuxera.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36253 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753438AbdDZR3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 13:29:20 -0400
Received: by mail-lf0-f65.google.com with SMTP id 75so1029260lfs.3
        for <linux-scsi@vger.kernel.org>; Wed, 26 Apr 2017 10:29:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: subhashj@codeaurora.org, vinholikatti@gmail.com, linux-scsi@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

It could be just cmp 0xe instead of >>1 and cmp 0x7, with readable code.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 +----------
 drivers/scsi/ufs/ufshci.h |  4 ++++
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9278666..95911fea 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -668,16 +668,7 @@ static inline void ufshcd_outstanding_req_clear(struct ufs_hba *hba, int tag)
  */
 static inline int ufshcd_get_lists_status(u32 reg)
 {
-	/*
-	 * The mask 0xFF is for the following HCS register bits
-	 * Bit		Description
-	 *  0		Device Present
-	 *  1		UTRLRDY
-	 *  2		UTMRLRDY
-	 *  3		UCRDY
-	 * 4-7		reserved
-	 */
-	return ((reg & 0xFF) >> 1) ^ 0x07;
+	return !((reg & UFSHCD_STATUS_READY) == UFSHCD_STATUS_READY);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index d14e9b9..8cd4f0e 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -159,6 +159,10 @@ enum {
 #define DEVICE_ERROR_INDICATOR			UFS_BIT(5)
 #define UIC_POWER_MODE_CHANGE_REQ_STATUS_MASK	UFS_MASK(0x7, 8)
 
+#define UFSHCD_STATUS_READY	(UTP_TRANSFER_REQ_LIST_READY |\
+				UTP_TASK_REQ_LIST_READY |\
+				UIC_COMMAND_READY)
+
 enum {
 	PWR_OK		= 0x0,
 	PWR_LOCAL	= 0x01,
-- 
2.9.3
