From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Fix missing ATO tag check
Date: Tue, 14 Apr 2015 17:11:03 -0400
Message-ID: <1429045863-4300-1-git-send-email-martin.petersen@oracle.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

3aec2f41a8bae introduced a merge error where we would end up check for
sdkp instead of sdkp->ATO. Fix this so we register app tag capability
correctly.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: <stable@vger.kernel.org> # v3.17+
---
 drivers/scsi/sd_dif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 14c7d42a11c2..5c06d292b94c 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -77,7 +77,7 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 
 		disk->integrity->flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
 
-		if (!sdkp)
+		if (!sdkp->ATO)
 			return;
 
 		if (type == SD_DIF_TYPE3_PROTECTION)
-- 
1.9.3
