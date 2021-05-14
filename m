Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7277C43470
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 895A461440
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhENVgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:45 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:38553 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhENVgg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:36 -0400
Received: by mail-pf1-f174.google.com with SMTP id k19so655531pfu.5
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/w/3FajyRueFFZTeb5dJrM2lkPjosqY1xTFZi9O7qqQ=;
        b=X86gOYPU+e6WiGtT0hhzmQpFsH5YaYBa4pxgdUCPPiYqfhvbmXMEN+KF1QQRX9stGC
         V2Ni7oDDiZPiqbatYCHdUZ/SDfbDvo0csxK/GOY6QVncbC9L8y7vngMfJicxPsqyKtiZ
         mic3TAW+6QlM57B17hikXUnXdXdlp2lI0CxgLSylkYw40JjAmncYlhtu/loBj07n0mtD
         d6d3IWapRA02WPHO3uIsjNRu2CJnKgDiDD9llS2+/X1vqzzh5jOOFsvfiC219b9nQ34R
         hzxJP37frKu0VAmdwXDIyteVdS3NgPTyNz4hD77frSkzECcLXBF4l5bSkh2hYbmyZNlF
         sQCA==
X-Gm-Message-State: AOAM532nwGaaIEWdgRL+kAyREYXUb4RGgPV0pO8TdDIgN7OoSsM/J/d9
        QWUz/Tu3wdqK41lh/I6IsnU=
X-Google-Smtp-Source: ABdhPJye4je6V0N2XzorJx8j5G210S3C0iHJj0A6DlJPmKhTPNnMMJQCUd3IJB1wBK7wJ8LdThwq7Q==
X-Received: by 2002:a62:1796:0:b029:2d5:91b4:642d with SMTP id 144-20020a6217960000b02902d591b4642dmr5082568pfx.7.1621028123335;
        Fri, 14 May 2021 14:35:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:22 -0700 (PDT)
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
Subject: [PATCH 45/50] ufs: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:00 -0700
Message-Id: <20210514213356.5264-46-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ab707a2c3796..18d8e48e739a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -387,16 +387,16 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 			 * Currently we only fully trace read(10) and write(10)
 			 * commands
 			 */
-			if (cmd->request && cmd->request->bio)
-				lba = cmd->request->bio->bi_iter.bi_sector;
+			if (blk_req(cmd) && blk_req(cmd)->bio)
+				lba = blk_req(cmd)->bio->bi_iter.bi_sector;
 			transfer_len = be32_to_cpu(
 				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
 			if (opcode == WRITE_10)
 				group_id = lrbp->cmd->cmnd[6];
 		} else if (opcode == UNMAP) {
-			if (cmd->request) {
+			if (blk_req(cmd)) {
 				lba = scsi_get_lba(cmd);
-				transfer_len = blk_rq_bytes(cmd->request);
+				transfer_len = blk_rq_bytes(blk_req(cmd));
 			}
 		}
 	}
@@ -2617,11 +2617,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	hba = shost_priv(host);
 
-	tag = cmd->request->tag;
+	tag = blk_req(cmd)->tag;
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
-			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
-			__func__, tag, cmd, cmd->request);
+			"%s: invalid command tag %d: cmd=0x%p, blk_req=0x%p",
+			__func__, tag, cmd, blk_req(cmd));
 		BUG();
 	}
 
@@ -2656,7 +2656,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
 
-	ufshcd_prepare_lrbp_crypto(cmd->request, lrbp);
+	ufshcd_prepare_lrbp_crypto(blk_req(cmd), lrbp);
 
 	lrbp->req_abort_skip = false;
 
@@ -6903,12 +6903,12 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	host = cmd->device->host;
 	hba = shost_priv(host);
-	tag = cmd->request->tag;
+	tag = blk_req(cmd)->tag;
 	lrbp = &hba->lrb[tag];
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
-			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
-			__func__, tag, cmd, cmd->request);
+			"%s: invalid command tag %d: cmd=0x%p, blk_req=0x%p",
+			__func__, tag, cmd, blk_req(cmd));
 		BUG();
 	}
 
