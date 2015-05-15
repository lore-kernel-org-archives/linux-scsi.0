From: Willy Tarreau <w@1wt.eu>
Subject: [ 45/48] scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
Date: Fri, 15 May 2015 10:06:15 +0200
Message-ID: <20150515080532.202226683@1wt.eu>
References: <9c2783dfae10ef2d1e9b08bcc1e562c5@local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9c2783dfae10ef2d1e9b08bcc1e562c5@local>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>, Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
List-Id: linux-scsi@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
(cherry picked from commit d73b032b63e8967462e1cf5763858ed89e97880f)

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 block/scsi_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 123eb17..f5df2a8 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -503,7 +503,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
 		err = DRIVER_ERROR << 24;
-		goto out;
+		goto error;
 	}
 
 	memset(sense, 0, sizeof(sense));
@@ -513,7 +513,6 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	blk_execute_rq(q, disk, rq, 0);
 
-out:
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
-- 
1.7.12.2.21.g234cd45.dirty
