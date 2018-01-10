From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 1/2] scsi: aacraid: Get correct lun count
Date: Wed, 10 Jan 2018 13:13:09 -0800
Message-ID: <20180110211310.23876-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0060.outbound.protection.outlook.com ([104.47.41.60]:31664
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752551AbeAJVN1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jan 2018 16:13:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, esc-teamarcdriversvl@microsemi.com

The correct lun count needs to be divided by 24, missed it in the previous
patch set.

Fixes: 4b00022753550055 (scsi: aacraid: Create helper functions to get lun info)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index a2bdd79..4c65991 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1868,7 +1868,7 @@ static int aac_get_safw_ciss_luns(struct aac_dev *dev)
 
 static inline u32 aac_get_safw_phys_lun_count(struct aac_dev *dev)
 {
-	return get_unaligned_be32(&dev->safw_phys_luns->list_length[0]);
+	return get_unaligned_be32(&dev->safw_phys_luns->list_length[0])/24;
 }
 
 static inline u32 aac_get_safw_phys_bus(struct aac_dev *dev, int lun)
-- 
2.9.4
