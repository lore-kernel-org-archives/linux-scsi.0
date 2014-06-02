From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 3/6] sg: prevent integer overflow when converting from sectors to bytes
Date: Mon,  2 Jun 2014 22:56:46 +0900
Message-ID: <1401717409-5236-4-git-send-email-akinobu.mita@gmail.com>
References: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43805 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaFBN5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 09:57:12 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so4231132pbb.36
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 06:57:12 -0700 (PDT)
In-Reply-To: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

This prevents integer overflow when converting the request queue's
max_sectors from sectors to bytes.  However, this is a preparation for
extending the data type of max_sectors in struct Scsi_Host and
scsi_host_template.  So, it is impossible to happen this integer
overflow for now, because SCSI low-level drivers can not specify
max_sectors greater than 0xffff due to the data type limitation.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---
This patch is a part of the v1 "scsi: increase upper limit for
max_sectors" patch.

 drivers/scsi/sg.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

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
-- 
1.9.1

