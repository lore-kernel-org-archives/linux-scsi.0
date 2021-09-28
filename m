Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30824C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 129D4611CA
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhI1F1R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 01:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbhI1F1Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 01:27:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70466C061575;
        Mon, 27 Sep 2021 22:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=WBkbbgBUVnyJppopQ/J+/NmSEWzXuT/YL8EsWEsPnQ8=; b=vzS4KL2KVq1oxJD7BYeqtLKwp5
        FFz7m2hktk1p5+UkQgymPzn0HlIC0dKhlBzEogXq4YaNPVlLW7KilrFK4Jjr8bfjZxH5SuHO2YRyP
        vgZxJGr/Q2FSpuqFHk4Ip3ffvRYu+p0KCj7hRyHK28MQ8Zh3XONawHeR0+IWv7MRGgkmN+J//M2sC
        jk/hnds891RqNkxjoRqRIQZsJ0gQmkvYQw8N1UktQIwWOPaQi7QpmFkNK089CedR5/JRbjBYmcD5d
        9YE9YCTxDGmPSaYPAFeorENyqh7pSw226C55U9unj5ew3Swe81pt9n9kCBvhOC4PtAqkvSDHo7rK5
        pVxAaXgQ==;
Received: from p4fdb05cb.dip0.t-ipconnect.de ([79.219.5.203] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mV5ay-00AWBX-Vw; Tue, 28 Sep 2021 05:24:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 4/5] block: remove the gendisk argument to blk_execute_rq
Date:   Tue, 28 Sep 2021 07:22:10 +0200
Message-Id: <20210928052211.112801-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928052211.112801-1-hch@lst.de>
References: <20210928052211.112801-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the gendisk aregument to blk_execute_rq and blk_execute_rq_nowait
given that it is unused now.  Also convert the boolean at_head parameter
to actually use the bool type while touching the prototype.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-exec.c                   |  9 +++------
 block/bsg-lib.c                    |  2 +-
 drivers/block/mtip32xx/mtip32xx.c  |  2 +-
 drivers/block/paride/pd.c          |  2 +-
 drivers/block/pktcdvd.c            |  2 +-
 drivers/block/sx8.c                |  4 ++--
 drivers/block/virtio_blk.c         |  2 +-
 drivers/mmc/core/block.c           | 10 +++++-----
 drivers/nvme/host/core.c           |  4 ++--
 drivers/nvme/host/pci.c            |  7 +++----
 drivers/nvme/target/passthru.c     |  3 +--
 drivers/scsi/scsi_bsg.c            |  2 +-
 drivers/scsi/scsi_error.c          |  2 +-
 drivers/scsi/scsi_ioctl.c          |  4 ++--
 drivers/scsi/scsi_lib.c            |  2 +-
 drivers/scsi/sg.c                  |  2 +-
 drivers/scsi/sr.c                  |  2 +-
 drivers/scsi/st.c                  |  2 +-
 drivers/scsi/ufs/ufshcd.c          |  3 +--
 drivers/scsi/ufs/ufshpb.c          |  4 ++--
 drivers/target/target_core_pscsi.c |  2 +-
 fs/nfsd/blocklayout.c              |  2 +-
 include/linux/blk-mq.h             |  7 +++----
 23 files changed, 37 insertions(+), 44 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 9832655bd2662..60a4939b1ef03 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -32,7 +32,6 @@ static void blk_end_sync_rq(struct request *rq, blk_status_t error)
 
 /**
  * blk_execute_rq_nowait - insert a request to I/O scheduler for execution
- * @bd_disk:	unused
  * @rq:		request to insert
  * @at_head:    insert request at head or tail of queue
  * @done:	I/O completion handler
@@ -44,8 +43,7 @@ static void blk_end_sync_rq(struct request *rq, blk_status_t error)
  * Note:
  *    This function will invoke @done directly if the queue is dead.
  */
-void blk_execute_rq_nowait(struct gendisk *bd_disk, struct request *rq,
-			   int at_head, rq_end_io_fn *done)
+void blk_execute_rq_nowait(struct request *rq, bool at_head, rq_end_io_fn *done)
 {
 	WARN_ON(irqs_disabled());
 	WARN_ON(!blk_rq_is_passthrough(rq));
@@ -77,7 +75,6 @@ static void blk_rq_poll_completion(struct request *rq, struct completion *wait)
 
 /**
  * blk_execute_rq - insert a request into queue for execution
- * @bd_disk:	unused
  * @rq:		request to insert
  * @at_head:    insert request at head or tail of queue
  *
@@ -86,13 +83,13 @@ static void blk_rq_poll_completion(struct request *rq, struct completion *wait)
  *    for execution and wait for completion.
  * Return: The blk_status_t result provided to blk_mq_end_request().
  */
-blk_status_t blk_execute_rq(struct gendisk *bd_disk, struct request *rq, int at_head)
+blk_status_t blk_execute_rq(struct request *rq, bool at_head)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	unsigned long hang_check;
 
 	rq->end_io_data = &wait;
-	blk_execute_rq_nowait(bd_disk, rq, at_head, blk_end_sync_rq);
+	blk_execute_rq_nowait(rq, at_head, blk_end_sync_rq);
 
 	/* Prevent hang_check timer from firing at us during very long I/O */
 	hang_check = sysctl_hung_task_timeout_secs;
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index ccb98276c964a..b7d37509606a5 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -85,7 +85,7 @@ static int bsg_transport_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 		goto out_unmap_bidi_rq;
 
 	bio = rq->bio;
-	blk_execute_rq(NULL, rq, !(hdr->flags & BSG_FLAG_Q_AT_TAIL));
+	blk_execute_rq(rq, !(hdr->flags & BSG_FLAG_Q_AT_TAIL));
 
 	/*
 	 * The assignments below don't make much sense, but are kept for
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 901855717cb53..f15c5ddd2a8df 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1015,7 +1015,7 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 	rq->timeout = timeout;
 
 	/* insert request and run queue */
-	blk_execute_rq(NULL, rq, true);
+	blk_execute_rq(rq, true);
 
 	if (int_cmd->status) {
 		dev_err(&dd->pdev->dev, "Internal command [%02X] failed %d\n",
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index ab9d336d7b79c..4a1a24761affe 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -781,7 +781,7 @@ static int pd_special_command(struct pd_unit *disk,
 	req = blk_mq_rq_to_pdu(rq);
 
 	req->func = func;
-	blk_execute_rq(disk->gd, rq, 0);
+	blk_execute_rq(rq, false);
 	blk_put_request(rq);
 	return 0;
 }
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 0f26b2510a756..3c99e0992deb6 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -722,7 +722,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 	if (cgc->quiet)
 		rq->rq_flags |= RQF_QUIET;
 
-	blk_execute_rq(pd->bdev->bd_disk, rq, 0);
+	blk_execute_rq(rq, false);
 	if (scsi_req(rq)->result)
 		ret = -EIO;
 out:
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 420cd952ddc4b..2fcbca777a4b5 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -539,7 +539,7 @@ static int carm_array_info (struct carm_host *host, unsigned int array_idx)
 	spin_unlock_irq(&host->lock);
 
 	DPRINTK("blk_execute_rq_nowait, tag == %u\n", rq->tag);
-	blk_execute_rq_nowait(NULL, rq, true, NULL);
+	blk_execute_rq_nowait(rq, true, NULL);
 
 	return 0;
 
@@ -578,7 +578,7 @@ static int carm_send_special (struct carm_host *host, carm_sspc_t func)
 	crq->msg_bucket = (u32) rc;
 
 	DPRINTK("blk_execute_rq_nowait, tag == %u\n", rq->tag);
-	blk_execute_rq_nowait(NULL, rq, true, NULL);
+	blk_execute_rq_nowait(rq, true, NULL);
 
 	return 0;
 }
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 9b3bd083b411f..06efeb7d5156d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -320,7 +320,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	if (err)
 		goto out;
 
-	blk_execute_rq(vblk->disk, req, false);
+	blk_execute_rq(req, false);
 	err = blk_status_to_errno(virtblk_result(blk_mq_rq_to_pdu(req)));
 out:
 	blk_put_request(req);
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 835220d34fabf..a91908d36c01d 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -264,7 +264,7 @@ static ssize_t power_ro_lock_store(struct device *dev,
 		goto out_put;
 	}
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_BOOT_WP;
-	blk_execute_rq(NULL, req, 0);
+	blk_execute_rq(req, false);
 	ret = req_to_mmc_queue_req(req)->drv_op_result;
 	blk_put_request(req);
 
@@ -657,7 +657,7 @@ static int mmc_blk_ioctl_cmd(struct mmc_blk_data *md,
 		rpmb ? MMC_DRV_OP_IOCTL_RPMB : MMC_DRV_OP_IOCTL;
 	req_to_mmc_queue_req(req)->drv_op_data = idatas;
 	req_to_mmc_queue_req(req)->ioc_count = 1;
-	blk_execute_rq(NULL, req, 0);
+	blk_execute_rq(req, false);
 	ioc_err = req_to_mmc_queue_req(req)->drv_op_result;
 	err = mmc_blk_ioctl_copy_to_user(ic_ptr, idata);
 	blk_put_request(req);
@@ -726,7 +726,7 @@ static int mmc_blk_ioctl_multi_cmd(struct mmc_blk_data *md,
 		rpmb ? MMC_DRV_OP_IOCTL_RPMB : MMC_DRV_OP_IOCTL;
 	req_to_mmc_queue_req(req)->drv_op_data = idata;
 	req_to_mmc_queue_req(req)->ioc_count = num_of_cmds;
-	blk_execute_rq(NULL, req, 0);
+	blk_execute_rq(req, false);
 	ioc_err = req_to_mmc_queue_req(req)->drv_op_result;
 
 	/* copy to user if data and response */
@@ -2734,7 +2734,7 @@ static int mmc_dbg_card_status_get(void *data, u64 *val)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_GET_CARD_STATUS;
-	blk_execute_rq(NULL, req, 0);
+	blk_execute_rq(req, false);
 	ret = req_to_mmc_queue_req(req)->drv_op_result;
 	if (ret >= 0) {
 		*val = ret;
@@ -2773,7 +2773,7 @@ static int mmc_ext_csd_open(struct inode *inode, struct file *filp)
 	}
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_GET_EXT_CSD;
 	req_to_mmc_queue_req(req)->drv_op_data = &ext_csd;
-	blk_execute_rq(NULL, req, 0);
+	blk_execute_rq(req, false);
 	err = req_to_mmc_queue_req(req)->drv_op_result;
 	blk_put_request(req);
 	if (err) {
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 7fa75433c0361..b2c4d2c4c92f4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1045,7 +1045,7 @@ static int nvme_execute_rq(struct gendisk *disk, struct request *rq,
 {
 	blk_status_t status;
 
-	status = blk_execute_rq(disk, rq, at_head);
+	status = blk_execute_rq(rq, at_head);
 	if (nvme_req(rq)->flags & NVME_REQ_CANCELLED)
 		return -EINTR;
 	if (nvme_req(rq)->status)
@@ -1272,7 +1272,7 @@ static void nvme_keep_alive_work(struct work_struct *work)
 
 	rq->timeout = ctrl->kato * HZ;
 	rq->end_io_data = ctrl;
-	blk_execute_rq_nowait(NULL, rq, 0, nvme_keep_alive_end_io);
+	blk_execute_rq_nowait(rq, false, nvme_keep_alive_end_io);
 }
 
 static void nvme_start_keep_alive(struct nvme_ctrl *ctrl)
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index ca5bda26226ae..331667f54e91e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1346,7 +1346,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 	}
 
 	abort_req->end_io_data = NULL;
-	blk_execute_rq_nowait(NULL, abort_req, 0, abort_endio);
+	blk_execute_rq_nowait(abort_req, false, abort_endio);
 
 	/*
 	 * The aborted req will be completed on receiving the abort req.
@@ -2391,9 +2391,8 @@ static int nvme_delete_queue(struct nvme_queue *nvmeq, u8 opcode)
 	req->end_io_data = nvmeq;
 
 	init_completion(&nvmeq->delete_done);
-	blk_execute_rq_nowait(NULL, req, false,
-			opcode == nvme_admin_delete_cq ?
-				nvme_del_cq_end : nvme_del_queue_end);
+	blk_execute_rq_nowait(req, false, opcode == nvme_admin_delete_cq ?
+			nvme_del_cq_end : nvme_del_queue_end);
 	return 0;
 }
 
diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index f0efb35379898..9e5b89ae29dfe 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -284,8 +284,7 @@ static void nvmet_passthru_execute_cmd(struct nvmet_req *req)
 		schedule_work(&req->p.work);
 	} else {
 		rq->end_io_data = req;
-		blk_execute_rq_nowait(ns ? ns->disk : NULL, rq, 0,
-				      nvmet_passthru_req_done);
+		blk_execute_rq_nowait(rq, false, nvmet_passthru_req_done);
 	}
 
 	if (ns)
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 81c3853a2a800..b67675a139e87 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -60,7 +60,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 		goto out_free_cmd;
 
 	bio = rq->bio;
-	blk_execute_rq(NULL, rq, !(hdr->flags & BSG_FLAG_Q_AT_TAIL));
+	blk_execute_rq(rq, !(hdr->flags & BSG_FLAG_Q_AT_TAIL));
 
 	/*
 	 * fill in all the output members
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b6c86cce57bfa..a41bb1eef8633 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2015,7 +2015,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	req->timeout = 10 * HZ;
 	rq->retries = 5;
 
-	blk_execute_rq_nowait(NULL, req, 1, eh_lock_door_done);
+	blk_execute_rq_nowait(req, true, eh_lock_door_done);
 }
 
 /**
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 6ff2207bd45a0..4a93f2c1d1afb 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -481,7 +481,7 @@ static int sg_io(struct scsi_device *sdev, struct gendisk *disk,
 
 	start_time = jiffies;
 
-	blk_execute_rq(disk, rq, at_head);
+	blk_execute_rq(rq, at_head);
 
 	hdr->duration = jiffies_to_msecs(jiffies - start_time);
 
@@ -618,7 +618,7 @@ static int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk,
 			goto error;
 	}
 
-	blk_execute_rq(disk, rq, 0);
+	blk_execute_rq(rq, false);
 
 	err = req->result & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a701d17b16146..9352799d729b0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -241,7 +241,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	/*
 	 * head injection *required* here otherwise quiesce won't work
 	 */
-	blk_execute_rq(NULL, req, 1);
+	blk_execute_rq(req, true);
 
 	/*
 	 * Some devices (USB mass-storage in particular) may transfer
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3c98f08dc25d9..24196ea7e0d76 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -833,7 +833,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 
 	srp->rq->timeout = timeout;
 	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
-	blk_execute_rq_nowait(NULL, srp->rq, at_head, sg_rq_end_io);
+	blk_execute_rq_nowait(srp->rq, at_head, sg_rq_end_io);
 	return 0;
 }
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 9cd8152aea5b3..eddb153a536d7 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -990,7 +990,7 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	rq->timeout = 60 * HZ;
 	bio = rq->bio;
 
-	blk_execute_rq(disk, rq, 0);
+	blk_execute_rq(rq, false);
 	if (scsi_req(rq)->result) {
 		struct scsi_sense_hdr sshdr;
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9933722acfd96..1d2855fe5faf8 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -581,7 +581,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	rq->retries = retries;
 	req->end_io_data = SRpnt;
 
-	blk_execute_rq_nowait(NULL, req, 1, st_scsi_execute_end);
+	blk_execute_rq_nowait(req, true, st_scsi_execute_end);
 	return 0;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 029c9631ec2bf..e2d7cd70a9ddc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7967,8 +7967,7 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
 	req->rq_flags |= RQF_PM | RQF_QUIET;
 	req->end_io_data = buffer;
 
-	blk_execute_rq_nowait(/*bd_disk=*/NULL, req, /*at_head=*/true,
-			      ufshcd_request_sense_done);
+	blk_execute_rq_nowait(req, true, ufshcd_request_sense_done);
 	return 0;
 
 out_put:
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index b20a058004eca..a3c56787f8f25 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -950,7 +950,7 @@ static void ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
 	ufshpb_set_unmap_cmd(rq->cmd, rgn);
 	rq->cmd_len = HPB_WRITE_BUFFER_CMD_LENGTH;
 
-	blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
+	blk_execute_rq_nowait(req, true, ufshpb_umap_req_compl_fn);
 
 	hpb->stats.umap_req_cnt++;
 }
@@ -992,7 +992,7 @@ static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 				map_req->rb.srgn_idx, mem_size);
 	rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
 
-	blk_execute_rq_nowait(NULL, req, 1, ufshpb_map_req_compl_fn);
+	blk_execute_rq_nowait(req, true, ufshpb_map_req_compl_fn);
 
 	hpb->stats.map_req_cnt++;
 	return 0;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 75ef52f008ff6..3722464f323fc 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1006,7 +1006,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 		req->timeout = PS_TIMEOUT_OTHER;
 	scsi_req(req)->retries = PS_RETRY;
 
-	blk_execute_rq_nowait(NULL, req, (cmd->sam_task_attr == TCM_HEAD_TAG),
+	blk_execute_rq_nowait(req, cmd->sam_task_attr == TCM_HEAD_TAG,
 			pscsi_req_done);
 
 	return 0;
diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index c99dee99a3c15..dc021afe14340 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -254,7 +254,7 @@ static int nfsd4_scsi_identify_device(struct block_device *bdev,
 	req->cmd[4] = bufflen & 0xff;
 	req->cmd_len = COMMAND_SIZE(INQUIRY);
 
-	blk_execute_rq(NULL, rq, 1);
+	blk_execute_rq(rq, true);
 	if (req->result) {
 		pr_err("pNFS: INQUIRY 0x83 failed with: %x\n",
 			req->result);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index bcda9c702d302..68f2efa65d906 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -874,10 +874,9 @@ int blk_rq_unmap_user(struct bio *);
 int blk_rq_map_kern(struct request_queue *, struct request *, void *,
 		unsigned int, gfp_t);
 int blk_rq_append_bio(struct request *rq, struct bio *bio);
-void blk_execute_rq_nowait(struct gendisk *, struct request *, int,
-		rq_end_io_fn *);
-blk_status_t blk_execute_rq(struct gendisk *bd_disk, struct request *rq,
-		int at_head);
+void blk_execute_rq_nowait(struct request *rq, bool at_head,
+		rq_end_io_fn *end_io);
+blk_status_t blk_execute_rq(struct request *rq, bool at_head);
 
 struct req_iterator {
 	struct bvec_iter iter;
-- 
2.30.2

