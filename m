Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71407C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiBVOFr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiBVOFq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:05:46 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFB715F361;
        Tue, 22 Feb 2022 06:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9Cpl2Zg9SghOajg8ZaRV8QEAfJa8+NBN5OP9Vd+pIo0=; b=wPX29FUouUxXiSBftauvFmUfk1
        UuB1Oe9D1DdoqgKNTfW3eHnB2BLd1vTXPJHB1dBTehDSOgwmdL1tLTcX280CkjCFIl06VzjzRI5E7
        o66BPdxC0IwVIGytGH2lulRYM4HAYdqAUs+Ps5Tk8BqiW/fyzwRQCdb9FZLGALAPwei9tYeHDLKSR
        mDbKvzM7TBoWskPHao/iQdj4aRIhjn95cIv5FT5yq/Cdw7cEQ4RfnvUZlksUZDiwGaiUlqLEyop3i
        i3vX3U70+P3ffWlBREhjhj1Zd2tN72t+4Mb1JKmMOpd4sDKTiWQxe5nHukq+iTRaELjsv/Gtrjo61
        Y9N9aD8g==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVmt-009nXd-IF; Tue, 22 Feb 2022 14:05:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 8/8] scsi: remove struct scsi_request
Date:   Tue, 22 Feb 2022 15:04:43 +0100
Message-Id: <20220222140443.589882-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222140443.589882-1-hch@lst.de>
References: <20220222140443.589882-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Let submitters initialized the scmd->allowed field directly instead of
indirecting through struct scsi_request and remove the now superflous
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/cdrom/cdrom.c              |  1 -
 drivers/scsi/scsi_debugfs.c        |  2 +-
 drivers/scsi/scsi_error.c          |  4 +---
 drivers/scsi/scsi_ioctl.c          | 12 ++++--------
 drivers/scsi/scsi_lib.c            |  6 +-----
 drivers/scsi/scsi_transport_sas.c  |  1 -
 drivers/scsi/sg.c                  |  4 +---
 drivers/scsi/sr.c                  |  2 --
 drivers/scsi/st.c                  |  4 +---
 drivers/target/target_core_pscsi.c |  2 +-
 include/scsi/scsi_cmnd.h           |  2 --
 include/scsi/scsi_request.h        | 16 ----------------
 12 files changed, 10 insertions(+), 46 deletions(-)
 delete mode 100644 include/scsi/scsi_request.h

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 1b57d4666e43c..7bd10d63ddbe5 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -284,7 +284,6 @@
 #include <linux/times.h>
 #include <linux/uaccess.h>
 #include <scsi/scsi_common.h>
-#include <scsi/scsi_request.h>
 
 /* used to tell the module to turn on full debugging messages */
 static bool debug;
diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index 17d7f73a895c6..217b70c678c3a 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -33,7 +33,7 @@ static int scsi_flags_show(struct seq_file *m, const unsigned long flags,
 
 void scsi_show_rq(struct seq_file *m, struct request *rq)
 {
-	struct scsi_cmnd *cmd = container_of(scsi_req(rq), typeof(*cmd), req);
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 	int alloc_ms = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
 	int timeout_ms = jiffies_to_msecs(rq->timeout);
 	char buf[80] = "(?)";
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cf02d1c503897..9c237b223e63c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2023,12 +2023,10 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 {
 	struct scsi_cmnd *scmd;
 	struct request *req;
-	struct scsi_request *rq;
 
 	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, 0);
 	if (IS_ERR(req))
 		return;
-	rq = scsi_req(req);
 	scmd = blk_mq_rq_to_pdu(req);
 
 	scmd->cmnd[0] = ALLOW_MEDIUM_REMOVAL;
@@ -2041,7 +2039,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 
 	req->rq_flags |= RQF_QUIET;
 	req->timeout = 10 * HZ;
-	rq->retries = 5;
+	scmd->allowed = 5;
 
 	blk_execute_rq_nowait(req, true, eh_lock_door_done);
 }
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index e95e104103f13..2b066dc7f9336 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -411,7 +411,6 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 	int writing = 0;
 	int at_head = 0;
 	struct request *rq;
-	struct scsi_request *req;
 	struct scsi_cmnd *scmd;
 	struct bio *bio;
 
@@ -440,7 +439,6 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 			     REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
-	req = scsi_req(rq);
 	scmd = blk_mq_rq_to_pdu(rq);
 
 	if (hdr->cmd_len > sizeof(scmd->cmnd)) {
@@ -475,7 +473,7 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 		goto out_put_request;
 
 	bio = rq->bio;
-	req->retries = 0;
+	scmd->allowed = 0;
 
 	start_time = jiffies;
 
@@ -522,7 +520,6 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 {
 	enum { OMAX_SB_LEN = 16 };	/* For backward compatibility */
 	struct request *rq;
-	struct scsi_request *req;
 	int err;
 	unsigned int in_len, out_len, bytes, opcode, cmdlen;
 	struct scsi_cmnd *scmd;
@@ -556,7 +553,6 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 		err = PTR_ERR(rq);
 		goto error_free_buffer;
 	}
-	req = scsi_req(rq);
 	scmd = blk_mq_rq_to_pdu(rq);
 
 	cmdlen = COMMAND_SIZE(opcode);
@@ -577,13 +573,13 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 		goto error;
 
 	/* default.  possible overridden later */
-	req->retries = 5;
+	scmd->allowed = 5;
 
 	switch (opcode) {
 	case SEND_DIAGNOSTIC:
 	case FORMAT_UNIT:
 		rq->timeout = FORMAT_UNIT_TIMEOUT;
-		req->retries = 1;
+		scmd->allowed = 1;
 		break;
 	case START_STOP:
 		rq->timeout = START_STOP_TIMEOUT;
@@ -596,7 +592,7 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 		break;
 	case READ_DEFECT_DATA:
 		rq->timeout = READ_DEFECT_DATA_TIMEOUT;
-		req->retries = 1;
+		scmd->allowed = 1;
 		break;
 	default:
 		rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 786bd989ca4de..69cea48a0cbe8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -213,7 +213,6 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int *resid)
 {
 	struct request *req;
-	struct scsi_request *rq;
 	struct scsi_cmnd *scmd;
 	int ret;
 
@@ -224,8 +223,6 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	rq = scsi_req(req);
-
 	if (bufflen) {
 		ret = blk_rq_map_kern(sdev->request_queue, req,
 				      buffer, bufflen, GFP_NOIO);
@@ -235,7 +232,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	scmd = blk_mq_rq_to_pdu(req);
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
-	rq->retries = retries;
+	scmd->allowed = retries;
 	req->timeout = timeout;
 	req->cmd_flags |= flags;
 	req->rq_flags |= rq_flags | RQF_QUIET;
@@ -1190,7 +1187,6 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
 	}
 
 	cmd->transfersize = blk_rq_bytes(req);
-	cmd->allowed = scsi_req(req)->retries;
 	return BLK_STS_OK;
 }
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 4ee578b181da5..12bff64dade64 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -34,7 +34,6 @@
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_request.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 26a753521cb29..6a1c3ffaf32a0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1725,7 +1725,6 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 {
 	int res;
 	struct request *rq;
-	struct scsi_request *req;
 	Sg_fd *sfp = srp->parentfp;
 	sg_io_hdr_t *hp = &srp->header;
 	int dxfer_len = (int) hp->dxfer_len;
@@ -1758,7 +1757,6 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	scmd = blk_mq_rq_to_pdu(rq);
-	req = scsi_req(rq);
 
 	if (hp->cmd_len > sizeof(scmd->cmnd)) {
 		blk_mq_free_request(rq);
@@ -1770,7 +1768,7 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 
 	srp->rq = rq;
 	rq->end_io_data = srp;
-	req->retries = SG_DEFAULT_RETRIES;
+	scmd->allowed = SG_DEFAULT_RETRIES;
 
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
 		return 0;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 494d00b05f53e..aaa54ad5f0352 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -965,7 +965,6 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 {
 	struct gendisk *disk = cdi->disk;
 	u32 len = nr * CD_FRAMESIZE_RAW;
-	struct scsi_request *req;
 	struct scsi_cmnd *scmd;
 	struct request *rq;
 	struct bio *bio;
@@ -974,7 +973,6 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	rq = scsi_alloc_request(disk->queue, REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
-	req = scsi_req(rq);
 	scmd = blk_mq_rq_to_pdu(rq);
 
 	ret = blk_rq_map_user(disk->queue, rq, NULL, ubuf, len, GFP_KERNEL);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c8533ca225bc0..6d4213e2e49ae 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -539,7 +539,6 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 			   int timeout, int retries)
 {
 	struct request *req;
-	struct scsi_request *rq;
 	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
 	int err = 0;
 	struct scsi_tape *STp = SRpnt->stp;
@@ -551,7 +550,6 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 	scmd = blk_mq_rq_to_pdu(req);
-	rq = scsi_req(req);
 	req->rq_flags |= RQF_QUIET;
 
 	mdata->null_mapped = 1;
@@ -580,7 +578,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	req->timeout = timeout;
-	rq->retries = retries;
+	scmd->allowed = retries;
 	req->end_io_data = SRpnt;
 
 	blk_execute_rq_nowait(req, true, st_scsi_execute_end);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 5b23a0ff905ea..d18d75d0d750c 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -993,7 +993,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 		req->timeout = PS_TIMEOUT_DISK;
 	else
 		req->timeout = PS_TIMEOUT_OTHER;
-	scsi_req(req)->retries = PS_RETRY;
+	scmd->allowed = PS_RETRY;
 
 	cmd->priv = scmd->cmnd;
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 5ff0a6e8460c3..76c5eaeeb3b54 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -10,7 +10,6 @@
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_request.h>
 
 struct Scsi_Host;
 struct scsi_driver;
@@ -68,7 +67,6 @@ enum scsi_cmnd_submitter {
 } __packed;
 
 struct scsi_cmnd {
-	struct scsi_request req;
 	struct scsi_device *device;
 	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
 	struct delayed_work abort_work;
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
deleted file mode 100644
index 929c7bd5c72fe..0000000000000
--- a/include/scsi/scsi_request.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _SCSI_SCSI_REQUEST_H
-#define _SCSI_SCSI_REQUEST_H
-
-#include <linux/blk-mq.h>
-
-struct scsi_request {
-	int		retries;
-};
-
-static inline struct scsi_request *scsi_req(struct request *rq)
-{
-	return blk_mq_rq_to_pdu(rq);
-}
-
-#endif /* _SCSI_SCSI_REQUEST_H */
-- 
2.30.2

