From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] block SG_IO: add SG_FLAG_Q_AT_HEAD flag
Date: Thu, 05 Jun 2014 10:02:22 -0400
Message-ID: <5390786E.8050601@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050603080200000803040306"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:43268 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaFEOCi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2014 10:02:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <james.bottomley@hansenpartnership.com>

This is a multi-part message in MIME format.
--------------050603080200000803040306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

After the SG_IO ioctl was copied into the block layer and
later into the bsg driver, subtle differences emerged.

One difference is the way injected commands are queued through
the block layer (i.e. this is not SCSI device queueing nor SATA
NCQ). Summarizing:
   - SG_IO on block layer device: blk_exec*(at_head=false)
   - sg device SG_IO: at_head=true
   - bsg device SG_IO: at_head=true

Some time ago Boaz Harrosh introduced a sg v4 flag called
BSG_FLAG_Q_AT_TAIL to override the bsg driver default. A
recent patch titled: "sg: add SG_FLAG_Q_AT_TAIL flag"
allowed the sg driver default to be overridden. This patch
allows a SG_IO ioctl sent to a block layer device to have
its default overridden.

ChangeLog:
     - introduce SG_FLAG_Q_AT_HEAD flag in sg.h to cause
       commands that are injected via a block layer
       device SG_IO ioctl to set at_head=true
     - make comments clearer about queueing in sg.h since the
       header is used both by the sg device and block layer
       device implementations of the SG_IO ioctl.
     - introduce BSG_FLAG_Q_AT_HEAD in bsg.h for compatibility
       (it does nothing) and update comments.


Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------050603080200000803040306
Content-Type: text/x-patch;
 name="sg_io_q_at_head.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg_io_q_at_head.patch"

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 2648797..e49b7ef 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -288,6 +288,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	unsigned long start_time;
 	ssize_t ret = 0;
 	int writing = 0;
+	int at_head = 0;
 	struct request *rq;
 	char sense[SCSI_SENSE_BUFFERSIZE];
 	struct bio *bio;
@@ -311,6 +312,8 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		case SG_DXFER_FROM_DEV:
 			break;
 		}
+	if (hdr->flags & SG_FLAG_Q_AT_HEAD)
+		at_head = 1;
 
 	rq = blk_get_request(q, writing ? WRITE : READ, GFP_KERNEL);
 	if (!rq)
@@ -366,7 +369,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	 * (if he doesn't check that is his problem).
 	 * N.B. a non-zero SCSI status is _not_ necessarily an error.
 	 */
-	blk_execute_rq(q, bd_disk, rq, 0);
+	blk_execute_rq(q, bd_disk, rq, at_head);
 
 	hdr->duration = jiffies_to_msecs(jiffies - start_time);
 
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 9859355..750e5db 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -86,7 +86,9 @@ typedef struct sg_io_hdr
 #define SG_FLAG_MMAP_IO 4       /* request memory mapped IO */
 #define SG_FLAG_NO_DXFER 0x10000 /* no transfer of kernel buffers to/from */
 				/* user space (debug indirect IO) */
-#define SG_FLAG_Q_AT_TAIL 0x10  /* default is Q_AT_HEAD */
+/* defaults:: for sg driver: Q_AT_HEAD; for block layer: Q_AT_TAIL */
+#define SG_FLAG_Q_AT_TAIL 0x10
+#define SG_FLAG_Q_AT_HEAD 0x20
 
 /* following 'info' values are "or"-ed together */
 #define SG_INFO_OK_MASK 0x1
diff --git a/include/uapi/linux/bsg.h b/include/uapi/linux/bsg.h
index 7a12e1c..02986cf 100644
--- a/include/uapi/linux/bsg.h
+++ b/include/uapi/linux/bsg.h
@@ -10,12 +10,13 @@
 #define BSG_SUB_PROTOCOL_SCSI_TRANSPORT	2
 
 /*
- * For flags member below
- * sg.h sg_io_hdr also has bits defined for it's flags member. However
- * none of these bits are implemented/used by bsg. The bits below are
- * allocated to not conflict with sg.h ones anyway.
+ * For flag constants below:
+ * sg.h sg_io_hdr also has bits defined for it's flags member. These
+ * two flag values (0x10 and 0x20) have the same meaning in sg.h . For
+ * bsg the BSG_FLAG_Q_AT_HEAD flag is ignored since it is the deafult.
  */
-#define BSG_FLAG_Q_AT_TAIL 0x10 /* default, == 0 at this bit, is Q_AT_HEAD */
+#define BSG_FLAG_Q_AT_TAIL 0x10 /* default is Q_AT_HEAD */
+#define BSG_FLAG_Q_AT_HEAD 0x20
 
 struct sg_io_v4 {
 	__s32 guard;		/* [i] 'Q' to differentiate from v3 */

--------------050603080200000803040306--
