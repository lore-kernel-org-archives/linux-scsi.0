Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC8BC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 06:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D0561053
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 06:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhG2Gvs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 02:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbhG2Gvq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 02:51:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF581C061757;
        Wed, 28 Jul 2021 23:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=++pnEH8yt1odkX2S39autPEnNQQdMDAsXauHxQBiD30=; b=jqZl5ck4s9LOxjC09Lt8gSXd7g
        qIEh/pk2nKvgSvfyvqt22IOlYFS007soV8/HpH7LeumZoCpo0w2xX2ep6mXo2w7FyZHP7hOJ73jk3
        x5NAVxhbuvD8hEt5/YVhY1roLb9kGmOyBodaTvbDJPUS2WdV9f/l5B52P5uy8f62QVO+ZKSRH9KcA
        SFkP6u6FcQav+AwarSvS0geKNWBz6Rxv3Pwhov0wUaZMjPrnk9RYjP3uCi2Bl8nxoUd6Mxd9ayCj6
        KzOuW+B4yLhf9gdTnFnKodx5pS2aFV0gD/BJkiY7jft0n96Vz+lFg4L3k3F0Rdz9J0cu/xly8VNLT
        zSYwOHZw==;
Received: from [2001:4bb8:184:87c5:8c88:c313:79e2:b780] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8zsI-00GnjD-MJ; Thu, 29 Jul 2021 06:50:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 3/4] block: remove the remaining SG_IO-related fields from struct request_queue
Date:   Thu, 29 Jul 2021 08:48:44 +0200
Message-Id: <20210729064845.1044147-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729064845.1044147-1-hch@lst.de>
References: <20210729064845.1044147-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the sg_timeout and sg_reserved_size fields into the bsg_device and
scsi_device structures as they have nothing to do with generic block I/O.
Note that these values are now separate for bsg vs scsi device node
access, but that just matches how /dev/sg vs the other nodes has always
behaved.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c             |  2 --
 block/bsg.c                | 13 +++++---
 drivers/scsi/scsi_ioctl.c  | 63 ++++++++++++++++++--------------------
 drivers/scsi/scsi_scan.c   |  2 ++
 include/linux/blkdev.h     |  5 ---
 include/scsi/scsi_device.h |  3 ++
 6 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2c4ac51e54eb..495f508c6300 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3298,8 +3298,6 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	    set->map[HCTX_TYPE_POLL].nr_queues)
 		blk_queue_flag_set(QUEUE_FLAG_POLL, q);
 
-	q->sg_reserved_size = INT_MAX;
-
 	INIT_DELAYED_WORK(&q->requeue_work, blk_mq_requeue_work);
 	INIT_LIST_HEAD(&q->requeue_list);
 	spin_lock_init(&q->requeue_lock);
diff --git a/block/bsg.c b/block/bsg.c
index 83a095185d33..3ba74eec4ba2 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -26,6 +26,8 @@ struct bsg_device {
 	struct device device;
 	struct cdev cdev;
 	int max_queue;
+	unsigned int timeout;
+	unsigned int reserved_size;
 };
 
 static inline struct bsg_device *to_bsg_device(struct inode *inode)
@@ -71,7 +73,7 @@ static int bsg_sg_io(struct bsg_device *bd, fmode_t mode, void __user *uarg)
 
 	rq->timeout = msecs_to_jiffies(hdr.timeout);
 	if (!rq->timeout)
-		rq->timeout = rq->q->sg_timeout;
+		rq->timeout = bd->timeout;
 	if (!rq->timeout)
 		rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	if (rq->timeout < BLK_MIN_SG_TIMEOUT)
@@ -161,19 +163,19 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case SG_SET_TIMEOUT:
 		if (get_user(val, intp))
 			return -EFAULT;
-		q->sg_timeout = clock_t_to_jiffies(val);
+		bd->timeout = clock_t_to_jiffies(val);
 		return 0;
 	case SG_GET_TIMEOUT:
-		return jiffies_to_clock_t(q->sg_timeout);
+		return jiffies_to_clock_t(bd->timeout);
 	case SG_GET_RESERVED_SIZE:
-		return put_user(min(q->sg_reserved_size, queue_max_bytes(q)),
+		return put_user(min(bd->reserved_size, queue_max_bytes(q)),
 				intp);
 	case SG_SET_RESERVED_SIZE:
 		if (get_user(val, intp))
 			return -EFAULT;
 		if (val < 0)
 			return -EINVAL;
-		q->sg_reserved_size =
+		bd->reserved_size =
 			min_t(unsigned int, val, queue_max_bytes(q));
 		return 0;
 	case SG_EMULATED_HOST:
@@ -219,6 +221,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 	if (!bd)
 		return ERR_PTR(-ENOMEM);
 	bd->max_queue = BSG_DEFAULT_CMDS;
+	bd->reserved_size = INT_MAX;
 	bd->queue = q;
 	bd->ops = ops;
 
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 633f016c2bfe..384238a1458f 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -173,29 +173,25 @@ static int sg_get_version(int __user *p)
 	return put_user(sg_version_num, p);
 }
 
-static int sg_get_timeout(struct request_queue *q)
-{
-	return jiffies_to_clock_t(q->sg_timeout);
-}
-
-static int sg_set_timeout(struct request_queue *q, int __user *p)
+static int sg_set_timeout(struct scsi_device *sdev, int __user *p)
 {
 	int timeout, err = get_user(timeout, p);
 
 	if (!err)
-		q->sg_timeout = clock_t_to_jiffies(timeout);
+		sdev->sg_timeout = clock_t_to_jiffies(timeout);
 
 	return err;
 }
 
-static int sg_get_reserved_size(struct request_queue *q, int __user *p)
+static int sg_get_reserved_size(struct scsi_device *sdev, int __user *p)
 {
-	int val = min(q->sg_reserved_size, queue_max_bytes(q));
+	int val = min(sdev->sg_reserved_size,
+		      queue_max_bytes(sdev->request_queue));
 
 	return put_user(val, p);
 }
 
-static int sg_set_reserved_size(struct request_queue *q, int __user *p)
+static int sg_set_reserved_size(struct scsi_device *sdev, int __user *p)
 {
 	int size, err = get_user(size, p);
 
@@ -205,7 +201,8 @@ static int sg_set_reserved_size(struct request_queue *q, int __user *p)
 	if (size < 0)
 		return -EINVAL;
 
-	q->sg_reserved_size = min_t(unsigned int, size, queue_max_bytes(q));
+	sdev->sg_reserved_size = min_t(unsigned int, size,
+				       queue_max_bytes(sdev->request_queue));
 	return 0;
 }
 
@@ -345,7 +342,7 @@ bool scsi_cmd_allowed(unsigned char *cmd, fmode_t mode)
 }
 EXPORT_SYMBOL(scsi_cmd_allowed);
 
-static int scsi_fill_sghdr_rq(struct request_queue *q, struct request *rq,
+static int scsi_fill_sghdr_rq(struct scsi_device *sdev, struct request *rq,
 		struct sg_io_hdr *hdr, fmode_t mode)
 {
 	struct scsi_request *req = scsi_req(rq);
@@ -362,7 +359,7 @@ static int scsi_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 
 	rq->timeout = msecs_to_jiffies(hdr->timeout);
 	if (!rq->timeout)
-		rq->timeout = q->sg_timeout;
+		rq->timeout = sdev->sg_timeout;
 	if (!rq->timeout)
 		rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	if (rq->timeout < BLK_MIN_SG_TIMEOUT)
@@ -409,7 +406,7 @@ static int scsi_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	return ret;
 }
 
-static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
+static int sg_io(struct scsi_device *sdev, struct gendisk *disk,
 		struct sg_io_hdr *hdr, fmode_t mode)
 {
 	unsigned long start_time;
@@ -423,7 +420,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	if (hdr->interface_id != 'S')
 		return -EINVAL;
 
-	if (hdr->dxfer_len > (queue_max_hw_sectors(q) << 9))
+	if (hdr->dxfer_len > (queue_max_hw_sectors(sdev->request_queue) << 9))
 		return -EIO;
 
 	if (hdr->dxfer_len)
@@ -441,7 +438,8 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		at_head = 1;
 
 	ret = -ENOMEM;
-	rq = blk_get_request(q, writing ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
+	rq = blk_get_request(sdev->request_queue, writing ?
+			     REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	req = scsi_req(rq);
@@ -452,7 +450,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 			goto out_put_request;
 	}
 
-	ret = scsi_fill_sghdr_rq(q, rq, hdr, mode);
+	ret = scsi_fill_sghdr_rq(sdev, rq, hdr, mode);
 	if (ret < 0)
 		goto out_free_cdb;
 
@@ -469,11 +467,11 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		/* SG_IO howto says that the shorter of the two wins */
 		iov_iter_truncate(&i, hdr->dxfer_len);
 
-		ret = blk_rq_map_user_iov(q, rq, NULL, &i, GFP_KERNEL);
+		ret = blk_rq_map_user_iov(rq->q, rq, NULL, &i, GFP_KERNEL);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
-		ret = blk_rq_map_user(q, rq, NULL, hdr->dxferp, hdr->dxfer_len,
-				      GFP_KERNEL);
+		ret = blk_rq_map_user(rq->q, rq, NULL, hdr->dxferp,
+				      hdr->dxfer_len, GFP_KERNEL);
 
 	if (ret)
 		goto out_free_cdb;
@@ -483,7 +481,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 
 	start_time = jiffies;
 
-	blk_execute_rq(bd_disk, rq, at_head);
+	blk_execute_rq(disk, rq, at_head);
 
 	hdr->duration = jiffies_to_msecs(jiffies - start_time);
 
@@ -806,9 +804,8 @@ static int scsi_put_cdrom_generic_arg(const struct cdrom_generic_command *cgc,
 	return 0;
 }
 
-static int scsi_cdrom_send_packet(struct request_queue *q,
-				  struct gendisk *bd_disk,
-				  fmode_t mode, void __user *arg)
+static int scsi_cdrom_send_packet(struct scsi_device *sdev,struct gendisk *disk,
+		fmode_t mode, void __user *arg)
 {
 	struct cdrom_generic_command cgc;
 	struct sg_io_hdr hdr;
@@ -848,7 +845,7 @@ static int scsi_cdrom_send_packet(struct request_queue *q,
 	hdr.cmdp = ((struct cdrom_generic_command __user *) arg)->cmd;
 	hdr.cmd_len = sizeof(cgc.cmd);
 
-	err = sg_io(q, bd_disk, &hdr, mode);
+	err = sg_io(sdev, disk, &hdr, mode);
 	if (err == -EFAULT)
 		return -EFAULT;
 
@@ -863,7 +860,7 @@ static int scsi_cdrom_send_packet(struct request_queue *q,
 	return err;
 }
 
-static int scsi_ioctl_sg_io(struct request_queue *q, struct gendisk *disk,
+static int scsi_ioctl_sg_io(struct scsi_device *sdev, struct gendisk *disk,
 		fmode_t mode, void __user *argp)
 {
 	struct sg_io_hdr hdr;
@@ -872,7 +869,7 @@ static int scsi_ioctl_sg_io(struct request_queue *q, struct gendisk *disk,
 	error = get_sg_io_hdr(&hdr, argp);
 	if (error)
 		return error;
-	error = sg_io(q, disk, &hdr, mode);
+	error = sg_io(sdev, disk, &hdr, mode);
 	if (error == -EFAULT)
 		return error;
 	if (put_sg_io_hdr(&hdr, argp))
@@ -918,21 +915,21 @@ int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
 	case SG_GET_VERSION_NUM:
 		return sg_get_version(arg);
 	case SG_SET_TIMEOUT:
-		return sg_set_timeout(q, arg);
+		return sg_set_timeout(sdev, arg);
 	case SG_GET_TIMEOUT:
-		return sg_get_timeout(q);
+		return jiffies_to_clock_t(sdev->sg_timeout);
 	case SG_GET_RESERVED_SIZE:
-		return sg_get_reserved_size(q, arg);
+		return sg_get_reserved_size(sdev, arg);
 	case SG_SET_RESERVED_SIZE:
-		return sg_set_reserved_size(q, arg);
+		return sg_set_reserved_size(sdev, arg);
 	case SG_EMULATED_HOST:
 		return sg_emulated_host(q, arg);
 	case SG_IO:
-		return scsi_ioctl_sg_io(q, disk, mode, arg);
+		return scsi_ioctl_sg_io(sdev, disk, mode, arg);
 	case SCSI_IOCTL_SEND_COMMAND:
 		return sg_scsi_ioctl(q, disk, mode, arg);
 	case CDROM_SEND_PACKET:
-		return scsi_cdrom_send_packet(q, disk, mode, arg);
+		return scsi_cdrom_send_packet(sdev, disk, mode, arg);
 	case CDROMCLOSETRAY:
 		return scsi_send_start_stop(sdev, 3);
 	case CDROMEJECT:
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3faedf4970ec..e06a2602fca4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -267,6 +267,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 */
 	sdev->borken = 1;
 
+	sdev->sg_reserved_size = INT_MAX;
+
 	q = blk_mq_init_queue(&sdev->host->tag_set);
 	if (IS_ERR(q)) {
 		/* release fn is set up in scsi_sysfs_device_initialise, so
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e0bb14acb708..987f15089eeb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -499,11 +499,6 @@ struct request_queue {
 	unsigned int		max_active_zones;
 #endif /* CONFIG_BLK_DEV_ZONED */
 
-	/*
-	 * sg stuff
-	 */
-	unsigned int		sg_timeout;
-	unsigned int		sg_reserved_size;
 	int			node;
 	struct mutex		debugfs_mutex;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 99082da1b951..7137e7924913 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -236,6 +236,9 @@ struct scsi_device {
 	size_t			dma_drain_len;
 	void			*dma_drain_buf;
 
+	unsigned int		sg_timeout;
+	unsigned int		sg_reserved_size;
+
 	struct bsg_device	*bsg_dev;
 	unsigned char		access_state;
 	struct mutex		state_mutex;
-- 
2.30.2

