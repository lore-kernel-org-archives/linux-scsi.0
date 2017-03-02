From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH] aacraid: Fix typo in blink status
Date: Thu, 2 Mar 2017 09:21:33 -0800
Message-ID: <20170302172133.3503-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0045.outbound.protection.outlook.com ([104.47.37.45]:58808
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751123AbdCCAdF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Mar 2017 19:33:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

The return status of the adapter check on KERNEL_PANIC is supposed
to be the upper 16 bits of the OMR status register.

Fixes: c421530bf848604e (scsi: aacraid: Reorder Adpater status check)
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/src.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 2e5338d..7b0410e 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -468,7 +468,7 @@ static int aac_src_check_health(struct aac_dev *dev)
 	return -1;
 
 err_blink:
-	return (status > 16) & 0xFF;
+	return (status >> 16) & 0xFF;
 }
 
 static inline u32 aac_get_vector(struct aac_dev *dev)
-- 
1.8.3.1
