From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH][SCSI] fix regression in SCSI_IOCTL_SEND_COMMAND
Date: Fri, 22 Aug 2014 15:53:35 -0400
Message-ID: <53F79FBF.4090000@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

blk_rq_set_block_pc() memsets rq->cmd to 0, so it should come
immediately after blk_get_request() to avoid overwriting the
user-supplied CDB.  Also check for failure to allocate rq.

Fixes: f27b087b81b7 ("block: add blk_rq_set_block_pc()")
Cc: <stable@vger.kernel.org> # 3.16.x
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

---

For inclusion in 3.17 and 3.16.x.

Note: I don't have any programs that use this ioctl, so this patch is
compile-tested only.

--- linux-3.17.0-rc1-a/block/scsi_ioctl.c	2014-08-16 12:40:26.000000000 -0400
+++ linux-3.17.0-rc1-b/block/scsi_ioctl.c	2014-08-22 14:15:34.000000000 -0400
@@ -448,6 +448,11 @@ int sg_scsi_ioctl(struct request_queue *
 	}
 
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
+	if (!rq) {
+		err = -ENOMEM;
+		goto error;
+	}
+	blk_rq_set_block_pc(rq);
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -501,7 +506,6 @@ int sg_scsi_ioctl(struct request_queue *
 	memset(sense, 0, sizeof(sense));
 	rq->sense = sense;
 	rq->sense_len = 0;
-	blk_rq_set_block_pc(rq);
 
 	blk_execute_rq(q, disk, rq, 0);
 
@@ -521,7 +525,8 @@ out:
 	
 error:
 	kfree(buffer);
-	blk_put_request(rq);
+	if (rq)
+		blk_put_request(rq);
 	return err;
 }
 EXPORT_SYMBOL_GPL(sg_scsi_ioctl);
