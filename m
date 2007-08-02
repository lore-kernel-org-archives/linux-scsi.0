From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] block: add protocol discriminators to requests and queues
Date: Thu, 02 Aug 2007 12:47:25 -0500
Message-ID: <1186076845.3449.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
Cc: Jens Axboe <Jens.Axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

This looks small and innocuous, but it's actually the beginning of
moving the upper layer drivers into block and adding a filtering layer.
The idea is that the queue contains a queue_protocol parameter which
details what the device actually speaks.  The requests are likewise
filled in with a cmd_protocol parameter by the ULDs (or bsg if it's a
user initiated command, using the existing sgv4 protocol fields).

Now we have the capability of adding say native ATA pass through to BSG,
but also we can add things like an ATAPI filter:  sr creates SCSI
requests, but these could be sent through a PACKET_COMMAND wrapper and
emerge as BLK_PROTOCOL_ATAPI before being sent to the device.  Likewise,
sd requests going to BLK_PROTOCOL_ATA devices would have to go through
SATL filters.  

The next steps are to make the block prep layer capable of binding to
drivers (and moving the SCSI ULDs up) followed by making the prep layer
filter capable.

James

Index: BUILD-2.6/block/bsg.c
===================================================================
--- BUILD-2.6.orig/block/bsg.c	2007-08-02 10:22:24.000000000 -0500
+++ BUILD-2.6/block/bsg.c	2007-08-02 10:22:47.000000000 -0500
@@ -192,6 +192,25 @@ static int blk_fill_sgv4_hdr_rq(struct r
 	 */
 	rq->cmd_len = hdr->request_len;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	switch (hdr->protocol) {
+	case BSG_PROTOCOL_SCSI:
+		switch (hdr->subprotocol) {
+		case BSG_SUB_PROTOCOL_SCSI_CMD:
+			rq->cmd_protocol = BLK_PROTOCOL_SCSI;
+			break;
+		case BSG_SUB_PROTOCOL_SCSI_TRANSPORT:
+			/* whatever format the transport defines */
+			rq->cmd_protocol = BLK_PROTOCOL_NATIVE;
+			break;
+		default:
+			rq->cmd_protocol = BLK_PROTOCOL_NATIVE;
+			break;
+		}
+		break;
+	default:
+		rq->cmd_protocol = BLK_PROTOCOL_NATIVE;
+		break;
+	}
 
 	rq->timeout = (hdr->timeout * HZ) / 1000;
 	if (!rq->timeout)
Index: BUILD-2.6/block/ll_rw_blk.c
===================================================================
--- BUILD-2.6.orig/block/ll_rw_blk.c	2007-08-02 10:22:24.000000000 -0500
+++ BUILD-2.6/block/ll_rw_blk.c	2007-08-02 12:45:23.000000000 -0500
@@ -231,6 +231,7 @@ void blk_queue_make_request(struct reque
 	 * by default assume old behaviour and bounce for any highmem page
 	 */
 	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);
+	blk_queue_protocol(q, BLK_PROTOCOL_NATIVE);
 }
 
 EXPORT_SYMBOL(blk_queue_make_request);
@@ -788,6 +789,21 @@ void blk_queue_dma_alignment(struct requ
 EXPORT_SYMBOL(blk_queue_dma_alignment);
 
 /**
+ * blk_queue_protocol - set the native protocol for the device
+ * @q:		The request queue for the device
+ * @proto:	The protocol
+ *
+ * description:
+ *	This is used to set the underlying device protocol.  It is used
+ *	by the prepare functions to decide how to package commands.
+ */
+void blk_queue_protocol(struct request_queue *q, enum blk_protocol proto)
+{
+	q->queue_protocol = proto;
+}
+EXPORT_SYMBOL(blk_queue_protocol);
+
+/**
  * blk_queue_find_tag - find a request by its tag and queue
  * @q:	 The request queue for the device
  * @tag: The tag of the request
Index: BUILD-2.6/block/scsi_ioctl.c
===================================================================
--- BUILD-2.6.orig/block/scsi_ioctl.c	2007-08-02 10:22:24.000000000 -0500
+++ BUILD-2.6/block/scsi_ioctl.c	2007-08-02 10:22:47.000000000 -0500
@@ -229,6 +229,7 @@ static int blk_fill_sghdr_rq(struct requ
 	 */
 	rq->cmd_len = hdr->cmd_len;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_protocol = BLK_PROTOCOL_SCSI;
 
 	rq->timeout = (hdr->timeout * HZ) / 1000;
 	if (!rq->timeout)
@@ -494,6 +495,7 @@ int sg_scsi_ioctl(struct file *file, str
 	rq->sense = sense;
 	rq->sense_len = 0;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_protocol = BLK_PROTOCOL_SCSI;
 
 	blk_execute_rq(q, disk, rq, 0);
 
@@ -527,6 +529,7 @@ static int __blk_send_generic(struct req
 
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_protocol = BLK_PROTOCOL_SCSI;
 	rq->data = NULL;
 	rq->data_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
Index: BUILD-2.6/include/linux/blkdev.h
===================================================================
--- BUILD-2.6.orig/include/linux/blkdev.h	2007-08-02 10:22:24.000000000 -0500
+++ BUILD-2.6/include/linux/blkdev.h	2007-08-02 10:22:47.000000000 -0500
@@ -164,6 +164,21 @@ enum rq_cmd_type_bits {
 };
 
 /*
+ * Add protocol types.  The idea here is to flag what the
+ * queue speaks natively, but allow other protocols to be sent
+ * (i.e. allow us to identify the need to find translators)
+ *
+ * Any device using REQ_BLOCK_PC with its own defined format should
+ * set BLK_PROTOCOL_NATIVE
+ */
+enum blk_protocol {
+	BLK_PROTOCOL_NATIVE, /* device defined REQ_BLOCK_PC */
+	BLK_PROTOCOL_ATA,
+	BLK_PROTOCOL_ATAPI,
+	BLK_PROTOCOL_SCSI,
+};
+
+/*
  * For request of type REQ_TYPE_LINUX_BLOCK, rq->cmd[0] is the opcode being
  * sent down (similar to how REQ_TYPE_BLOCK_PC means that ->cmd[] holds a
  * SCSI cdb.
@@ -237,6 +252,7 @@ struct request {
 
 	unsigned int cmd_flags;
 	enum rq_cmd_type_bits cmd_type;
+	enum blk_protocol cmd_protocol;
 
 	/* Maintain bio traversal state for part by part I/O submission.
 	 * hard_* are block layer internals, no driver should touch them!
@@ -454,6 +470,7 @@ struct request_queue
 
 	unsigned int		nr_sorted;
 	unsigned int		in_flight;
+	enum blk_protocol	queue_protocol;
 
 	/*
 	 * sg stuff
@@ -766,6 +783,7 @@ extern void blk_queue_segment_boundary(s
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
+extern void blk_queue_protocol(struct request_queue *, enum blk_protocol);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 extern int blk_queue_ordered(struct request_queue *, unsigned, prepare_flush_fn *);



