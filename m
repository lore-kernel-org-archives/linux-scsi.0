From: Jan Kara <jack@suse.cz>
Subject: [PATCH] scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
Date: Wed, 22 Oct 2014 09:30:26 +0200
Message-ID: <1413963026-25974-1-git-send-email-jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When sg_scsi_ioctl() fails to prepare request to submit in
blk_rq_map_kern() we jump to a label where we just end up copying
(luckily zeroed-out) kernel buffer to userspace instead of reporting
error. Fix the problem by jumping to the right label.

CC: Jens Axboe <axboe@kernel.dk>
CC: linux-scsi@vger.kernel.org
CC: stable@vger.kernel.org
Coverity-id: 1226871
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/scsi_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index abb2e65b24cc..cc7927a1a62e 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -508,7 +508,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
 		err = DRIVER_ERROR << 24;
-		goto out;
+		goto error;
 	}
 
 	memset(sense, 0, sizeof(sense));
-- 
1.8.1.4
