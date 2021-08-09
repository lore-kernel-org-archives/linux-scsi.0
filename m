Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADC9C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F95F60FE3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbhHIXFn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:43 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:53952 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbhHIXFn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:43 -0400
Received: by mail-pj1-f53.google.com with SMTP id j1so30352329pjv.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/trrQIYDwfyLamGClCwRt+DPiP0Zme/Paii05lyDYz4=;
        b=PPolPkzxgobnCKj82UF5KDBvjeX9sIkTuYL/zWF/VDnevVoFeqZC96Fz19x6OoD251
         5rL7y4iNQcVzkfbaRexaEDHXvr8cznSFV5wLfQABlNaxXZ+ghf0BxYrp4wd4vhpsLsYi
         /eAW3sld7oS0N0/pExwaD59h/9MqUWOinTDRURFsqAfRtVS5+/4CSwNB04lwpHFZaFtd
         05FuhUboHhsrXjgU/ImRrRgHiDzqZTXPc4fIPPXzRSvBrP++8siKuZpyEkwaoh3IVpPG
         71xGk8Etgxy1t1Kv95jOpq2kfHw6h5gDN6eqVqnQyQ4pp0VoQV0uKfyy6slOUne2PZtZ
         EtHQ==
X-Gm-Message-State: AOAM533nzmSKiTztOQvlSFFMxmCcc2+x03Ihg81u4Kzniug1VM4GAOFe
        XNFyt/xZXon2ZlQ2eAwcgyQ=
X-Google-Smtp-Source: ABdhPJyXj02eTQ6/5EDuB56bu3lISDln9hdauSg/UT/agbhE6H6gdlGDEzSmp7jxdTbpdtEVj43rJg==
X-Received: by 2002:a17:90a:bb0b:: with SMTP id u11mr1555427pjr.18.1628550321765;
        Mon, 09 Aug 2021 16:05:21 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v5 47/52] ufs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:50 -0700
Message-Id: <20210809230355.8186-48-bvanassche@acm.org>
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

Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 11 ++++++-----
 drivers/scsi/ufs/ufshpb.c | 19 ++++++++++---------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6c263e94144b..72348153adb0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -365,6 +365,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct scsi_cmnd *cmd = lrbp->cmd;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	int transfer_len = -1;
 
 	if (!cmd)
@@ -390,7 +391,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 		/*
 		 * The number of Bytes to be unmapped beginning with the lba.
 		 */
-		transfer_len = blk_rq_bytes(cmd->request);
+		transfer_len = blk_rq_bytes(rq);
 	}
 
 	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
@@ -2054,7 +2055,7 @@ static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
-		struct request *req = lrbp->cmd->request;
+		struct request *req = scsi_cmd_to_rq(lrbp->cmd);
 		struct ufs_hba_monitor *m = &hba->monitor;
 		ktime_t now, inc, lat;
 
@@ -2675,7 +2676,7 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
 	struct ufs_hba *hba = shost_priv(host);
-	int tag = cmd->request->tag;
+	int tag = scsi_cmd_to_rq(cmd)->tag;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
 
@@ -2734,7 +2735,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
 
-	ufshcd_prepare_lrbp_crypto(cmd->request, lrbp);
+	ufshcd_prepare_lrbp_crypto(scsi_cmd_to_rq(cmd), lrbp);
 
 	lrbp->req_abort_skip = false;
 
@@ -6974,7 +6975,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct ufs_hba *hba = shost_priv(host);
-	unsigned int tag = cmd->request->tag;
+	unsigned int tag = scsi_cmd_to_rq(cmd)->tag;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	unsigned long flags;
 	int err = FAILED;
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index d0eb14be47a3..908130596610 100644
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
@@ -516,9 +517,9 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
 
 	pre_req->hpb = hpb;
 	pre_req->wb.lpn = sectors_to_logical(cmd->device,
-					     blk_rq_pos(cmd->request));
+					     blk_rq_pos(scsi_cmd_to_rq(cmd)));
 	pre_req->wb.len = sectors_to_logical(cmd->device,
-					     blk_rq_sectors(cmd->request));
+					     blk_rq_sectors(scsi_cmd_to_rq(cmd)));
 	if (ufshpb_pre_req_add_bio_page(hpb, q, pre_req))
 		return -ENOMEM;
 
@@ -596,6 +597,7 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	struct ufshpb_region *rgn;
 	struct ufshpb_subregion *srgn;
 	struct scsi_cmnd *cmd = lrbp->cmd;
+	struct request *rq = scsi_cmd_to_rq(cmd);
 	u32 lpn;
 	__be64 ppn;
 	unsigned long flags;
@@ -616,17 +618,16 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
