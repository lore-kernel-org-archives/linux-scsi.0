From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: sanity check for timeout in sg_io()
Date: Wed, 10 May 2017 15:24:36 +0200
Message-ID: <1494422676-72745-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38678 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750733AbdEJNYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 May 2017 09:24:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

sg_io() is using msecs_to_jiffies() to convert a passed in timeout
value (in milliseconds) to a jiffies value. However, if the value
is too large msecs_to_jiffies() will return MAX_JIFFY_OFFSET, which
will be truncated to -2 and cause the timeout to be set to 1.3
_years_. Which is probably too long for most applications.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/scsi_ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 4a294a5..53b95ea 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -231,6 +231,7 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 			     struct sg_io_hdr *hdr, fmode_t mode)
 {
 	struct scsi_request *req = scsi_req(rq);
+	unsigned long timeout;
 
 	if (copy_from_user(req->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
@@ -242,7 +243,11 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 	 */
 	req->cmd_len = hdr->cmd_len;
 
-	rq->timeout = msecs_to_jiffies(hdr->timeout);
+	timeout = msecs_to_jiffies(hdr->timeout);
+	if (timeout == MAX_JIFFY_OFFSET)
+		rq->timeout = 0;
+	else
+		rq->timeout = timeout;
 	if (!rq->timeout)
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
-- 
1.8.5.6
