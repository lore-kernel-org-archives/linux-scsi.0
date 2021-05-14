Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982E2C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76400613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhENVfe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:34 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:43780 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhENVfa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:30 -0400
Received: by mail-pl1-f181.google.com with SMTP id v12so91537plo.10
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IH/r9AOycjnWvxZ4S6rtMcxkeQP9ikVB0ZSiMJZU0ak=;
        b=aQ/H/HiiClKnsgUp4GwDrxrrkJLyXaDrZlBDOJDzgVYpL2erY0zJxSQklOjzvOqHYy
         q6AqxDuNDfTe36KOhTKOkslPALoaTtjEZ5BXXB5Zu8lR4cOa5BmYR3q9DWJBlyrY5GHc
         gT8TLt5KxBTkw+05XYIEhv8IuyfOYnxWlHDLZILOd0QJSs2U9ahMbCizdRaGwREp6OY0
         HXuTO86wMGiabGOQzWcmSeYCFPIh7VxJzvuWEiJhVUoGAoRRsbBdpcL6RaxnBrqW6eZy
         OCWtMW9HsTU7yb7OvThI6EDkjHnp7sx0BnEGLCq8HY2hR9GCbXBzy0EUpz6dl3grD8AD
         KeRg==
X-Gm-Message-State: AOAM530z+NYncSiP06Boi47U5m41bOQzU61Lr3nQQwfqKQdcVBS/pvvp
        XO99igJC+H58fFXa2YkNGiM=
X-Google-Smtp-Source: ABdhPJyRyFdfCGj/gGVB+oaxqq3nBUkmJFEOXRPsKEetBD9jDIC6EkPtjlHAvCoN8Xr8X2iu0jQ68A==
X-Received: by 2002:a17:90a:4d0a:: with SMTP id c10mr13124093pjg.206.1621028057366;
        Fri, 14 May 2021 14:34:17 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 07/50] ata: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:22 -0700
Message-Id: <20210514213356.5264-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-eh.c   |  5 ++---
 drivers/ata/libata-scsi.c | 10 +++++-----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bb3637762985..4b007c9adfcb 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -912,7 +912,7 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
 	 * Note that ATA_QCFLAG_FAILED is unconditionally set after
 	 * this function completes.
 	 */
-	blk_abort_request(qc->scsicmd->request);
+	blk_abort_request(blk_req(qc->scsicmd));
 }
 
 /**
@@ -1893,8 +1893,7 @@ static inline int ata_eh_worth_retry(struct ata_queued_cmd *qc)
  */
 static inline bool ata_eh_quiet(struct ata_queued_cmd *qc)
 {
-	if (qc->scsicmd &&
-	    qc->scsicmd->request->rq_flags & RQF_QUIET)
+	if (qc->scsicmd && blk_req(qc->scsicmd)->rq_flags & RQF_QUIET)
 		qc->flags |= ATA_QCFLAG_QUIET;
 	return qc->flags & ATA_QCFLAG_QUIET;
 }
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index fd8b6febbf70..108c2f0b3e17 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -627,7 +627,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 {
 	struct ata_queued_cmd *qc;
 
-	qc = ata_qc_new_init(dev, cmd->request->tag);
+	qc = ata_qc_new_init(dev, blk_req(cmd)->tag);
 	if (qc) {
 		qc->scsicmd = cmd;
 		qc->scsidone = cmd->scsi_done;
@@ -635,7 +635,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 		qc->sg = scsi_sglist(cmd);
 		qc->n_elem = scsi_sg_count(cmd);
 
-		if (cmd->request->rq_flags & RQF_QUIET)
+		if (blk_req(cmd)->rq_flags & RQF_QUIET)
 			qc->flags |= ATA_QCFLAG_QUIET;
 	} else {
 		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
@@ -1497,7 +1497,7 @@ static unsigned int ata_scsi_verify_xlat(struct ata_queued_cmd *qc)
 
 static bool ata_check_nblocks(struct scsi_cmnd *scmd, u32 n_blocks)
 {
-	struct request *rq = scmd->request;
+	struct request *rq = blk_req(scmd);
 	u32 req_blocks;
 
 	if (!blk_rq_is_passthrough(rq))
@@ -1532,7 +1532,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	const u8 *cdb = scmd->cmnd;
-	struct request *rq = scmd->request;
+	struct request *rq = blk_req(scmd);
 	int class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 	unsigned int tf_flags = 0;
 	u64 block;
@@ -3182,7 +3182,7 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	 * as it modifies the DATA OUT buffer, which would corrupt user
 	 * memory for SG_IO commands.
 	 */
-	if (unlikely(blk_rq_is_passthrough(scmd->request)))
+	if (unlikely(blk_rq_is_passthrough(blk_req(scmd))))
 		goto invalid_opcode;
 
 	if (unlikely(scmd->cmd_len < 16)) {
