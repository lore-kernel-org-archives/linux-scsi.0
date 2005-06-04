From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 3/4] convert scsi-ioctl to use blk_rq_map_kern
Date: Fri, 03 Jun 2005 18:32:01 -0700
Message-ID: <1117848721.23706.8.camel@mina>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org, axboe@suse.de
List-Id: linux-scsi@vger.kernel.org

convert old sg_scsi_ioctl to use blk_rq_map_kern when there is data so
all SG IO paths use bio backed requests. This simplifies scsi and
is a step twords scatter gather io always being used (just need
to convert the "special" request path.

This patch was made against 2.6.12-rc5, and works with scsi-misc.


--- linux-2.6.12-rc5.orig/drivers/block/scsi_ioctl.c	2005-06-03 03:23:46.000000000 -0700
+++ linux-2.6.12-rc5/drivers/block/scsi_ioctl.c	2005-06-03 14:55:36.000000000 -0700
@@ -334,7 +334,7 @@ static int sg_scsi_ioctl(struct file *fi
 			 struct gendisk *bd_disk, Scsi_Ioctl_Command __user *sic)
 {
 	struct request *rq;
-	int err;
+	int err, write;
 	unsigned int in_len, out_len, bytes, opcode, cmdlen;
 	char *buffer = NULL, sense[SCSI_SENSE_BUFFERSIZE];
 
@@ -350,16 +350,23 @@ static int sg_scsi_ioctl(struct file *fi
 	if (get_user(opcode, sic->data))
 		return -EFAULT;
 
+	write = in_len ? WRITE : READ;
 	bytes = max(in_len, out_len);
 	if (bytes) {
 		buffer = kmalloc(bytes, q->bounce_gfp | GFP_USER| __GFP_NOWARN);
 		if (!buffer)
 			return -ENOMEM;
-
 		memset(buffer, 0, bytes);
-	}
 
-	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
+		rq = blk_rq_map_kern(bd_disk->queue, write, buffer, bytes,
+				     __GFP_WAIT);
+	} else
+		rq = blk_get_request(q, write, __GFP_WAIT);
+
+	if (IS_ERR(rq)) {
+		err = PTR_ERR(rq);
+		goto free_buffer;
+	}
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -369,14 +376,14 @@ static int sg_scsi_ioctl(struct file *fi
 	err = -EFAULT;
 	rq->cmd_len = cmdlen;
 	if (copy_from_user(rq->cmd, sic->data, cmdlen))
-		goto error;
+		goto free_request;
 
 	if (copy_from_user(buffer, sic->data + cmdlen, in_len))
-		goto error;
+		goto free_request;
 
 	err = verify_command(file, rq->cmd);
 	if (err)
-		goto error;
+		goto free_request;
 
 	switch (opcode) {
 		case SEND_DIAGNOSTIC:
@@ -421,10 +428,11 @@ static int sg_scsi_ioctl(struct file *fi
 		if (copy_to_user(sic->data, buffer, out_len))
 			err = -EFAULT;
 	}
-	
-error:
-	kfree(buffer);
+
+free_request:
 	blk_put_request(rq);
+free_buffer:
+	kfree(buffer);
 	return err;
 }
 
