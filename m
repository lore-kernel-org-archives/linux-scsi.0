Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60449C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbiBVOFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiBVOFX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:05:23 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FBE15E6E1;
        Tue, 22 Feb 2022 06:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2qvParJYxAprydnv+J6+lSileXfX4IeZ8LbcbqI22xk=; b=gcsdMtCUUQks71Mon8rNwdXoAi
        khlcTtSyTu6FeJwu8JJhEDYOaeKSA6g/PxbDzkkPfITkielyAHGO39gXQiQonKmomqQOEvbYFz+4D
        HMDLR/CrAOayNEDezDVrm3UuZAYoKGs77SfjTOU6rqaw3UFPGPKspamIyHl65khs1ILxdN5ghEyRk
        A9J58GGVpmb4Zj7YknIiwEbfTG4zSEBsEf0eM8IMMVfxc/gZLSP5Oj0GAXjKHwEwKZpKYNuTXoaAK
        6WZcsuLA69bHsu5PRPy8IpvVgXpxMCCbUlASicPLIoD5QFBe38TUjSfc+Nc4Q1LRGJLRlnY2qiAXD
        6a+gWBJQ==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVmi-009nRZ-Dj; Tue, 22 Feb 2022 14:04:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 4/8] scsi: remove the cmd field from struct scsi_request
Date:   Tue, 22 Feb 2022 15:04:39 +0100
Message-Id: <20220222140443.589882-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222140443.589882-1-hch@lst.de>
References: <20220222140443.589882-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that each scsi_request is backed by a scsi_cmnd, there is no
need indirect the CDB storage.  Change all submitters of SCSI
passthrough request to store the CDB information directly in the
scsi_cmnd, and while doing so allocate the full 32 bytes that cover
all Linux supported SCSI hosts instead of requiring dynamic allocation
for > 16 byte CDBs.  On 64-bit systems this does not change the size of
the scsi_cmnd at all, while on 32-bit systems it slightly increases it
for now, but that increase will be made up by the removal of the
remaining scsi_request fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/libata-scsi.c           |  4 +++-
 drivers/block/pktcdvd.c             |  6 +++--
 drivers/scsi/scsi_bsg.c             | 23 +++++++++---------
 drivers/scsi/scsi_debugfs.c         |  4 +---
 drivers/scsi/scsi_error.c           | 28 +++++++++++-----------
 drivers/scsi/scsi_ioctl.c           | 37 +++++++++++++----------------
 drivers/scsi/scsi_lib.c             | 19 +++++++--------
 drivers/scsi/scsi_logging.c         |  5 +---
 drivers/scsi/sd.c                   | 28 +---------------------
 drivers/scsi/sg.c                   | 30 +++++++++--------------
 drivers/scsi/sr.c                   | 24 ++++++++++---------
 drivers/scsi/st.c                   | 12 ++++++----
 drivers/scsi/ufs/ufshpb.c           | 22 ++++++++---------
 drivers/target/target_core_pscsi.c  | 12 ++++++----
 drivers/usb/storage/cypress_atacb.c |  1 -
 drivers/usb/storage/isd200.c        |  4 ++--
 include/scsi/scsi_cmnd.h            |  7 +-----
 include/scsi/scsi_eh.h              |  4 +---
 include/scsi/scsi_request.h         | 11 ---------
 19 files changed, 113 insertions(+), 168 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ed8be585a98f7..c8283bd4ffd15 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1022,7 +1022,9 @@ void ata_scsi_sdev_config(struct scsi_device *sdev)
  */
 bool ata_scsi_dma_need_drain(struct request *rq)
 {
-	return atapi_cmd_type(scsi_req(rq)->cmd[0]) == ATAPI_MISC;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+
+	return atapi_cmd_type(scmd->cmnd[0]) == ATAPI_MISC;
 }
 EXPORT_SYMBOL_GPL(ata_scsi_dma_need_drain);
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 2b6b70a39e760..42c284b2d7f93 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -693,6 +693,7 @@ static void pkt_rbtree_insert(struct pktcdvd_device *pd, struct pkt_rb_node *nod
 static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *cgc)
 {
 	struct request_queue *q = bdev_get_queue(pd->bdev);
+	struct scsi_cmnd *scmd;
 	struct request *rq;
 	int ret = 0;
 
@@ -700,6 +701,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 			     REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
+	scmd = blk_mq_rq_to_pdu(rq);
 
 	if (cgc->buflen) {
 		ret = blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen,
@@ -708,8 +710,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 			goto out;
 	}
 
-	scsi_req(rq)->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
-	memcpy(scsi_req(rq)->cmd, cgc->cmd, CDROM_PACKET_SIZE);
+	scmd->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
+	memcpy(scmd->cmnd, cgc->cmd, CDROM_PACKET_SIZE);
 
 	rq->timeout = 60*HZ;
 	if (cgc->quiet)
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index b7a464383cc0b..f8b65bd75ee10 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -13,6 +13,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 		fmode_t mode, unsigned int timeout)
 {
 	struct scsi_request *sreq;
+	struct scsi_cmnd *scmd;
 	struct request *rq;
 	struct bio *bio;
 	int ret;
@@ -33,19 +34,19 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 
 	ret = -ENOMEM;
 	sreq = scsi_req(rq);
-	sreq->cmd_len = hdr->request_len;
-	if (sreq->cmd_len > BLK_MAX_CDB) {
-		sreq->cmd = kzalloc(sreq->cmd_len, GFP_KERNEL);
-		if (!sreq->cmd)
-			goto out_put_request;
+	scmd = blk_mq_rq_to_pdu(rq);
+	scmd->cmd_len = hdr->request_len;
+	if (scmd->cmd_len > sizeof(scmd->cmnd)) {
+		ret = -EINVAL;
+		goto out_put_request;
 	}
 
 	ret = -EFAULT;
-	if (copy_from_user(sreq->cmd, uptr64(hdr->request), sreq->cmd_len))
-		goto out_free_cmd;
+	if (copy_from_user(scmd->cmnd, uptr64(hdr->request), scmd->cmd_len))
+		goto out_put_request;
 	ret = -EPERM;
-	if (!scsi_cmd_allowed(sreq->cmd, mode))
-		goto out_free_cmd;
+	if (!scsi_cmd_allowed(scmd->cmnd, mode))
+		goto out_put_request;
 
 	ret = 0;
 	if (hdr->dout_xfer_len) {
@@ -57,7 +58,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	}
 
 	if (ret)
-		goto out_free_cmd;
+		goto out_put_request;
 
 	bio = rq->bio;
 	blk_execute_rq(rq, !(hdr->flags & BSG_FLAG_Q_AT_TAIL));
@@ -92,8 +93,6 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 
 	blk_rq_unmap_user(bio);
 
-out_free_cmd:
-	scsi_req_free_cmd(scsi_req(rq));
 out_put_request:
 	blk_mq_free_request(rq);
 	return ret;
diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index db8517f1a485a..17d7f73a895c6 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -36,11 +36,9 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
 	struct scsi_cmnd *cmd = container_of(scsi_req(rq), typeof(*cmd), req);
 	int alloc_ms = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
 	int timeout_ms = jiffies_to_msecs(rq->timeout);
-	const u8 *const cdb = READ_ONCE(cmd->cmnd);
 	char buf[80] = "(?)";
 
-	if (cdb)
-		__scsi_format_command(buf, sizeof(buf), cdb, cmd->cmd_len);
+	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
 	seq_printf(m, ", .cmd=%s, .retries=%d, .result = %#x, .flags=", buf,
 		   cmd->retries, cmd->result);
 	scsi_flags_show(m, cmd->flags, scsi_cmd_flags,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 60a6ae9d1219f..5383139a3de86 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -980,7 +980,7 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
  * @scmd:       SCSI command structure to hijack
  * @ses:        structure to save restore information
  * @cmnd:       CDB to send. Can be NULL if no new cmnd is needed
- * @cmnd_size:  size in bytes of @cmnd (must be <= BLK_MAX_CDB)
+ * @cmnd_size:  size in bytes of @cmnd (must be <= MAX_COMMAND_SIZE)
  * @sense_bytes: size of sense data to copy. or 0 (if != 0 @cmnd is ignored)
  *
  * This function is used to save a scsi command information before re-execution
@@ -1002,7 +1002,6 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	 * command.
 	 */
 	ses->cmd_len = scmd->cmd_len;
-	ses->cmnd = scmd->cmnd;
 	ses->data_direction = scmd->sc_data_direction;
 	ses->sdb = scmd->sdb;
 	ses->result = scmd->result;
@@ -1013,8 +1012,8 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 
 	scmd->prot_op = SCSI_PROT_NORMAL;
 	scmd->eh_eflags = 0;
-	scmd->cmnd = ses->eh_cmnd;
-	memset(scmd->cmnd, 0, BLK_MAX_CDB);
+	memcpy(ses->cmnd, scmd->cmnd, sizeof(ses->cmnd));
+	memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 	scmd->result = 0;
 	scmd->req.resid_len = 0;
@@ -1033,7 +1032,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	} else {
 		scmd->sc_data_direction = DMA_NONE;
 		if (cmnd) {
-			BUG_ON(cmnd_size > BLK_MAX_CDB);
+			BUG_ON(cmnd_size > sizeof(scmd->cmnd));
 			memcpy(scmd->cmnd, cmnd, cmnd_size);
 			scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 		}
@@ -1066,7 +1065,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	 * Restore original data
 	 */
 	scmd->cmd_len = ses->cmd_len;
-	scmd->cmnd = ses->cmnd;
+	memcpy(scmd->cmnd, ses->cmnd, sizeof(ses->cmnd));
 	scmd->sc_data_direction = ses->data_direction;
 	scmd->sdb = ses->sdb;
 	scmd->result = ses->result;
@@ -2022,6 +2021,7 @@ static void eh_lock_door_done(struct request *req, blk_status_t status)
  */
 static void scsi_eh_lock_door(struct scsi_device *sdev)
 {
+	struct scsi_cmnd *scmd;
 	struct request *req;
 	struct scsi_request *rq;
 
@@ -2029,14 +2029,15 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	if (IS_ERR(req))
 		return;
 	rq = scsi_req(req);
+	scmd = blk_mq_rq_to_pdu(req);
 
-	rq->cmd[0] = ALLOW_MEDIUM_REMOVAL;
-	rq->cmd[1] = 0;
-	rq->cmd[2] = 0;
-	rq->cmd[3] = 0;
-	rq->cmd[4] = SCSI_REMOVAL_PREVENT;
-	rq->cmd[5] = 0;
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
+	scmd->cmnd[0] = ALLOW_MEDIUM_REMOVAL;
+	scmd->cmnd[1] = 0;
+	scmd->cmnd[2] = 0;
+	scmd->cmnd[3] = 0;
+	scmd->cmnd[4] = SCSI_REMOVAL_PREVENT;
+	scmd->cmnd[5] = 0;
+	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 
 	req->rq_flags |= RQF_QUIET;
 	req->timeout = 10 * HZ;
@@ -2399,7 +2400,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
 	scsi_init_command(dev, scmd);
-	scmd->cmnd = scsi_req(rq)->cmd;
 
 	scmd->submitter = SUBMITTED_BY_SCSI_RESET_IOCTL;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index e13fd380deb6f..6d9f1b44566d1 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -345,19 +345,15 @@ EXPORT_SYMBOL(scsi_cmd_allowed);
 static int scsi_fill_sghdr_rq(struct scsi_device *sdev, struct request *rq,
 		struct sg_io_hdr *hdr, fmode_t mode)
 {
-	struct scsi_request *req = scsi_req(rq);
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
 
 	if (hdr->cmd_len < 6)
 		return -EMSGSIZE;
-	if (copy_from_user(req->cmd, hdr->cmdp, hdr->cmd_len))
+	if (copy_from_user(scmd->cmnd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (!scsi_cmd_allowed(req->cmd, mode))
+	if (!scsi_cmd_allowed(scmd->cmnd, mode))
 		return -EPERM;
-
-	/*
-	 * fill in request structure
-	 */
-	req->cmd_len = hdr->cmd_len;
+	scmd->cmd_len = hdr->cmd_len;
 
 	rq->timeout = msecs_to_jiffies(hdr->timeout);
 	if (!rq->timeout)
@@ -416,6 +412,7 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 	int at_head = 0;
 	struct request *rq;
 	struct scsi_request *req;
+	struct scsi_cmnd *scmd;
 	struct bio *bio;
 
 	if (hdr->interface_id != 'S')
@@ -444,16 +441,16 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	req = scsi_req(rq);
+	scmd = blk_mq_rq_to_pdu(rq);
 
-	if (hdr->cmd_len > BLK_MAX_CDB) {
-		req->cmd = kzalloc(hdr->cmd_len, GFP_KERNEL);
-		if (!req->cmd)
-			goto out_put_request;
+	if (hdr->cmd_len > sizeof(scmd->cmnd)) {
+		ret = -EINVAL;
+		goto out_put_request;
 	}
 
 	ret = scsi_fill_sghdr_rq(sdev, rq, hdr, mode);
 	if (ret < 0)
-		goto out_free_cdb;
+		goto out_put_request;
 
 	ret = 0;
 	if (hdr->iovec_count) {
@@ -463,7 +460,7 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 		ret = import_iovec(rq_data_dir(rq), hdr->dxferp,
 				   hdr->iovec_count, 0, &iov, &i);
 		if (ret < 0)
-			goto out_free_cdb;
+			goto out_put_request;
 
 		/* SG_IO howto says that the shorter of the two wins */
 		iov_iter_truncate(&i, hdr->dxfer_len);
@@ -475,7 +472,7 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 				      hdr->dxfer_len, GFP_KERNEL);
 
 	if (ret)
-		goto out_free_cdb;
+		goto out_put_request;
 
 	bio = rq->bio;
 	req->retries = 0;
@@ -488,8 +485,6 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 
 	ret = scsi_complete_sghdr_rq(rq, hdr, bio);
 
-out_free_cdb:
-	scsi_req_free_cmd(req);
 out_put_request:
 	blk_mq_free_request(rq);
 	return ret;
@@ -530,6 +525,7 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 	struct scsi_request *req;
 	int err;
 	unsigned int in_len, out_len, bytes, opcode, cmdlen;
+	struct scsi_cmnd *scmd;
 	char *buffer = NULL;
 
 	if (!sic)
@@ -561,6 +557,7 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 		goto error_free_buffer;
 	}
 	req = scsi_req(rq);
+	scmd = blk_mq_rq_to_pdu(rq);
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -568,15 +565,15 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 	 * get command and data to send to device, if any
 	 */
 	err = -EFAULT;
-	req->cmd_len = cmdlen;
-	if (copy_from_user(req->cmd, sic->data, cmdlen))
+	scmd->cmd_len = cmdlen;
+	if (copy_from_user(scmd->cmnd, sic->data, cmdlen))
 		goto error;
 
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
 	err = -EPERM;
-	if (!scsi_cmd_allowed(req->cmd, mode))
+	if (!scsi_cmd_allowed(scmd->cmnd, mode))
 		goto error;
 
 	/* default.  possible overridden later */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 960795d469d8c..be02999b78ea5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -214,6 +214,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 {
 	struct request *req;
 	struct scsi_request *rq;
+	struct scsi_cmnd *scmd;
 	int ret;
 
 	req = scsi_alloc_request(sdev->request_queue,
@@ -231,8 +232,9 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		if (ret)
 			goto out;
 	}
-	rq->cmd_len = COMMAND_SIZE(cmd[0]);
-	memcpy(rq->cmd, cmd, rq->cmd_len);
+	scmd = blk_mq_rq_to_pdu(req);
+	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	rq->retries = retries;
 	req->timeout = timeout;
 	req->cmd_flags |= flags;
@@ -1126,9 +1128,9 @@ static void scsi_initialize_rq(struct request *rq)
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 	struct scsi_request *req = &cmd->req;
 
-	memset(req->__cmd, 0, sizeof(req->__cmd));
-	req->cmd = req->__cmd;
-	req->cmd_len = BLK_MAX_CDB;
+	memset(cmd->cmnd, 0, sizeof(cmd->cmnd));
+	cmd->cmd_len = MAX_COMMAND_SIZE;
+
 	req->sense_len = 0;
 
 	init_rcu_head(&cmd->rcu);
@@ -1197,8 +1199,6 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
 		memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 	}
 
-	cmd->cmd_len = scsi_req(req)->cmd_len;
-	cmd->cmnd = scsi_req(req)->cmd;
 	cmd->transfersize = blk_rq_bytes(req);
 	cmd->allowed = scsi_req(req)->retries;
 	return BLK_STS_OK;
@@ -1568,8 +1568,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	cmd->prot_type = 0;
 	cmd->prot_flags = 0;
 	cmd->submitter = 0;
-	cmd->cmd_len = 0;
-	cmd->cmnd = NULL;
 	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 	cmd->underflow = 0;
 	cmd->transfersize = 0;
@@ -1617,8 +1615,7 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 			return ret;
 	}
 
-	cmd->cmnd = scsi_req(req)->cmd = scsi_req(req)->__cmd;
-	memset(cmd->cmnd, 0, BLK_MAX_CDB);
+	memset(cmd->cmnd, 0, sizeof(cmd->cmnd));
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 1f8f80b2dbfcb..ff89de86545d1 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -87,7 +87,7 @@ void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 	char *logbuf;
 	size_t off = 0, logbuf_len;
 
-	if (!scmd || !scmd->cmnd)
+	if (!scmd)
 		return;
 
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
@@ -183,9 +183,6 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 	char *logbuf;
 	size_t off, logbuf_len;
 
-	if (!cmd->cmnd)
-		return;
-
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
 	if (!logbuf)
 		return;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bf32a05414276..2f9d160bc8c21 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -128,7 +128,6 @@ static DEFINE_IDA(sd_index_ida);
 static DEFINE_MUTEX(sd_ref_mutex);
 
 static struct kmem_cache *sd_cdb_cache;
-static mempool_t *sd_cdb_pool;
 static mempool_t *sd_page_pool;
 static struct lock_class_key sd_bio_compl_lkclass;
 
@@ -1075,13 +1074,7 @@ static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
 				       sector_t lba, unsigned int nr_blocks,
 				       unsigned char flags)
 {
-	cmd->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
-	if (unlikely(cmd->cmnd == NULL))
-		return BLK_STS_RESOURCE;
-
 	cmd->cmd_len = SD_EXT_CDB_SIZE;
-	memset(cmd->cmnd, 0, cmd->cmd_len);
-
 	cmd->cmnd[0]  = VARIABLE_LENGTH_CMD;
 	cmd->cmnd[7]  = 0x18; /* Additional CDB len */
 	cmd->cmnd[9]  = write ? WRITE_32 : READ_32;
@@ -1313,17 +1306,9 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = scsi_cmd_to_rq(SCpnt);
-	u8 *cmnd;
 
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
 		mempool_free(rq->special_vec.bv_page, sd_page_pool);
-
-	if (SCpnt->cmnd != scsi_req(rq)->cmd) {
-		cmnd = SCpnt->cmnd;
-		SCpnt->cmnd = NULL;
-		SCpnt->cmd_len = 0;
-		mempool_free(cmnd, sd_cdb_pool);
-	}
 }
 
 static bool sd_need_revalidate(struct block_device *bdev,
@@ -3819,18 +3804,11 @@ static int __init init_sd(void)
 		goto err_out_class;
 	}
 
-	sd_cdb_pool = mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_cache);
-	if (!sd_cdb_pool) {
-		printk(KERN_ERR "sd: can't init extended cdb pool\n");
-		err = -ENOMEM;
-		goto err_out_cache;
-	}
-
 	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-		goto err_out_ppool;
+		goto err_out_cache;
 	}
 
 	err = scsi_register_driver(&sd_template.gendrv);
@@ -3842,9 +3820,6 @@ static int __init init_sd(void)
 err_out_driver:
 	mempool_destroy(sd_page_pool);
 
-err_out_ppool:
-	mempool_destroy(sd_cdb_pool);
-
 err_out_cache:
 	kmem_cache_destroy(sd_cdb_cache);
 
@@ -3868,7 +3843,6 @@ static void __exit exit_sd(void)
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
 	scsi_unregister_driver(&sd_template.gendrv);
-	mempool_destroy(sd_cdb_pool);
 	mempool_destroy(sd_page_pool);
 	kmem_cache_destroy(sd_cdb_cache);
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index bbd75026ec937..cc3f11270dc23 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -818,7 +818,6 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	}
 	if (atomic_read(&sdp->detaching)) {
 		if (srp->bio) {
-			scsi_req_free_cmd(scsi_req(srp->rq));
 			blk_mq_free_request(srp->rq);
 			srp->rq = NULL;
 		}
@@ -1393,7 +1392,6 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	 * blk_rq_unmap_user() can be called from user context.
 	 */
 	srp->rq = NULL;
-	scsi_req_free_cmd(scsi_req(rq));
 	blk_mq_free_request(rq);
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
@@ -1738,18 +1736,12 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 	struct request_queue *q = sfp->parentdp->device->request_queue;
 	struct rq_map_data *md, map_data;
 	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
-	unsigned char *long_cmdp = NULL;
+	struct scsi_cmnd *scmd;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_start_req: dxfer_len=%d\n",
 				      dxfer_len));
 
-	if (hp->cmd_len > BLK_MAX_CDB) {
-		long_cmdp = kzalloc(hp->cmd_len, GFP_KERNEL);
-		if (!long_cmdp)
-			return -ENOMEM;
-	}
-
 	/*
 	 * NOTE
 	 *
@@ -1763,16 +1755,18 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 	 */
 	rq = scsi_alloc_request(q, hp->dxfer_direction == SG_DXFER_TO_DEV ?
 			REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
-	if (IS_ERR(rq)) {
-		kfree(long_cmdp);
+	if (IS_ERR(rq))
 		return PTR_ERR(rq);
-	}
+	scmd = blk_mq_rq_to_pdu(rq);
 	req = scsi_req(rq);
 
-	if (hp->cmd_len > BLK_MAX_CDB)
-		req->cmd = long_cmdp;
-	memcpy(req->cmd, cmd, hp->cmd_len);
-	req->cmd_len = hp->cmd_len;
+	if (hp->cmd_len > sizeof(scmd->cmnd)) {
+		blk_mq_free_request(rq);
+		return -EINVAL;
+	}
+
+	memcpy(scmd->cmnd, cmd, hp->cmd_len);
+	scmd->cmd_len = hp->cmd_len;
 
 	srp->rq = rq;
 	rq->end_io_data = srp;
@@ -1865,10 +1859,8 @@ sg_finish_rem_req(Sg_request *srp)
 	if (srp->bio)
 		ret = blk_rq_unmap_user(srp->bio);
 
-	if (srp->rq) {
-		scsi_req_free_cmd(scsi_req(srp->rq));
+	if (srp->rq)
 		blk_mq_free_request(srp->rq);
-	}
 
 	if (srp->res_used)
 		sg_unlink_reserve(sfp, srp);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index f925b1f1f9ada..3adba389cae51 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -966,6 +966,7 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	struct gendisk *disk = cdi->disk;
 	u32 len = nr * CD_FRAMESIZE_RAW;
 	struct scsi_request *req;
+	struct scsi_cmnd *scmd;
 	struct request *rq;
 	struct bio *bio;
 	int ret;
@@ -974,22 +975,23 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	req = scsi_req(rq);
+	scmd = blk_mq_rq_to_pdu(rq);
 
 	ret = blk_rq_map_user(disk->queue, rq, NULL, ubuf, len, GFP_KERNEL);
 	if (ret)
 		goto out_put_request;
 
-	req->cmd[0] = GPCMD_READ_CD;
-	req->cmd[1] = 1 << 2;
-	req->cmd[2] = (lba >> 24) & 0xff;
-	req->cmd[3] = (lba >> 16) & 0xff;
-	req->cmd[4] = (lba >>  8) & 0xff;
-	req->cmd[5] = lba & 0xff;
-	req->cmd[6] = (nr >> 16) & 0xff;
-	req->cmd[7] = (nr >>  8) & 0xff;
-	req->cmd[8] = nr & 0xff;
-	req->cmd[9] = 0xf8;
-	req->cmd_len = 12;
+	scmd->cmnd[0] = GPCMD_READ_CD;
+	scmd->cmnd[1] = 1 << 2;
+	scmd->cmnd[2] = (lba >> 24) & 0xff;
+	scmd->cmnd[3] = (lba >> 16) & 0xff;
+	scmd->cmnd[4] = (lba >>  8) & 0xff;
+	scmd->cmnd[5] = lba & 0xff;
+	scmd->cmnd[6] = (nr >> 16) & 0xff;
+	scmd->cmnd[7] = (nr >>  8) & 0xff;
+	scmd->cmnd[8] = nr & 0xff;
+	scmd->cmnd[9] = 0xf8;
+	scmd->cmd_len = 12;
 	rq->timeout = 60 * HZ;
 	bio = rq->bio;
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e869e90e05afe..229e819a1797e 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -472,10 +472,11 @@ static void st_release_request(struct st_request *streq)
 
 static void st_do_stats(struct scsi_tape *STp, struct request *req)
 {
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
 	ktime_t now;
 
 	now = ktime_get();
-	if (scsi_req(req)->cmd[0] == WRITE_6) {
+	if (scmd->cmnd[0] == WRITE_6) {
 		now = ktime_sub(now, STp->stats->write_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_write_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
@@ -489,7 +490,7 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 		} else
 			atomic64_add(atomic_read(&STp->stats->last_write_size),
 				&STp->stats->write_byte_cnt);
-	} else if (scsi_req(req)->cmd[0] == READ_6) {
+	} else if (scmd->cmnd[0] == READ_6) {
 		now = ktime_sub(now, STp->stats->read_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_read_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
@@ -542,12 +543,14 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
 	int err = 0;
 	struct scsi_tape *STp = SRpnt->stp;
+	struct scsi_cmnd *scmd;
 
 	req = scsi_alloc_request(SRpnt->stp->device->request_queue,
 			data_direction == DMA_TO_DEVICE ?
 			REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
+	scmd = blk_mq_rq_to_pdu(req);
 	rq = scsi_req(req);
 	req->rq_flags |= RQF_QUIET;
 
@@ -574,9 +577,8 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	}
 
 	SRpnt->bio = req->bio;
-	rq->cmd_len = COMMAND_SIZE(cmd[0]);
-	memset(rq->cmd, 0, BLK_MAX_CDB);
-	memcpy(rq->cmd, cmd, rq->cmd_len);
+	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	req->timeout = timeout;
 	rq->retries = retries;
 	req->end_io_data = SRpnt;
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 2d36a0715fca6..3ca745ad616c1 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -666,15 +666,14 @@ static void ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
 				   struct ufshpb_req *umap_req,
 				   struct ufshpb_region *rgn)
 {
-	struct request *req;
-	struct scsi_request *rq;
+	struct request *req = umap_req->req;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
 
-	req = umap_req->req;
 	req->timeout = 0;
-	req->end_io_data = (void *)umap_req;
-	rq = scsi_req(req);
-	ufshpb_set_unmap_cmd(rq->cmd, rgn);
-	rq->cmd_len = HPB_WRITE_BUFFER_CMD_LENGTH;
+	req->end_io_data = umap_req;
+
+	ufshpb_set_unmap_cmd(scmd->cmnd, rgn);
+	scmd->cmd_len = HPB_WRITE_BUFFER_CMD_LENGTH;
 
 	blk_execute_rq_nowait(req, true, ufshpb_umap_req_compl_fn);
 
@@ -686,7 +685,7 @@ static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 {
 	struct request_queue *q;
 	struct request *req;
-	struct scsi_request *rq;
+	struct scsi_cmnd *scmd;
 	int mem_size = hpb->srgn_mem_size;
 	int ret = 0;
 	int i;
@@ -709,14 +708,13 @@ static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 
 	req->end_io_data = map_req;
 
-	rq = scsi_req(req);
-
 	if (unlikely(last))
 		mem_size = hpb->last_srgn_entries * HPB_ENTRY_SIZE;
 
-	ufshpb_set_read_buf_cmd(rq->cmd, map_req->rb.rgn_idx,
+	scmd = blk_mq_rq_to_pdu(req);
+	ufshpb_set_read_buf_cmd(scmd->cmnd, map_req->rb.rgn_idx,
 				map_req->rb.srgn_idx, mem_size);
-	rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
+	scmd->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
 
 	blk_execute_rq_nowait(req, true, ufshpb_map_req_compl_fn);
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 622158ed5d9ce..0a8078db923d3 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -961,6 +961,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 	struct scatterlist *sgl = cmd->t_data_sg;
 	u32 sgl_nents = cmd->t_data_nents;
 	struct pscsi_dev_virt *pdv = PSCSI_DEV(cmd->se_dev);
+	struct scsi_cmnd *scmd;
 	struct request *req;
 	sense_reason_t ret;
 
@@ -978,12 +979,15 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 
 	req->end_io = pscsi_req_done;
 	req->end_io_data = cmd;
-	scsi_req(req)->cmd_len = scsi_command_size(cmd->t_task_cdb);
-	if (scsi_req(req)->cmd_len > BLK_MAX_CDB) {
+
+	scmd = blk_mq_rq_to_pdu(req);
+	scmd->cmd_len = scsi_command_size(cmd->t_task_cdb);
+	if (scmd->cmd_len > sizeof(scmd->cmnd)) {
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto fail_put_request;
 	}
-	memcpy(scsi_req(req)->cmd, cmd->t_task_cdb, scsi_req(req)->cmd_len);
+	memcpy(scmd->cmnd, cmd->t_task_cdb, scmd->cmd_len);
+
 	if (pdv->pdv_sd->type == TYPE_DISK ||
 	    pdv->pdv_sd->type == TYPE_ZBC)
 		req->timeout = PS_TIMEOUT_DISK;
@@ -991,7 +995,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 		req->timeout = PS_TIMEOUT_OTHER;
 	scsi_req(req)->retries = PS_RETRY;
 
-	cmd->priv = scsi_req(req)->cmd;
+	cmd->priv = scmd->cmnd;
 
 	blk_execute_rq_nowait(req, cmd->sam_task_attr == TCM_HEAD_TAG,
 			pscsi_req_done);
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 2f7093ba5a2f4..98b3ec352a138 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -177,7 +177,6 @@ static void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
 		 * but reading register selected in srb->cmnd[4]
 		 */
 		srb->cmd_len = 16;
-		srb->cmnd = ses.cmnd;
 		srb->cmnd[2] = 1;
 
 		usb_stor_transparent_scsi_command(srb, us);
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 3c76336e43bb2..05429f1f69f9d 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -326,7 +326,7 @@ struct isd200_info {
 
 	/* maximum number of LUNs supported */
 	unsigned char MaxLUNs;
-	unsigned char cmnd[BLK_MAX_CDB];
+	unsigned char cmnd[MAX_COMMAND_SIZE];
 	struct scsi_cmnd srb;
 	struct scatterlist sg;
 };
@@ -485,7 +485,7 @@ static int isd200_action( struct us_data *us, int action,
 	int status;
 
 	memset(&ata, 0, sizeof(ata));
-	srb->cmnd = info->cmnd;
+	memcpy(srb->cmnd, info->cmnd, MAX_COMMAND_SIZE);
 	srb->device = &srb_dev;
 
 	ata.generic.SignatureByte0 = info->ConfigData.ATAMajorCommand;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 7a19c8bbaed9e..3e432e25645ac 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -28,9 +28,6 @@ struct scsi_driver;
  * supports without specifying a cmd_len by ULD's
  */
 #define MAX_COMMAND_SIZE 16
-#if (MAX_COMMAND_SIZE > BLK_MAX_CDB)
-# error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
-#endif
 
 struct scsi_data_buffer {
 	struct sg_table table;
@@ -100,9 +97,7 @@ struct scsi_cmnd {
 	unsigned short cmd_len;
 	enum dma_data_direction sc_data_direction;
 
-	/* These elements define the operation we are about to perform */
-	unsigned char *cmnd;
-
+	unsigned char cmnd[32]; /* SCSI CDB */
 
 	/* These elements define the operation we ultimately want to perform */
 	struct scsi_data_buffer sdb;
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 468094254b3cc..1ae08e81339fa 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -38,10 +38,8 @@ struct scsi_eh_save {
 	unsigned underflow;
 	unsigned char cmd_len;
 	unsigned char prot_op;
-	unsigned char *cmnd;
+	unsigned char cmnd[32];
 	struct scsi_data_buffer sdb;
-	/* new command support */
-	unsigned char eh_cmnd[BLK_MAX_CDB];
 	struct scatterlist sense_sgl;
 };
 
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
index 9129b23e12bc0..aeee0611bcbe1 100644
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -4,12 +4,7 @@
 
 #include <linux/blk-mq.h>
 
-#define BLK_MAX_CDB	16
-
 struct scsi_request {
-	unsigned char	__cmd[BLK_MAX_CDB];
-	unsigned char	*cmd;
-	unsigned short	cmd_len;
 	int		result;
 	unsigned int	sense_len;
 	unsigned int	resid_len;	/* residual count */
@@ -22,10 +17,4 @@ static inline struct scsi_request *scsi_req(struct request *rq)
 	return blk_mq_rq_to_pdu(rq);
 }
 
-static inline void scsi_req_free_cmd(struct scsi_request *req)
-{
-	if (req->cmd != req->__cmd)
-		kfree(req->cmd);
-}
-
 #endif /* _SCSI_SCSI_REQUEST_H */
-- 
2.30.2

