Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A707FC4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 893A261078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242913AbhHETUd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:33 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:51954 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242816AbhHETUc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:32 -0400
Received: by mail-pj1-f49.google.com with SMTP id mt6so11333743pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:20:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7KL5rtPFJtsJVLFB61Usn+cOy+BSy0IfHXEXQq5DblI=;
        b=Ayt77aaXuenDqyDRlON0yFvVVkRk1ZnpEASRu3HbEycYphHf12JGkcIqrR4TZQ6sLJ
         9R3zOMnBlDws3SY/jGDQ4vCcmwipb0v1yncfHtYeOlfXO+IpzOyozg7NjOEvX8BFaJKb
         SgQadxrMtB5B+41Ro4++9/MdCaIPb+nXkxW6ARQOw99ZGBY4TQh/wB8OFuoCyfk+5qpS
         X1n/G2e+L3A/gQRQr1c64FOQTeZOX76wCor1lb+YA4NuLI6iCG+oe0aylKifPBTaVj9R
         7DYnwxgP/HurXz6XOZ3oASAclmXGNwhZnAgCDgJUrL0hsJBdf0V2xB+RAcinte+1nPgd
         GmBQ==
X-Gm-Message-State: AOAM5319sGoLsHbcn9eiwM1pqqGZSKMIDo7TxZkzoUvsH4bfceKNvQht
        9INkpDRYlGMHGrSbnsePeXM=
X-Google-Smtp-Source: ABdhPJzqjqqWxFsUJHLMtMURyMn+GzyuZ8rr5go8JxGfHCwkRY5zZciTwzFjJ0C7lBGT27zyDBp3Fw==
X-Received: by 2002:a17:90a:6e07:: with SMTP id b7mr16699274pjk.1.1628191215248;
        Thu, 05 Aug 2021 12:20:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:20:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4 47/52] ufs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:23 -0700
Message-Id: <20210805191828.3559897-48-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 11 ++++++-----
 drivers/scsi/ufs/ufshpb.c | 19 ++++++++++---------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 47a5085f16a9..90d23e0cb6cc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -364,6 +364,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct scsi_cmnd *cmd = lrbp->cmd;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	int transfer_len = -1;
 
 	if (!cmd)
@@ -392,7 +393,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 		/*
 		 * The number of Bytes to be unmapped beginning with the lba.
 		 */
-		transfer_len = blk_rq_bytes(cmd->request);
+		transfer_len = blk_rq_bytes(rq);
 	}
 
 	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
@@ -2056,7 +2057,7 @@ static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
-		struct request *req = lrbp->cmd->request;
+		struct request *req = scsi_cmd_to_rq(lrbp->cmd);
 		struct ufs_hba_monitor *m = &hba->monitor;
 		ktime_t now, inc, lat;
 
@@ -2677,7 +2678,7 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
 	struct ufs_hba *hba = shost_priv(host);
-	int tag = cmd->request->tag;
+	int tag = scsi_cmd_to_rq(cmd)->tag;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
 
@@ -2736,7 +2737,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
 
-	ufshcd_prepare_lrbp_crypto(cmd->request, lrbp);
+	ufshcd_prepare_lrbp_crypto(scsi_cmd_to_rq(cmd), lrbp);
 
 	lrbp->req_abort_skip = false;
 
@@ -6976,7 +6977,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct ufs_hba *hba = shost_priv(host);
-	unsigned int tag = cmd->request->tag;
+	unsigned int tag = scsi_cmd_to_rq(cmd)->tag;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	unsigned long flags;
 	int err = FAILED;
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 54e8e019bdbe..41b47ef4b60f 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -70,13 +70,14 @@ static int ufshpb_is_valid_srgn(struct ufshpb_region *rgn,
 
 static bool ufshpb_is_read_cmd(struct scsi_cmnd *cmd)
 {
-	return req_op(cmd->request) == REQ_OP_READ;
+	return req_op(scsi_cmd_to_rq(cmd)) == REQ_OP_READ;
 }
 
 static bool ufshpb_is_write_or_discard(struct scsi_cmnd *cmd)
 {
-	return op_is_write(req_op(cmd->request)) ||
-	       op_is_discard(req_op(cmd->request));
+	enum req_opf op = req_op(scsi_cmd_to_rq(cmd));
+
+	return op_is_write(op) || op_is_discard(op);
 }
 
 static bool ufshpb_is_supported_chunk(struct ufshpb_lu *hpb, int transfer_len)
@@ -512,9 +513,9 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
 
 	pre_req->hpb = hpb;
 	pre_req->wb.lpn = sectors_to_logical(cmd->device,
-					     blk_rq_pos(cmd->request));
+					     blk_rq_pos(scsi_cmd_to_rq(cmd)));
 	pre_req->wb.len = sectors_to_logical(cmd->device,
-					     blk_rq_sectors(cmd->request));
+					     blk_rq_sectors(scsi_cmd_to_rq(cmd)));
 	if (ufshpb_pre_req_add_bio_page(hpb, q, pre_req))
 		return -ENOMEM;
 
@@ -592,6 +593,7 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	struct ufshpb_region *rgn;
 	struct ufshpb_subregion *srgn;
 	struct scsi_cmnd *cmd = lrbp->cmd;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	u32 lpn;
 	__be64 ppn;
 	unsigned long flags;
@@ -612,17 +614,16 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		return -ENODEV;
 	}
 
-	if (blk_rq_is_passthrough(cmd->request) ||
+	if (blk_rq_is_passthrough(rq) ||
 	    (!ufshpb_is_write_or_discard(cmd) &&
 	     !ufshpb_is_read_cmd(cmd)))
 		return 0;
 
-	transfer_len = sectors_to_logical(cmd->device,
-					  blk_rq_sectors(cmd->request));
+	transfer_len = sectors_to_logical(cmd->device, blk_rq_sectors(rq));
 	if (unlikely(!transfer_len))
 		return 0;
 
-	lpn = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
+	lpn = sectors_to_logical(cmd->device, blk_rq_pos(rq));
 	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
 	rgn = hpb->rgn_tbl + rgn_idx;
 	srgn = rgn->srgn_tbl + srgn_idx;
