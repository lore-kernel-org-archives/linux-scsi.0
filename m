Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B35C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6206D61040
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhJYHID (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbhJYHH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 03:07:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5045EC061745;
        Mon, 25 Oct 2021 00:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=d1Pb75oxXWhujmWoM67L3tYtJqj6VxNZpExp9J9VF2Y=; b=Ry6ENBi1H77CdB4PNpRnTElvBb
        tnT81KzPGL3PztEVtw6aQxyHpavHkCoS5sMRPWne+MawSkLAoFnZmarA9Psfnx2QPGanjFQDESofB
        oRYuSyUH8h/WmqIrxQ43sTVM2+g9VNquQrkgvKXvCaBOknVPQAnsW3k2rqrJaSIDBd6pRD1/wYvWH
        cp3Z0wNwjksIOMwIUH+3iQLfTNBEODvUo62a5+S6jlOvE/1OkpQFtOvklfI/n96WSxV/Ma8sGtdaj
        GBWOFfKujPcknM3q8PuJrNrxE++YJpACPVzQpnTKexZZFatvwSw8hxtmkNDdj3qdGoc83u2fKKkcJ
        0xVY+Rnw==;
Received: from [2001:4bb8:184:6dcb:6093:467a:cccc:351c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meu2u-00FUOz-Bh; Mon, 25 Oct 2021 07:05:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 02/12] block: remove blk_{get,put}_request
Date:   Mon, 25 Oct 2021 09:05:07 +0200
Message-Id: <20211025070517.1548584-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211025070517.1548584-1-hch@lst.de>
References: <20211025070517.1548584-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These are now pointless wrappers around blk_mq_{alloc,free}_request,
so remove them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c                   | 21 ---------------------
 drivers/block/paride/pd.c          |  4 ++--
 drivers/block/pktcdvd.c            |  2 +-
 drivers/block/virtio_blk.c         |  4 ++--
 drivers/md/dm-mpath.c              |  4 ++--
 drivers/mmc/core/block.c           | 20 ++++++++++----------
 drivers/scsi/scsi_bsg.c            |  2 +-
 drivers/scsi/scsi_error.c          |  2 +-
 drivers/scsi/scsi_ioctl.c          |  4 ++--
 drivers/scsi/scsi_lib.c            |  4 ++--
 drivers/scsi/sg.c                  |  6 +++---
 drivers/scsi/sr.c                  |  2 +-
 drivers/scsi/st.c                  |  4 ++--
 drivers/scsi/ufs/ufshcd.c          | 20 ++++++++++----------
 drivers/scsi/ufs/ufshpb.c          |  8 ++++----
 drivers/target/target_core_pscsi.c |  4 ++--
 include/linux/blk-mq.h             |  3 ---
 17 files changed, 45 insertions(+), 69 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3edc5c5178dd6..0d267cfb71484 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -597,27 +597,6 @@ bool blk_get_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_get_queue);
 
-/**
- * blk_get_request - allocate a request
- * @q: request queue to allocate a request for
- * @op: operation (REQ_OP_*) and REQ_* flags, e.g. REQ_SYNC.
- * @flags: BLK_MQ_REQ_* flags, e.g. BLK_MQ_REQ_NOWAIT.
- */
-struct request *blk_get_request(struct request_queue *q, unsigned int op,
-				blk_mq_req_flags_t flags)
-{
-	WARN_ON_ONCE(op & REQ_NOWAIT);
-	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM));
-	return blk_mq_alloc_request(q, op, flags);
-}
-EXPORT_SYMBOL(blk_get_request);
-
-void blk_put_request(struct request *req)
-{
-	blk_mq_free_request(req);
-}
-EXPORT_SYMBOL(blk_put_request);
-
 static void handle_bad_sector(struct bio *bio, sector_t maxsector)
 {
 	char b[BDEVNAME_SIZE];
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 675327df6aff9..9cd0bd509b887 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -775,14 +775,14 @@ static int pd_special_command(struct pd_unit *disk,
 	struct request *rq;
 	struct pd_req *req;
 
-	rq = blk_get_request(disk->gd->queue, REQ_OP_DRV_IN, 0);
+	rq = blk_mq_alloc_request(disk->gd->queue, REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	req = blk_mq_rq_to_pdu(rq);
 
 	req->func = func;
 	blk_execute_rq(disk->gd, rq, 0);
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return 0;
 }
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index cacf64eedad87..40e7a45e3347c 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -726,7 +726,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 	if (scsi_req(rq)->result)
 		ret = -EIO;
 out:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return ret;
 }
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 303caf2d17d0c..f81a768943e15 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -312,7 +312,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	struct request *req;
 	int err;
 
-	req = blk_get_request(q, REQ_OP_DRV_IN, 0);
+	req = blk_mq_alloc_request(q, REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -323,7 +323,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	blk_execute_rq(vblk->disk, req, false);
 	err = blk_status_to_errno(virtblk_result(blk_mq_rq_to_pdu(req)));
 out:
-	blk_put_request(req);
+	blk_mq_free_request(req);
 	return err;
 }
 
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 694aaca4eea24..510f6c3ab98d4 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -530,7 +530,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 
 	bdev = pgpath->path.dev->bdev;
 	q = bdev_get_queue(bdev);
-	clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE,
+	clone = blk_mq_alloc_request(q, rq->cmd_flags | REQ_NOMERGE,
 			BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(clone)) {
 		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
@@ -579,7 +579,7 @@ static void multipath_release_clone(struct request *clone,
 						    clone->io_start_time_ns);
 	}
 
-	blk_put_request(clone);
+	blk_mq_free_request(clone);
 }
 
 /*
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 431af5e8be2f8..74882fa0f86d0 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -258,7 +258,7 @@ static ssize_t power_ro_lock_store(struct device *dev,
 	mq = &md->queue;
 
 	/* Dispatch locking to the block layer */
-	req = blk_get_request(mq->queue, REQ_OP_DRV_OUT, 0);
+	req = blk_mq_alloc_request(mq->queue, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req)) {
 		count = PTR_ERR(req);
 		goto out_put;
@@ -266,7 +266,7 @@ static ssize_t power_ro_lock_store(struct device *dev,
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_BOOT_WP;
 	blk_execute_rq(NULL, req, 0);
 	ret = req_to_mmc_queue_req(req)->drv_op_result;
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 	if (!ret) {
 		pr_info("%s: Locking boot partition ro until next power on\n",
@@ -646,7 +646,7 @@ static int mmc_blk_ioctl_cmd(struct mmc_blk_data *md,
 	 * Dispatch the ioctl() into the block request queue.
 	 */
 	mq = &md->queue;
-	req = blk_get_request(mq->queue,
+	req = blk_mq_alloc_request(mq->queue,
 		idata->ic.write_flag ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -660,7 +660,7 @@ static int mmc_blk_ioctl_cmd(struct mmc_blk_data *md,
 	blk_execute_rq(NULL, req, 0);
 	ioc_err = req_to_mmc_queue_req(req)->drv_op_result;
 	err = mmc_blk_ioctl_copy_to_user(ic_ptr, idata);
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 cmd_done:
 	kfree(idata->buf);
@@ -716,7 +716,7 @@ static int mmc_blk_ioctl_multi_cmd(struct mmc_blk_data *md,
 	 * Dispatch the ioctl()s into the block request queue.
 	 */
 	mq = &md->queue;
-	req = blk_get_request(mq->queue,
+	req = blk_mq_alloc_request(mq->queue,
 		idata[0]->ic.write_flag ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -733,7 +733,7 @@ static int mmc_blk_ioctl_multi_cmd(struct mmc_blk_data *md,
 	for (i = 0; i < num_of_cmds && !err; i++)
 		err = mmc_blk_ioctl_copy_to_user(&cmds[i], idata[i]);
 
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 cmd_err:
 	for (i = 0; i < num_of_cmds; i++) {
@@ -2730,7 +2730,7 @@ static int mmc_dbg_card_status_get(void *data, u64 *val)
 	int ret;
 
 	/* Ask the block layer about the card status */
-	req = blk_get_request(mq->queue, REQ_OP_DRV_IN, 0);
+	req = blk_mq_alloc_request(mq->queue, REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_GET_CARD_STATUS;
@@ -2740,7 +2740,7 @@ static int mmc_dbg_card_status_get(void *data, u64 *val)
 		*val = ret;
 		ret = 0;
 	}
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 	return ret;
 }
@@ -2766,7 +2766,7 @@ static int mmc_ext_csd_open(struct inode *inode, struct file *filp)
 		return -ENOMEM;
 
 	/* Ask the block layer for the EXT CSD */
-	req = blk_get_request(mq->queue, REQ_OP_DRV_IN, 0);
+	req = blk_mq_alloc_request(mq->queue, REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto out_free;
@@ -2775,7 +2775,7 @@ static int mmc_ext_csd_open(struct inode *inode, struct file *filp)
 	req_to_mmc_queue_req(req)->drv_op_data = &ext_csd;
 	blk_execute_rq(NULL, req, 0);
 	err = req_to_mmc_queue_req(req)->drv_op_result;
-	blk_put_request(req);
+	blk_mq_free_request(req);
 	if (err) {
 		pr_err("FAILED %d\n", err);
 		goto out_free;
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 551727a6f6941..081b84bb7985b 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -95,7 +95,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 out_free_cmd:
 	scsi_req_free_cmd(scsi_req(rq));
 out_put_request:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return ret;
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 71d027b94be40..36870b41c888d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1979,7 +1979,7 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 
 static void eh_lock_door_done(struct request *req, blk_status_t status)
 {
-	blk_put_request(req);
+	blk_mq_free_request(req);
 }
 
 /**
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 0078975e3c07c..34412eac4566b 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -490,7 +490,7 @@ static int sg_io(struct scsi_device *sdev, struct gendisk *disk,
 out_free_cdb:
 	scsi_req_free_cmd(req);
 out_put_request:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return ret;
 }
 
@@ -634,7 +634,7 @@ static int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk,
 	}
 
 error:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 
 error_free_buffer:
 	kfree(buffer);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1f7e68699941f..514cabc0f31b4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -260,7 +260,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		scsi_normalize_sense(rq->sense, rq->sense_len, sshdr);
 	ret = rq->result;
  out:
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 	return ret;
 }
@@ -1140,7 +1140,7 @@ struct request *scsi_alloc_request(struct request_queue *q,
 {
 	struct request *rq;
 
-	rq = blk_get_request(q, op, flags);
+	rq = blk_mq_alloc_request(q, op, flags);
 	if (!IS_ERR(rq))
 		scsi_initialize_rq(rq);
 	return rq;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 85f57ac0b844e..141099ab90921 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -815,7 +815,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	if (atomic_read(&sdp->detaching)) {
 		if (srp->bio) {
 			scsi_req_free_cmd(scsi_req(srp->rq));
-			blk_put_request(srp->rq);
+			blk_mq_free_request(srp->rq);
 			srp->rq = NULL;
 		}
 
@@ -1390,7 +1390,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	 */
 	srp->rq = NULL;
 	scsi_req_free_cmd(scsi_req(rq));
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (unlikely(srp->orphan)) {
@@ -1830,7 +1830,7 @@ sg_finish_rem_req(Sg_request *srp)
 
 	if (srp->rq) {
 		scsi_req_free_cmd(scsi_req(srp->rq));
-		blk_put_request(srp->rq);
+		blk_mq_free_request(srp->rq);
 	}
 
 	if (srp->res_used)
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7c4d9a9647999..3009b986d1d74 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -1003,7 +1003,7 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	if (blk_rq_unmap_user(bio))
 		ret = -EFAULT;
 out_put_request:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return ret;
 }
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1275299f61597..c2d5608f6b1a5 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -530,7 +530,7 @@ static void st_scsi_execute_end(struct request *req, blk_status_t status)
 		complete(SRpnt->waiting);
 
 	blk_rq_unmap_user(tmp);
-	blk_put_request(req);
+	blk_mq_free_request(req);
 }
 
 static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
@@ -557,7 +557,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 		err = blk_rq_map_user(req->q, req, mdata, NULL, bufflen,
 				      GFP_KERNEL);
 		if (err) {
-			blk_put_request(req);
+			blk_mq_free_request(req);
 			return err;
 		}
 	}
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bf81da2ecf98c..c85f540f6af4e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2925,7 +2925,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	 * Even though we use wait_event() which sleeps indefinitely,
 	 * the maximum wait time is bounded by SCSI request timeout.
 	 */
-	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto out_unlock;
@@ -2952,7 +2952,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
 out:
-	blk_put_request(req);
+	blk_mq_free_request(req);
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
@@ -6517,9 +6517,9 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	int task_tag, err;
 
 	/*
-	 * blk_get_request() is used here only to get a free tag.
+	 * blk_mq_alloc_request() is used here only to get a free tag.
 	 */
-	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -6575,7 +6575,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	ufshcd_release(hba);
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 	return err;
 }
@@ -6660,7 +6660,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	down_read(&hba->clk_scaling_lock);
 
-	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto out_unlock;
@@ -6741,7 +6741,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
 out:
-	blk_put_request(req);
+	blk_mq_free_request(req);
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
@@ -7912,7 +7912,7 @@ static void ufshcd_request_sense_done(struct request *rq, blk_status_t error)
 	if (error != BLK_STS_OK)
 		pr_err("%s: REQUEST SENSE failed (%d)\n", __func__, error);
 	kfree(rq->end_io_data);
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 }
 
 static int
@@ -7932,7 +7932,7 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
 	if (!buffer)
 		return -ENOMEM;
 
-	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN,
+	req = blk_mq_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
 			      /*flags=*/BLK_MQ_REQ_PM);
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
@@ -7957,7 +7957,7 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
 	return 0;
 
 out_put:
-	blk_put_request(req);
+	blk_mq_free_request(req);
 out_free:
 	kfree(buffer);
 	return ret;
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 589af5f6b940a..a2a3080071e9d 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -564,7 +564,7 @@ static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
 	int _read_id;
 	int ret = 0;
 
-	req = blk_get_request(cmd->device->request_queue,
+	req = blk_mq_alloc_request(cmd->device->request_queue,
 			      REQ_OP_DRV_OUT | REQ_SYNC, BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(req))
 		return -EAGAIN;
@@ -592,7 +592,7 @@ static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
 	ufshpb_put_pre_req(hpb, pre_req);
 unlock_out:
 	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-	blk_put_request(req);
+	blk_mq_free_request(req);
 	return ret;
 }
 
@@ -721,7 +721,7 @@ static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
 		return NULL;
 
 retry:
-	req = blk_get_request(hpb->sdev_ufs_lu->request_queue, dir,
+	req = blk_mq_alloc_request(hpb->sdev_ufs_lu->request_queue, dir,
 			      BLK_MQ_REQ_NOWAIT);
 
 	if (!atomic && (PTR_ERR(req) == -EWOULDBLOCK) && (--retries > 0)) {
@@ -745,7 +745,7 @@ static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
 
 static void ufshpb_put_req(struct ufshpb_lu *hpb, struct ufshpb_req *rq)
 {
-	blk_put_request(rq->req);
+	blk_mq_free_request(rq->req);
 	kmem_cache_free(hpb->map_req_cache, rq);
 }
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index b5705a2bd7618..7fa57fb57bf22 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1011,7 +1011,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 	return 0;
 
 fail_put_request:
-	blk_put_request(req);
+	blk_mq_free_request(req);
 fail:
 	kfree(pt);
 	return ret;
@@ -1066,7 +1066,7 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 		break;
 	}
 
-	blk_put_request(req);
+	blk_mq_free_request(req);
 	kfree(pt);
 }
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 9f9634cd4cfd2..850ecfdebe595 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -892,9 +892,6 @@ static inline bool rq_is_sync(struct request *rq)
 }
 
 void blk_rq_init(struct request_queue *q, struct request *rq);
-void blk_put_request(struct request *rq);
-struct request *blk_get_request(struct request_queue *q, unsigned int op,
-		blk_mq_req_flags_t flags);
 int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 		struct bio_set *bs, gfp_t gfp_mask,
 		int (*bio_ctr)(struct bio *, struct bio *, void *), void *data);
-- 
2.30.2

