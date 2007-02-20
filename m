From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SG: cap reserved_size values at max_sectors
Date: Tue, 20 Feb 2007 11:01:57 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0702201056040.4992-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46399 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965197AbXBTQB6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Feb 2007 11:01:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, Jens Axboe <jens.axboe@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as857) modifies the SG_GET_RESERVED_SIZE and
SG_SET_RESERVED_SIZE ioctls in the sg driver, capping the values at
the device's request_queue's max_sectors value.  This will permit
cdrecord to obtain a legal value for the maximum transfer length,
fixing Bugzilla #7026.

The patch also caps the initial reserved_size value.  There's no
reason to have a reserved buffer larger than max_sectors, since it
would be impossible to use the extra space.

The corresponding ioctls in the block layer are modified similarly,
and the initial value for the reserved_size is set as large as
possible.  This will effectively make it default to max_sectors.
Note that the actual value is meaningless anyway, since block devices
don't have a reserved buffer.

Finally, the BLKSECTGET ioctl is added to sg, so that there will be a
uniform way for users to determine the actual max_sectors value for
any raw SCSI transport.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/sg.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sg.c
+++ usb-2.6/drivers/scsi/sg.c
@@ -917,6 +917,8 @@ sg_ioctl(struct inode *inode, struct fil
 			return result;
                 if (val < 0)
                         return -EINVAL;
+		val = min_t(int, val,
+				sdp->device->request_queue->max_sectors * 512);
 		if (val != sfp->reserve.bufflen) {
 			if (sg_res_in_use(sfp) || sfp->mmap_called)
 				return -EBUSY;
@@ -925,7 +927,8 @@ sg_ioctl(struct inode *inode, struct fil
 		}
 		return 0;
 	case SG_GET_RESERVED_SIZE:
-		val = (int) sfp->reserve.bufflen;
+		val = min_t(int, sfp->reserve.bufflen,
+				sdp->device->request_queue->max_sectors * 512);
 		return put_user(val, ip);
 	case SG_SET_COMMAND_Q:
 		result = get_user(val, ip);
@@ -1061,6 +1064,9 @@ sg_ioctl(struct inode *inode, struct fil
 		if (sdp->detached)
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, cmd_in, p);
+	case BLKSECTGET:
+		return put_user(sdp->device->request_queue->max_sectors * 512,
+				ip);
 	default:
 		if (read_only)
 			return -EPERM;	/* don't know so take safe approach */
@@ -2339,6 +2345,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 {
 	Sg_fd *sfp;
 	unsigned long iflags;
+	int bufflen;
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
@@ -2369,7 +2376,9 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
 
-	sg_build_reserve(sfp, sg_big_buff);
+	bufflen = min_t(int, sg_big_buff,
+			sdp->device->request_queue->max_sectors * 512);
+	sg_build_reserve(sfp, bufflen);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
 			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));
 	return sfp;
Index: usb-2.6/block/ll_rw_blk.c
===================================================================
--- usb-2.6.orig/block/ll_rw_blk.c
+++ usb-2.6/block/ll_rw_blk.c
@@ -1925,6 +1925,8 @@ blk_init_queue_node(request_fn_proc *rfn
 	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
 	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
 
+	q->sg_reserved_size = INT_MAX;
+
 	/*
 	 * all done
 	 */
Index: usb-2.6/block/scsi_ioctl.c
===================================================================
--- usb-2.6.orig/block/scsi_ioctl.c
+++ usb-2.6/block/scsi_ioctl.c
@@ -78,7 +78,9 @@ static int sg_set_timeout(request_queue_
 
 static int sg_get_reserved_size(request_queue_t *q, int __user *p)
 {
-	return put_user(q->sg_reserved_size, p);
+	unsigned val = min(q->sg_reserved_size, q->max_sectors << 9);
+
+	return put_user(val, p);
 }
 
 static int sg_set_reserved_size(request_queue_t *q, int __user *p)

