From: Jiri Slaby <jslaby@suse.cz>
Subject: [patch added to the 3.12 stable tree] scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
Date: Fri, 14 Nov 2014 13:26:16 +0100
Message-ID: <1415968006-9521-76-git-send-email-jslaby@suse.cz>
References: <1415968006-9521-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935360AbaKNM1W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2014 07:27:22 -0500
In-Reply-To: <1415968006-9521-1-git-send-email-jslaby@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, Jens Axboe <axboe@fb.com>

From: Jan Kara <jack@suse.cz>

This patch has been added to the 3.12 stable tree. If you have any
objections, please let us know.

===============

commit 84ce0f0e94ac97217398b3b69c21c7a62ebeed05 upstream.

When sg_scsi_ioctl() fails to prepare request to submit in
blk_rq_map_kern() we jump to a label where we just end up copying
(luckily zeroed-out) kernel buffer to userspace instead of reporting
error. Fix the problem by jumping to the right label.

CC: Jens Axboe <axboe@kernel.dk>
CC: linux-scsi@vger.kernel.org
Coverity-id: 1226871
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Fixed up the, now unused, out label.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 block/scsi_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a5ffcc988f0b..1b4988b4bc11 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -506,7 +506,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
 		err = DRIVER_ERROR << 24;
-		goto out;
+		goto error;
 	}
 
 	memset(sense, 0, sizeof(sense));
@@ -516,7 +516,6 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	blk_execute_rq(q, disk, rq, 0);
 
-out:
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
-- 
2.1.3

