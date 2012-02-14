From: Yang Bai <hamo.by@gmail.com>
Subject: [PATCH] scsi: if sd card is removed, do not revalidate it
Date: Tue, 14 Feb 2012 12:10:54 +0800
Message-ID: <1329192654-11284-1-git-send-email-hamo.by@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Yang Bai <hamo.by@gmail.com>
List-Id: linux-scsi@vger.kernel.org

During revalidating, if sd card is removed, scsi_device
will be NULL, so we should not revalidate or it will cause
a panic.
This problem is report at:
http://comments.gmane.org/gmane.linux.kernel/1250235

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 drivers/scsi/sd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c691fb5..470339c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2370,10 +2370,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 				      "sd_revalidate_disk\n"));
 
 	/*
-	 * If the device is offline, don't try and read capacity or any
+	 * If the device is removed or offline, don't try and read capacity or any
 	 * of the other niceties.
 	 */
-	if (!scsi_device_online(sdp))
+	if (!sdp || !scsi_device_online(sdp))
 		goto out;
 
 	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
-- 
1.7.9
