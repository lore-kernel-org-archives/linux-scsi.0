From: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC PATCH 4/6] bsg: refactor ioctl to use regular BSG-command infrastructure for SG_IO
Date: Wed,  9 Aug 2017 16:11:18 +0200
Message-ID: <ce1d611619cb54c6ff033beab8337ecee29d12d7.1502120928.git.bblock@linux.vnet.ibm.com>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCLYZUM5WUFRBQNQVTGAKGQEIYEVJ3Y-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <cover.1502120928.git.bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
In-Reply-To: <cover.1502120928.git.bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
References: <cover.1502120928.git.bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Before, the SG_IO ioctl for BSG devices used to use its own on-stack data
to assemble and send the specified command. The read and write calls use
their own infrastructure build around the struct bsg_command and a custom
slab-pool for that.

Rafactor this, so that SG_IO ioctl also uses struct bsg_command and the
surrounding infrastructure. This way we use global defines like
BSG_COMMAND_REPLY_BUFFERSIZE only in one place, rather than two, the
handling of BSG commands gets more consistent, and it reduces some code-
duplications (the bio-pointer handling). It also reduces the stack
footprint by 320 to 384 bytes (depending on how large pointers are), and
uses the active slab-implementation for efficient alloc/free.

There are two other side-effects:
 - the 'duration' field in the sg header is now also filled for SG_IO
   calls, unlike before were it was always zero.
 - the BSG device queue-limit is also applied to SG_IO, unlike before were
   you could flood one BSG device with as many commands as you'd like. If
   one can trust older SG documentation this limit is applicable to either
   normal writes, or SG_IO calls; but this wasn't enforced before for
   SG_IO.

A complete unification is not possible, as it then would also enqueue SG_IO
commands in the BGS devices's command list, but this is only for the read-
and write-calls.

Signed-off-by: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 block/bsg.c | 60 ++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index b924f1c23c58..8517361a9b3f 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -320,6 +320,17 @@ static void bsg_rq_end_io(struct request *rq, blk_status_t status)
 	wake_up(&bd->wq_done);
 }
 
+static int bsg_prep_add_command(struct bsg_command *bc, struct request *rq)
+{
+	bc->rq = rq;
+	bc->bio = rq->bio;
+	if (rq->next_rq)
+		bc->bidi_bio = rq->next_rq->bio;
+	bc->hdr.duration = jiffies;
+
+	return 0 == (bc->hdr.flags & BSG_FLAG_Q_AT_TAIL);
+}
+
 /*
  * do final setup of a 'bc' and submit the matching 'rq' to the block
  * layer for io
@@ -327,16 +338,11 @@ static void bsg_rq_end_io(struct request *rq, blk_status_t status)
 static void bsg_add_command(struct bsg_device *bd, struct request_queue *q,
 			    struct bsg_command *bc, struct request *rq)
 {
-	int at_head = (0 == (bc->hdr.flags & BSG_FLAG_Q_AT_TAIL));
+	int at_head = bsg_prep_add_command(bc, rq);
 
 	/*
 	 * add bc command to busy queue and submit rq for io
 	 */
-	bc->rq = rq;
-	bc->bio = rq->bio;
-	if (rq->next_rq)
-		bc->bidi_bio = rq->next_rq->bio;
-	bc->hdr.duration = jiffies;
 	spin_lock_irq(&bd->lock);
 	list_add_tail(&bc->list, &bd->busy_list);
 	spin_unlock_irq(&bd->lock);
@@ -916,31 +922,37 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return scsi_cmd_ioctl(bd->queue, NULL, file->f_mode, cmd, uarg);
 	}
 	case SG_IO: {
-		struct request *rq;
-		u8 reply_buffer[BSG_COMMAND_REPLY_BUFFERSIZE] = { 0, };
-		struct bio *bio, *bidi_bio = NULL;
-		struct sg_io_v4 hdr;
+		struct bsg_command *bc;
 		int at_head;
 
-		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
-			return -EFAULT;
+		bc = bsg_alloc_command(bd);
+		if (IS_ERR(bc))
+			return PTR_ERR(bc);
 
-		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE,
-				 reply_buffer);
-		if (IS_ERR(rq))
-			return PTR_ERR(rq);
+		if (copy_from_user(&bc->hdr, uarg, sizeof(bc->hdr))) {
+			ret = -EFAULT;
+			goto sg_io_out;
+		}
 
-		bio = rq->bio;
-		if (rq->next_rq)
-			bidi_bio = rq->next_rq->bio;
+		bc->rq = bsg_map_hdr(bd, &bc->hdr, file->f_mode & FMODE_WRITE,
+				     bc->reply_buffer);
+		if (IS_ERR(bc->rq)) {
+			ret = PTR_ERR(bc->rq);
+			goto sg_io_out;
+		}
 
-		at_head = (0 == (hdr.flags & BSG_FLAG_Q_AT_TAIL));
-		blk_execute_rq(bd->queue, NULL, rq, at_head);
-		ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
+		at_head = bsg_prep_add_command(bc, bc->rq);
+		blk_execute_rq(bd->queue, NULL, bc->rq, at_head);
+		bc->hdr.duration = jiffies_to_msecs(jiffies - bc->hdr.duration);
 
-		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
-			return -EFAULT;
+		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
+					       bc->bidi_bio);
 
+		if (copy_to_user(uarg, &bc->hdr, sizeof(bc->hdr)))
+			ret = -EFAULT;
+
+	sg_io_out:
+		bsg_free_command(bc);
 		return ret;
 	}
 	/*
-- 
2.12.2

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
