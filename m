From: Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 116/170] scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
Date: Tue, 11 Nov 2014 11:07:55 +0000
Message-ID: <1415704129-12709-117-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, kernel-team@lists.ubuntu.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>, Luis Henriques <luis.henriques@canonical.com>
List-Id: linux-scsi@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 84ce0f0e94ac97217398b3b69c21c7a62ebeed05 upstream.

When sg_scsi_ioctl() fails to prepare request to submit in
blk_rq_map_kern() we jump to a label where we just end up copying
(luckily zeroed-out) kernel buffer to userspace instead of reporting
error. Fix the problem by jumping to the right label.

CC: Jens Axboe <axboe@kernel.dk>
CC: linux-scsi@vger.kernel.org
Coverity-id: 1226871
Signed-off-by: Jan Kara <jack@suse.cz>

Fixed up the, now unused, out label.

Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/scsi_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 84ab119b6ffa..de3bd8287d81 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -490,7 +490,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
 		err = DRIVER_ERROR << 24;
-		goto out;
+		goto error;
 	}
 
 	memset(sense, 0, sizeof(sense));
@@ -499,7 +499,6 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	blk_execute_rq(q, disk, rq, 0);
 
-out:
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
-- 
2.1.0
