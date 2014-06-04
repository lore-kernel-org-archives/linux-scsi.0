From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] sg: add SG_FLAG_Q_AT_TAIL flag
Date: Tue, 03 Jun 2014 21:36:56 -0400
Message-ID: <538E7838.5000809@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090108070603030102010905"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:60850 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaFDBhF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2014 21:37:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <JBottomley@parallels.com>
Cc: openosd@gmail.com

This is a multi-part message in MIME format.
--------------090108070603030102010905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

When the SG_IO ioctl was copied into the block layer and
later into the bsg driver, subtle differences emerged.

One difference is the way injected commands are queued through
the block layer (i.e. this is not SCSI device queueing nor SATA
NCQ). Summarizing:
   - SG_IO in the block layer: blk_exec*(at_head=false)
   - sg SG_IO: at_head=true
   - bsg SG_IO: at_head=true

Some time ago Boaz Harrosh introduced a sg v4 flag called
BSG_FLAG_Q_AT_TAIL to override the bsg driver default.
This patch does the equivalent for the sg driver.

ChangeLog:
	Introduce SG_FLAG_Q_AT_TAIL flag to cause commands
	to be injected into the block layer with
	at_head=false.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------090108070603030102010905
Content-Type: text/x-patch;
 name="sg_q_at_tail.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg_q_at_tail.patch"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 177f755..1b7d4f6 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -740,7 +740,7 @@ static int
 sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		unsigned char *cmnd, int timeout, int blocking)
 {
-	int k, data_dir;
+	int k, data_dir, at_head;
 	Sg_device *sdp = sfp->parentdp;
 	sg_io_hdr_t *hp = &srp->header;
 
@@ -784,11 +784,12 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		break;
 	}
 	hp->duration = jiffies_to_msecs(jiffies);
+	at_head = !(hp->interface_id && (SG_FLAG_Q_AT_TAIL & hp->flags));
 
 	srp->rq->timeout = timeout;
 	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
 	blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
-			      srp->rq, 1, sg_rq_end_io);
+			      srp->rq, at_head, sg_rq_end_io);
 	return 0;
 }
 
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index d8c0c43..9859355 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -86,6 +86,7 @@ typedef struct sg_io_hdr
 #define SG_FLAG_MMAP_IO 4       /* request memory mapped IO */
 #define SG_FLAG_NO_DXFER 0x10000 /* no transfer of kernel buffers to/from */
 				/* user space (debug indirect IO) */
+#define SG_FLAG_Q_AT_TAIL 0x10  /* default is Q_AT_HEAD */
 
 /* following 'info' values are "or"-ed together */
 #define SG_INFO_OK_MASK 0x1

--------------090108070603030102010905--
