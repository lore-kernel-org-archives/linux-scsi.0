Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C8FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiBVOFr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiBVOFb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:05:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72E515F345;
        Tue, 22 Feb 2022 06:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=079lSwvJWc/ogqR4uK90RbW5TqanXcZwjirCcQ71QC4=; b=0PTFBJ/+4AHZARhErDSW9fIMT7
        ecynPkl60L6nrZYhxqTg39mTX9kx4pRlccN6HItsw30+2dJVGbJdWWy3s3jMT9KDPJB4sAcAXfGv8
        KdGjaH9Prh8NHClbULtwZewPDGjt4kC6o9/pCT+dNMlPd2hdALW4JvhBmPuUXvq0lDiHyQ4FScrmx
        vnxT/tQymgyzy3dtcNZDmTMX+rbBvXHb+EZOnCwi4Q86rcfe3lW0TzZaCvYWCcsZx4Uts/mtBIr8m
        3rOzqM401SGDSFWZe/TTSd8hbDGZM11id65iEQnitIe1NAy9y70yJOoRuJIMEDBt+ulKqY02B16MV
        KG/ecvFQ==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVmq-009nWD-RH; Tue, 22 Feb 2022 14:05:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 7/8] scsi: move the result field from struct scsi_request to struct scsi_cmnd
Date:   Tue, 22 Feb 2022 15:04:42 +0100
Message-Id: <20220222140443.589882-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222140443.589882-1-hch@lst.de>
References: <20220222140443.589882-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removing the scsi_request structure by moving the result
field to struct scsi_cmnd.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/pktcdvd.c            |  2 +-
 drivers/scsi/scsi_bsg.c            |  8 +++-----
 drivers/scsi/scsi_ioctl.c          |  9 ++++-----
 drivers/scsi/scsi_lib.c            | 15 ++++-----------
 drivers/scsi/sg.c                  |  3 +--
 drivers/scsi/sr.c                  |  2 +-
 drivers/scsi/st.c                  |  7 +++----
 drivers/target/target_core_pscsi.c |  9 ++++-----
 include/scsi/scsi_request.h        |  1 -
 9 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 42c284b2d7f93..aca94ebf49478 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -718,7 +718,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 		rq->rq_flags |= RQF_QUIET;
 
 	blk_execute_rq(rq, false);
-	if (scsi_req(rq)->result)
+	if (scmd->result)
 		ret = -EIO;
 out:
 	blk_mq_free_request(rq);
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 4c697d0ddf1d2..8039c3c11a6ee 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -12,7 +12,6 @@
 static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 		fmode_t mode, unsigned int timeout)
 {
-	struct scsi_request *sreq;
 	struct scsi_cmnd *scmd;
 	struct request *rq;
 	struct bio *bio;
@@ -33,7 +32,6 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	rq->timeout = timeout;
 
 	ret = -ENOMEM;
-	sreq = scsi_req(rq);
 	scmd = blk_mq_rq_to_pdu(rq);
 	scmd->cmd_len = hdr->request_len;
 	if (scmd->cmd_len > sizeof(scmd->cmnd)) {
@@ -66,10 +64,10 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	/*
 	 * fill in all the output members
 	 */
-	hdr->device_status = sreq->result & 0xff;
-	hdr->transport_status = host_byte(sreq->result);
+	hdr->device_status = scmd->result & 0xff;
+	hdr->transport_status = host_byte(scmd->result);
 	hdr->driver_status = 0;
-	if (scsi_status_is_check_condition(sreq->result))
+	if (scsi_status_is_check_condition(scmd->result))
 		hdr->driver_status = DRIVER_SENSE;
 	hdr->info = 0;
 	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 546b98321023c..e95e104103f13 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -370,16 +370,15 @@ static int scsi_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 		struct bio *bio)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
-	struct scsi_request *req = scsi_req(rq);
 	int r, ret = 0;
 
 	/*
 	 * fill in all the output members
 	 */
-	hdr->status = req->result & 0xff;
-	hdr->masked_status = status_byte(req->result);
+	hdr->status = scmd->result & 0xff;
+	hdr->masked_status = status_byte(scmd->result);
 	hdr->msg_status = COMMAND_COMPLETE;
-	hdr->host_status = host_byte(req->result);
+	hdr->host_status = host_byte(scmd->result);
 	hdr->driver_status = 0;
 	if (scsi_status_is_check_condition(hdr->status))
 		hdr->driver_status = DRIVER_SENSE;
@@ -612,7 +611,7 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 
 	blk_execute_rq(rq, false);
 
-	err = req->result & 0xff;	/* only 8 bit SCSI status */
+	err = scmd->result & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (scmd->sense_len && scmd->sense_buffer) {
 			bytes = (OMAX_SB_LEN > scmd->sense_len) ?
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c0664f7a86e73..786bd989ca4de 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -261,7 +261,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	if (sshdr)
 		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
 				     sshdr);
-	ret = rq->result;
+	ret = scmd->result;
  out:
 	blk_mq_free_request(req);
 
@@ -959,13 +959,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	if (unlikely(result))	/* a nz result may or may not be an error */
 		result = scsi_io_completion_nz_result(cmd, result, &blk_stat);
 
-	if (unlikely(blk_rq_is_passthrough(req))) {
-		/*
-		 * scsi_result_to_blk_status may have reset the host_byte
-		 */
-		scsi_req(req)->result = cmd->result;
-	}
-
 	/*
 	 * Next deal with any sectors which we were able to correctly
 	 * handle.
@@ -1780,15 +1773,15 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
 	case BLK_STS_AGAIN:
-		scsi_req(req)->result = DID_BUS_BUSY << 16;
+		cmd->result = DID_BUS_BUSY << 16;
 		if (req->rq_flags & RQF_DONTPREP)
 			scsi_mq_uninit_cmd(cmd);
 		break;
 	default:
 		if (unlikely(!scsi_device_online(sdev)))
-			scsi_req(req)->result = DID_NO_CONNECT << 16;
+			cmd->result = DID_NO_CONNECT << 16;
 		else
-			scsi_req(req)->result = DID_ERROR << 16;
+			cmd->result = DID_ERROR << 16;
 		/*
 		 * Make sure to release all allocated resources when
 		 * we hit an error, as we will never see this command
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3eaabfb315e0c..26a753521cb29 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1325,7 +1325,6 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
 	struct sg_request *srp = rq->end_io_data;
-	struct scsi_request *req = scsi_req(rq);
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	unsigned long iflags;
@@ -1345,7 +1344,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 		pr_info("%s: device detaching\n", __func__);
 
 	sense = scmd->sense_buffer;
-	result = req->result;
+	result = scmd->result;
 	resid = scmd->resid_len;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sdp,
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 1d19dd13d7f01..494d00b05f53e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -996,7 +996,7 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	bio = rq->bio;
 
 	blk_execute_rq(rq, false);
-	if (scsi_req(rq)->result) {
+	if (scmd->result) {
 		struct scsi_sense_hdr sshdr;
 
 		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0546d2c84ad16..c8533ca225bc0 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -481,7 +481,7 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_write_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
 		atomic64_inc(&STp->stats->write_cnt);
-		if (scsi_req(req)->result) {
+		if (scmd->result) {
 			atomic64_add(atomic_read(&STp->stats->last_write_size)
 				- STp->buffer->cmdstat.residual,
 				&STp->stats->write_byte_cnt);
@@ -495,7 +495,7 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_read_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
 		atomic64_inc(&STp->stats->read_cnt);
-		if (scsi_req(req)->result) {
+		if (scmd->result) {
 			atomic64_add(atomic_read(&STp->stats->last_read_size)
 				- STp->buffer->cmdstat.residual,
 				&STp->stats->read_byte_cnt);
@@ -516,11 +516,10 @@ static void st_scsi_execute_end(struct request *req, blk_status_t status)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
 	struct st_request *SRpnt = req->end_io_data;
-	struct scsi_request *rq = scsi_req(req);
 	struct scsi_tape *STp = SRpnt->stp;
 	struct bio *tmp;
 
-	STp->buffer->cmdstat.midlevel_result = SRpnt->result = rq->result;
+	STp->buffer->cmdstat.midlevel_result = SRpnt->result = scmd->result;
 	STp->buffer->cmdstat.residual = scmd->resid_len;
 
 	st_do_stats(STp, req);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index d5828da3d392a..5b23a0ff905ea 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1032,25 +1032,24 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 {
 	struct se_cmd *cmd = req->end_io_data;
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
-	int result = scsi_req(req)->result;
-	enum sam_status scsi_status = result & 0xff;
+	enum sam_status scsi_status = scmd->result & 0xff;
 	u8 *cdb = cmd->priv;
 
 	if (scsi_status != SAM_STAT_GOOD) {
 		pr_debug("PSCSI Status Byte exception at cmd: %p CDB:"
-			" 0x%02x Result: 0x%08x\n", cmd, cdb[0], result);
+			" 0x%02x Result: 0x%08x\n", cmd, cdb[0], scmd->result);
 	}
 
 	pscsi_complete_cmd(cmd, scsi_status, scmd->sense_buffer);
 
-	switch (host_byte(result)) {
+	switch (host_byte(scmd->result)) {
 	case DID_OK:
 		target_complete_cmd_with_length(cmd, scsi_status,
 			cmd->data_length - scmd->resid_len);
 		break;
 	default:
 		pr_debug("PSCSI Host Byte exception at cmd: %p CDB:"
-			" 0x%02x Result: 0x%08x\n", cmd, cdb[0], result);
+			" 0x%02x Result: 0x%08x\n", cmd, cdb[0], scmd->result);
 		target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION);
 		break;
 	}
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
index 74be75336a54d..929c7bd5c72fe 100644
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -5,7 +5,6 @@
 #include <linux/blk-mq.h>
 
 struct scsi_request {
-	int		result;
 	int		retries;
 };
 
-- 
2.30.2

