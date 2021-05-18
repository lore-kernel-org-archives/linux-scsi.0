Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 939DCC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74C7861074
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351341AbhERRrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:14 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:35486 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351329AbhERRrK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:10 -0400
Received: by mail-pj1-f43.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso204807pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ch7z7VSw6yzfLj0A9EnDxgqXt0vFaVpmyV0R7QVYQkc=;
        b=BLnhn4vG2pdQV6zdRuFIRM9tX2Gyw9/OJ/R7B6yPgXt9oXvvQhasPp7TggXdbZLS+5
         z7TuxDhhvjy7AVLZNUq6AxkgMZshqbEyQXlfNkuh1wsLEIICPvcHm1eey2kFJ5VoxUXR
         cfYcF1UKuSHtyKKhun8+9NEamcrqHrtK+Q4unAbN8PTjXlmzXh3IGoRcnXQmseZ1Hv9K
         YXPDg+SBpDjPdUemK+/MYZRS/eyGGzjMbmevhRm44NQZApZNUQjCtgWkASYdZzhIENve
         gct9/0wrYUEmiyDN4YTfNNj0ghU89hoZmjgSrTm4aPgKLCyAbFMvFqMlIe712j699jPA
         eWfg==
X-Gm-Message-State: AOAM530G0YVks59aTekOq8Tg/+xbFV085rryvuGt84V2yfx/+u0QuxZf
        mpAXaaUCd0562uBu3W149uOHyEnX32zQMQ==
X-Google-Smtp-Source: ABdhPJyB8v1L4HwUTDn6bv1dbQ0HZ2O1DqSvZoDYtNuXS92DsrWg7XtK9lhnk3U41EYgJjw9rgvuPw==
X-Received: by 2002:a17:90a:5406:: with SMTP id z6mr6455301pjh.130.1621359952418;
        Tue, 18 May 2021 10:45:52 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 45/50] ufs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:45 -0700
Message-Id: <20210518174450.20664-46-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d543864df7c2..7d30b5f04204 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -379,6 +379,8 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	}
 
 	if (cmd) { /* data phase exists */
+		struct request *rq = scsi_cmd_to_rq(cmd);
+
 		/* trace UPIU also */
 		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
 		opcode = cmd->cmnd[0];
@@ -387,17 +389,15 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 			 * Currently we only fully trace read(10) and write(10)
 			 * commands
 			 */
-			if (cmd->request && cmd->request->bio)
-				lba = cmd->request->bio->bi_iter.bi_sector;
+			if (rq->bio)
+				lba = rq->bio->bi_iter.bi_sector;
 			transfer_len = be32_to_cpu(
 				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
 			if (opcode == WRITE_10)
 				group_id = lrbp->cmd->cmnd[6];
 		} else if (opcode == UNMAP) {
-			if (cmd->request) {
-				lba = scsi_get_lba(cmd);
-				transfer_len = blk_rq_bytes(cmd->request);
-			}
+			lba = scsi_get_lba(cmd);
+			transfer_len = blk_rq_bytes(rq);
 		}
 	}
 
@@ -2058,7 +2058,7 @@ static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
 
 	if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
-		struct request *req = lrbp->cmd->request;
+		struct request *req = scsi_cmd_to_rq(lrbp->cmd);
 		struct ufs_hba_monitor *m = &hba->monitor;
 		ktime_t now, inc, lat;
 
@@ -2677,11 +2677,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	hba = shost_priv(host);
 
-	tag = cmd->request->tag;
+	tag = scsi_cmd_to_rq(cmd)->tag;
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
-			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
-			__func__, tag, cmd, cmd->request);
+			"%s: invalid command tag %d: cmd=0x%p, scsi_cmd_to_rq=0x%p",
+			__func__, tag, cmd, scsi_cmd_to_rq(cmd));
 		BUG();
 	}
 
@@ -2716,7 +2716,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
 
-	ufshcd_prepare_lrbp_crypto(cmd->request, lrbp);
+	ufshcd_prepare_lrbp_crypto(scsi_cmd_to_rq(cmd), lrbp);
 
 	lrbp->req_abort_skip = false;
 
@@ -6965,12 +6965,12 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
-	tag = cmd->request->tag;
+	tag = scsi_cmd_to_rq(cmd)->tag;
 	lrbp = &hba->lrb[tag];
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
-			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
-			__func__, tag, cmd, cmd->request);
+			"%s: invalid command tag %d: cmd=0x%p, scsi_cmd_to_rq=0x%p",
+			__func__, tag, cmd, scsi_cmd_to_rq(cmd));
 		BUG();
 	}
 
