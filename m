From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/5] sg: convert the non-data path to use the block layer
Date: Tue, 26 Aug 2008 11:10:52 +0900
Message-ID: <1219716654-27827-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1219716654-27827-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219716654-27827-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219716654-27827-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46416 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbYHZCNK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 22:13:10 -0400
In-Reply-To: <1219716654-27827-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

This patch converts the non data path to use the block layer functions
(blk_get_request, blk_execute_rq_nowait, etc) instead of uses
scsi_execute_async().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/sg.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 661f9f2..d1b3de9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -137,6 +137,7 @@ typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
 	volatile char done;	/* 0->before bh, 1->before read, 2->read */
+	struct request *rq;
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
@@ -176,7 +177,7 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 static int sg_fasync(int fd, struct file *filp, int mode);
 /* tasklet or soft irq callback */
 static void sg_cmd_done(void *data, char *sense, int result, int resid);
-static int sg_start_req(Sg_request * srp);
+static int sg_start_req(Sg_request * srp, unsigned char *cmd);
 static void sg_finish_rem_req(Sg_request * srp);
 static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
 static int sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp,
@@ -229,6 +230,11 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 				  cmd, filp->f_mode & FMODE_WRITE);
 }
 
+static void sg_rq_end_io(struct request *rq, int uptodate)
+{
+	sg_cmd_done(rq->end_io_data, rq->sense, rq->errors, rq->data_len);
+}
+
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -732,7 +738,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	SCSI_LOG_TIMEOUT(4, printk("sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			  (int) cmnd[0], (int) hp->cmd_len));
 
-	if ((k = sg_start_req(srp))) {
+	if ((k = sg_start_req(srp, cmnd))) {
 		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: start_req err=%d\n", k));
 		sg_finish_rem_req(srp);
 		return k;	/* probably out of space --> ENOMEM */
@@ -765,6 +771,12 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	hp->duration = jiffies_to_msecs(jiffies);
 /* Now send everything of to mid-level. The next time we hear about this
    packet is when sg_cmd_done() is called (i.e. a callback). */
+	if (srp->rq) {
+		srp->rq->timeout = timeout;
+		blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
+				      srp->rq, 1, sg_rq_end_io);
+		return 0;
+	}
 	if (scsi_execute_async(sdp->device, cmnd, hp->cmd_len, data_dir, srp->data.buffer,
 				hp->dxfer_len, srp->data.k_use_sg, timeout,
 				SG_DEFAULT_RETRIES, srp, sg_cmd_done,
@@ -1634,8 +1646,33 @@ exit_sg(void)
 	idr_destroy(&sg_index_idr);
 }
 
+static int __sg_start_req(struct sg_request *srp, struct sg_io_hdr *hp,
+			  unsigned char *cmd)
+{
+	struct sg_fd *sfp = srp->parentfp;
+	struct request_queue *q = sfp->parentdp->device->request_queue;
+	struct request *rq;
+	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
+
+	rq = blk_get_request(q, rw, GFP_ATOMIC);
+	if (!rq)
+		return -ENOMEM;
+
+	memcpy(rq->cmd, cmd, hp->cmd_len);
+
+	rq->cmd_len = hp->cmd_len;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+
+	srp->rq = rq;
+	rq->end_io_data = srp;
+	rq->sense = srp->sense_b;
+	rq->retries = SG_DEFAULT_RETRIES;
+
+	return 0;
+}
+
 static int
-sg_start_req(Sg_request * srp)
+sg_start_req(Sg_request * srp, unsigned char *cmd)
 {
 	int res;
 	Sg_fd *sfp = srp->parentfp;
@@ -1646,8 +1683,10 @@ sg_start_req(Sg_request * srp)
 	Sg_scatter_hold *rsv_schp = &sfp->reserve;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_start_req: dxfer_len=%d\n", dxfer_len));
+
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
-		return 0;
+		return __sg_start_req(srp, hp, cmd);
+
 	if (sg_allow_dio && (hp->flags & SG_FLAG_DIRECT_IO) &&
 	    (dxfer_dir != SG_DXFER_UNKNOWN) && (0 == hp->iovec_count) &&
 	    (!sfp->parentdp->device->host->unchecked_isa_dma)) {
@@ -1678,6 +1717,10 @@ sg_finish_rem_req(Sg_request * srp)
 		sg_unlink_reserve(sfp, srp);
 	else
 		sg_remove_scat(req_schp);
+
+	if (srp->rq)
+		blk_put_request(srp->rq);
+
 	sg_remove_request(sfp, srp);
 }
 
-- 
1.5.5.GIT

