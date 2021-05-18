Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CBBC43462
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76A1F611BF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351196AbhERRq1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:27 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:43588 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351200AbhERRqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:23 -0400
Received: by mail-pl1-f171.google.com with SMTP id v12so5508011plo.10
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yRnB/7qFCWzyh5k4i/233fSXHzI7oLLX6YQv9T9/m2U=;
        b=Y2ZouSQ01qLIDcO28WOPef7pltaLIhkDC1Ub+iyPPouornzNjEE2X3xGv0NpCQAV1M
         DOaopfEFFo80HHc0+oWj92MUEXJqda9qnwCKNjWAMe2VItPVDVs2VhBsOHYXkRlxs72V
         bRm3ajy5u5jALWD4nwO4vZWMHtTqzG41J0XvkjOWiGQ6gB0YkFgWLdsEITQyjsl4XKkS
         YqWSfmS5PYCfRU2tlV9UvKbGiJvg1xTTmBnpOU0czKacG52qXdDKSLB1TJsUyxpvM6yg
         lkFosjMFMUfb2oY1s7A41PgzVFwbPR+gS4kI2UeqG2aw6BIsHIaxrNYJf8cMAv+Ln7wz
         5z3w==
X-Gm-Message-State: AOAM533rUm+Sd1kcED+gMiJR8hRHmqGCm/4OTcyM2GqnzXu2vxrN6V/x
        SOaIQpBFLbcwwWoM/fXyRTA=
X-Google-Smtp-Source: ABdhPJwUkVrAKyu0WCPVhZJNqGskVIsZi+8HjJzx4zMxaonuMVEEK7Y6PdU7ASRsyvLOP40KOQLSqw==
X-Received: by 2002:a17:902:82ca:b029:f3:fa5b:2637 with SMTP id u10-20020a17090282cab02900f3fa5b2637mr1297177plz.83.1621359905047;
        Tue, 18 May 2021 10:45:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 07/50] ata: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:07 -0700
Message-Id: <20210518174450.20664-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
index fd8b6febbf70..debc78f653c1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -627,7 +627,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 {
 	struct ata_queued_cmd *qc;
 
-	qc = ata_qc_new_init(dev, cmd->request->tag);
+	qc = ata_qc_new_init(dev, scsi_cmd_to_rq(cmd)->tag);
 	if (qc) {
 		qc->scsicmd = cmd;
 		qc->scsidone = cmd->scsi_done;
@@ -635,7 +635,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 		qc->sg = scsi_sglist(cmd);
 		qc->n_elem = scsi_sg_count(cmd);
 
-		if (cmd->request->rq_flags & RQF_QUIET)
+		if (scsi_cmd_to_rq(cmd)->rq_flags & RQF_QUIET)
 			qc->flags |= ATA_QCFLAG_QUIET;
 	} else {
 		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
@@ -1497,7 +1497,7 @@ static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc)
 
 static bool ata_check_nblocks(struct scsi_cmnd *scmd, u32 n_blocks)
 {
-	struct request *rq = scmd->request;
+	struct request *rq = scsi_cmd_to_rq(scmd);
 	u32 req_blocks;
 
 	if (!blk_rq_is_passthrough(rq))
@@ -1532,7 +1532,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	const u8 *cdb = scmd->cmnd;
-	struct request *rq = scmd->request;
+	struct request *rq = scsi_cmd_to_rq(scmd);
 	int class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 	unsigned int tf_flags = 0;
 	u64 block;
@@ -3182,7 +3182,7 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	 * as it modifies the DATA OUT buffer, which would corrupt user
 	 * memory for SG_IO commands.
 	 */
-	if (unlikely(blk_rq_is_passthrough(scmd->request)))
+	if (unlikely(blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))))
 		goto invalid_opcode;
 
 	if (unlikely(scmd->cmd_len < 16)) {
diff --git a/drivers/ata/pata_falcon.c b/drivers/ata/pata_falcon.c
index 27b0952fde6b..154e3577878b 100644
--- a/drivers/ata/pata_falcon.c
+++ b/drivers/ata/pata_falcon.c
@@ -50,8 +50,8 @@ static unsigned int pata_falcon_data_xfer(struct ata_queued_cmd *qc,
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	bool swap = 1;
 
-	if (dev->class == ATA_DEV_ATA && cmd && cmd->request &&
-	    !blk_rq_is_passthrough(cmd->request))
+	if (dev->class == ATA_DEV_ATA && cmd &&
+	    !blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)))
 		swap = 0;
 
 	/* Transfer multiple of 2 bytes */
