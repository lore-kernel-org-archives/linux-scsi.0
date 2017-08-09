From: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC PATCH 6/6] bsg: reduce unnecessary arguments for blk_complete_sgv4_hdr_rq()
Date: Wed,  9 Aug 2017 16:11:20 +0200
Message-ID: <d95177abfa703a4f77a3d8ddb218eaead465f5ec.1502120928.git.bblock@linux.vnet.ibm.com>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCLYZUM5WUFRBRNQVTGAKGQEKM6Y62Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

Since struct bsg_command is now used in every calling case, we don't
need separation of arguments anymore that are contained in the same
bsg_command.

Signed-off-by: Benjamin Block <bblock-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 block/bsg.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 6ee2ffca808a..09f767cdf816 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -399,13 +399,14 @@ static struct bsg_command *bsg_get_done_cmd(struct bsg_device *bd)
 	return bc;
 }
 
-static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
-				    struct bio *bio, struct bio *bidi_bio)
+static int blk_complete_sgv4_hdr_rq(struct bsg_command *bc)
 {
+	struct sg_io_v4 *hdr = &bc->hdr;
+	struct request *rq = bc->rq;
 	struct scsi_request *req = scsi_req(rq);
 	int ret = 0;
 
-	dprintk("rq %p bio %p 0x%x\n", rq, bio, req->result);
+	dprintk("rq %p bio %p 0x%x\n", rq, bc->bio, req->result);
 	/*
 	 * fill in all the output members
 	 */
@@ -432,7 +433,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	if (rq->next_rq) {
 		hdr->dout_resid = req->resid_len;
 		hdr->din_resid = scsi_req(rq->next_rq)->resid_len;
-		blk_rq_unmap_user(bidi_bio);
+		blk_rq_unmap_user(bc->bidi_bio);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
 		hdr->din_resid = req->resid_len;
@@ -448,7 +449,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	if (!ret && req->result < 0)
 		ret = req->result;
 
-	blk_rq_unmap_user(bio);
+	blk_rq_unmap_user(bc->bio);
 	scsi_req_free_cmd(req);
 	blk_put_request(rq);
 
@@ -507,8 +508,7 @@ static int bsg_complete_all_commands(struct bsg_device *bd)
 		if (IS_ERR(bc))
 			break;
 
-		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
-						bc->bidi_bio);
+		tret = blk_complete_sgv4_hdr_rq(bc);
 		if (!ret)
 			ret = tret;
 
@@ -542,8 +542,7 @@ __bsg_read(char __user *buf, size_t count, struct bsg_device *bd,
 		 * after completing the request. so do that here,
 		 * bsg_complete_work() cannot do that for us
 		 */
-		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
-					       bc->bidi_bio);
+		ret = blk_complete_sgv4_hdr_rq(bc);
 
 		if (copy_to_user(buf, &bc->hdr, sizeof(bc->hdr)))
 			ret = -EFAULT;
@@ -944,8 +943,7 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		blk_execute_rq(bd->queue, NULL, bc->rq, at_head);
 		bc->hdr.duration = jiffies_to_msecs(jiffies - bc->hdr.duration);
 
-		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
-					       bc->bidi_bio);
+		ret = blk_complete_sgv4_hdr_rq(bc);
 
 		if (copy_to_user(uarg, &bc->hdr, sizeof(bc->hdr)))
 			ret = -EFAULT;
-- 
2.12.2

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
