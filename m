From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/4] scsi: increase upper limit for max_sectors
Date: Sun, 25 May 2014 21:43:35 +0900
Message-ID: <1401021816-10423-4-git-send-email-akinobu.mita@gmail.com>
References: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45763 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaEYMoI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 May 2014 08:44:08 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so6302018pbb.5
        for <linux-scsi@vger.kernel.org>; Sun, 25 May 2014 05:44:07 -0700 (PDT)
In-Reply-To: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

max_sectors in struct Scsi_Host specifies maximum number of sectors
allowed in a single SCSI command.  The data type of max_sectors is
unsigned short, so the maximum transfer length per SCSI command is
limited to less than 256MB in 4096-bytes sector size. (0xffff * 4096)

This commit increases the SCSI mid level's limitation for max_sectors
upto the block layer's limitation for max_hw_sectors by extending the
data type of max_sectors in struct Scsi_Host and scsi_host_template,
so that SCSI lower level drivers can specify more than 0xffff.

This change requires the scsi disk (sd) driver to handle the requests
whose transfer length is more than 0xffff with READ_16 or WRITE_16.
Also, this needs to prevent SG_GET_RESERVED_SIZE and SG_SET_RESERVED_SIZE
ioctls for the scsi generic (sg) driver from integer overflow when
converting max_sectors to bytes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/sd.c        |  5 +----
 drivers/scsi/sg.c        | 17 +++++++++++++----
 include/scsi/scsi_host.h |  4 ++--
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index efcbcd1..4508115 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1056,7 +1056,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
 		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
 		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
-	} else if (sdp->use_16_for_rw) {
+	} else if ((this_count > 0xffff) || sdp->use_16_for_rw) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
 		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
 		SCpnt->cmnd[2] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
@@ -1075,9 +1075,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	} else if ((this_count > 0xff) || (block > 0x1fffff) ||
 		   scsi_device_protection(SCpnt->device) ||
 		   SCpnt->device->use_10_for_rw) {
-		if (this_count > 0xffff)
-			this_count = 0xffff;
-
 		SCpnt->cmnd[0] += READ_10 - READ_6;
 		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
 		SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index df5e961..e3404d2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -806,6 +806,15 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
 	return ret;
 }
 
+static int max_sectors_bytes(struct request_queue *q)
+{
+	unsigned int max_sectors = queue_max_sectors(q);
+
+	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
+
+	return max_sectors << 9;
+}
+
 static long
 sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -945,7 +954,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
                 if (val < 0)
                         return -EINVAL;
 		val = min_t(int, val,
-			    queue_max_sectors(sdp->device->request_queue) * 512);
+			    max_sectors_bytes(sdp->device->request_queue));
 		if (val != sfp->reserve.bufflen) {
 			if (sg_res_in_use(sfp) || sfp->mmap_called)
 				return -EBUSY;
@@ -955,7 +964,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		return 0;
 	case SG_GET_RESERVED_SIZE:
 		val = min_t(int, sfp->reserve.bufflen,
-			    queue_max_sectors(sdp->device->request_queue) * 512);
+			    max_sectors_bytes(sdp->device->request_queue));
 		return put_user(val, ip);
 	case SG_SET_COMMAND_Q:
 		result = get_user(val, ip);
@@ -1095,7 +1104,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, cmd_in, p);
 	case BLKSECTGET:
-		return put_user(queue_max_sectors(sdp->device->request_queue) * 512,
+		return put_user(max_sectors_bytes(sdp->device->request_queue),
 				ip);
 	case BLKTRACESETUP:
 		return blk_trace_setup(sdp->device->request_queue,
@@ -2086,7 +2095,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 		sg_big_buff = def_reserved_size;
 
 	bufflen = min_t(int, sg_big_buff,
-			queue_max_sectors(sdp->device->request_queue) * 512);
+			max_sectors_bytes(sdp->device->request_queue));
 	sg_build_reserve(sfp, bufflen);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
 			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 94844fc..db7d8bd 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -408,7 +408,7 @@ struct scsi_host_template {
 	/*
 	 * Set this if the host adapter has limitations beside segment count.
 	 */
-	unsigned short max_sectors;
+	unsigned int max_sectors;
 
 	/*
 	 * DMA scatter gather segment boundary limit. A segment crossing this
@@ -652,7 +652,7 @@ struct Scsi_Host {
 	short cmd_per_lun;
 	short unsigned int sg_tablesize;
 	short unsigned int sg_prot_tablesize;
-	short unsigned int max_sectors;
+	unsigned int max_sectors;
 	unsigned long dma_boundary;
 	/* 
 	 * Used to assign serial numbers to the cmds.
-- 
1.9.1

