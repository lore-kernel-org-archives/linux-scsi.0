From: michaelc@cs.wisc.edu
Subject: [PATCH 1/7] rm bio hacks in scsi tgt
Date: Sun, 04 Mar 2007 12:31:18 -0600
Message-ID: <11730330852430-git-send-email-michaelc@cs.wisc.edu>
References: <1173033084706-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbXCDSbg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Mar 2007 13:31:36 -0500
In-Reply-To: <1173033084706-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

scsi tgt breaks up a command into multple scatterlists
if we cannot fit all the data in one. This was because
the block rq helpers did not support large requests and
because we can get a command of any old size so it is
hard to preallocate pages for scatterlist large enough
(we cannot really preallocate pages with the bio map
user path). In 2.6.20, we added large request support to
the block layer helper, blk_rq_map_user. And at LSF,
we talked about increasing SCSI_MAX_PHYS_SEGMENTS for
scsi tgt if we want to support really really :) large
(greater than 256 * PAGE_SIZE in the worst mapping case)
requests.

The only target currently implemented does not even support
the multiple scatterlists stuff and only supports smaller
requests, so this patch just coverts scsi tgt to use
blk_rq_map_user.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_tgt_lib.c |  133 +++++++++++--------------------------------
 include/scsi/scsi_cmnd.h    |    3 -
 2 files changed, 34 insertions(+), 102 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index d402aff..47c29a9 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -28,7 +28,6 @@ #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tgt.h>
-#include <../drivers/md/dm-bio-list.h>
 
 #include "scsi_tgt_priv.h"
 
@@ -42,9 +41,8 @@ static struct kmem_cache *scsi_tgt_cmd_c
 struct scsi_tgt_cmd {
 	/* TODO replace work with James b's code */
 	struct work_struct work;
-	/* TODO replace the lists with a large bio */
-	struct bio_list xfer_done_list;
-	struct bio_list xfer_list;
+	/* TODO fix limits of some drivers */
+	struct bio *bio;
 
 	struct list_head hash_list;
 	struct request *rq;
@@ -93,7 +91,12 @@ struct scsi_cmnd *scsi_host_get_command(
 	if (!tcmd)
 		goto put_dev;
 
-	rq = blk_get_request(shost->uspace_req_q, write, gfp_mask);
+	/*
+	 * The blk helpers are used to the READ/WRITE requests
+	 * transfering data from a initiator point of view. Since
+	 * we are in target mode we want the opposite.
+	 */
+	rq = blk_get_request(shost->uspace_req_q, !write, gfp_mask);
 	if (!rq)
 		goto free_tcmd;
 
@@ -111,8 +114,6 @@ struct scsi_cmnd *scsi_host_get_command(
 	rq->cmd_flags |= REQ_TYPE_BLOCK_PC;
 	rq->end_io_data = tcmd;
 
-	bio_list_init(&tcmd->xfer_list);
-	bio_list_init(&tcmd->xfer_done_list);
 	tcmd->rq = rq;
 
 	return cmd;
@@ -157,22 +158,6 @@ void scsi_host_put_command(struct Scsi_H
 }
 EXPORT_SYMBOL_GPL(scsi_host_put_command);
 
-static void scsi_unmap_user_pages(struct scsi_tgt_cmd *tcmd)
-{
-	struct bio *bio;
-
-	/* must call bio_endio in case bio was bounced */
-	while ((bio = bio_list_pop(&tcmd->xfer_done_list))) {
-		bio_endio(bio, bio->bi_size, 0);
-		bio_unmap_user(bio);
-	}
-
-	while ((bio = bio_list_pop(&tcmd->xfer_list))) {
-		bio_endio(bio, bio->bi_size, 0);
-		bio_unmap_user(bio);
-	}
-}
-
 static void cmd_hashlist_del(struct scsi_cmnd *cmd)
 {
 	struct request_queue *q = cmd->request->q;
@@ -185,6 +170,11 @@ static void cmd_hashlist_del(struct scsi
 	spin_unlock_irqrestore(&qdata->cmd_hash_lock, flags);
 }
 
+static void scsi_unmap_user_pages(struct scsi_tgt_cmd *tcmd)
+{
+	blk_rq_unmap_user(tcmd->bio);
+}
+
 static void scsi_tgt_cmd_destroy(struct work_struct *work)
 {
 	struct scsi_tgt_cmd *tcmd =
@@ -193,16 +183,6 @@ static void scsi_tgt_cmd_destroy(struct 
 
 	dprintk("cmd %p %d %lu\n", cmd, cmd->sc_data_direction,
 		rq_data_dir(cmd->request));
-	/*
-	 * We fix rq->cmd_flags here since when we told bio_map_user
-	 * to write vm for WRITE commands, blk_rq_bio_prep set
-	 * rq_data_dir the flags to READ.
-	 */
-	if (cmd->sc_data_direction == DMA_TO_DEVICE)
-		cmd->request->cmd_flags |= REQ_RW;
-	else
-		cmd->request->cmd_flags &= ~REQ_RW;
-
 	scsi_unmap_user_pages(tcmd);
 	scsi_host_put_command(scsi_tgt_cmd_to_host(cmd), cmd);
 }
@@ -215,6 +195,7 @@ static void init_scsi_tgt_cmd(struct req
 	struct list_head *head;
 
 	tcmd->tag = tag;
+	tcmd->bio = NULL;
 	INIT_WORK(&tcmd->work, scsi_tgt_cmd_destroy);
 	spin_lock_irqsave(&qdata->cmd_hash_lock, flags);
 	head = &qdata->cmd_hash[cmd_hashfn(tag)];
@@ -419,52 +400,33 @@ static int scsi_map_user_pages(struct sc
 	struct request *rq = cmd->request;
 	void *uaddr = tcmd->buffer;
 	unsigned int len = tcmd->bufflen;
-	struct bio *bio;
 	int err;
 
-	while (len > 0) {
-		dprintk("%lx %u\n", (unsigned long) uaddr, len);
-		bio = bio_map_user(q, NULL, (unsigned long) uaddr, len, rw);
-		if (IS_ERR(bio)) {
-			err = PTR_ERR(bio);
-			dprintk("fail to map %lx %u %d %x\n",
-				(unsigned long) uaddr, len, err, cmd->cmnd[0]);
-			goto unmap_bios;
-		}
-
-		uaddr += bio->bi_size;
-		len -= bio->bi_size;
-
+	dprintk("%lx %u\n", (unsigned long) uaddr, len);
+	err = blk_rq_map_user(q, rq, uaddr, len);
+	if (err) {
 		/*
-		 * The first bio is added and merged. We could probably
-		 * try to add others using scsi_merge_bio() but for now
-		 * we keep it simple. The first bio should be pretty large
-		 * (either hitting the 1 MB bio pages limit or a queue limit)
-		 * already but for really large IO we may want to try and
-		 * merge these.
+		 * TODO: need to fixup sg_tablesize, max_segment_size,
+		 * max_sectors, etc for modern HW and software drivers
+		 * where this value is bogus.
+		 *
+		 * TODO2: we can alloc a reserve buffer of max size
+		 * we can handle and do the slow copy path for really large
+		 * IO.
 		 */
-		if (!rq->bio) {
-			blk_rq_bio_prep(q, rq, bio);
-			rq->data_len = bio->bi_size;
-		} else
-			/* put list of bios to transfer in next go around */
-			bio_list_add(&tcmd->xfer_list, bio);
+		eprintk("Could not handle request of size %u.\n", len);
+		return err;
 	}
 
-	cmd->offset = 0;
+	tcmd->bio = rq->bio;
 	err = scsi_tgt_init_cmd(cmd, GFP_KERNEL);
 	if (err)
-		goto unmap_bios;
+		goto unmap_rq;
 
 	return 0;
 
-unmap_bios:
-	if (rq->bio) {
-		bio_unmap_user(rq->bio);
-		while ((bio = bio_list_pop(&tcmd->xfer_list)))
-			bio_unmap_user(bio);
-	}
-
+unmap_rq:
+	scsi_unmap_user_pages(tcmd);
 	return err;
 }
 
@@ -473,12 +435,10 @@ static int scsi_tgt_transfer_data(struct
 static void scsi_tgt_data_transfer_done(struct scsi_cmnd *cmd)
 {
 	struct scsi_tgt_cmd *tcmd = cmd->request->end_io_data;
-	struct bio *bio;
 	int err;
 
 	/* should we free resources here on error ? */
 	if (cmd->result) {
-send_uspace_err:
 		err = scsi_tgt_uspace_send_status(cmd, tcmd->tag);
 		if (err <= 0)
 			/* the tgt uspace eh will have to pick this up */
@@ -490,34 +450,8 @@ send_uspace_err:
 		cmd, cmd->request_bufflen, tcmd->bufflen);
 
 	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
-	bio_list_add(&tcmd->xfer_done_list, cmd->request->bio);
-
 	tcmd->buffer += cmd->request_bufflen;
-	cmd->offset += cmd->request_bufflen;
-
-	if (!tcmd->xfer_list.head) {
-		scsi_tgt_transfer_response(cmd);
-		return;
-	}
-
-	dprintk("cmd2 %p request_bufflen %u bufflen %u\n",
-		cmd, cmd->request_bufflen, tcmd->bufflen);
-
-	bio = bio_list_pop(&tcmd->xfer_list);
-	BUG_ON(!bio);
-
-	blk_rq_bio_prep(cmd->request->q, cmd->request, bio);
-	cmd->request->data_len = bio->bi_size;
-	err = scsi_tgt_init_cmd(cmd, GFP_ATOMIC);
-	if (err) {
-		cmd->result = DID_ERROR << 16;
-		goto send_uspace_err;
-	}
-
-	if (scsi_tgt_transfer_data(cmd)) {
-		cmd->result = DID_NO_CONNECT << 16;
-		goto send_uspace_err;
-	}
+	scsi_tgt_transfer_response(cmd);
 }
 
 static int scsi_tgt_transfer_data(struct scsi_cmnd *cmd)
@@ -617,8 +551,9 @@ int scsi_tgt_kspace_exec(int host_no, u6
 	}
 	cmd = rq->special;
 
-	dprintk("cmd %p result %d len %d bufflen %u %lu %x\n", cmd,
-		result, len, cmd->request_bufflen, rq_data_dir(rq), cmd->cmnd[0]);
+	dprintk("cmd %p scb %x result %d len %d bufflen %u %lu %x\n",
+		cmd, cmd->cmnd[0], result, len, cmd->request_bufflen,
+		rq_data_dir(rq), cmd->cmnd[0]);
 
 	if (result == TASK_ABORTED) {
 		scsi_tgt_abort_cmd(shost, cmd);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index d6948d0..a2e0c10 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -73,9 +73,6 @@ #define MAX_COMMAND_SIZE	16
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
 	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
 
-	/* offset in cmd we are at (for multi-transfer tgt cmds) */
-	unsigned offset;
-
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
 
-- 
1.4.1.1

