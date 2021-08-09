Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D6EC43214
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F04BD60EE7
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhHIXEg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:04:36 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:36384 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbhHIXEf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:35 -0400
Received: by mail-pj1-f52.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so1460252pjr.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T9S4ykGgWfeetO9QGDQXXGmgG+9kGiG2iugFnSdFh4M=;
        b=TutoEkp/LApoV3Ir1RbYah0zRByzW9+FXAj5wuXbiTfv+pM4yLD/9mo81vPfhHFWVK
         DeI9RwPWXUcEvXYNWu1eh4J5qVihCYmoO9owUQHKTTGe1JhnuKLIwMjPpTpzP65b0A/I
         uGAx/5JeNL79wztN8NtLXZs4uHpExHYUlKJLvtRLCQ6kIBYfMobgMVuw8KDO08yW/G3e
         Kayx/wYF2zEL4g/BUqlJd1cSBAhOvJ5qYESJdfG6PZffOjDlhVeY7IYoqfD9PwjDjjmK
         DJKMqwVunT3w+yBRSDtOuJd2BthVGU51sE6G7/9hZYbdqrizTl/ysnYmnBPYWDpKxjwy
         9kgw==
X-Gm-Message-State: AOAM533XVteHb0HX7AhffSb7fLw1aPqzBktU5Axua5NZIi+o0NfpMpVd
        2pnfG3eyH/3DGfG3iPWRGns=
X-Google-Smtp-Source: ABdhPJxBKzwYhDNH0idFBH1xiFRpLfZ1aAzWQ9/JSom7RBXUk99tGHFyXbxzWV/JfafiZnQiToyWXQ==
X-Received: by 2002:a17:90a:2ec3:: with SMTP id h3mr28079975pjs.125.1628550253626;
        Mon, 09 Aug 2021 16:04:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v5 07/52] ata: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:10 -0700
Message-Id: <20210809230355.8186-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-eh.c   |  5 ++---
 drivers/ata/libata-scsi.c | 10 +++++-----
 drivers/ata/pata_falcon.c |  4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bb3637762985..bf9c4b6c5c3d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -912,7 +912,7 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
 	 * Note that ATA_QCFLAG_FAILED is unconditionally set after
 	 * this function completes.
 	 */
-	blk_abort_request(qc->scsicmd->request);
+	blk_abort_request(scsi_cmd_to_rq(qc->scsicmd));
 }
 
 /**
@@ -1893,8 +1893,7 @@ static inline int ata_eh_worth_retry(struct ata_queued_cmd *qc)
  */
 static inline bool ata_eh_quiet(struct ata_queued_cmd *qc)
 {
-	if (qc->scsicmd &&
-	    qc->scsicmd->request->rq_flags & RQF_QUIET)
+	if (qc->scsicmd && scsi_cmd_to_rq(qc->scsicmd)->rq_flags & RQF_QUIET)
 		qc->flags |= ATA_QCFLAG_QUIET;
 	return qc->flags & ATA_QCFLAG_QUIET;
 }
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9588c52815d..f7f630485465 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -631,7 +631,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 {
 	struct ata_queued_cmd *qc;
 
-	qc = ata_qc_new_init(dev, cmd->request->tag);
+	qc = ata_qc_new_init(dev, scsi_cmd_to_rq(cmd)->tag);
 	if (qc) {
 		qc->scsicmd = cmd;
 		qc->scsidone = cmd->scsi_done;
@@ -639,7 +639,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 		qc->sg = scsi_sglist(cmd);
 		qc->n_elem = scsi_sg_count(cmd);
 
-		if (cmd->request->rq_flags & RQF_QUIET)
+		if (scsi_cmd_to_rq(cmd)->rq_flags & RQF_QUIET)
 			qc->flags |= ATA_QCFLAG_QUIET;
 	} else {
 		cmd->result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
@@ -1496,7 +1496,7 @@ static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc)
 
 static bool ata_check_nblocks(struct scsi_cmnd *scmd, u32 n_blocks)
 {
-	struct request *rq = scmd->request;
+	struct request *rq = scsi_cmd_to_rq(scmd);
 	u32 req_blocks;
 
 	if (!blk_rq_is_passthrough(rq))
@@ -1531,7 +1531,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	const u8 *cdb = scmd->cmnd;
-	struct request *rq = scmd->request;
+	struct request *rq = scsi_cmd_to_rq(scmd);
 	int class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 	unsigned int tf_flags = 0;
 	u64 block;
@@ -3181,7 +3181,7 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	 * as it modifies the DATA OUT buffer, which would corrupt user
 	 * memory for SG_IO commands.
 	 */
-	if (unlikely(blk_rq_is_passthrough(scmd->request)))
+	if (unlikely(blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))))
 		goto invalid_opcode;
 
 	if (unlikely(scmd->cmd_len < 16)) {
diff --git a/drivers/ata/pata_falcon.c b/drivers/ata/pata_falcon.c
index 9d0dd8f4c21c..121635aa8c00 100644
--- a/drivers/ata/pata_falcon.c
+++ b/drivers/ata/pata_falcon.c
@@ -48,8 +48,8 @@ static unsigned int pata_falcon_data_xfer(struct ata_queued_cmd *qc,
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	bool swap = 1;
 
-	if (dev->class == ATA_DEV_ATA && cmd && cmd->request &&
-	    !blk_rq_is_passthrough(cmd->request))
+	if (dev->class == ATA_DEV_ATA && cmd &&
+	    !blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)))
 		swap = 0;
 
 	/* Transfer multiple of 2 bytes */
