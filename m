From: lizf@kernel.org
Subject: [PATCH 3.4 100/177] scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
Date: Wed, 28 Jan 2015 12:09:18 +0800
Message-ID: <1422418236-12852-191-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Zefan Li <lizefan@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 block/scsi_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 9a87daa..f1c00c9 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -505,7 +505,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
 		err = DRIVER_ERROR << 24;
-		goto out;
+		goto error;
 	}
 
 	memset(sense, 0, sizeof(sense));
@@ -515,7 +515,6 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	blk_execute_rq(q, disk, rq, 0);
 
-out:
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
-- 
1.9.1
