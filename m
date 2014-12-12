From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.2 075/164] scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.327458186@decadent.org.uk>
References: <lsq.1418364865.554543691@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966047AbaLLGsa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:30 -0500
Content-Disposition: inline
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 block/scsi_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -505,7 +505,7 @@ int sg_scsi_ioctl(struct request_queue *
 
 	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
 		err = DRIVER_ERROR << 24;
-		goto out;
+		goto error;
 	}
 
 	memset(sense, 0, sizeof(sense));
@@ -515,7 +515,6 @@ int sg_scsi_ioctl(struct request_queue *
 
 	blk_execute_rq(q, disk, rq, 0);
 
-out:
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {

