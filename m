From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 4/6] sd: use READ_16 or WRITE_16 when transfer length is greater than 0xffff
Date: Mon,  2 Jun 2014 22:56:47 +0900
Message-ID: <1401717409-5236-5-git-send-email-akinobu.mita@gmail.com>
References: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37599 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaFBN5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 09:57:15 -0400
Received: by mail-pa0-f52.google.com with SMTP id bj1so3925892pad.39
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 06:57:15 -0700 (PDT)
In-Reply-To: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Elliott, Robert" <Elliott@hp.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

This change makes the scsi disk driver handle the requests whose
transfer length is greater than 0xffff with READ_16 or WRITE_16.

However, this is a preparation for extending the data type of
max_sectors in struct Scsi_Host and scsi_host_template.  So, it is
impossible to happen this condition for now, because SCSI low-level
drivers can not specify max_sectors greater than 0xffff due to the
data type limitation.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Elliott, Robert" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---
This patch is a part of the v1 "scsi: increase upper limit for
max_sectors" patch.  But Reorder conditional in command selection,
suggested by Elliott, Robert.

 drivers/scsi/sd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index efcbcd1..66310c9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1056,7 +1056,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
 		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
 		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
-	} else if (sdp->use_16_for_rw) {
+	} else if (sdp->use_16_for_rw || (this_count > 0xffff)) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
 		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
 		SCpnt->cmnd[2] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
@@ -1075,9 +1075,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	} else if ((this_count > 0xff) || (block > 0x1fffff) ||
 		   scsi_device_protection(SCpnt->device) ||
 		   SCpnt->device->use_10_for_rw) {
-		if (this_count > 0xffff)
-			this_count = 0xffff;
-
 		SCpnt->cmnd[0] += READ_10 - READ_6;
 		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
 		SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
-- 
1.9.1

