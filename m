Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D82C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Apr 2022 17:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239935AbiDJRjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 13:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239919AbiDJRjQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 13:39:16 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1289028E22
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 10:37:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id ED6302041D7;
        Sun, 10 Apr 2022 19:37:02 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xqnzUVCAmQfn; Sun, 10 Apr 2022 19:37:01 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 8B8D22041CE;
        Sun, 10 Apr 2022 19:37:00 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@lst.de
Subject: [PATCH v2 4/6] bsg: allow cmd_len > 32
Date:   Sun, 10 Apr 2022 13:36:50 -0400
Message-Id: <20220410173652.313016-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220410173652.313016-1-dgilbert@interlog.com>
References: <20220410173652.313016-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the bsg interface accesses the CDB via scsi_cmnd::cmnd
directly, change that to use the new access functions.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_bsg.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 96ee35256a16..0001a95c6ce1 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -15,6 +15,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	struct scsi_cmnd *scmd;
 	struct request *rq;
 	struct bio *bio;
+	u8 *cdb;
 	int ret;
 
 	if (hdr->protocol != BSG_PROTOCOL_SCSI  ||
@@ -33,17 +34,24 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 
 	scmd = blk_mq_rq_to_pdu(rq);
 	scmd->cmd_len = hdr->request_len;
-	if (scmd->cmd_len > sizeof(scmd->cmnd)) {
+	if (unlikely(scmd->cmd_len > SCSI_MAX_RUN_TIME_CDB_LEN)) {
 		ret = -EINVAL;
 		goto out_put_request;
 	}
+	cdb = scsi_cmnd_set_cdb(scmd, NULL, scmd->cmd_len);
+	if (unlikely(!cdb)) {
+		ret = -ENOMEM;
+		goto out_put_request;
+	}
 
-	ret = -EFAULT;
-	if (copy_from_user(scmd->cmnd, uptr64(hdr->request), scmd->cmd_len))
+	if (unlikely(copy_from_user(cdb, uptr64(hdr->request), scmd->cmd_len))) {
+		ret = -EFAULT;
 		goto out_put_request;
-	ret = -EPERM;
-	if (!scsi_cmd_allowed(scmd->cmnd, mode))
+	}
+	if (unlikely(!scsi_cmd_allowed(cdb, mode))) {
+		ret = -EPERM;
 		goto out_put_request;
+	}
 
 	ret = 0;
 	if (hdr->dout_xfer_len) {
@@ -54,7 +62,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 				hdr->din_xfer_len, GFP_KERNEL);
 	}
 
-	if (ret)
+	if (unlikely(ret))
 		goto out_put_request;
 
 	bio = rq->bio;
@@ -92,7 +100,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	blk_rq_unmap_user(bio);
 
 out_put_request:
-	blk_mq_free_request(rq);
+	scsi_free_cmnd(scmd);
 	return ret;
 }
 
-- 
2.25.1

