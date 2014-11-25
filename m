From: Tim Small <tim@seoss.co.uk>
Subject: [PATCH 2/4] Remove ex-BKL lock from ioctl path; fix simultaneous record on >1 drive
Date: Tue, 25 Nov 2014 14:09:20 +0000
Message-ID: <1416924562-16849-3-git-send-email-tim@seoss.co.uk>
References: <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.234.210]:49174 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835AbaKYOyJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 09:54:09 -0500
In-Reply-To: <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
In-Reply-To: <20141121100210.GC8866@infradead.org>
References: <20141121100210.GC8866@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tim@buttersideup.com, Christoph Hellwig <hch@infradead.org>
Cc: Tim Small <tim@seoss.co.uk>, Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>


Signed-off-by: Tim Small <tim@seoss.co.uk>
---
 drivers/scsi/sr.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 2de44cc..93111b1 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -547,8 +547,6 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
-	mutex_lock(&sr_mutex);
-
 	/*
 	 * Send SCSI addressing ioctls directly to mid level, send other
 	 * ioctls to cdrom/block level.
@@ -556,13 +554,12 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	switch (cmd) {
 	case SCSI_IOCTL_GET_IDLUN:
 	case SCSI_IOCTL_GET_BUS_NUMBER:
-		ret = scsi_ioctl(sdev, cmd, argp);
-		goto out;
+		return scsi_ioctl(sdev, cmd, argp);
 	}
 
 	ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
 	if (ret != -ENOSYS)
-		goto out;
+		return ret;
 
 	/*
 	 * ENODEV means that we didn't recognise the ioctl, or that we
@@ -573,12 +570,9 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	ret = scsi_nonblockable_ioctl(sdev, cmd, argp,
 					(mode & FMODE_NDELAY) != 0);
 	if (ret != -ENODEV)
-		goto out;
-	ret = scsi_ioctl(sdev, cmd, argp);
+		return ret;
 
-out:
-	mutex_unlock(&sr_mutex);
-	return ret;
+	return scsi_ioctl(sdev, cmd, argp);
 }
 
 static unsigned int sr_block_check_events(struct gendisk *disk,
-- 
2.1.3

