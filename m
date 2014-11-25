From: Tim Small <tim@seoss.co.uk>
Subject: [PATCH 3/4] Remove ex-BKL lock from ioctl path; fix simultaneous record on >1 drive
Date: Tue, 25 Nov 2014 14:09:21 +0000
Message-ID: <1416924562-16849-4-git-send-email-tim@seoss.co.uk>
References: <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.234.210]:39954 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbaKYOyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 09:54:10 -0500
In-Reply-To: <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
In-Reply-To: <20141121100210.GC8866@infradead.org>
References: <20141121100210.GC8866@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tim@buttersideup.com, Christoph Hellwig <hch@infradead.org>
Cc: Tim Small <tim@seoss.co.uk>, Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

Signed-off-by: Tim Small <tim@seoss.co.uk>
---
 drivers/block/paride/pcd.c | 8 +-------
 drivers/cdrom/gdrom.c      | 8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 3b7c9f1..61cabfd 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -248,13 +248,7 @@ static int pcd_block_ioctl(struct block_device *bdev, fmode_t mode,
 				unsigned cmd, unsigned long arg)
 {
 	struct pcd_unit *cd = bdev->bd_disk->private_data;
-	int ret;
-
-	mutex_lock(&pcd_mutex);
-	ret = cdrom_ioctl(&cd->info, bdev, mode, cmd, arg);
-	mutex_unlock(&pcd_mutex);
-
-	return ret;
+	return cdrom_ioctl(&cd->info, bdev, mode, cmd, arg);
 }
 
 static unsigned int pcd_block_check_events(struct gendisk *disk,
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 584bc31..f01d01f 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -519,13 +519,7 @@ static unsigned int gdrom_bdops_check_events(struct gendisk *disk,
 static int gdrom_bdops_ioctl(struct block_device *bdev, fmode_t mode,
 	unsigned cmd, unsigned long arg)
 {
-	int ret;
-
-	mutex_lock(&gdrom_mutex);
-	ret = cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);
-	mutex_unlock(&gdrom_mutex);
-
-	return ret;
+	return cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);
 }
 
 static const struct block_device_operations gdrom_bdops = {
-- 
2.1.3

