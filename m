From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/6] scsi: ufs: make ufshcd_is_{device_present,hba_active}() return bool
Date: Tue, 28 Mar 2017 16:49:24 +0300
Message-ID: <20170328134929.25599-1-tkusumi@tuxera.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33411 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbdC1NuE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2017 09:50:04 -0400
Received: by mail-lf0-f65.google.com with SMTP id r36so10601333lfi.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2017 06:49:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

ufshcd driver generally uses bool for is_xxx type things instead of int,
so conform to its style.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b7e5128..b006f1e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -585,12 +585,12 @@ static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
  *			      the host controller
  * @hba: pointer to adapter instance
  *
- * Returns 1 if device present, 0 if no device detected
+ * Returns true if device present, false if no device detected
  */
-static inline int ufshcd_is_device_present(struct ufs_hba *hba)
+static inline bool ufshcd_is_device_present(struct ufs_hba *hba)
 {
 	return (ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
-						DEVICE_PRESENT) ? 1 : 0;
+						DEVICE_PRESENT) ? true : false;
 }
 
 /**
@@ -832,11 +832,11 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
  * ufshcd_is_hba_active - Get controller state
  * @hba: per adapter instance
  *
- * Returns zero if controller is active, 1 otherwise
+ * Returns false if controller is active, true otherwise
  */
-static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
+static inline bool ufshcd_is_hba_active(struct ufs_hba *hba)
 {
-	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
+	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? false : true;
 }
 
 static const char *ufschd_uic_link_state_to_string(
-- 
2.9.3
