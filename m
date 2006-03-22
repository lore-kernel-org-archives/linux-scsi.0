From: Christoph Hellwig <hch@lst.de>
Subject: unify SCSI_IOCTL_SEND_COMMAND implementations
Date: Wed, 22 Mar 2006 17:52:04 +0100
Message-ID: <20060322165204.GA32287@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:51376 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751224AbWCVQwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 11:52:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, axboe@suse.de
Cc: linux-scsi@vger.kernel.org

We currently have two implementations of this obsolete ioctl, one in
the block layer and one in the scsi code.  Both of them have drawbacks.

This patch kills the scsi layer version after updating the block version
with the missing bits:

 - argument checking
 - use scatterlist I/O
 - set number of retries based on the submitted command

This is the last user of non-S/G I/O except for the gdth driver, so
getting this in ASAP and through the scsi tree would be nie to kill
the non-S/G I/O path.  Jens, what do you think about adding a check
for non-S/G I/O in the midlayer?

Thanks to  Or Gerlitz for testing this patch.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/scsi_ioctl.c
===================================================================
--- linux-2.6.orig/block/scsi_ioctl.c	2006-02-13 21:44:00.000000000 +0100
+++ linux-2.6/block/scsi_ioctl.c	2006-03-08 15:13:47.000000000 +0100
@@ -350,16 +350,51 @@
 	return ret;
 }
 
+/**
+ * sg_scsi_ioctl  --  handle deprecated SCSI_IOCTL_SEND_COMMAND ioctl
+ * @file:	file this ioctl operates on (optional)
+ * @q:		request queue to send scsi commands down
+ * @disk:	gendisk to operate on (option)
+ * @sic:	userspace structure describing the command to perform
+ *
+ * Send down the scsi command described by @sic to the device below
+ * the request queue @q.  If @file is non-NULL it's used to perform
+ * fine-grained permission checks that allow users to send down
+ * non-destructive SCSI commands.  If the caller has a struct gendisk
+ * available it should be passed in as @disk to allow the low level
+ * driver to use the information contained in it.  A non-NULL @disk
+ * is only allowed if the caller knows that the low level driver doesn't
+ * need it (e.g. in the scsi subsystem).
+ *
+ * Notes:
+ *   -  This interface is deprecated - users should use the SG_IO
+ *      interface instead, as this is a more flexible approach to
+ *      performing SCSI commands on a device.
+ *   -  The SCSI command length is determined by examining the 1st byte
+ *      of the given command. There is no way to override this.
+ *   -  Data transfers are limited to PAGE_SIZE
+ *   -  The length (x + y) must be at least OMAX_SB_LEN bytes long to
+ *      accommodate the sense buffer when an error occurs.
+ *      The sense buffer is truncated to OMAX_SB_LEN (16) bytes so that
+ *      old code will not be surprised.
+ *   -  If a Unix error occurs (e.g. ENOMEM) then the user will receive
+ *      a negative return and the Unix error code in 'errno'.
+ *      If the SCSI command succeeds then 0 is returned.
+ *      Positive numbers returned are the compacted SCSI error codes (4
+ *      bytes in one int) where the lowest byte is the SCSI status.
+ */
 #define OMAX_SB_LEN 16          /* For backward compatibility */
-
-static int sg_scsi_ioctl(struct file *file, request_queue_t *q,
-			 struct gendisk *bd_disk, Scsi_Ioctl_Command __user *sic)
+int sg_scsi_ioctl(struct file *file, struct request_queue *q,
+		  struct gendisk *disk, struct scsi_ioctl_command __user *sic)
 {
 	struct request *rq;
 	int err;
 	unsigned int in_len, out_len, bytes, opcode, cmdlen;
 	char *buffer = NULL, sense[SCSI_SENSE_BUFFERSIZE];
 
+	if (!sic)
+		return -EINVAL;
+
 	/*
 	 * get in an out lengths, verify they don't exceed a page worth of data
 	 */
@@ -393,45 +428,53 @@
 	if (copy_from_user(rq->cmd, sic->data, cmdlen))
 		goto error;
 
-	if (copy_from_user(buffer, sic->data + cmdlen, in_len))
+	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
 	err = verify_command(file, rq->cmd);
 	if (err)
 		goto error;
 
+	/* default.  possible overriden later */
+	rq->retries = 5;
+
 	switch (opcode) {
-		case SEND_DIAGNOSTIC:
-		case FORMAT_UNIT:
-			rq->timeout = FORMAT_UNIT_TIMEOUT;
-			break;
-		case START_STOP:
-			rq->timeout = START_STOP_TIMEOUT;
-			break;
-		case MOVE_MEDIUM:
-			rq->timeout = MOVE_MEDIUM_TIMEOUT;
-			break;
-		case READ_ELEMENT_STATUS:
-			rq->timeout = READ_ELEMENT_STATUS_TIMEOUT;
-			break;
-		case READ_DEFECT_DATA:
-			rq->timeout = READ_DEFECT_DATA_TIMEOUT;
-			break;
-		default:
-			rq->timeout = BLK_DEFAULT_TIMEOUT;
-			break;
+	case SEND_DIAGNOSTIC:
+	case FORMAT_UNIT:
+		rq->timeout = FORMAT_UNIT_TIMEOUT;
+		rq->retries = 1;
+		break;
+	case START_STOP:
+		rq->timeout = START_STOP_TIMEOUT;
+		break;
+	case MOVE_MEDIUM:
+		rq->timeout = MOVE_MEDIUM_TIMEOUT;
+		break;
+	case READ_ELEMENT_STATUS:
+		rq->timeout = READ_ELEMENT_STATUS_TIMEOUT;
+		break;
+	case READ_DEFECT_DATA:
+		rq->timeout = READ_DEFECT_DATA_TIMEOUT;
+		rq->retries = 1;
+		break;
+	default:
+		rq->timeout = BLK_DEFAULT_TIMEOUT;
+		break;
+	}
+
+	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
+		err = DRIVER_ERROR << 24;
+		goto out;
 	}
 
 	memset(sense, 0, sizeof(sense));
 	rq->sense = sense;
 	rq->sense_len = 0;
-
-	rq->data = buffer;
-	rq->data_len = bytes;
 	rq->flags |= REQ_BLOCK_PC;
-	rq->retries = 0;
 
-	blk_execute_rq(q, bd_disk, rq, 0);
+	blk_execute_rq(q, disk, rq, 0);
+
+out:
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
@@ -450,7 +493,7 @@
 	blk_put_request(rq);
 	return err;
 }
-
+EXPORT_SYMBOL_GPL(sg_scsi_ioctl);
 
 /* Send basic block requests */
 static int __blk_send_generic(request_queue_t *q, struct gendisk *bd_disk, int cmd, int data)
Index: linux-2.6/drivers/scsi/scsi_ioctl.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_ioctl.c	2005-11-06 20:09:10.000000000 +0100
+++ linux-2.6/drivers/scsi/scsi_ioctl.c	2006-03-08 15:58:13.000000000 +0100
@@ -158,181 +158,6 @@
 EXPORT_SYMBOL(scsi_set_medium_removal);
 
 /*
- * This interface is deprecated - users should use the scsi generic (sg)
- * interface instead, as this is a more flexible approach to performing
- * generic SCSI commands on a device.
- *
- * The structure that we are passed should look like:
- *
- * struct sdata {
- *  unsigned int inlen;      [i] Length of data to be written to device 
- *  unsigned int outlen;     [i] Length of data to be read from device 
- *  unsigned char cmd[x];    [i] SCSI command (6 <= x <= 12).
- *                           [o] Data read from device starts here.
- *                           [o] On error, sense buffer starts here.
- *  unsigned char wdata[y];  [i] Data written to device starts here.
- * };
- * Notes:
- *   -  The SCSI command length is determined by examining the 1st byte
- *      of the given command. There is no way to override this.
- *   -  Data transfers are limited to PAGE_SIZE (4K on i386, 8K on alpha).
- *   -  The length (x + y) must be at least OMAX_SB_LEN bytes long to
- *      accommodate the sense buffer when an error occurs.
- *      The sense buffer is truncated to OMAX_SB_LEN (16) bytes so that
- *      old code will not be surprised.
- *   -  If a Unix error occurs (e.g. ENOMEM) then the user will receive
- *      a negative return and the Unix error code in 'errno'. 
- *      If the SCSI command succeeds then 0 is returned.
- *      Positive numbers returned are the compacted SCSI error codes (4 
- *      bytes in one int) where the lowest byte is the SCSI status.
- *      See the drivers/scsi/scsi.h file for more information on this.
- *
- */
-#define OMAX_SB_LEN 16		/* Old sense buffer length */
-
-int scsi_ioctl_send_command(struct scsi_device *sdev,
-			    struct scsi_ioctl_command __user *sic)
-{
-	char *buf;
-	unsigned char cmd[MAX_COMMAND_SIZE];
-	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
-	char __user *cmd_in;
-	unsigned char opcode;
-	unsigned int inlen, outlen, cmdlen;
-	unsigned int needed, buf_needed;
-	int timeout, retries, result;
-	int data_direction;
-	gfp_t gfp_mask = GFP_KERNEL;
-
-	if (!sic)
-		return -EINVAL;
-
-	if (sdev->host->unchecked_isa_dma)
-		gfp_mask |= GFP_DMA;
-
-	/*
-	 * Verify that we can read at least this much.
-	 */
-	if (!access_ok(VERIFY_READ, sic, sizeof(Scsi_Ioctl_Command)))
-		return -EFAULT;
-
-	if(__get_user(inlen, &sic->inlen))
-		return -EFAULT;
-		
-	if(__get_user(outlen, &sic->outlen))
-		return -EFAULT;
-
-	/*
-	 * We do not transfer more than MAX_BUF with this interface.
-	 * If the user needs to transfer more data than this, they
-	 * should use scsi_generics (sg) instead.
-	 */
-	if (inlen > MAX_BUF)
-		return -EINVAL;
-	if (outlen > MAX_BUF)
-		return -EINVAL;
-
-	cmd_in = sic->data;
-	if(get_user(opcode, cmd_in))
-		return -EFAULT;
-
-	needed = buf_needed = (inlen > outlen ? inlen : outlen);
-	if (buf_needed) {
-		buf_needed = (buf_needed + 511) & ~511;
-		if (buf_needed > MAX_BUF)
-			buf_needed = MAX_BUF;
-		buf = kmalloc(buf_needed, gfp_mask);
-		if (!buf)
-			return -ENOMEM;
-		memset(buf, 0, buf_needed);
-		if (inlen == 0) {
-			data_direction = DMA_FROM_DEVICE;
-		} else if (outlen == 0 ) {
-			data_direction = DMA_TO_DEVICE;
-		} else {
-			/*
-			 * Can this ever happen?
-			 */
-			data_direction = DMA_BIDIRECTIONAL;
-		}
-
-	} else {
-		buf = NULL;
-		data_direction = DMA_NONE;
-	}
-
-	/*
-	 * Obtain the command from the user's address space.
-	 */
-	cmdlen = COMMAND_SIZE(opcode);
-	
-	result = -EFAULT;
-
-	if (!access_ok(VERIFY_READ, cmd_in, cmdlen + inlen))
-		goto error;
-
-	if(__copy_from_user(cmd, cmd_in, cmdlen))
-		goto error;
-
-	/*
-	 * Obtain the data to be sent to the device (if any).
-	 */
-
-	if(inlen && copy_from_user(buf, cmd_in + cmdlen, inlen))
-		goto error;
-
-	switch (opcode) {
-	case SEND_DIAGNOSTIC:
-	case FORMAT_UNIT:
-		timeout = FORMAT_UNIT_TIMEOUT;
-		retries = 1;
-		break;
-	case START_STOP:
-		timeout = START_STOP_TIMEOUT;
-		retries = NORMAL_RETRIES;
-		break;
-	case MOVE_MEDIUM:
-		timeout = MOVE_MEDIUM_TIMEOUT;
-		retries = NORMAL_RETRIES;
-		break;
-	case READ_ELEMENT_STATUS:
-		timeout = READ_ELEMENT_STATUS_TIMEOUT;
-		retries = NORMAL_RETRIES;
-		break;
-	case READ_DEFECT_DATA:
-		timeout = READ_DEFECT_DATA_TIMEOUT;
-		retries = 1;
-		break;
-	default:
-		timeout = IOCTL_NORMAL_TIMEOUT;
-		retries = NORMAL_RETRIES;
-		break;
-	}
-
-	result = scsi_execute(sdev, cmd, data_direction, buf, needed,
-			      sense, timeout, retries, 0);
-
-	/* 
-	 * If there was an error condition, pass the info back to the user. 
-	 */
-	if (result) {
-		int sb_len = sizeof(*sense);
-
-		sb_len = (sb_len > OMAX_SB_LEN) ? OMAX_SB_LEN : sb_len;
-		if (copy_to_user(cmd_in, sense, sb_len))
-			result = -EFAULT;
-	} else {
-		if (outlen && copy_to_user(cmd_in, buf, outlen))
-			result = -EFAULT;
-	}	
-
-error:
-	kfree(buf);
-	return result;
-}
-EXPORT_SYMBOL(scsi_ioctl_send_command);
-
-/*
  * The scsi_ioctl_get_pci() function places into arg the value
  * pci_dev::slot_name (8 characters) for the PCI device (if any).
  * Returns: 0 on success
@@ -410,7 +235,7 @@
 	case SCSI_IOCTL_SEND_COMMAND:
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 			return -EACCES;
-		return scsi_ioctl_send_command(sdev, arg);
+		return sg_scsi_ioctl(NULL, sdev->request_queue, NULL, arg);
 	case SCSI_IOCTL_DOORLOCK:
 		return scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 	case SCSI_IOCTL_DOORUNLOCK:
Index: linux-2.6/drivers/scsi/sg.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sg.c	2006-03-06 23:29:57.000000000 +0100
+++ linux-2.6/drivers/scsi/sg.c	2006-03-08 14:59:23.000000000 +0100
@@ -1045,7 +1045,7 @@
 			if (!sg_allow_access(opcode, sdp->device->type))
 				return -EPERM;
 		}
-		return scsi_ioctl_send_command(sdp->device, p);
+		return sg_scsi_ioctl(filp, sdp->device->request_queue, NULL, p);
 	case SG_SET_DEBUG:
 		result = get_user(val, ip);
 		if (result)
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2006-02-13 21:44:02.000000000 +0100
+++ linux-2.6/include/linux/blkdev.h	2006-03-08 15:13:30.000000000 +0100
@@ -17,6 +17,8 @@
 
 #include <asm/scatterlist.h>
 
+struct scsi_ioctl_command;
+
 struct request_queue;
 typedef struct request_queue request_queue_t;
 struct elevator_queue;
@@ -602,6 +604,8 @@
 extern int blk_remove_plug(request_queue_t *);
 extern void blk_recount_segments(request_queue_t *, struct bio *);
 extern int scsi_cmd_ioctl(struct file *, struct gendisk *, unsigned int, void __user *);
+extern int sg_scsi_ioctl(struct file *, struct request_queue *,
+		struct gendisk *, struct scsi_ioctl_command __user *);
 extern void blk_start_queue(request_queue_t *q);
 extern void blk_stop_queue(request_queue_t *q);
 extern void blk_sync_queue(struct request_queue *q);
Index: linux-2.6/include/scsi/scsi_ioctl.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_ioctl.h	2005-10-31 12:24:16.000000000 +0100
+++ linux-2.6/include/scsi/scsi_ioctl.h	2006-03-08 15:12:13.000000000 +0100
@@ -41,8 +41,6 @@
 } Scsi_FCTargAddress;
 
 extern int scsi_ioctl(struct scsi_device *, int, void __user *);
-extern int scsi_ioctl_send_command(struct scsi_device *,
-				   struct scsi_ioctl_command __user *);
 extern int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 				   void __user *arg, struct file *filp);
 
