Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC62C49EA6
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 12:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73CA9613FA
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 12:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbhFXMmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 08:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbhFXMmU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 08:42:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1316C061574;
        Thu, 24 Jun 2021 05:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=FhT7jjrlHLjpQaVJvWJtq0damwMxwXuO2NevODqm/2M=; b=FaA0XMI3GgGp9a44zv5QhXzYii
        vk2YbYepeR1CWi9qH4IcD+K9KbZUVTHrlVPiOxF1KyxMumUg3xUNgJAeWJdoO8WiSRj4a7XECLi9o
        FMrtTGjc5OL7jhlVkAZa6sI5QUMzxM7Y6/aLQ2cjOPFwTi8QGG1SmwSHjPTb3C7NYONBFivtLzFyI
        YTH1hDxOW2fEBgYDbaiaGzMc7sdG0/kOTW/lsRJOpFGACwQbX4urUzMFF7rad/6ld5323szqz8jDV
        KBZSUj6PGjBUwLQ4OdG7xTkr/6lWCcGg12ATq6gl6b+yoO2qE8hmpJQ7yL8mGJLNIapBE45E5V7QC
        0VzbTmfw==;
Received: from 213-225-9-92.nat.highway.a1.net ([213.225.9.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwOdu-00GZkD-Th; Thu, 24 Jun 2021 12:39:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] block: remove REQ_OP_SCSI_{IN,OUT}
Date:   Thu, 24 Jun 2021 14:39:34 +0200
Message-Id: <20210624123935.479229-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With the legacy IDE driver gone drivers now use either REQ_OP_DRV_*
or REQ_OP_SCSI_*, so unify the two concepts of passthrough requests
into a single one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c                   |  2 --
 block/bsg-lib.c                    |  2 +-
 block/bsg.c                        |  2 +-
 block/scsi_ioctl.c                 |  6 +++---
 drivers/block/pktcdvd.c            |  2 +-
 drivers/cdrom/cdrom.c              |  2 +-
 drivers/scsi/scsi_error.c          |  2 +-
 drivers/scsi/scsi_lib.c            |  8 ++++----
 drivers/scsi/sg.c                  |  2 +-
 drivers/scsi/st.c                  |  2 +-
 drivers/target/target_core_pscsi.c |  2 +-
 fs/nfsd/blocklayout.c              |  2 +-
 include/linux/blk_types.h          |  3 ---
 include/linux/blkdev.h             | 33 +++---------------------------
 14 files changed, 19 insertions(+), 51 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 514838ccab2d..3eea8d795565 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -142,8 +142,6 @@ static const char *const blk_op_name[] = {
 	REQ_OP_NAME(ZONE_APPEND),
 	REQ_OP_NAME(WRITE_SAME),
 	REQ_OP_NAME(WRITE_ZEROES),
-	REQ_OP_NAME(SCSI_IN),
-	REQ_OP_NAME(SCSI_OUT),
 	REQ_OP_NAME(DRV_IN),
 	REQ_OP_NAME(DRV_OUT),
 };
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 330fede77271..57b082bc9017 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -45,7 +45,7 @@ static int bsg_transport_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
 		return PTR_ERR(job->request);
 
 	if (hdr->dout_xfer_len && hdr->din_xfer_len) {
-		job->bidi_rq = blk_get_request(rq->q, REQ_OP_SCSI_IN, 0);
+		job->bidi_rq = blk_get_request(rq->q, REQ_OP_DRV_IN, 0);
 		if (IS_ERR(job->bidi_rq)) {
 			ret = PTR_ERR(job->bidi_rq);
 			goto out;
diff --git a/block/bsg.c b/block/bsg.c
index bd10922d5cbb..323e45878362 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -152,7 +152,7 @@ static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 		return ret;
 
 	rq = blk_get_request(q, hdr.dout_xfer_len ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
+			REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 1b3fe99b83a6..41ca95bfe607 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -311,7 +311,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		at_head = 1;
 
 	ret = -ENOMEM;
-	rq = blk_get_request(q, writing ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
+	rq = blk_get_request(q, writing ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	req = scsi_req(rq);
@@ -433,7 +433,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	}
 
-	rq = blk_get_request(q, in_len ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
+	rq = blk_get_request(q, in_len ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq)) {
 		err = PTR_ERR(rq);
 		goto error_free_buffer;
@@ -521,7 +521,7 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	struct request *rq;
 	int err;
 
-	rq = blk_get_request(q, REQ_OP_SCSI_OUT, 0);
+	rq = blk_get_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index f69b5c69c2a6..538446b652de 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -704,7 +704,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 	int ret = 0;
 
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
-			     REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
+			     REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 90ad34c6ef8e..feb827eefd1a 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2186,7 +2186,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		len = nr * CD_FRAMESIZE_RAW;
 
-		rq = blk_get_request(q, REQ_OP_SCSI_IN, 0);
+		rq = blk_get_request(q, REQ_OP_DRV_IN, 0);
 		if (IS_ERR(rq)) {
 			ret = PTR_ERR(rq);
 			break;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d8fafe77dbbe..03a2ff547b22 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2011,7 +2011,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	struct request *req;
 	struct scsi_request *rq;
 
-	req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN, 0);
+	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req))
 		return;
 	rq = scsi_req(req);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 532304d42f00..6cc7dad923cb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -215,7 +215,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 
 	req = blk_get_request(sdev->request_queue,
 			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
+			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
 			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
 	if (IS_ERR(req))
 		return ret;
@@ -540,7 +540,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	if (blk_queue_add_random(q))
 		add_disk_randomness(req->rq_disk);
 
-	if (!blk_rq_is_scsi(req)) {
+	if (!blk_rq_is_passthrough(req)) {
 		WARN_ON_ONCE(!(cmd->flags & SCMD_INITIALIZED));
 		cmd->flags &= ~SCMD_INITIALIZED;
 	}
@@ -1115,7 +1115,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	bool in_flight;
 	int budget_token = cmd->budget_token;
 
-	if (!blk_rq_is_scsi(rq) && !(flags & SCMD_INITIALIZED)) {
+	if (!blk_rq_is_passthrough(rq) && !(flags & SCMD_INITIALIZED)) {
 		flags |= SCMD_INITIALIZED;
 		scsi_initialize_rq(rq);
 	}
@@ -1556,7 +1556,7 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	 * Special handling for passthrough commands, which don't go to the ULP
 	 * at all:
 	 */
-	if (blk_rq_is_scsi(req))
+	if (blk_rq_is_passthrough(req))
 		return scsi_setup_scsi_cmnd(sdev, req);
 
 	if (sdev->handler && sdev->handler->prep_fn) {
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index def7ec3bbaf9..f84fa550dd15 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1756,7 +1756,7 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 	 * not expect an EWOULDBLOCK from this condition.
 	 */
 	rq = blk_get_request(q, hp->dxfer_direction == SG_DXFER_TO_DEV ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
+			REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq)) {
 		kfree(long_cmdp);
 		return PTR_ERR(rq);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 3b1afe1d5b27..86c951c654a8 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -549,7 +549,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 
 	req = blk_get_request(SRpnt->stp->device->request_queue,
 			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
+			REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req))
 		return DRIVER_ERROR << 24;
 	rq = scsi_req(req);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f2a11414366d..4531cf47d24e 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -982,7 +982,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 
 	req = blk_get_request(pdv->pdv_sd->request_queue,
 			cmd->data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
+			REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req)) {
 		pr_err("PSCSI: blk_get_request() failed\n");
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index 1058659a8d31..c99dee99a3c1 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -236,7 +236,7 @@ static int nfsd4_scsi_identify_device(struct block_device *bdev,
 	if (!buf)
 		return -ENOMEM;
 
-	rq = blk_get_request(q, REQ_OP_SCSI_IN, 0);
+	rq = blk_get_request(q, REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq)) {
 		error = -ENOMEM;
 		goto out_free_buf;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index fd3860d18d7e..db61f7df1823 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -350,9 +350,6 @@ enum req_opf {
 	/* reset all the zone present on the device */
 	REQ_OP_ZONE_RESET_ALL	= 17,
 
-	/* SCSI passthrough using struct scsi_request */
-	REQ_OP_SCSI_IN		= 32,
-	REQ_OP_SCSI_OUT		= 33,
 	/* Driver private requests */
 	REQ_OP_DRV_IN		= 34,
 	REQ_OP_DRV_OUT		= 35,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d66d0da72529..d199e51524eb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -240,42 +240,15 @@ struct request {
 	void *end_io_data;
 };
 
-static inline bool blk_op_is_scsi(unsigned int op)
-{
-	return op == REQ_OP_SCSI_IN || op == REQ_OP_SCSI_OUT;
-}
-
-static inline bool blk_op_is_private(unsigned int op)
+static inline bool blk_op_is_passthrough(unsigned int op)
 {
+	op &= REQ_OP_MASK;
 	return op == REQ_OP_DRV_IN || op == REQ_OP_DRV_OUT;
 }
 
-static inline bool blk_rq_is_scsi(struct request *rq)
-{
-	return blk_op_is_scsi(req_op(rq));
-}
-
-static inline bool blk_rq_is_private(struct request *rq)
-{
-	return blk_op_is_private(req_op(rq));
-}
-
 static inline bool blk_rq_is_passthrough(struct request *rq)
 {
-	return blk_rq_is_scsi(rq) || blk_rq_is_private(rq);
-}
-
-static inline bool bio_is_passthrough(struct bio *bio)
-{
-	unsigned op = bio_op(bio);
-
-	return blk_op_is_scsi(op) || blk_op_is_private(op);
-}
-
-static inline bool blk_op_is_passthrough(unsigned int op)
-{
-	return (blk_op_is_scsi(op & REQ_OP_MASK) ||
-			blk_op_is_private(op & REQ_OP_MASK));
+	return blk_op_is_passthrough(req_op(rq));
 }
 
 static inline unsigned short req_get_ioprio(struct request *req)
-- 
2.30.2

