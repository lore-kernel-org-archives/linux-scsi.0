From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v6 1/2] block,scsi: verify return pointer from blk_get_request
Date: Thu, 31 Oct 2013 09:50:33 -0400
Message-ID: <1383227434-4536-2-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o141.mxlogic.net ([208.65.145.64]:46184 "EHLO
	p01c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3JaOCc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2013 10:02:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <JBottomley@parallels.com>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Benny Halevy <bhalevy@tonian.com>, Boaz Harrosh <bharrosh@panasas.com>, Doug Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>, Paolo Bonzini <pbonzini@redhat.com>, Tim Waugh <tim@cyberelk.net>, Willem Riede <osst@riede.org>, Joe Lawrence <joe.lawrence@stratus.com>

The blk-core dead queue checks introduce an error scenario to
blk_get_request that returns NULL if the request queue has been
shutdown. This affects the behavior for __GFP_WAIT callers, who should
verify the return value before dereferencing.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 block/scsi_ioctl.c        | 9 ++++++++-
 drivers/block/paride/pd.c | 2 ++
 drivers/block/pktcdvd.c   | 2 ++
 drivers/scsi/scsi_error.c | 2 ++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a5ffcc988f0b..dd1810d7b4ee 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -459,6 +459,10 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	}
 
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
+	if (!rq) {
+		err = -ENODEV;
+		goto error_free_buffer;
+	}
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -531,8 +535,9 @@ out:
 	}
 	
 error:
-	kfree(buffer);
 	blk_put_request(rq);
+error_free_buffer:
+	kfree(buffer);
 	return err;
 }
 EXPORT_SYMBOL_GPL(sg_scsi_ioctl);
@@ -545,6 +550,8 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	int err;
 
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
+	if (!rq)
+		return -ENODEV;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	rq->cmd[0] = cmd;
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 19ad8f0c83ef..856178a34f9a 100644
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
index 56188475cfd3..99719a0922a5 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -718,6 +718,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
 			     WRITE : READ, __GFP_WAIT);
+	if (!rq)
+		return -ENODEV;
 
 	if (cgc->buflen) {
 		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 83e591b60193..af6f2c44d742 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1709,6 +1709,8 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	 * request becomes available
 	 */
 	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
+	if (!req)
+		return;
 
 	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
 	req->cmd[1] = 0;
-- 
1.8.3.1

