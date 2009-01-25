From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH version2] bsg: Add support for submitting requests at tail
 of queue
Date: Sun, 25 Jan 2009 11:41:44 +0200
Message-ID: <497C33D8.1060802@panasas.com>
References: <4976F067.8000501@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:30901 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751649AbZAYJlt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jan 2009 04:41:49 -0500
In-Reply-To: <4976F067.8000501@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, James Bottomley <James.Bottomley@HansenPartnership.com>


Currently inherited from sg.c bsg will submit asynchronous request
at the head-of-the-queue, (using "at_head" set in the call to
blk_execute_rq_nowait()). This is bad in situation where the queues
are full but requests need to execute in order. Failing to do that can
cause the first submitted commands to never execute.

The sg_io_v4->flags member is used and a bit is allocated to denote the
Q_AT_TAIL. Zero is to queue at_head as before, to be compatible with old
code at the write/read path. SG_IO code path behavior was changed so to
be the same as write/read behavior. SG_IO was very rarely used and breaking
compatibility with it is OK at this stage.

sg_io_hdr at sg.h also has a flags member and uses 3 bits from the first
nibble and one bit from the last nibble. Even though none of these bits
are supported by bsg, The second nibble is allocated for use by bsg. Just
in case.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Douglas Gilbert <dgilbert@interlog.com>
---
 block/bsg.c         |    9 +++++++--
 include/linux/bsg.h |    8 ++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 44a2a0f..2e55655 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -350,6 +350,8 @@ static void bsg_rq_end_io(struct request *rq, int uptodate)
 static void bsg_add_command(struct bsg_device *bd, struct request_queue *q,
 			    struct bsg_command *bc, struct request *rq)
 {
+	int at_head = (0 == (bc->hdr.flags & BSG_FLAG_Q_AT_TAIL));
+
 	/*
 	 * add bc command to busy queue and submit rq for io
 	 */
@@ -365,7 +367,7 @@ static void bsg_add_command(struct bsg_device *bd, struct request_queue *q,
 	dprintk("%s: queueing rq %p, bc %p\n", bd->name, rq, bc);
 
 	rq->end_io_data = bc;
-	blk_execute_rq_nowait(q, NULL, rq, 1, bsg_rq_end_io);
+	blk_execute_rq_nowait(q, NULL, rq, at_head, bsg_rq_end_io);
 }
 
 static struct bsg_command *bsg_next_done_cmd(struct bsg_device *bd)
@@ -921,6 +923,7 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		struct request *rq;
 		struct bio *bio, *bidi_bio = NULL;
 		struct sg_io_v4 hdr;
+		int at_head;
 		u8 sense[SCSI_SENSE_BUFFERSIZE];
 
 		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
@@ -933,7 +936,9 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		bio = rq->bio;
 		if (rq->next_rq)
 			bidi_bio = rq->next_rq->bio;
-		blk_execute_rq(bd->queue, NULL, rq, 0);
+
+		at_head = (0 == (bc->hdr.flags & BSG_FLAG_Q_AT_TAIL));
+		blk_execute_rq(bd->queue, NULL, rq, at_head);
 		ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
 
 		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index cf0303a..3f0c64a 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -7,6 +7,14 @@
 #define BSG_SUB_PROTOCOL_SCSI_TMF	1
 #define BSG_SUB_PROTOCOL_SCSI_TRANSPORT	2
 
+/*
+ * For flags member below
+ * sg.h sg_io_hdr also has bits defined for it's flags member. However
+ * none of these bits are implemented/used by bsg. The bits below are
+ * allocated to not conflict with sg.h ones anyway.
+ */
+#define BSG_FLAG_Q_AT_TAIL 0x10 /* default, == 0 at this bit, is Q_AT_HEAD */
+
 struct sg_io_v4 {
 	__s32 guard;		/* [i] 'Q' to differentiate from v3 */
 	__u32 protocol;		/* [i] 0 -> SCSI , .... */
-- 
1.6.0.1


