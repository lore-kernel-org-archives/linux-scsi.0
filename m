From: Christoph Hellwig <hch@lst.de>
Subject: [RFC] generic scsi ioctls for character devices
Date: Fri, 23 May 2003 10:33:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030523103341.A30181@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:8710 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263938AbTEWIUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2003 04:20:38 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

add a scsi_cmd_ioctl variant that works for character devices that have
a gendisk/queue.  It's a bit ugly because the fs/bio.c wants a struct
block_device * for each bio so we have to fake one up.  The codepathes
scsi_cmd_ioctl uses only ever looks into it's ->bd_queue though..


--- 1.26/drivers/block/scsi_ioctl.c	Wed May 14 12:22:25 2003
+++ edited/drivers/block/scsi_ioctl.c	Fri May 16 23:08:01 2003
@@ -45,13 +45,12 @@
 #define SCSI_SENSE_BUFFERSIZE 64
 #endif
 
-static int blk_do_rq(request_queue_t *q, struct block_device *bdev, 
-		     struct request *rq)
+static int blk_do_rq(struct gendisk *disk, struct request *rq)
 {
 	DECLARE_COMPLETION(wait);
 	int err = 0;
 
-	rq->rq_disk = bdev->bd_disk;
+	rq->rq_disk = disk;
 
 	/*
 	 * we need an extra reference to the request, so we can look at
@@ -62,8 +61,8 @@
 	rq->flags |= REQ_NOMERGE;
 	rq->waiting = &wait;
         drive_stat_acct(rq, rq->nr_sectors, 1);
-	elv_add_request(q, rq, 1, 1);
-	generic_unplug_device(q);
+	elv_add_request(disk->queue, rq, 1, 1);
+	generic_unplug_device(disk->queue);
 	wait_for_completion(&wait);
 
 	if (rq->errors)
@@ -80,12 +79,12 @@
 	return put_user(sg_version_num, p);
 }
 
-static int scsi_get_idlun(request_queue_t *q, int *p)
+static int scsi_get_idlun(int *p)
 {
 	return put_user(0, p);
 }
 
-static int scsi_get_bus(request_queue_t *q, int *p)
+static int scsi_get_bus(int *p)
 {
 	return put_user(0, p);
 }
@@ -124,14 +123,15 @@
  * will always return that we are ATAPI even for a real SCSI drive, I'm not
  * so sure this is worth doing anything about (why would you care??)
  */
-static int sg_emulated_host(request_queue_t *q, int *p)
+static int sg_emulated_host(int *p)
 {
 	return put_user(1, p);
 }
 
-static int sg_io(request_queue_t *q, struct block_device *bdev,
-		 struct sg_io_hdr *uptr)
+static int sg_io(struct gendisk *disk, struct sg_io_hdr *uptr,
+		struct block_device *bdev)
 {
+	struct request_queue *q = disk->queue;
 	unsigned long uaddr, start_time;
 	int reading, writing, nr_sectors;
 	struct sg_io_hdr hdr;
@@ -251,7 +251,7 @@
 	 * (if he doesn't check that is his problem).
 	 * N.B. a non-zero SCSI status is _not_ necessarily an error.
 	 */
-	blk_do_rq(q, bdev, rq);
+	blk_do_rq(disk, rq);
 
 	if (bio)
 		bio_unmap_user(bio, reading);
@@ -299,8 +299,7 @@
 #define READ_DEFECT_DATA_TIMEOUT	(60 * HZ )
 #define OMAX_SB_LEN 16          /* For backward compatibility */
 
-static int sg_scsi_ioctl(request_queue_t *q, struct block_device *bdev,
-			 Scsi_Ioctl_Command *sic)
+static int sg_scsi_ioctl(struct gendisk *disk, struct scsi_ioctl_command *sic)
 {
 	struct request *rq;
 	int err, in_len, out_len, bytes, opcode, cmdlen;
@@ -320,14 +319,14 @@
 
 	bytes = max(in_len, out_len);
 	if (bytes) {
-		buffer = kmalloc(bytes, q->bounce_gfp | GFP_USER);
+		buffer = kmalloc(bytes, disk->queue->bounce_gfp | GFP_USER);
 		if (!buffer)
 			return -ENOMEM;
 
 		memset(buffer, 0, bytes);
 	}
 
-	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
+	rq = blk_get_request(disk->queue, in_len ? WRITE : READ, __GFP_WAIT);
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -372,7 +371,7 @@
 	rq->data_len = bytes;
 	rq->flags |= REQ_BLOCK_PC;
 
-	blk_do_rq(q, bdev, rq);
+	blk_do_rq(disk, rq);
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
@@ -392,77 +391,98 @@
 	return err;
 }
 
-int scsi_cmd_ioctl(struct block_device *bdev, unsigned int cmd, unsigned long arg)
+static int tray_ioctl(struct gendisk *disk, int close)
 {
-	request_queue_t *q;
-	struct request *rq;
-	int close = 0, err;
+	struct request *rq = blk_get_request(disk->queue, WRITE, __GFP_WAIT);
+	int error;
+
+	rq->flags = REQ_BLOCK_PC;
+	rq->data = NULL;
+	rq->data_len = 0;
+	rq->timeout = BLK_DEFAULT_TIMEOUT;
+	memset(rq->cmd, 0, sizeof(rq->cmd));
+	rq->cmd[0] = GPCMD_START_STOP_UNIT;
+	rq->cmd[4] = 0x02 + (close != 0);
+	rq->cmd_len = 6;
+	error = blk_do_rq(disk, rq);
+	blk_put_request(rq);
+
+	return error;
+}
 
-	q = bdev_get_queue(bdev);
-	if (!q)
-		return -ENXIO;
+static int __scsi_cmd_ioctl(struct block_device *bdev,
+		unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct request_queue *q = disk->queue;
 
 	switch (cmd) {
-		/*
-		 * new sgv3 interface
-		 */
-		case SG_GET_VERSION_NUM:
-			return sg_get_version((int *) arg);
-		case SCSI_IOCTL_GET_IDLUN:
-			return scsi_get_idlun(q, (int *) arg);
-		case SCSI_IOCTL_GET_BUS_NUMBER:
-			return scsi_get_bus(q, (int *) arg);
-		case SG_SET_TIMEOUT:
-			return sg_set_timeout(q, (int *) arg);
-		case SG_GET_TIMEOUT:
-			return sg_get_timeout(q);
-		case SG_GET_RESERVED_SIZE:
-			return sg_get_reserved_size(q, (int *) arg);
-		case SG_SET_RESERVED_SIZE:
-			return sg_set_reserved_size(q, (int *) arg);
-		case SG_EMULATED_HOST:
-			return sg_emulated_host(q, (int *) arg);
-		case SG_IO:
-			err = bd_claim(bdev, current);
-			if (err)
-				break;
-			err = sg_io(q, bdev, (struct sg_io_hdr *) arg);
-			bd_release(bdev);
-			break;
-		/*
-		 * old junk scsi send command ioctl
-		 */
-		case SCSI_IOCTL_SEND_COMMAND:
-			if (!arg)
-				return -EINVAL;
-
-			err = bd_claim(bdev, current);
-			if (err)
-				break;
-			err = sg_scsi_ioctl(q, bdev, (Scsi_Ioctl_Command *)arg);
+	/*
+	 * new sgv3 interface
+	 */
+	case SG_GET_VERSION_NUM:
+		return sg_get_version((int *) arg);
+	case SCSI_IOCTL_GET_IDLUN:
+		return scsi_get_idlun((int *) arg);
+	case SCSI_IOCTL_GET_BUS_NUMBER:
+		return scsi_get_bus((int *) arg);
+	case SG_SET_TIMEOUT:
+		return sg_set_timeout(q, (int *) arg);
+	case SG_GET_TIMEOUT:
+		return sg_get_timeout(q);
+	case SG_GET_RESERVED_SIZE:
+		return sg_get_reserved_size(q, (int *) arg);
+	case SG_SET_RESERVED_SIZE:
+		return sg_set_reserved_size(q, (int *) arg);
+	case SG_EMULATED_HOST:
+		return sg_emulated_host((int *) arg);
+	case SG_IO:
+		return sg_io(disk, (struct sg_io_hdr *)arg, bdev);
+	/*
+	 * old junk scsi send command ioctl
+	 */
+	case SCSI_IOCTL_SEND_COMMAND:
+		return sg_scsi_ioctl(disk, (struct scsi_ioctl_command *)arg);
+	/*
+	 * CDROM ioctls.
+	 */
+	case CDROMCLOSETRAY:
+		return tray_ioctl(disk, 1);
+	case CDROMEJECT:
+		return tray_ioctl(disk, 0);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+int scsi_cmd_ioctl(struct block_device *bdev, unsigned int cmd, unsigned long arg)
+{
+	int error;
+
+	switch (cmd) {
+	case SG_IO:
+	case SCSI_IOCTL_SEND_COMMAND:
+		error = bd_claim(bdev, current);
+		if (!error) {
+			error = __scsi_cmd_ioctl(bdev, cmd, arg);
 			bd_release(bdev);
-			break;
-		case CDROMCLOSETRAY:
-			close = 1;
-		case CDROMEJECT:
-			rq = blk_get_request(q, WRITE, __GFP_WAIT);
-			rq->flags = REQ_BLOCK_PC;
-			rq->data = NULL;
-			rq->data_len = 0;
-			rq->timeout = BLK_DEFAULT_TIMEOUT;
-			memset(rq->cmd, 0, sizeof(rq->cmd));
-			rq->cmd[0] = GPCMD_START_STOP_UNIT;
-			rq->cmd[4] = 0x02 + (close != 0);
-			rq->cmd_len = 6;
-			err = blk_do_rq(q, bdev, rq);
-			blk_put_request(rq);
-			break;
-		default:
-			err = -ENOTTY;
+		}
+
+		return error;
 	}
 
-	blk_put_queue(q);
-	return err;
+	return __scsi_cmd_ioctl(bdev, cmd, arg);
+}
+
+int scsi_cmd_ioctl_chrdev(struct gendisk *disk, unsigned int cmd, unsigned long arg)
+{
+	struct block_device fake_bdev;
+
+	memset(&fake_bdev, 0x0e, sizeof(fake_bdev));
+	fake_bdev.bd_disk = disk;
+
+	return __scsi_cmd_ioctl(&fake_bdev, cmd, arg);
 }
 
 EXPORT_SYMBOL(scsi_cmd_ioctl);
