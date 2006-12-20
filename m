From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 5/6] bsg: replace SG v3 with SG v4
Date: Wed, 20 Dec 2006 14:43:11 +0900
Message-ID: <20061220144311D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:61019 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbWLTFnQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Dec 2006 00:43:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, dougg@torque.net

This patch replaces SG v3 in bsg with SG v4 (except for SG_IO).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |  198 ++++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 121 insertions(+), 77 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 53a09a5..6d139d2 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -103,8 +103,8 @@ struct bsg_command {
 	struct request *rq;
 	struct bio *bio;
 	int err;
-	struct sg_io_hdr hdr;
-	struct sg_io_hdr __user *uhdr;
+	struct sg_io_v4 hdr;
+	struct sg_io_v4 __user *uhdr;
 	char sense[SCSI_SENSE_BUFFERSIZE];
 };
 
@@ -235,57 +235,82 @@ static struct bsg_command *bsg_get_comma
 	return bc;
 }
 
+static int blk_fill_sgv4_hdr_rq(request_queue_t *q, struct request *rq,
+				struct sg_io_v4 *hdr, int has_write_perm)
+{
+	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
+
+	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
+			   hdr->request_len))
+		return -EFAULT;
+	if (blk_verify_command(rq->cmd, has_write_perm))
+		return -EPERM;
+
+	/*
+	 * fill in request structure
+	 */
+	rq->cmd_len = hdr->request_len;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+
+	rq->timeout = (hdr->timeout * HZ) / 1000;
+	if (!rq->timeout)
+		rq->timeout = q->sg_timeout;
+	if (!rq->timeout)
+		rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
+
+	return 0;
+}
+
 /*
- * Check if sg_io_hdr from user is allowed and valid
+ * Check if sg_io_v4 from user is allowed and valid
  */
 static int
-bsg_validate_sghdr(request_queue_t *q, struct sg_io_hdr *hdr, int *rw)
+bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr, int *rw)
 {
-	if (hdr->interface_id != 'S')
+	if (hdr->guard != 'Q')
 		return -EINVAL;
-	if (hdr->cmd_len > BLK_MAX_CDB)
+	if (hdr->request_len > BLK_MAX_CDB)
 		return -EINVAL;
-	if (hdr->dxfer_len > (q->max_sectors << 9))
+	if (hdr->dout_xfer_len > (q->max_sectors << 9) ||
+	    hdr->din_xfer_len > (q->max_sectors << 9))
 		return -EIO;
 
+	/* not supported currently */
+	if (hdr->protocol || hdr->subprotocol)
+		return -EINVAL;
+
 	/*
 	 * looks sane, if no data then it should be fine from our POV
 	 */
-	if (!hdr->dxfer_len)
+	if (!hdr->dout_xfer_len && !hdr->din_xfer_len)
 		return 0;
 
-	switch (hdr->dxfer_direction) {
-		case SG_DXFER_TO_FROM_DEV:
-		case SG_DXFER_FROM_DEV:
-			*rw = READ;
-			break;
-		case SG_DXFER_TO_DEV:
-			*rw = WRITE;
-			break;
-		default:
-			return -EINVAL;
-	}
+	/* not supported currently */
+	if (hdr->dout_xfer_len && hdr->din_xfer_len)
+		return -EINVAL;
+
+	*rw = hdr->dout_xfer_len ? WRITE : READ;
 
 	return 0;
 }
 
 /*
- * map sg_io_hdr to a request. for scatter-gather sg_io_hdr, we map
- * each segment to a bio and string multiple bio's to the request
+ * map sg_io_v4 to a request.
  */
 static struct request *
-bsg_map_hdr(struct bsg_device *bd, int rw, struct sg_io_hdr *hdr)
+bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 {
 	request_queue_t *q = bd->queue;
-	struct sg_iovec iov;
-	struct sg_iovec __user *u_iov;
 	struct request *rq;
-	int ret, i = 0;
+	int ret, rw;
+	unsigned int dxfer_len;
+	void *dxferp = NULL;
 
-	dprintk("map hdr %p/%d/%d\n", hdr->dxferp, hdr->dxfer_len,
-					hdr->iovec_count);
+	dprintk("map hdr %llx/%u %llx/%u\n", (unsigned long long) hdr->dout_xferp,
+		hdr->dout_xfer_len, (unsigned long long) hdr->din_xferp,
+		hdr->din_xfer_len);
 
-	ret = bsg_validate_sghdr(q, hdr, &rw);
+	ret = bsg_validate_sgv4_hdr(q, hdr, &rw);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -293,44 +318,29 @@ bsg_map_hdr(struct bsg_device *bd, int r
 	 * map scatter-gather elements seperately and string them to request
 	 */
 	rq = blk_get_request(q, rw, GFP_KERNEL);
-	ret = blk_fill_sghdr_rq(q, rq, hdr, test_bit(BSG_F_WRITE_PERM,
-				&bd->flags));
+	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, test_bit(BSG_F_WRITE_PERM,
+						       &bd->flags));
 	if (ret) {
 		blk_put_request(rq);
 		return ERR_PTR(ret);
 	}
 
-	if (!hdr->iovec_count) {
-		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len);
-		if (ret)
-			goto out;
-	}
-
-	u_iov = hdr->dxferp;
-	for (ret = 0, i = 0; i < hdr->iovec_count; i++, u_iov++) {
-		if (copy_from_user(&iov, u_iov, sizeof(iov))) {
-			ret = -EFAULT;
-			break;
-		}
-
-		if (!iov.iov_len || !iov.iov_base) {
-			ret = -EINVAL;
-			break;
+	if (hdr->dout_xfer_len) {
+		dxfer_len = hdr->dout_xfer_len;
+		dxferp = (void*)(unsigned long)hdr->dout_xferp;
+	} else if (hdr->din_xfer_len) {
+		dxfer_len = hdr->din_xfer_len;
+		dxferp = (void*)(unsigned long)hdr->din_xferp;
+	} else
+		dxfer_len = 0;
+
+	if (dxfer_len) {
+		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
+		if (ret) {
+			dprintk("failed map at %d\n", ret);
+			blk_put_request(rq);
+			rq = ERR_PTR(ret);
 		}
-
-		ret = blk_rq_map_user(q, rq, iov.iov_base, iov.iov_len);
-		if (ret)
-			break;
-	}
-
-	/*
-	 * bugger, cleanup
-	 */
-	if (ret) {
-out:
-		dprintk("failed map at %d: %d\n", i, ret);
-		blk_unmap_sghdr_rq(rq, hdr);
-		rq = ERR_PTR(ret);
 	}
 
 	return rq;
@@ -346,7 +356,7 @@ static void bsg_rq_end_io(struct request
 	struct bsg_device *bd = bc->bd;
 	unsigned long flags;
 
-	dprintk("%s: finished rq %p bc %p, bio %p offset %d stat %d\n",
+	dprintk("%s: finished rq %p bc %p, bio %p offset %Zd stat %d\n",
 		bd->name, rq, bc, bc->bio, bc - bd->cmd_map, uptodate);
 
 	bc->hdr.duration = jiffies_to_msecs(jiffies - bc->hdr.duration);
@@ -434,6 +444,42 @@ bsg_get_done_cmd_nosignals(struct bsg_de
 	return __bsg_get_done_cmd(bd, TASK_UNINTERRUPTIBLE);
 }
 
+static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
+				    struct bio *bio)
+{
+	int ret = 0;
+
+	dprintk("rq %p bio %p %u\n", rq, bio, rq->errors);
+	/*
+	 * fill in all the output members
+	 */
+	hdr->device_status = status_byte(rq->errors);
+	hdr->transport_status = host_byte(rq->errors);
+	hdr->driver_status = driver_byte(rq->errors);
+	hdr->info = 0;
+	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
+		hdr->info |= SG_INFO_CHECK;
+	hdr->din_resid = rq->data_len;
+	hdr->response_len = 0;
+
+	if (rq->sense_len && hdr->response) {
+		int len = min((unsigned int) hdr->max_response_len,
+			      rq->sense_len);
+
+		ret = copy_to_user((void*)(unsigned long)hdr->response,
+				   rq->sense, len);
+		if (!ret)
+			hdr->response_len = len;
+		else
+			ret = -EFAULT;
+	}
+
+	blk_rq_unmap_user(bio);
+	blk_put_request(rq);
+
+	return ret;
+}
+
 static int bsg_complete_all_commands(struct bsg_device *bd)
 {
 	struct bsg_command *bc;
@@ -476,7 +522,7 @@ static int bsg_complete_all_commands(str
 			break;
 		}
 
-		tret = blk_complete_sghdr_rq(bc->rq, &bc->hdr, bc->bio);
+		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio);
 		if (!ret)
 			ret = tret;
 
@@ -495,11 +541,11 @@ __bsg_read(char __user *buf, size_t coun
 	struct bsg_command *bc;
 	int nr_commands, ret;
 
-	if (count % sizeof(struct sg_io_hdr))
+	if (count % sizeof(struct sg_io_v4))
 		return -EINVAL;
 
 	ret = 0;
-	nr_commands = count / sizeof(struct sg_io_hdr);
+	nr_commands = count / sizeof(struct sg_io_v4);
 	while (nr_commands) {
 		bc = get_bc(bd, iov);
 		if (IS_ERR(bc)) {
@@ -512,7 +558,7 @@ __bsg_read(char __user *buf, size_t coun
 		 * after completing the request. so do that here,
 		 * bsg_complete_work() cannot do that for us
 		 */
-		ret = blk_complete_sghdr_rq(bc->rq, &bc->hdr, bc->bio);
+		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio);
 
 		if (copy_to_user(buf, (char *) &bc->hdr, sizeof(bc->hdr)))
 			ret = -EFAULT;
@@ -522,8 +568,8 @@ __bsg_read(char __user *buf, size_t coun
 		if (ret)
 			break;
 
-		buf += sizeof(struct sg_io_hdr);
-		*bytes_read += sizeof(struct sg_io_hdr);
+		buf += sizeof(struct sg_io_v4);
+		*bytes_read += sizeof(struct sg_io_v4);
 		nr_commands--;
 	}
 
@@ -582,16 +628,15 @@ static ssize_t __bsg_write(struct bsg_de
 	struct request *rq;
 	int ret, nr_commands;
 
-	if (count % sizeof(struct sg_io_hdr))
+	if (count % sizeof(struct sg_io_v4))
 		return -EINVAL;
 
-	nr_commands = count / sizeof(struct sg_io_hdr);
+	nr_commands = count / sizeof(struct sg_io_v4);
 	rq = NULL;
 	bc = NULL;
 	ret = 0;
 	while (nr_commands) {
 		request_queue_t *q = bd->queue;
-		int rw = READ;
 
 		bc = bsg_get_command(bd);
 		if (!bc)
@@ -602,7 +647,7 @@ static ssize_t __bsg_write(struct bsg_de
 			break;
 		}
 
-		bc->uhdr = (struct sg_io_hdr __user *) buf;
+		bc->uhdr = (struct sg_io_v4 __user *) buf;
 		if (copy_from_user(&bc->hdr, buf, sizeof(bc->hdr))) {
 			ret = -EFAULT;
 			break;
@@ -611,7 +656,7 @@ static ssize_t __bsg_write(struct bsg_de
 		/*
 		 * get a request, fill in the blanks, and add to request queue
 		 */
-		rq = bsg_map_hdr(bd, rw, &bc->hdr);
+		rq = bsg_map_hdr(bd, &bc->hdr);
 		if (IS_ERR(rq)) {
 			ret = PTR_ERR(rq);
 			rq = NULL;
@@ -622,12 +667,10 @@ static ssize_t __bsg_write(struct bsg_de
 		bc = NULL;
 		rq = NULL;
 		nr_commands--;
-		buf += sizeof(struct sg_io_hdr);
-		*bytes_read += sizeof(struct sg_io_hdr);
+		buf += sizeof(struct sg_io_v4);
+		*bytes_read += sizeof(struct sg_io_v4);
 	}
 
-	if (rq)
-		blk_unmap_sghdr_rq(rq, &bc->hdr);
 	if (bc)
 		bsg_free_command(bc);
 
@@ -898,11 +941,12 @@ bsg_ioctl(struct inode *inode, struct fi
 	case SG_GET_RESERVED_SIZE:
 	case SG_SET_RESERVED_SIZE:
 	case SG_EMULATED_HOST:
-	case SG_IO:
 	case SCSI_IOCTL_SEND_COMMAND: {
 		void __user *uarg = (void __user *) arg;
 		return scsi_cmd_ioctl(file, bd->disk, cmd, uarg);
 	}
+	case SG_IO:
+		return -EINVAL;
 	/*
 	 * block device ioctls
 	 */
-- 
1.4.3.2

