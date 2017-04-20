From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/2] scsi: ufs: use MASK_EE_STATUS
Date: Thu, 20 Apr 2017 15:01:44 +0300
Message-ID: <20170420120145.7035-1-tkusumi@tuxera.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36375 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940472AbdDTMB4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 08:01:56 -0400
Received: by mail-lf0-f66.google.com with SMTP id 75so5536976lfs.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2017 05:01:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: subhashj@codeaurora.org, vinholikatti@gmail.com, linux-scsi@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

MASK_EE_STATUS added by 66ec6d59 was unused, but it seems to have been
defined to do this.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 096e95b..9278666 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4717,7 +4717,7 @@ static int ufshcd_disable_ee(struct ufs_hba *hba, u16 mask)
 		goto out;
 
 	val = hba->ee_ctrl_mask & ~mask;
-	val &= 0xFFFF; /* 2 bytes */
+	val &= MASK_EE_STATUS;
 	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
 			QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
 	if (!err)
@@ -4745,7 +4745,7 @@ static int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask)
 		goto out;
 
 	val = hba->ee_ctrl_mask | mask;
-	val &= 0xFFFF; /* 2 bytes */
+	val &= MASK_EE_STATUS;
 	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
 			QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
 	if (!err)
-- 
2.9.3
