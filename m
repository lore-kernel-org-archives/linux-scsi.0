From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/4] block: fix SG_[GS]ET_RESERVED_SIZE ioctl when max_sectors is huge
Date: Sun, 25 May 2014 21:43:34 +0900
Message-ID: <1401021816-10423-3-git-send-email-akinobu.mita@gmail.com>
References: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47898 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaEYMoG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 May 2014 08:44:06 -0400
Received: by mail-pa0-f48.google.com with SMTP id rd3so6284565pab.35
        for <linux-scsi@vger.kernel.org>; Sun, 25 May 2014 05:44:06 -0700 (PDT)
In-Reply-To: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

SG_GET_RESERVED_SIZE and SG_SET_RESERVED_SIZE ioctls access a reserved
buffer in bytes as int type.  The value needs to be capped at the request
queue's max_sectors.  But integer overflow is not correctly handled in
the calculation when converting max_sectors from sectors to bytes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---
 block/scsi_ioctl.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 2648797..6174bba 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -82,9 +82,18 @@ static int sg_set_timeout(struct request_queue *q, int __user *p)
 	return err;
 }
 
+static int max_sectors_bytes(struct request_queue *q)
+{
+	unsigned int max_sectors = queue_max_sectors(q);
+
+	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
+
+	return max_sectors << 9;
+}
+
 static int sg_get_reserved_size(struct request_queue *q, int __user *p)
 {
-	unsigned val = min(q->sg_reserved_size, queue_max_sectors(q) << 9);
+	int val = min_t(int, q->sg_reserved_size, max_sectors_bytes(q));
 
 	return put_user(val, p);
 }
@@ -98,10 +107,8 @@ static int sg_set_reserved_size(struct request_queue *q, int __user *p)
 
 	if (size < 0)
 		return -EINVAL;
-	if (size > (queue_max_sectors(q) << 9))
-		size = queue_max_sectors(q) << 9;
 
-	q->sg_reserved_size = size;
+	q->sg_reserved_size = min(size, max_sectors_bytes(q));
 	return 0;
 }
 
-- 
1.9.1

