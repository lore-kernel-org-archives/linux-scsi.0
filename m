From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v5 1/2] block,scsi: verify return pointer from
 blk_get_request
Date: Fri, 24 May 2013 14:16:37 -0400
Message-ID: <20130524141637.405c7f39@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com>
	<20130524141531.737073a8@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:57423 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3EXSUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 May 2013 14:20:24 -0400
In-Reply-To: <20130524141531.737073a8@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>, "James E.J. Bottomley" <JBottomley@parallels.com>, Bart Van Assche <bvanassche@acm.org>

>From 22307be1bc6e404622b1f074094902e385a1bd30 Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Fri, 24 May 2013 12:39:04 -0400
Subject: [PATCH v5 1/2] block,scsi: verify return pointer from blk_get_request

The blk-core dead queue checks introduced in commit 70460571 added an
error scenario to blk_get_request that returns NULL if the request queue
has been shutdown. This changed the behavior for __GFP_WAIT callers, who
should now verify the return value before dereferencing.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
---
 block/scsi_ioctl.c        | 9 ++++++++-
 drivers/block/paride/pd.c | 2 ++
 drivers/block/pktcdvd.c   | 2 ++
 drivers/scsi/scsi_error.c | 2 ++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 9a87daa..6c87d4e 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -458,6 +458,10 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	}
 
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
+	if (!rq) {
+		err = -ENODEV;
+		goto error_free_buffer;
+	}
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -530,8 +534,9 @@ out:
 	}
 	
 error:
-	kfree(buffer);
 	blk_put_request(rq);
+error_free_buffer:
+	kfree(buffer);
 	return err;
 }
 EXPORT_SYMBOL_GPL(sg_scsi_ioctl);
@@ -544,6 +549,8 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	int err;
 
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
+	if (!rq)
+		return -ENODEV;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	rq->cmd[0] = cmd;
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 831e3ac..fc2ecff 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -722,6 +722,8 @@ static int pd_special_command(struct pd_unit *disk,
 	int err = 0;
 
 	rq = blk_get_request(disk->gd->queue, READ, __GFP_WAIT);
+	if (!rq)
+		return -ENODEV;
 
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = func;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 1119042..4a8fb03f 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -711,6 +711,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
 			     WRITE : READ, __GFP_WAIT);
+	if (!rq)
+		return -ENODEV;
 
 	if (cgc->buflen) {
 		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..aa6b83d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1635,6 +1635,8 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	 * request becomes available
 	 */
 	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
+	if (!req)
+		return;
 
 	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
 	req->cmd[1] = 0;
-- 
1.8.1.4

