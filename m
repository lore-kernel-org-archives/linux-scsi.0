From: Andrew Morton <akpm@digeo.com>
Subject: [patch] fix drivers/scsi/sd.c warnings
Date: Wed, 18 Dec 2002 22:04:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E016158.CC3D9909@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id WAA07794
	for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2002 22:04:08 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Somebody forgot to test with CONFIG_LBD=n:

drivers/scsi/sd.c: In function `sd_init_command':
drivers/scsi/sd.c:304: warning: right shift count >= width of type
drivers/scsi/sd.c:305: warning: right shift count >= width of type
drivers/scsi/sd.c:306: warning: right shift count >= width of type
drivers/scsi/sd.c:307: warning: right shift count >= width of type
drivers/scsi/sd.c: In function `sd_read_capacity':
drivers/scsi/sd.c:1016: warning: left shift count >= width of type
drivers/scsi/sd.c:1017: warning: left shift count >= width of type
drivers/scsi/sd.c:1018: warning: left shift count >= width of type
drivers/scsi/sd.c:1019: warning: left shift count >= width of type



--- 25/drivers/scsi/sd.c~scsi-warnings	Wed Dec 18 22:01:40 2002
+++ 25-akpm/drivers/scsi/sd.c	Wed Dec 18 22:02:41 2002
@@ -174,7 +174,7 @@ static int sd_init_command(struct scsi_c
 {
 	unsigned int this_count, timeout;
 	struct gendisk *disk;
-	sector_t block;
+	u64 block;
 	struct scsi_device *sdp = SCpnt->device;
 
 	timeout = SD_TIMEOUT;
@@ -1013,10 +1013,10 @@ repeat:
 			(buffer[2] << 8) |
 			buffer[3]);			
 	} else {
-		sdkp->capacity = 1 + (((sector_t)buffer[0] << 56) |
-			((sector_t)buffer[1] << 48) |
-			((sector_t)buffer[2] << 40) |
-			((sector_t)buffer[3] << 32) |
+		sdkp->capacity = 1 + (((u64)buffer[0] << 56) |
+			((u64)buffer[1] << 48) |
+			((u64)buffer[2] << 40) |
+			((u64)buffer[3] << 32) |
 			((sector_t)buffer[4] << 24) |
 			((sector_t)buffer[5] << 16) |
 			((sector_t)buffer[6] << 8)  |

_
