From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] SCSI: sd: fix null dereference
Date: Sat,  7 Mar 2015 11:17:34 +0530
Message-ID: <1425707254-10877-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

we were dereferencing sdkp first and then we were checking for it
being NULL. 

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/scsi/sd_dif.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 14c7d42..a514645 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -40,11 +40,16 @@
  */
 void sd_dif_config_host(struct scsi_disk *sdkp)
 {
-	struct scsi_device *sdp = sdkp->device;
-	struct gendisk *disk = sdkp->disk;
-	u8 type = sdkp->protection_type;
+	struct scsi_device *sdp = NULL;
+	struct gendisk *disk = NULL;
+	u8 type;
 	int dif, dix;
 
+	if (!sdkp)
+		return;
+	sdp = sdkp->device;
+	disk = sdkp->disk;
+	type = sdkp->protection_type;
 	dif = scsi_host_dif_capable(sdp->host, type);
 	dix = scsi_host_dix_capable(sdp->host, type);
 
@@ -77,9 +82,6 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 
 		disk->integrity->flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
 
-		if (!sdkp)
-			return;
-
 		if (type == SD_DIF_TYPE3_PROTECTION)
 			disk->integrity->tag_size = sizeof(u16) + sizeof(u32);
 		else
-- 
1.8.1.2
